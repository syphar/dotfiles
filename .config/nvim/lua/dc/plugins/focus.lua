--auto focus / resize for splits

return {
	"nvim-focus/focus.nvim",
	config = function()
		require("focus").setup({
			cursorline = false,
			signcolumn = false,
			autoresize = {
				enable = true,
			},
			excluded_filetypes = { "fugitiveblame", "packer" },
		})

		-- the default focus.nvim autocmd is disabled via autoresize=false.
		-- This autocmd below is a copy of it that is calling WinScrolled
		-- afterwards so _incline_ floats are updated correctly.
		-- upstream fix: https://github.com/beauwilliams/focus.nvim/pull/83
		vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
			pattern = "*",
			group = vim.api.nvim_create_augroup("focus_nvim", {}),
			callback = function()
				vim.schedule(function()
					require("focus").resize()
					vim.api.nvim_exec_autocmds("WinScrolled", {})
				end)
			end,
		})
	end,
}
