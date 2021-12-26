if executable('pytest')
    compiler pytest
    nmap <leader>ts :make<CR>
    nmap <leader>tf :make %<CR>
endif

" 88 is black format default
setlocal textwidth=88
