" vim-test
nmap <leader>tn :TestNearest<CR>
nmap <leader>tf :TestFile<CR>
nmap <leader>ts :TestSuite<CR>
nmap <leader>tl :TestLast<CR>

source $HOME/.config/nvim/languageserver.vim

let b:indentLine_enabled = 0

let g:ale_fixers.python = ['black', 'autopep8', 'yapf', 'isort']

" type ,p to insert breakpoint. ^[ is at the end.  Insert with ctrl v and then esc
" (the github web gui doesn't display control characters, but it is there)
nnoremap <leader>b oimport pdb;pdb.set_trace()
