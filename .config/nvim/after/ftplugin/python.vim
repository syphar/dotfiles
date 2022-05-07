if executable('pytest')
    compiler pytest
    " nmap <leader>ts :make<CR>
    " nmap <leader>tf :make %<CR>
endif

" vim-test
nmap <leader>tn :TestNearest<CR>
nmap <leader>tf :TestFile<CR>
nmap <leader>ts :TestSuite<CR>
nmap <leader>tl :TestLast<CR>

let g:test#python#pytest#options = {
    \ 'nearest': '--show-capture=no --disable-warnings --tb=short -vv',
    \ 'file':    '--show-capture=no --disable-warnings --tb=short -vv',
    \ 'suite':   '--show-capture=no --disable-warnings --tb=short -vv',
  \}

" 88 is black format default
setlocal textwidth=88

set suffixesadd+=.py,__init__.py

DashKeywords python3 django
