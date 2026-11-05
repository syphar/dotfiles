#!/usr/bin/python3
"""Select a power profile at login and when UPower reports power changes."""

import logging

import dbus
from dbus.mainloop.glib import DBusGMainLoop
from gi.repository import GLib

logger = logging.getLogger(__name__)

POWER_SAVER_PERCENT = 30
POWER_CHANGE_DELAY_MS = 2000
UPOWER = "org.freedesktop.UPower"
UPOWER_PATH = "/org/freedesktop/UPower"
DISPLAY_PATH = UPOWER_PATH + "/devices/DisplayDevice"
PPD = "net.hadess.PowerProfiles"
PPD_PATH = "/net/hadess/PowerProfiles"
PROPERTIES = "org.freedesktop.DBus.Properties"


def select_profile(on_battery, percentage):
    if not on_battery:
        return "performance"
    if percentage <= POWER_SAVER_PERCENT:
        return "power-saver"
    return "balanced"


class PowerProfiles:
    def __init__(self, bus):
        self.bus = bus
        self.pending = None

    def properties(self, service, path):
        return dbus.Interface(self.bus.get_object(service, path), PROPERTIES)

    def on_battery(self):
        upower = dbus.Interface(self.bus.get_object(UPOWER, UPOWER_PATH), UPOWER)
        adapters = []
        for path in upower.EnumerateDevices():
            device = self.properties(UPOWER, path).GetAll(UPOWER + ".Device")
            if device["Type"] == 1:  # Line power, including USB-C power supplies.
                adapters.append(bool(device["Online"]))

        # A full battery may report discharging while an adapter still supplies power.
        if adapters:
            return not any(adapters)
        return bool(self.properties(UPOWER, UPOWER_PATH).Get(UPOWER, "OnBattery"))

    def update(self):
        self.pending = None
        try:
            on_battery = self.on_battery()
            logger.debug("battery: %s", on_battery)

            percentage = 100
            if on_battery:
                battery = self.properties(UPOWER, DISPLAY_PATH).GetAll(
                    UPOWER + ".Device"
                )
                if not battery["IsPresent"]:
                    logger.warning("Battery data unavailable; keeping current profile")
                    return False
                percentage = float(battery["Percentage"])

            logger.debug("percentage: %s", percentage)

            desired = select_profile(on_battery, percentage)
            logger.debug("desired => %s", desired)

            profiles = self.properties(PPD, PPD_PATH)

            active_profile = str(profiles.Get(PPD, "ActiveProfile"))
            logger.debug("active profile: %s", active_profile)

            if active_profile != desired:
                profiles.Set(PPD, "ActiveProfile", dbus.String(desired))
                actual = str(profiles.Get(PPD, "ActiveProfile"))
                if actual != desired:
                    logger.warning(
                        "Requested %s, but active profile is %s", desired, actual
                    )
                else:
                    logger.info(
                        "selected %s. on_battery: %s, percent: %s",
                        desired,
                        on_battery,
                        percentage,
                    )

        except dbus.DBusException as error:
            logger.warning("Cannot update power profile; will retry: %s", error)

        return False

    def changed(self, *args):
        # Let transient USB-C power changes settle before changing profiles.
        if self.pending is not None:
            GLib.source_remove(self.pending)
        self.pending = GLib.timeout_add(POWER_CHANGE_DELAY_MS, self.update)

    def retry(self):
        # Also recover after suspend or a power-management daemon restart.
        if self.pending is None:
            self.changed()
        return True


def main():
    logging.basicConfig(level=logging.INFO, format="%(levelname)s: %(message)s")

    DBusGMainLoop(set_as_default=True)
    bus = dbus.SystemBus()
    controller = PowerProfiles(bus)

    logger.info("registering signal receivers...")

    for service, path in (
        (UPOWER, None),
        (PPD, PPD_PATH),
    ):
        bus.add_signal_receiver(
            controller.changed,
            signal_name="PropertiesChanged",
            dbus_interface=PROPERTIES,
            bus_name=service,
            path=path,
        )

    for signal in ("DeviceAdded", "DeviceRemoved"):
        bus.add_signal_receiver(
            controller.changed,
            signal_name=signal,
            dbus_interface=UPOWER,
            bus_name=UPOWER,
            path=UPOWER_PATH,
        )

    GLib.timeout_add_seconds(30, controller.retry)
    controller.changed()
    GLib.MainLoop().run()


if __name__ == "__main__":
    main()
