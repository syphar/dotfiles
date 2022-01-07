-- https://github.com/sindresorhus/cli-spinners
local spinner_symbols = { "⠋ ", "⠙ ", "⠹ ", "⠸ ", "⠼ ", "⠴ ", "⠦ ", "⠧ ", "⠇ ", "⠏ " }
local gps_separator = " > "
require("nvim-gps").setup({
	icons = {
		["class-name"] = " ",
		["function-name"] = " ",
		["method-name"] = " ",
		["container-name"] = " ",
		["tag-name"] = "» ",
	},
	languages = {},
	separator = gps_separator,
	depth = 2,
	depth_limit_indicator = "…",
})

local gps = require("nvim-gps")
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
				"b:gitsigns_head",
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
			{ gps.get_location, cond = gps.is_available },
		},
		lualine_x = {
			{
				"lsp_progress",
				display_components = {
					-- "lsp_client_name",
					{
						"title",
						"message",
						"percentage",
					},
					"spinner",
				},
				spinner_symbols = spinner_symbols,
				timer = { progress_enddelay = 0, spinner = 80, lsp_client_name_enddelay = 0 },
				message = { commenced = "", completed = "" },
				separators = {
					component = " ",
					progress = " ",
					lsp_client_name = { pre = "[", post = "] " },
					title = { pre = "", post = " " },
					percentage = { pre = "", post = "%% " },
					message = { pre = "(", post = ") " },
				},
			},
		},
		lualine_y = {
			{ "diagnostics", sources = { "nvim_diagnostic" } },
		},
		lualine_z = {
			{ "filetype", icon_only = false },
		},
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { { "filename", path = 1 } },
		lualine_x = {},
		lualine_y = {},
		lualine_z = {
			{ "filetype", icon_only = false },
		},
	},
	tabline = {},
	extensions = {
		"fugitive",
		"quickfix",
	},
})
