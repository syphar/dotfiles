require("incline").setup({
	render = function(props)
		local bufname = vim.api.nvim_buf_get_name(props.buf)
		if bufname == "" then
			return "[No name]"
		else
			-- ":." is the filename relative to the PWD (=project)
			bufname = vim.fn.fnamemodify(bufname, ":.")

			-- shorten bufname when it's in the crates.io registry
			bufname = string.gsub(bufname, "/Users/syphar/%.cargo/registry/src/github.com%-1ecc6299db9ec823", " ")
		end

		-- cut the content if it takes more than half of the screen
		local max_len = vim.api.nvim_win_get_width(props.win) / 2

		local icon = require("nvim-web-devicons").get_icon(bufname, nil, { default = true })

		if #bufname > max_len then
			return icon .. " …" .. string.sub(bufname, #bufname - max_len, -1)
		else
			return icon .. " " .. bufname
		end
	end,
	window = {
		zindex = 100,
		width = "fit",
		placement = { horizontal = "right", vertical = "top" },
		margin = {
			horizontal = { left = 1, right = 0 },
			vertical = { bottom = 0, top = 1 },
		},
		padding = { left = 1, right = 1 },
		padding_char = " ",
		winhighlight = {
			Normal = "TreesitterContext",
		},
	},
	ignore = {
		floating_wins = true,
		unlisted_buffers = true,
		filetypes = {},
		buftypes = "special",
		wintypes = "special",
	},
	hide = {
		focused_win = false,
	},
})
