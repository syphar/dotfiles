local programs = require("programs")

-----------------
----  BINDS  ----
-----------------

hl.config({
	binds = {
		workspace_back_and_forth = true,
	},
})

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
-- Send a graceful request to close the window
hl.bind(mainMod .. " + W", hl.dsp.window.close())

hl.bind(
	mainMod .. " + M",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)

hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(programs.file_manager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(programs.ipc .. "panel-toggle launcher"))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Resize windows
local resizeUnit = 20
hl.bind(
	mainMod .. " + SHIFT + right",
	hl.dsp.window.resize({ x = resizeUnit, y = 0, relative = true }),
	{ repeating = true }
)
hl.bind(
	mainMod .. " + SHIFT + left",
	hl.dsp.window.resize({ x = -resizeUnit, y = 0, relative = true }),
	{ repeating = true }
)
hl.bind(
	mainMod .. " + SHIFT + up",
	hl.dsp.window.resize({ x = 0, y = -resizeUnit, relative = true }),
	{ repeating = true }
)
hl.bind(
	mainMod .. " + SHIFT + down",
	hl.dsp.window.resize({ x = 0, y = resizeUnit, relative = true }),
	{ repeating = true }
)

for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	-- Switch workspaces with mainMod + [0-9]
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))

	-- Move window to a different workspace and switch to that workspace with mainMod + SHIFT + [0-9]
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
	-- Move window to a different workspace but keep current workspace with mainMod + CTRL + [0-9]
	hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

hl.bind(mainMod .. " + CTRL + left", hl.dsp.window.move({ workspace = "e-1", follow = true }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.move({ workspace = "e+1", follow = true }))

-- Fullscreen - Window takes up the entire working space, keeping the margins.
hl.bind(mainMod .. " + CTRL + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
-- Fullscreen - Window takes up the entire screen.
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))

-- Screenshot a monitor
hl.bind("PRINT", hl.dsp.exec_cmd(programs.ipc .. "screenshot-fullscreen pick"))
-- Screenshot a region
hl.bind(mainMod .. " +  PRINT", hl.dsp.exec_cmd(programs.ipc .. "screenshot-region"))

-- Special workspaces
hl.bind(mainMod .. " + N", hl.dsp.workspace.toggle_special("notes"))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.window.move({ workspace = "special:notes" }))
hl.bind(mainMod .. " + S", hl.dsp.focus({ workspace = 9 }))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = 9 }))
hl.bind(mainMod .. " + A", hl.dsp.workspace.toggle_special("ai"))
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.window.move({ workspace = "special:ai" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- new mappings denis
hl.bind("SUPER + TAB", hl.dsp.layout("cyclenext"))
hl.bind("SUPER + SHIFT + TAB", hl.dsp.layout("cycleprev"))
hl.bind("ALT + TAB", hl.dsp.exec_cmd("noctalia msg window-switcher"))
hl.bind("ALT + SPACE", hl.dsp.exec_cmd(programs.ipc .. "panel-toggle launcher"))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd(programs.ipc .. "session lock"))

-- hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", function()
	-- local windows = hl.get_windows()
	-- for _, w in ipairs(windows) do
	-- 	if w.class == "com.mitchellh.ghostty" then
	-- 		hl.dispatch(hl.dsp.focus({ window = w }))
	-- 		return
	-- 	end
	-- end
	hl.exec_cmd(programs.terminal)
end)
