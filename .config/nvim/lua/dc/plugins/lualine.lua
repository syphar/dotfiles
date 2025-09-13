return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"drzel/vim-line-no-indicator",
		{
			"linrongbin16/lsp-progress.nvim",
			config = function()
				require("lsp-progress").setup({
					max_size = 50,
					client_format = function(client_name, spinner, series_messages)
						if #series_messages > 0 then
							return spinner .. " " .. table.concat(series_messages, ", ")
						else
							return nil
						end
					end,

					format = function(client_messages)
						if #client_messages > 0 then
							return table.concat(client_messages, " ")
						end
						return ""
					end,
				})
			end,
		},
		"franco-ruggeri/codecompanion-lualine.nvim",
	},
	config = function()
		require("lualine").setup({
			options = {
				theme = "kanagawa",
				component_separators = "|",
				section_separators = "",
				always_divide_middle = false,
			},
			sections = {
				lualine_a = {
					{
						"mode",
						fmt = function(str)
							-- only show first character of modeq
							return str:sub(1, 1)
						end,
					},
				},
				lualine_b = {
					{
						"branch",
						icon = "",
						fmt = function(str)
							if string.len(str) > 20 then
								return string.sub(str, 1, 20) .. "…"
							else
								return str
							end
						end,
					},
				},
				lualine_c = {
					{
						"filename",
						path = 1, -- 1 => relativepath
						shorting_target = 20,
					},
				},
				lualine_x = {},
				lualine_y = {
					{
						function()
							return require("lsp-progress").progress()
						end,
					},
					"codecompanion",
					{
						function()
							local linters = require("lint").get_running()
							if #linters == 0 then
								return "󰦕"
							end
							return "󱉶 " .. table.concat(linters, ", ")
						end,
					},
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						symbols = {
							error = "󰅚 ", -- xf659
							warn = "󰀪 ", -- xf529
							info = "󰋽 ", -- xf7fc
							hint = "󰌶 ", -- xf835
						},
					},
					{ "filetype", icon_only = false },
				},
				lualine_z = { "LineNoIndicator", "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { { "filename", path = 1 } },
				lualine_x = {},
				lualine_y = {
					{ "filetype", icon_only = false },
				},
				lualine_z = { "LineNoIndicator", "location" },
			},
			tabline = {},
			extensions = {
				"quickfix",
				"lazy",
			},
		})

		-- listen lsp-progress event and refresh lualine
		vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
		vim.api.nvim_create_autocmd("User", {
			group = "lualine_augroup",
			pattern = "LspProgressStatusUpdated",
			callback = require("lualine").refresh,
		})
	end,
}
