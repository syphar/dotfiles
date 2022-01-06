local function diff_source()
	-- https://github.com/nvim-lualine/lualine.nvim/wiki/Component-snippets#using-external-source-for-diff
	local gitsigns = vim.b.gitsigns_status_dict
	if gitsigns then
		return {
			added = gitsigns.added,
			modified = gitsigns.changed,
			removed = gitsigns.removed,
		}
	end
end

require("nvim-gps").setup({
	icons = {
		["class-name"] = " ",
		["function-name"] = " ",
		["method-name"] = " ",
		["container-name"] = " ",
		["tag-name"] = "» ",
	},
	languages = {},
	separator = " > ",
	depth = 20,
	depth_limit_indicator = "..",
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
			{ "diff", source = diff_source },
			{ "diagnostics", sources = { "nvim_diagnostic" } },
		},
		lualine_c = {
			{
				"filename",
				path = 1, -- 1 => relativepath
			},
			{ gps.get_location, cond = gps.is_available },
		},
		lualine_x = {
			{
				"lsp_progress",
				display_components = {
					"lsp_client_name",
					{
						-- "title",
						"percentage",
						"message",
					},
					"spinner",
				},
				-- https://github.com/sindresorhus/cli-spinners
				spinner_symbols = { "⠋ ", "⠙ ", "⠹ ", "⠸ ", "⠼ ", "⠴ ", "⠦ ", "⠧ ", "⠇ ", "⠏ " },
				timer = { progress_enddelay = 100, spinner = 80, lsp_client_name_enddelay = 100 },
				message = { commenced = "", completed = "" },
				separators = {
					component = " ",
					progress = " ",
					title = { pre = "", post = " " },
					message = { pre = "(", post = ")" },
				},
			},
		},
		lualine_y = {
			{ "filetype", icon_only = false },
		},
		lualine_z = { "progress", "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { { "filename", path = 1 } },
		lualine_x = {},
		lualine_y = {},
		lualine_z = { "progress", "location" },
	},
	tabline = {},
	extensions = {
		"fugitive",
		"quickfix",
	},
})
