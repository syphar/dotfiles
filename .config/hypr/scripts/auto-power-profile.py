#!/usr/bin/python3
"""Select a power profile at login and when UPower reports power changes."""

import logging

import dbus
from dbus.mainloop.glib import DBusGMainLoop
from gi.repository import GLib

POWER_SAVER_PERCENT = 20
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
        self.pending = False

    def properties(self, service, path):
        return dbus.Interface(
            self.bus.get_object(service, path), PROPERTIES
        )

    def update(self):
        self.pending = False
        try:
            on_battery = self.properties(UPOWER, UPOWER_PATH).Get(
                UPOWER, "OnBattery"
            )
            percentage = 100
            if on_battery:
                battery = self.properties(UPOWER, DISPLAY_PATH).GetAll(
                    UPOWER + ".Device"
                )
                if not battery["IsPresent"]:
                    logging.warning("Battery data unavailable; keeping current profile")
                    return False
                percentage = float(battery["Percentage"])
            desired = select_profile(on_battery, percentage)
            profiles = self.properties(PPD, PPD_PATH)
            if str(profiles.Get(PPD, "ActiveProfile")) != desired:
                profiles.Set(PPD, "ActiveProfile", dbus.String(desired))
                actual = str(profiles.Get(PPD, "ActiveProfile"))
                if actual != desired:
                    logging.warning("Requested %s, but active profile is %s", desired, actual)
                else:
                    logging.info("Selected %s", desired)
        except dbus.DBusException as error:
            logging.warning("Cannot update power profile; will retry: %s", error)
        return False

    def changed(self, *args):
        # Coalesce related battery/profile events before querying current values.
        if not self.pending:
            self.pending = True
            GLib.idle_add(self.update)

    def retry(self):
        # Also recover after suspend or a power-management daemon restart.
        self.changed()
        return True


def main():
    logging.basicConfig(level=logging.INFO, format="%(levelname)s: %(message)s")
    DBusGMainLoop(set_as_default=True)
    bus = dbus.SystemBus()
    controller = PowerProfiles(bus)
    for service, path in (
        (UPOWER, UPOWER_PATH),
        (UPOWER, DISPLAY_PATH),
        (PPD, PPD_PATH),
    ):
        bus.add_signal_receiver(
            controller.changed,
            signal_name="PropertiesChanged",
            dbus_interface=PROPERTIES,
            bus_name=service,
            path=path,
        )
    GLib.timeout_add_seconds(30, controller.retry)
    controller.changed()
    GLib.MainLoop().run()


if __name__ == "__main__":
    main()
