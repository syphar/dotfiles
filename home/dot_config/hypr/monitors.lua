------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/

-- when external screen connected (default rule)
-- set primary
hl.monitor({
	-- external
	output = "",
	mode = "preferred",
	position = "0x0",
	scale = 2,
})

-- Put the laptop to the right of this Samsung, below other external screens.
local right_monitor_serial = "HTPK700345"
local internal_position

local function update_internal_position(removed_monitor)
	local position = "auto-center-down"
	for _, monitor in ipairs(hl.get_monitors()) do
		if monitor.name ~= removed_monitor and monitor.serial == right_monitor_serial then
			position = "auto-center-right"
			break
		end
	end

	if position == internal_position then
		return
	end
	internal_position = position
	hl.monitor({
		output = "eDP-1",
		mode = "preferred",
		position = position,
		scale = "auto",
	})
end

update_internal_position()
hl.on("hyprland.start", function()
	update_internal_position()
end)
hl.on("monitor.added", function()
	update_internal_position()
end)
hl.on("monitor.removed", function(monitor)
	update_internal_position(monitor.name)
end)
