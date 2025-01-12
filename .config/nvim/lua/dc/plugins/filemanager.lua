return {
	"stevearc/oil.nvim",
	opts = {
		keymaps = {
			["q"] = { "actions.close", mode = "n" },
		},
	},
	dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
	keys = {
		{
			"-",
			"<CMD>Oil --float<CR>",
			{ desc = "Open parent directory" },
		},
	},
}
