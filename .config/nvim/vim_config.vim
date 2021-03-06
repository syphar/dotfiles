filetype plugin indent on
syntax enable

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

let g:python3_host_prog = $HOME."/src/neovim_env/venv/bin/python"

" enable mouse support
set mouse=a

" search files into subfolders
" provides tab-complete for all files
set path+=**

" show all options when tab-completing
set wildmenu


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

" these overrides have to be defined before I load the colorscheme
let g:jellybeans_overrides = {
\    'background': { 'ctermbg': 'none', '256ctermbg': 'none', 'guibg': 'none' },
\    'SignColumn': { 'ctermbg': 'none', '256ctermbg': 'none', 'guibg': 'none' },
\    'VertSplit': { 'ctermbg': 'none', '256ctermbg': 'none', 'guibg': 'none' }
\}
colorscheme jellybeans

if executable('rg')
	set grepprg=rg\ --vimgrep\ --hidden\ —glob "!.git"
endif


set wildignore+=.git,.hg,.svn,.idea,.pytest_cache,__pycache__,.DS_Store,tags

set tags=./tags;/,~/.vimtags


" no scrollbars
set guioptions-=L
set guioptions-=l
set guioptions-=R
set guioptions-=r

set showtabline=1

set showmatch

" auto-adjust splits when window is resized
" https://vi.stackexchange.com/questions/201/make-panes-resize-when-host-window-is-resized
autocmd VimResized * wincmd =
set equalalways


" don't show docstring when completing
set completeopt-=preview

set foldmethod=manual
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
set backspace=indent,eol,start

" mkview and loadview shouldn't do options (which includes keyboard mappings
" etc)
set viewoptions=cursor,slash,unix " ,folds


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
set scrolloff=10

set incsearch           " search as characters are entered
set hlsearch            " highlight matches
set smartcase           " smartcase search


" vim: et ts=2 sts=2 sw=2
