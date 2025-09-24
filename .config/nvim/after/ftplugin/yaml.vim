set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

augroup TrimYamlWhitespace
  autocmd!
  autocmd BufWritePre <buffer> %s/\s\+$//e
augroup END
