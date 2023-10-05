return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = {
		{ "kyazdani42/nvim-web-devicons" },
	},
	opts = {
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
	},
}
