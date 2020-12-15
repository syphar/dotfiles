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


nnoremap <F7> :call LanguageClient_contextMenu()<CR>
nnoremap <F8> :call LanguageClient#handleCodeLensAction()<CR>
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
nmap <leader>gd :call LanguageClient#textDocument_definition()<CR>
nmap <leader>n :call LanguageClient#textDocument_references()<CR>
