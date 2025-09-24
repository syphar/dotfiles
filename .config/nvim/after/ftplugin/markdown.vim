setlocal textwidth=80
setlocal formatoptions+=t "auto-wrap text using textwidth
setlocal colorcolumn=81
setlocal spell

noremap <leader>rr :Glow<CR>

augroup TrimMarkdownWhitespace
  autocmd!
  autocmd BufWritePre <buffer> %s/\s\+$//e
augroup END
