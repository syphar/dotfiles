set nocompatible               " be iMproved
filetype off                   " required!


set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

Bundle 'scrooloose/nerdtree'
Bundle 'kien/ctrlp.vim'
Bundle 'Lokaltog/vim-powerline'
Bundle 'jistr/vim-nerdtree-tabs'
Bundle 'nathanaelkane/vim-indent-guides'

Bundle 'tpope/vim-fugitive'
Bundle 'scrooloose/nerdcommenter'
Bundle 'majutsushi/tagbar'

"Bundle 'scrooloose/syntastic'
Bundle 'Valloric/YouCompleteMe'
Bundle 'Lokaltog/vim-easymotion'

Bundle 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}

Bundle 'klen/python-mode'
Bundle 'python.vim'

Bundle 'tpope/vim-markdown'

Bundle 'git://vim-latex.git.sourceforge.net/gitroot/vim-latex/vim-latex'
Bundle 'vim-scripts/LargeFile'
Bundle 'AutoTag'

Bundle 'mileszs/ack.vim'
Bundle 'airblade/vim-gitgutter'
Bundle 'scrooloose/syntastic'


filetype plugin indent on     
syntax on                   " Syntax highlighting
set mouse=a                 " Automatically enable mouse usage
set mousehide               " Hide the mouse cursor while typing
scriptencoding utf-8

if has ('gui') 
	set clipboard=unnamed
endif

" Always switch to the current file directory
"autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif

set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
set virtualedit=onemore             " Allow for cursor beyond last character
set history=1000                    " Store a ton of history (default is 20)
set spell                           " Spell checking on
set hidden                          " Allow buffer switching without saving

set backup                  " Backups are nice ...
set backupdir=$HOME/.vim/backup//
set undofile                " So is persistent undo ...
set undolevels=1000         " Maximum number of changes that can be undone
set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
set undodir=$HOME/.vim/undo//

set directory=$HOME/.vim/swap//

set tabpagemax=15               " Only show 15 tabs
set showmode                    " Display the current mode

set cursorline                  " Highlight current line

if has('cmdline_info')
	set ruler                   " Show the ruler
	set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
	set showcmd                 " Show partial commands in status line and
				    " Selected characters/lines in visual mode
endif

if has('statusline')
	set laststatus=2

	" Broken down into easily includeable segments
	set statusline=%<%f\                     " Filename
	set statusline+=%w%h%m%r                 " Options
	set statusline+=%{fugitive#statusline()} " Git Hotness
	set statusline+=\ [%{&ff}/%Y]            " Filetype
	set statusline+=\ [%{getcwd()}]          " Current dir
	set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
endif

set backspace=indent,eol,start  " Backspace for dummies
set linespace=0                 " No extra spaces between rows
set nu                          " Line numbers on
set showmatch                   " Show matching brackets/parenthesis
set incsearch                   " Find as you type search
set hlsearch                    " Highlight search terms
set winminheight=0              " Windows can be 0 line high
set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive when uc present
set wildmenu                    " Show list instead of just completing
set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
set scrolljump=5                " Lines to scroll when cursor leaves screen
set scrolloff=3                 " Minimum lines to keep above and below cursor
set foldenable                  " Auto fold code
set list
set listchars=tab:,.,trail:.,extends:#,nbsp:. " Highlight problematic whitespace

set nowrap                      " Wrap long lines
set autoindent                  " Indent at the same level of the previous line
set shiftwidth=4                " Use indents of 4 spaces
set expandtab                   " Tabs are spaces, not tabs
set tabstop=4                   " An indentation every four columns
set softtabstop=4               " Let backspace delete indent
"set matchpairs+=<:>             " Match, to be used with %
set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
"set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
" Remove trailing whitespaces and ^M chars
autocmd FileType c,cpp,java,php,javascript,python,twig,xml,yml autocmd BufWritePre <buffer> call StripTrailingWhitespace()
autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig

let mapleader = ','

" Easier moving in tabs and windows
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_
map <C-L> <C-W>l<C-W>_
map <C-H> <C-W>h<C-W>_

" Wrapped lines goes down/up to next row, rather than next line in file.
nnoremap j gj
nnoremap k gk

if has("user_commands")
    command! -bang -nargs=* -complete=file E e<bang> <args>
    command! -bang -nargs=* -complete=file W w<bang> <args>
    command! -bang -nargs=* -complete=file Wq wq<bang> <args>
    command! -bang -nargs=* -complete=file WQ wq<bang> <args>
    command! -bang Wa wa<bang>
    command! -bang WA wa<bang>
    command! -bang Q q<bang>
    command! -bang QA qa<bang>
    command! -bang Qa qa<bang>
endif

cmap Tabe tabe

" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$

" Toggle search highlighting
nmap <silent> <leader>/ :set invhlsearch<CR>

" Change Working Directory to that of the current file
cmap cwd lcd %:p:h
cmap cd. lcd %:p:h

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" Fix home and end keybindings for screen, particularly on mac
" - for some reason this fixes the arrow keys too. huh.
map [F $
imap [F $
map [H g0
imap [H g0

" Some helpers to edit mode
" http://vimcasts.org/e/14
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%

" Adjust viewports to the same size
map <Leader>= <C-w>=

" Map <Leader>ff to display all lines with keyword under cursor
" and ask which one to jump to
nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

let g:NERDShutUp=1
let b:match_ignorecase = 1

set tags=./tags;/,~/.vimtags

"Nerdtree
map <C-e> :NERDTreeToggle<CR>:NERDTreeMirror<CR>
map <leader>e :NERDTreeFind<CR>
nmap <leader>nt :NERDTreeFind<CR>

let NERDTreeShowBookmarks=1
let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
let NERDTreeChDirMode=2
let NERDTreeQuitOnOpen=1
let NERDTreeMouseMode=2
let NERDTreeShowHidden=1
let NERDTreeKeepTreeInNewTab=1
let g:nerdtree_tabs_open_on_gui_startup=0

let g:ctrlp_working_path_mode = 2
nnoremap <silent> <D-t> :CtrlP<CR>
nnoremap <silent> <D-r> :CtrlPMRU<CR>
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll|pyc|class)$',
  \ }

let g:ctrlp_user_command = {
    \ 'types': {
    \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
	\ 2: ['.hg', 'hg --cwd %s locate -I .'],
    \ },
    \ 'fallback': 'find %s -type f'
\ }

nnoremap <silent> <leader>tt :TagbarToggle<CR>

nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gl :Glog<CR>
nnoremap <silent> <leader>gp :Git push<CR>

let g:indent_guides_auto_colors = 1
set ts=4 sw=4 et
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1

if has('gui_running')
	set guioptions-=T           " Remove the toolbar
	set lines=40                " 40 lines of text instead of 24,
else
	if &term == 'xterm' || &term == 'screen'
	    set t_Co=256                 " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
	endif
endif

function! StripTrailingWhitespace()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " do the business:
    %s/\s\+$//e
    " clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

set guifont=Source\ Code\ Pro:h12,Monaco:h12,Andale\ Mono\ Regular:h12,Menlo\ Regular:h12,Consolas\ Regular:h12,Courier\ New\ Regular:h12

colorscheme tomorrow-night

map <D-1> :tabn 1<CR>
map <D-2> :tabn 2<CR>
map <D-3> :tabn 3<CR>
map <D-4> :tabn 4<CR>
map <D-5> :tabn 5<CR>
map <D-6> :tabn 6<CR>
map <D-7> :tabn 7<CR>
map <D-8> :tabn 8<CR>
map <D-9> :tabn 9<CR>

map! <D-1> <C-O>:tabn 1<CR>
map! <D-2> <C-O>:tabn 2<CR>
map! <D-3> <C-O>:tabn 3<CR>
map! <D-4> <C-O>:tabn 4<CR>
map! <D-5> <C-O>:tabn 5<CR>
map! <D-6> <C-O>:tabn 6<CR>
map! <D-7> <C-O>:tabn 7<CR>
map! <D-8> <C-O>:tabn 8<CR>
map! <D-9> <C-O>:tabn 9<CR>


" moving between windows like in iterm
map <M-D-Down> <C-W>j<C-W>_
map <M-D-Up> <C-W>k<C-W>_
map <M-D-Right> <C-W>l<C-W>_
map <M-D-Left> <C-W>h<C-W>_

if has('gui_running')
    " switch buffers with swiping
    nmap <SwipeUp> :bN<CR>
    nmap <SwipeDown> :bn<CR>
    nnoremap <SwipeLeft> gT
    nnoremap <SwipeRight> gt
endif

"tags for current buffer
nmap <leader>m :CtrlPBufTag<CR>
nmap <leader>n :CtrlPTag<CR>

set wildignore+=*/target/*
 
"ignore tags in nerdtree
let NERDTreeIgnore=['.DS_Store', '^tags$', '\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr', '\.class$']
let NERDTreeShowHidden=0

set nolist
set listchars=tab:▸\ ,trail:.,extends:#,nbsp:.


let g:virtualenv_auto_activate = 1
let g:virtualenv_stl_format = '[Env: %n]'

"show errorlist when there are errors
let g:syntastic_auto_loc_list=1
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
let g:syntastic_python_checker="flake8,pyflakes,pylint,python"
let g:syntastic_python_flake8_args="--ignore=E501"
let g:syntastic_java_javac_autoload_maven_classpath=1

let g:pymode_lint = 0
let g:pymode_utils_whitespaces = 0
let g:pymode_rope = 0
let g:pymode_folding = 0
let g:pymode_virtualenv = 0

" Filetype-specific tabs and spaces"
autocmd FileType php setlocal ts=4 sts=4 sw=4 noexpandtab
autocmd FileType rst setlocal ts=2 sts=2 sw=2 noexpandtab textwidth=78 spell spelllang=de_de
autocmd FileType java setlocal ts=4 sts=4 sw=4 noexpandtab
autocmd FileType markdown setlocal textwidth=78 spell spelllang=de_de

set colorcolumn=80
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%>80v.\+/

" auto clean fugitive-buffers
autocmd BufReadPost fugitive://* set bufhidden=delete

set nospell

let g:Tex_ViewRule_pdf = 'Preview'

"ignore whitespace in vimdiff
set diffopt+=iwhite

" no scrollbars
set guioptions-=L
set guioptions-=l
set guioptions-=R
set guioptions-=r

" no tabline even if there are tabs
set showtabline=0

"completely disable folding
set nofoldenable
