require("fidget").setup({
	text = {
		spinner = "dots", -- animation shown when tasks are ongoing
		done = "✔", -- character shown when all tasks are complete
		commenced = "Started", -- message shown when task starts
		completed = "Completed", -- message shown when task completes
	},
	align = {
		bottom = true, -- align fidgets along bottom edge of buffer
		right = true, -- align fidgets along right edge of buffer
	},
	timer = {
		spinner_rate = 125, -- frame rate of spinner animation, in ms
		fidget_decay = 500, -- how long to keep around empty fidget, in ms
		task_decay = 500, -- how long to keep around completed task, in ms
	},
	fmt = {
		leftpad = true, -- right-justify text in fidget box
		stack_upwards = false, -- list of tasks grows upwards
		-- function to format fidget title
		-- fidget = function(fidget_name, spinner)
		-- 	return string.format("%s %s", spinner, fidget_name)
		-- end,
		-- -- function to format each task line
		-- task = function(task_name, message, percentage)
		-- 	return string.format(
		-- 		"%s%s [%s]",
		-- 		message,
		-- 		percentage and string.format(" (%s%%)", percentage) or "",
		-- 		task_name
		-- 	)
		-- end,
	},
	debug = {
		logging = false,
	},
})
