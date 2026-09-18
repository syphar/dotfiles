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

-- explicit internal screen is secondary,
-- or primary when no external is connected
hl.monitor({
	output = "eDP-1",
	mode = "preferred",
	position = "auto-center-right",
	scale = "auto",
})
