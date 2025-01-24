" 88 is black format default
setlocal textwidth=88
setlocal colorcolumn=89

setlocal foldlevelstart=0
setlocal foldlevel=0

set suffixesadd+=.py,__init__.py

DashKeywords python3 django

nnoremap <silent> gh <cmd>Telescope python_docs<CR>
vnoremap <silent> gh "zy:Telescope python_docs search=<C-r>z<CR>


lua << EOF
vim.keymap.set("n", "<leader>w", function()
	-- choose from files inside current virtualenv
	require("telescope.builtin").find_files({
		path_display = { "smart" },
		find_command = {
			"fd",
			"--type",
			"f",
			"--hidden",
			"--no-ignore",
			[[.*\.pyi?$]],
			vim.env.VIRTUAL_ENV,
		},
	})
end)
EOF
