" 100 is rustfmt default
setlocal textwidth=100
setlocal colorcolumn=101

nnoremap <buffer> <leader>b :make build<CR>
nnoremap <buffer> <leader>c :make check<CR>

let g:rust_fold=0


lua << EOF
vim.keymap.set("n", "<leader>w", function()
    require("telescope.builtin").lsp_dynamic_workspace_symbols()
end, { buffer = true, silent = true })
vim.keymap.set("n", "gh", function()
    require("rustaceanvim.commands.external_docs")()
end, { buffer = true, silent = true })
vim.keymap.set("n", "<leader>tr", function()
    vim.cmd([[!cargo run]])
end, { buffer = true, silent = true })
vim.keymap.set("n", "<leader>tn", function()
    vim.cmd([[RustTest]])
end, { buffer = true, silent = true })
vim.keymap.set("n", "<leader>l", function()
	vim.notify("running clippy fix...")
	require("lint").try_lint("clippy")
end, { buffer = true, silent = true })
EOF
