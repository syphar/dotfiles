local programs = require("programs")

-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function()
	hl.exec_cmd("noctalia")
	hl.exec_cmd("/usr/bin/mise exec -- librepods --start-minimized")
	hl.exec_cmd("dropbox start -i")
	hl.exec_cmd("/opt/1Password/1password --silent")

	--   hl.exec_cmd("nm-applet")
	--   hl.exec_cmd("waybar & hyprpaper & firefox")
end)

-- Flatpak apps can finish launching after Hyprland's startup workspace token has
-- expired.  Retry their placement only during login, leaving later windows alone.
local startup_workspace_targets = {
	["md.obsidian.Obsidian"] = "special:notes",
	["zulip"] = 9,
	["Beeper"] = 9,
}
local startup_placement_timer

hl.on("hyprland.start", function()
	hl.exec_cmd("flatpak run app.zen_browser.zen", { workspace = "1 silent" })
	hl.exec_cmd(programs.terminal, { workspace = "2 silent" })
	hl.exec_cmd("flatpak run md.obsidian.Obsidian", { workspace = "special:notes silent" })
	hl.exec_cmd("chatgpt", { workspace = "special:ai silent" })
	hl.exec_cmd("flatpak run org.zulip.Zulip", { workspace = "9 silent" })
	hl.exec_cmd("/home/syphar/.config/hypr/start-beeper", { workspace = "9 silent" })

	startup_placement_timer = hl.timer(function()
		for _, window in ipairs(hl.get_windows()) do
			local workspace = startup_workspace_targets[window.class]
			if workspace then
				hl.dispatch(hl.dsp.window.move({ window = window, workspace = workspace, follow = false }))
				startup_workspace_targets[window.class] = nil
			end
		end

		if next(startup_workspace_targets) == nil then
			startup_placement_timer:set_enabled(false)
		end
	end, { timeout = 1000, type = "repeat" })
end)
