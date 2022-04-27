require("incline").setup({
	render = function(props)
		local bufname = vim.api.nvim_buf_get_name(props.buf)
		if bufname == "" then
			return "[No name]"
		else
			bufname = vim.fn.fnamemodify(bufname, ":.")
		end
		local win_width = vim.api.nvim_win_get_width(props.win)
		local max_len = win_width / 2

		if #bufname > max_len then
			return "…" .. string.sub(bufname, #bufname - max_len, -1)
		else
			return bufname
		end
	end,
	-- debounce_threshold = { rising = 10, falling = 50 },
	window = {
		-- 	width = "fit",
		-- 	placement = { horizontal = "right", vertical = "top" },
		-- 	margin = {
		-- 		horizontal = { left = 1, right = 1 },
		-- 		vertical = { bottom = 0, top = 1 },
		-- 	},
		-- 	padding = { left = 1, right = 1 },
		-- 	padding_char = " ",
		zindex = 100,
	},
	-- ignore = {
	-- 	floating_wins = true,
	-- 	unlisted_buffers = true,
	-- 	filetypes = {},
	-- 	buftypes = "special",
	-- 	wintypes = "special",
	-- },
	hide = {
		focused_win = false,
	},
})
