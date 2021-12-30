local default_colors = require("kanagawa.colors").setup()
require("kanagawa").setup({
	undercurl = true, -- enable undercurls
	commentStyle = "italic",
	functionStyle = "NONE",
	keywordStyle = "bold",
	statementStyle = "bold",
	typeStyle = "NONE",
	variablebuiltinStyle = "italic",
	specialReturn = true,
	specialException = true,
	transparent = true,
	colors = {
		-- inactive statusline was too dark, should be brighter
		bg_status = default_colors.bg_light0,
	},
	overrides = {
		-- brighter background for context and LspReference
		TreesitterContext = { bg = default_colors.bg_light0 },
		LspReferenceText = { bg = default_colors.bg_light0 },
		-- default NormalFloat BG is too dark
		NormalFloat = { bg = default_colors.bg_light1 },
	},
})
vim.cmd("colorscheme kanagawa")
