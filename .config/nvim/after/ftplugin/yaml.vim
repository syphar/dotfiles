setlocal expandtab
setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2

augroup TrimYamlWhitespace
  autocmd! * <buffer>
  autocmd BufWritePre <buffer> %s/\s\+$//e
augroup END
