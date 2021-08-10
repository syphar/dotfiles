" LanguageClient_Neovim
" ______________________________________________________________________

lua << EOF
local lsp = require('lspconfig')
lsp.pylsp.setup({
    on_attach = function(client, bufnr)
        require "lsp_signature".on_attach({
            bind = true,
        })  
    end,
    settings = {
        pylsp = {
            configurationSources = {"flake8", "pycodestyle"},
            plugins = {
                pydocstyle = {
                    enabled = true
                },
                pycodestyle = {
                    enabled = true
                },
                pyflakes = {
                    enabled = true
                },
                jedi_signature_help = {
                    enabled = false
                },
                pylsp_mypy = {
                    enabled = true, 
                    live_mode = false,
                    dmypy = true,
                }
            },
        },
    }
})

-- lsp.pyright.setup({
--     settings = {
--         disableLanguageServices = true,
--         disableOrganizeImports = true,
--     }
-- })

-- lsp.efm.setup({
--     init_options = {documentFormatting = true},
--     settings = {
--         rootMarkers = {".git/"},
--         languages = {
--             lua = {
--                 {formatCommand = "lua-format -i", formatStdin = true}
--             }
--         }
--     }
-- })

EOF

autocmd BufWritePre * lua vim.lsp.buf.formatting_sync(nil, 1000)

" nnoremap <F7> :call LanguageClient_contextMenu()<CR>
" nnoremap <F8> :call LanguageClient#handleCodeLensAction()<CR>
nnoremap <silent> K :lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <F2> :lua vim.lsp.buf.rename()<CR>
" nmap <leader>c :call LanguageClient#textDocument_visualCodeAction()<CR>
nmap <leader>gd :lua vim.lsp.buf.definition()<CR>
nmap <leader>n :lua vim.lsp.buf.references()<CR>
