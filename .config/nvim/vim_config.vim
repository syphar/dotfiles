filetype plugin indent on
syntax enable

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif


if filereadable('/usr/local/bin/python3')
  let g:python_host_prog = '/usr/local/bin/python2'
  let g:python3_host_prog = '/usr/local/bin/python3'
else
  let g:python_host_prog = '/usr/bin/python2'
  let g:python3_host_prog = '/usr/bin/python3'
endif

" global tab/spaces settings
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" really write files
set fsync

set clipboard=unnamed  " use system clipboard
set autoread
set hidden

set conceallevel=2
set concealcursor=""

" to get an incremental visual feedback when doing the substitude command.
set inccommand=split

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

" better backup, swap and undos storage
set backup                        " make backup files
set undofile                      " persistent undos - undo after you re-open the file
set directory=~/.cache/vim/dirs/tmp     " directory to place swap files in
set backupdir=~/.cache/vim/dirs/backups " where to put backup files
set undodir=~/.cache/vim/dirs/undodir   " undo directory

" Redraw only when essential
set lazyredraw

" Just sync some lines of a large file
set synmaxcol=400
syntax sync minlines=256

" Highlight cursor line (slows down)
set nocursorline

" Set updatetime
set updatetime=2000

" When scrolling, keep cursor 5 lines away from screen border
set scrolloff=5

" vim: et ts=2 sts=2 sw=2
