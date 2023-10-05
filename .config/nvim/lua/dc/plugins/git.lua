return {
	{ --git commands
		"tpope/vim-fugitive",
		cmd = { "Git", "Gedit", "GEdit" },
	},
	{ --fugitive and github integration
		"tpope/vim-rhubarb",
		dependencies = { "tpope/vim-fugitive" },
		cmd = { "GBrowse", "Gbrowse" },
	},
	{ "lewis6991/gitsigns.nvim", dependencies = { "nvim-lua/plenary.nvim" }, config = true },
}
