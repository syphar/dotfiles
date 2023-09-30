vim.cmd([[
	augroup FormatAutogroup
	  autocmd!
	  autocmd BufWritePost * FormatWrite
	augroup END
]])

return {
	"mhartington/formatter.nvim",
	config = function()
		local util = require("formatter.util")
		local dc_utils = require("dc.utils")

		require("formatter").setup({
			logging = false,
			-- log_level = vim.log.levels.WARN,
			filetype = {
				lua = {
					require("formatter.filetypes.lua").stylua,
				},
				python = {
					function()
						if not dc_utils.pyproject_toml()["tool.black"] then
							return nil
						end
						-- FIXME: re-add `--fast`
						return require("formatter.filetypes.python").black()
					end,
				},
			},
		})
	end,
	keys = {
		{ "<leader>gq", "<cmd>FormatWrite<cr>" },
	},
	cmd = { "Format", "FormatWrite", "FormatLock", "FormatWriteLock" },
}
