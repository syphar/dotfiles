nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
nmap <leader>gd :call LanguageClient#textDocument_definition()<CR>
nmap <leader>n :call LanguageClient#textDocument_references()<CR>
