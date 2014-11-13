" built with inspiration from
" http://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/

" Select your Leader key
let mapleader = ","


" Load sensible defaults and setup NeoBundle
call vimrc#before()

NeoBundle 'Shougo/vimproc.vim', {
      \ 'build' : {
      \     'windows' : 'tools\\update-dll-mingw',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'linux' : 'make',
      \     'unix' : 'gmake',
      \    },
      \ }

NeoBundle 'kien/ctrlp.vim'
" let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
      \ --ignore .git
      \ --ignore .svn
      \ --ignore .hg
      \ --ignore .DS_Store
      \ --ignore "**/*.pyc"
      \ -g ""'
let g:ctrlp_working_path_mode = 2
nnoremap <silent> <D-t> :CtrlP<CR>
nnoremap <silent> <D-r> :CtrlPMRU<CR>
nmap <leader>m :CtrlPBufTag<CR>
nmap <leader>n :CtrlPTag<CR>
nmap <leader>r :CtrlPMRU<CR>
nmap <leader>t :CtrlP<CR>
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll|pyc|class)$',
  \ }
let g:ctrlp_use_caching = 0
let g:ctrlp_prompt_mappings = {
  \ 'AcceptSelection("e")': ['<space>', '<cr>', '<2-LeftMouse>'],
  \ }

NeoBundle 'terryma/vim-expand-region'
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-commentary'
NeoBundle 'vim-scripts/gitignore'

NeoBundle 'Valloric/YouCompleteMe', {
      \ 'build' : {
      \     'mac' : './install.sh',
      \    },
      \ }


NeoBundle 'bling/vim-airline'
let g:airline_theme='powerlineish'
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_section_z=''

NeoBundle 'scrooloose/syntastic'
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
let g:syntastic_enable_balloons = 0
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_jump = 0
let g:syntastic_enable_signs = 0
let g:syntastic_aggregate_errors=1
let g:syntastic_python_checkers=['flake8', 'python']
let g:syntastic_python_flake8_args="--ignore=E501"


NeoBundle 'scrooloose/nerdtree'
let g:NERDShutUp=1
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


NeoBundle 'nathanaelkane/vim-indent-guides'
let g:indent_guides_auto_colors = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1

NeoBundle 'ywjno/vim-tomorrow-theme'
set background=dark
colorscheme tomorrow-night

NeoBundle 'AutoTag'
NeoBundle 'rking/ag.vim'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'django.vim'

NeoBundleLazy 'klen/python-mode', {
          \ 'autoload' : {
          \   'filetypes' : 'python',
          \ }}
let g:pymode_lint = 0
let g:pymode_utils_whitespaces = 1
let g:pymode_rope = 0
let g:pymode_folding = 0
let g:pymode_virtualenv = 0
let g:pymode_doc = 0
let g:pymode_run = 0
let g:pymode_rope_completion = 0
let g:pymode_rope_complete_on_dot = 0

" Vim plugin that displays tags in a window, ordered by class etc.
NeoBundle "majutsushi/tagbar", {
  \ 'lazy': 1,
  \ 'autoload' : {'commands': 'TagbarToggle'}} 
    
let g:tagbar_width = 30
let g:tagbar_foldlevel = 1
nnoremap <silent> <F3> :TagbarToggle<CR>

" Load plugins
call vimrc#after()

set tags=./tags;/,~/.vimtags

set guifont=Source\ Code\ Pro\ Light:h12,Monaco:h11,Andale\ Mono\ Regular:h12,Menlo\ Regular:h12,Consolas\ Regular:h12,Courier\ New\ Regular:h12

set colorcolumn=80

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

" moving between windows like in iterm
map <M-D-Down> <C-W>j<C-W>_
map <M-D-Up> <C-W>k<C-W>_
map <M-D-Right> <C-W>l<C-W>_
map <M-D-Left> <C-W>h<C-W>_

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" Define maps for your plugins
nnoremap <Leader>o :CtrlP<CR>

