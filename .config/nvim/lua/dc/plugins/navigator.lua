-- jump between vim and tmux splits with C+hjkl
return {
	"numToStr/Navigator.nvim",
	keys = {
		{
			"<C-h>",
			function()
				require("Navigator").left()
			end,
			"n",
		},
		{
			"<C-k>",
			function()
				require("Navigator").up()
			end,
			"n",
		},
		{
			"<C-l>",
			function()
				require("Navigator").right()
			end,
			"n",
		},
		{
			"<C-j>",
			function()
				require("Navigator").down()
			end,
			"n",
		},
	},
}
