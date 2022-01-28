-- https://github.com/sindresorhus/cli-spinners
local spinner_symbols = { "⠋ ", "⠙ ", "⠹ ", "⠸ ", "⠼ ", "⠴ ", "⠦ ", "⠧ ", "⠇ ", "⠏ " }
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
		},
		lualine_x = {
			-- {
			-- 	"lsp_progress",
			-- 	display_components = {
			-- 		-- "lsp_client_name",
			-- 		{
			-- 			"title",
			-- 			"message",
			-- 			-- for later: https://changaco.oy.lc/unicode-progress-bars/
			-- 			"percentage",
			-- 		},
			-- 		"spinner",
			-- 	},
			-- 	spinner_symbols = spinner_symbols,
			-- 	timer = { progress_enddelay = 0, spinner = 80, lsp_client_name_enddelay = 0 },
			-- 	message = { commenced = "", completed = "" },
			-- 	separators = {
			-- 		component = " ",
			-- 		progress = " ",
			-- 		lsp_client_name = { pre = "[", post = "] " },
			-- 		title = { pre = "", post = " " },
			-- 		percentage = { pre = "", post = "%% " },
			-- 		message = { pre = "(", post = ") " },
			-- 	},
			-- 	fmt = function(str)
			-- 		-- FIXME ugly hack.
			-- 		-- Something in either the sumneko_lua & rust_analyzer LSPs or
			-- 		-- lualine_lsp_progress leads to some statuses being duplicated.
			-- 		-- This happens only on workspace load / startup.
			-- 		--
			-- 		-- This codes just de-duplicates words, which partially fixes
			-- 		-- this issue.
			-- 		local output = {}
			-- 		local seen = {}

			-- 		for _, word in ipairs(vim.split(str, " ")) do
			-- 			if seen[word] == nil then
			-- 				table.insert(output, word)
			-- 				seen[word] = true
			-- 			end
			-- 		end
			-- 		return table.concat(output, " ")
			-- 	end,
			-- },
		},
		lualine_y = {
			{ "diagnostics", sources = { "nvim_diagnostic" } },
			{ "filetype", icon_only = false },
		},
		lualine_z = { "LineNoIndicator", "location", },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { { "filename", path = 1 } },
		lualine_x = {},
		lualine_y = {
			{ "filetype", icon_only = false },
		},
		lualine_z = { "LineNoIndicator", "location", },
	},
	tabline = {},
	extensions = {
		"fugitive",
		"quickfix",
	},
})
