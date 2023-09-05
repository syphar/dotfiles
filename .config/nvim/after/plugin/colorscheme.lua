require("kanagawa").setup({
	compile = false,
	undercurl = true, -- enable undercurls
	commentStyle = { italic = true },
	functionStyle = {},
	keywordStyle = { bold = true },
	statementStyle = { bold = true },
	typeStyle = {},
	variablebuiltinStyle = { italic = true },
	specialReturn = true,
	specialException = true,
	transparent = true,
	dimInactive = false,
	globalStatus = true,
	colors = {
		theme = {
			all = {
				ui = {
					bg_gutter = "none",
				},
			},
		},
	},
	overrides = function(colors)
		return {
			-- brighter background for context and LspReference
			TreesitterContext = { bg = colors.palette.sumiInk4 },
			LspReferenceText = { bg = colors.palette.sumiInk4 },
			-- default NormalFloat BG is too dark
			NormalFloat = { bg = colors.palette.sumiInk3 },
			WinSeparator = { bg = "NONE", fg = "#727169" },
		}
	end,
})
vim.cmd("colorscheme kanagawa")
