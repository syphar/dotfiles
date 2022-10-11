nmap <leader>b :make build<CR>
nmap <leader>c :make check<CR>
nmap <leader>tr :call test#strategy#neovim("cargo run")<CR>
nmap <leader>tn :TestNearest<CR>
nmap <leader>tf :TestFile<CR>
nmap <leader>ts :TestSuite<CR>
nmap <leader>tl :TestLast<CR>

let g:rust_fold=0


lua << EOF
vim.keymap.set("n", "<leader>w", require("telescope.builtin").lsp_dynamic_workspace_symbols)
EOF
