" LanguageClient_Neovim
" ______________________________________________________________________

" pyls only works when run in a venv with version smaller than the smallest
" project python runtime
let g:LanguageClient_serverCommands = {
    \ 'python': ['~/src/pyls/venv/bin/pyls'],
    \ 'rust': ['~/.local/bin/rust-analyzer'],
    \ 'go': ['gopls'],
    \ 'typescript': ['typescript-language-server', '--stdio'],
    \ 'typescript.tsx': ['typescript-language-server', '--stdio'],
    \ }

let g:LanguageClient_diagnosticsEnable = 0  " disable LC-Checks because I'm using ALE
let g:LanguageClient_useVirtualText="CodeLens"

nnoremap <F7> :call LanguageClient_contextMenu()<CR>
nnoremap <F8> :call LanguageClient#handleCodeLensAction()<CR>
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
nmap <leader>c :call LanguageClient#textDocument_visualCodeAction()<CR>
nmap <leader>gd :call LanguageClient#textDocument_definition()<CR>
nmap <leader>n :call LanguageClient#textDocument_references()<CR>

" nnoremap <leader>lf :call LanguageClient#textDocument_formatting()<CR>
nnoremap <leader>lt :call LanguageClient#textDocument_typeDefinition()<CR>
" nnoremap <leader>la :call LanguageClient_workspace_applyEdit()<CR>
" nnoremap <leader>lc :call LanguageClient#textDocument_completion()<CR>
nnoremap <leader>ls :call LanguageClient_textDocument_documentSymbol()<CR>
