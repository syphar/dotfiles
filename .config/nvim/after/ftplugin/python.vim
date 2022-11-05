if executable('pytest')
    compiler pytest
    " nmap <leader>ts :make<CR>
    " nmap <leader>tf :make %<CR>
endif

" vim-test
nmap <leader>tn :TestNearest<CR>
nmap <leader>tf :TestFile<CR>
nmap <leader>ts :TestSuite<CR>
nmap <leader>tl :TestLast<CR>

let g:test#python#pytest#options = {
    \ 'nearest': '--show-capture=no --disable-warnings --tb=short -vv',
    \ 'file':    '--show-capture=no --disable-warnings --tb=short -vv',
    \ 'suite':   '--show-capture=no --disable-warnings --tb=short -vv',
  \}

" 88 is black format default
setlocal textwidth=88

set suffixesadd+=.py,__init__.py

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
