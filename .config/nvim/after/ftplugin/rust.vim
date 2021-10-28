nmap <leader>tr :term cargo run<CR>
nmap <leader>tn :TestNearest<CR>
nmap <leader>tf :TestFile<CR>
nmap <leader>ts :TestSuite<CR>
nmap <leader>tl :TestLast<CR>

compiler cargo
setlocal makeprg=cargo\ build

let g:rust_fold=1
