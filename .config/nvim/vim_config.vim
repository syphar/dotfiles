filetype plugin indent on
syntax enable

set clipboard=unnamed  " use system clipboard
set autoread
set hidden
set laststatus=2
set noshowmode

set background=dark
colorscheme base16-tomorrow-night

set wildignore+=.git,.hg,.svn,.idea,.pytest_cache,__pycache__,.DS_Store,tags

set tags=./tags;/,~/.vimtags

" no scrollbars
set guioptions-=L
set guioptions-=l
set guioptions-=R
set guioptions-=r

set showtabline=1

" auto-adjust splits when window is resized
" https://vi.stackexchange.com/questions/201/make-panes-resize-when-host-window-is-resized
autocmd VimResized * wincmd =
set equalalways


" don't show docstring when completing
set completeopt-=preview

" set nofoldenable
set foldmethod=manual
set backspace=indent,eol,start

" mkview and loadview shouldn't do options (which includes keyboard mappings
" etc)
set viewoptions-=options


" https://vi.stackexchange.com/questions/16148/slow-vim-escape-from-insert-mode
set timeoutlen=1000
set ttimeoutlen=5

" vim: et ts=2 sts=2 sw=2
