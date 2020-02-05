" LanguageClient_Neovim
" ______________________________________________________________________

" pyls only works when run in a venv with version smaller than the smallest
" project python runtime
let g:LanguageClient_serverCommands = {
    \ 'python': ['~/src/pyls/venv/bin/pyls'],
    \ 'rust': ['~/src/rust-analyzer/target/release/ra_lsp_server'],
    \ }
    " \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],

let g:LanguageClient_diagnosticsEnable = 0  " disable LC-Checks because I'm using ALE

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
nmap <leader>gd :call LanguageClient#textDocument_definition()<CR>
nmap <leader>n :call LanguageClient#textDocument_references()<CR>
