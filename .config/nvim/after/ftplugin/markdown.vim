setlocal textwidth=80
setlocal formatoptions+=t "auto-wrap text using textwidth
setlocal colorcolumn=81
setlocal spell

augroup TrimMarkdownWhitespace
  autocmd! * <buffer>
  autocmd BufWritePre <buffer> %s/\s\+$//e
augroup END
