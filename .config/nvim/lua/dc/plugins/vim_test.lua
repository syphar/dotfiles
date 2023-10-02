return { --simple test running
	"janko/vim-test",
	config = function()
		vim.cmd([[
				let g:test#python#runner = 'pytest'
				let g:test#strategy = 'dispatch'
			]])
	end,
	dependencies = {
		{
			"tpope/vim-dispatch",
			config = function()
				vim.cmd([[
					" If you need more control, *g:dispatch_compilers* can
					" be set to a dictionary with commands for keys and
					" compiler plugins for values.  Use an empty value to
					" skip the matched string and try again with the rest of
					" the command.
					" FIXME : prefix removal ( with poetry run) doesn't work?
					let g:dispatch_compilers = { 
						\ 'poetry' : 'pytest',
						\ 'python' : 'pytest'
					\ }

					" no default keymaps please

					let g:dispatch_no_maps = 1
				]])
			end,
		},
		"radenling/vim-dispatch-neovim",
	},
	ft = { "rust", "python" },
}
