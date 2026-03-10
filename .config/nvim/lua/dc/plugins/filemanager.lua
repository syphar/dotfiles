return {
	{
		"stevearc/oil.nvim",
		opts = {
			keymaps = {
				["q"] = { "actions.close", mode = "n" },
				["<ESC>"] = { "actions.close", mode = "n" },
			},
			win_options = {
				signcolumn = "yes:1",
			},
		},
		dependencies = {
			{ "echasnovski/mini.icons", opts = {} },
			"nvim-tree/nvim-web-devicons", -- use if prefer nvim-web-devicons
			{
				"malewicz1337/oil-git.nvim",
				dependencies = { "stevearc/oil.nvim" },
				opts = {},
			},
		},
		keys = {
			{
				"-",
				"<CMD>Oil --float<CR>",
				{ desc = "Open parent directory" },
			},
		},
	},
}
