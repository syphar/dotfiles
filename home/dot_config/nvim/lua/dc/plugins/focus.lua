--auto focus / resize for splits

return {
	"nvim-focus/focus.nvim",
	event = "VeryLazy",
	config = function()
		require("focus").setup({
			ui = {
				cursorline = false,
				signcolumn = false,
			},
			autoresize = {
				enable = true,
				-- minwidth = 60,
				-- minheight = 10,
			},
		})

		-- disabling focus for certain filetypes:
		-- https://github.com/nvim-focus/focus.nvim?tab=readme-ov-file#disabling-focus
		local ignore_filetypes = { "fugitiveblame", "packer", "Trouble", "qf" }
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("FocusDisable", { clear = true }),
			callback = function(_)
				if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
					vim.b.focus_disable = true
				else
					vim.b.focus_disable = false
				end
			end,
			desc = "Disable focus autoresize for FileType",
		})
	end,
}
