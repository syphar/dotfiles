" 100 is rustfmt default
setlocal textwidth=100
setlocal colorcolumn=101

nmap <leader>b :make build<CR>
nmap <leader>c :make check<CR>

let g:rust_fold=0


lua << EOF
vim.keymap.set("n", "<leader>w", function() 
    require("telescope.builtin").lsp_dynamic_workspace_symbols()
end)
vim.keymap.set("n", "gh", function()
    require("rustaceanvim.commands.external_docs")()
end)
vim.keymap.set("n", "<leader>tr", function()
    vim.cmd([[!cargo run]])
end)
vim.keymap.set("n", "<leader>tn", function() 
    vim.cmd([[RustTest]])
end )
vim.keymap.set("n", "<leader>ts", function() 
    vim.cmd([[Ctest]])
end )
vim.keymap.set("n", "<leader>l", function() 
	vim.notify("running clippy fix...")
	require("lint").try_lint("clippy")
end)
EOF
