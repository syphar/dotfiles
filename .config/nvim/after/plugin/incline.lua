require("incline").setup({
	render = function(props)
		-- generate name
		local bufname = vim.api.nvim_buf_get_name(props.buf)
		if bufname == "" then
			return "[No name]"
		else
			-- ":." is the filename relative to the PWD (=project)
			bufname = vim.fn.fnamemodify(bufname, ":.")

			-- shorten bufname when it's in the crates.io registry
			bufname = string.gsub(bufname, "/Users/syphar/%.cargo/registry/src/github.com%-1ecc6299db9ec823", " ")

			-- shorten bufname if its from the rust toolchain
			local toolchain, path = string.match(
				bufname,
				"/Users/syphar/.rustup/toolchains/([^/]*)/lib/rustlib/src/rust/library/(.*)"
			)

			if toolchain then
				bufname = toolchain:gsub("%-x86%_64%-apple%-darwin", "") .. "/" .. path
			end
		end

		-- find devicon for the bufname
		local icon = require("nvim-web-devicons").get_icon(bufname, nil, { default = true })

		-- cut the content if it takes more than half of the screen
		local max_len = vim.api.nvim_win_get_width(props.win) / 2

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

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
	group = vim.api.nvim_create_augroup("hide_incline_on_first_line", {}),
	buffer = 0,
	callback = function()
		local incline = require("incline")
		if vim.fn.line(".", vim.api.nvim_get_current_win()) == 1 then
			incline.disable()
		else
			incline.enable()
		end
	end,
})
