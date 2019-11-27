if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/Users/syphar/.cache/dein/repos/github.com/Shougo/dein.vim

if has('nvim')
  let g:python2_host_prog = '/usr/local/bin/python'
  let g:python3_host_prog = '/usr/local/bin/python3'
endif


" Required:
if dein#load_state('/Users/syphar/.cache/dein')
  call dein#begin('/Users/syphar/.cache/dein')

  " Let dein manage dein
  " Required:
  call dein#add('/Users/syphar/.cache/dein/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here:
  call dein#add('vim-scripts/LargeFile')
  call dein#add('kien/ctrlp.vim')
  call dein#add('FelikZ/ctrlp-py-matcher')
  call dein#add('terryma/vim-expand-region')
  call dein#add('tpope/vim-fugitive')
  call dein#add('tpope/vim-commentary')
  call dein#add('vim-scripts/gitignore')
  call dein#add('bling/vim-airline')
  call dein#add('vim-airline/vim-airline-themes')
  call dein#add('scrooloose/syntastic')
  call dein#add('scrooloose/nerdtree')
  call dein#add('ywjno/vim-tomorrow-theme')
  call dein#add('vim-scripts/AutoTag')
  call dein#add('rking/ag.vim')
  call dein#add('airblade/vim-gitgutter')
  call dein#add('vim-scripts/django.vim')
  call dein#add('editorconfig/editorconfig-vim')
  call dein#add('majutsushi/tagbar')
  call dein#add('direnv/direnv.vim') 

  call dein#add('davidhalter/jedi-vim')
  call dein#add('Shougo/deoplete.nvim')
  if !has('nvim')
    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
  endif
  call dein#add('deoplete-plugins/deoplete-jedi')

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

"End dein Scripts-------------------------
"

" built with inspiration from
" http://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/

" Select your Leader key
let mapleader = ","

if has ('gui')
  set clipboard=unnamed
  set autoread
endif

let g:gitgutter_enabled = 1

" let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
      \ --ignore .git
      \ --ignore .svn
      \ --ignore .direnv
      \ --ignore .pytest_cache
      \ --ignore __pycache__
      \ --ignore .hg
      \ --ignore .DS_Store
      \ --ignore "**/*.pyc"
      \ -g ""'
let g:ctrlp_working_path_mode = 2
nnoremap <silent> <D-t> :CtrlP<CR>
nnoremap <silent> <D-r> :CtrlPMRU<CR>
nmap <leader>m :CtrlPBufTag<CR>
nmap <leader>n :CtrlPTag<CR>
nmap <leader>r :CtrlPBookmarkDir<CR>
nmap <leader>t :CtrlPMixed<CR>
let g:ctrlp_use_caching = 1
let g:ctrlp_prompt_mappings = {
  \ 'AcceptSelection("e")': ['<space>', '<cr>', '<2-LeftMouse>'],
  \ }
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }

vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

let g:jedi#completions_enabled = 0
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#jedi#enable_typeinfo = 1
let g:deoplete#sources#jedi#show_docstring = 0

" deoplete tab-complete
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"


let g:airline_theme='powerlineish'
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_section_z=''
let g:airline#extensions#tabline#enabled = 1

let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
let g:syntastic_enable_balloons = 0
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_jump = 0
let g:syntastic_enable_signs = 1
let g:syntastic_aggregate_errors=1
let g:syntastic_python_checkers=['flake8', 'python']
let g:syntastic_python_flake8_args="--ignore=E501"

let g:NERDShutUp=1
map <C-e> :NERDTreeToggle<CR>:NERDTreeMirror<CR>
map <leader>e :NERDTreeFind<CR>
nmap <leader>nt :NERDTreeFind<CR>

let NERDTreeRespectWildIgnore=1
set wildignore+=*.pyc,.git,.hg,.svn,.idea,.direnv,.pytest_cache,__pycache__,.DS_Store,tags

let NERDTreeShowBookmarks=1
let NERDTreeChDirMode=2
let NERDTreeQuitOnOpen=1
let NERDTreeMouseMode=2
let NERDTreeShowHidden=1
let NERDTreeKeepTreeInNewTab=1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1


let g:indent_guides_auto_colors = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1

set background=dark
colorscheme tomorrow-night


let g:tagbar_width = 30
let g:tagbar_foldlevel = 1
nnoremap <silent> <F3> :TagbarToggle<CR>

set tags=./tags;/,~/.vimtags

" no scrollbars
set guioptions-=L
set guioptions-=l
set guioptions-=R
set guioptions-=r

" no tabline even if there are tabs
set showtabline=0

" move between tabs with cmd+number
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


" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

nnoremap <Leader>o :CtrlP<CR>

" common typos .. (Wq WQ)
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

" highlight characters over 80 line length
highlight OverLength ctermbg=88 ctermfg=white guibg=#592929
match OverLength /\%81v.\+/


" don't show docstring when completing 
autocmd FileType python setlocal completeopt-=preview


set backspace=indent,eol,start
