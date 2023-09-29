return {
	{
		-- jump between vim and tmux splits with C+hjkl
		"numToStr/Navigator.nvim",
		config = true,
		keys = {
			{
				"<C-h>",
				function()
					require("Navigator").left()
				end,
			},
			{
				"<C-k>",
				function()
					require("Navigator").up()
				end,
			},
			{
				"<C-l>",
				function()
					require("Navigator").right()
				end,
			},
			{
				"<C-j>",
				function()
					require("Navigator").down()
				end,
			},
		},
	},
	--easily resize vim and tmux panes through meta+hjkl
	"RyanMillerC/better-vim-tmux-resizer",
}
