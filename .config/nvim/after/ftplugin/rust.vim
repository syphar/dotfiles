nmap <leader>b :make build<CR>
nmap <leader>c :make check<CR>

let g:rust_fold=0


lua << EOF
vim.keymap.set("n", "<leader>w", require("telescope.builtin").lsp_dynamic_workspace_symbols)
vim.keymap.set("n", "gh", require("rustaceanvim.commands.external_docs"))
EOF
