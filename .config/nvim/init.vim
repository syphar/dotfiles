" Required:
set runtimepath+=/Users/syphar/.cache/dein/repos/github.com/Shougo/dein.vim

let g:python2_host_prog = '/usr/local/bin/python2'
" tricky .. if python3-host is older than the virtualenv version, jedi-goto
" is working fine. if python3-host version is never as the virtualenv, it
" breaks
let g:python3_host_prog = '/Users/syphar/.pyenv/versions/3.6.9/bin/python3'


" Required:
if dein#load_state('/Users/syphar/.cache/dein')
  call dein#begin('/Users/syphar/.cache/dein')

  " Let dein manage dein
  " Required:
  call dein#add('/Users/syphar/.cache/dein/repos/github.com/Shougo/dein.vim')

  " interface
  call dein#add('chriskempson/base16-vim')
  call dein#add('vim-airline/vim-airline')
  call dein#add('vim-airline/vim-airline-themes')

  " general plugins
  call dein#add('vim-scripts/restore_view.vim') " safe/restore folds and position
  call dein#add('vim-scripts/LargeFile')  " disable stuff for big files for performance
  call dein#add('terryma/vim-expand-region') " intelligently expand selection with V / CTRL+V
  call dein#add('simnalamburt/vim-mundo') " visualize undo tree
  " TODO: tpope/vim-obsession " save sessions including splits, files, ... ?

  " file management / search
  call dein#add('scrooloose/nerdtree', {'on_cmd': 'NERDTreeToggle'}) " left-side file explorer tree
  call dein#add('tpope/vim-vinegar') " simple 'dig through current folder'  on the - key
  call dein#add('Yggdroot/LeaderF', { 'build': './install.sh' })  " fuzzy file and tag search
  call dein#add('rking/ag.vim') " better grep

  " GIT integration
  call dein#add('tpope/vim-fugitive') " git commands
  call dein#add('tpope/vim-rhubarb')  " fugitive and github integration
  call dein#add('junegunn/gv.vim')  " nice git log
  call dein#add('airblade/vim-gitgutter')  " git status per line in file

  " specific file types
  call dein#add('chrisbra/csv.vim', {'on_ft': ['csv']})
  call dein#add('vim-scripts/django.vim', {'on_ft': ['html', 'htmldjango']})
  call dein#add('cespare/vim-toml', {'on_ft': ['toml']})

  " generic software dev stuff
  call dein#add('dense-analysis/ale') " linting / fixing
  call dein#add('tpope/vim-commentary') " comment/uncomment on gcc
  call dein#add('editorconfig/editorconfig-vim') " read editorconfig and configure vim
  call dein#add('majutsushi/tagbar')  " tagbar and tag in statusline
  call dein#add('direnv/direnv.vim') " read direnv for vim env

  call dein#add('Shougo/deoplete.nvim', {'on_i': 1}) " autocomplete
  call dein#add('tbodt/deoplete-tabnine', { 'on_i': 1, 'build': './install.sh' }) " ML-based autocomplete

  " not yet
  " Plug 'autozimu/LanguageClient-neovim', {
  "   \ 'branch': 'next',
  "   \ 'do': 'bash install.sh',
  "   \ }
  " " (Optional) Multi-entry selection UI.
  " Plug 'junegunn/fzf'

  " python stuff
  call dein#add('davidhalter/jedi-vim', {'on_ft': ['python']})
  call dein#add('deoplete-plugins/deoplete-jedi', {'on_ft': ['python']})
  call dein#add('Vimjas/vim-python-pep8-indent', {'on_ft': ['python']})
  call dein#add('jeetsukumaran/vim-pythonsense', {'on_ft': ['python']})
  call dein#add('numirias/semshi', {'on_ft': ['python']}) " better python coloscheme

  " call dein#add('tmhedberg/SimpylFold',
  " 	\{'on_ft': ['python']})

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

set clipboard=unnamed
set autoread

let g:gitgutter_enabled = 1

let g:Lf_ShortcutF = '<C-P>'
let g:Lf_ShortcutB = ''
let g:Lf_WindowPosition = 'popup'
let g:Lf_WorkingDirectoryMode = 'Ac'
let g:Lf_PopupWidth = &columns * 3 / 4 " wider popup window
let g:LfDiscardEmptyBuffer = 1

" use normal AG to find files, which respects .gitignore.
" additionally add the virtualenv to the list of directories to search
" in the venv, gitignores are not respected, so I add some additional ignores
" here
let g:Lf_ExternalCommand = 'ag %s $VIRTUAL_ENV -i --nocolor --nogroup --hidden
       \ --ignore .git
       \ --ignore "*.pyc"
       \ -g ""'

nmap <leader>t :LeaderfBufTag<CR>
nmap <leader>T :LeaderfTag<CR>
nmap <leader>m :LeaderfMruCwd<CR>
nmap <leader>h :LeaderfHelp<CR>

nnoremap <F5> :MundoToggle<CR>

" for tag-search
let g:Lf_PreviewCode=1
let g:Lf_HideHelp=1
let g:Lf_PreviewInPopup=1
let g:Lf_PreviewHorizontalPosition = 'center'
let g:Lf_PreviewResult = {
    \ 'Tag': 1,
    \ 'BufTag': 1,
    \ 'Function': 1,
    \ 'Line': 1,
    \ 'Rg': 1,
    \ 'Gtags': 1
\ }

vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)


let g:jedi#completions_enabled = 0

let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#jedi#enable_typeinfo = 1
let g:deoplete#sources#jedi#show_docstring = 0
" call deoplete#custom#source('tabnine', 'rank', 100)
let g:deoplete#auto_complete_delay = 100  " needed for semshi


" deoplete tab-complete
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_highlighting_cache = 1
let g:airline_theme='base16_tomorrow' " need to set explicitly so VimR also uses it

" only works together
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#tabline#show_buffers = 0


let g:airline#extensions#tagbar#flags='f' " current tag in statusbar should show class + method
let g:airline#extensions#virtualenv#enabled = 0



function! ToggleLocList()
    for i in range(1, winnr('$'))
        let bnum = winbufnr(i)
        if getbufvar(bnum, '&buftype') == 'quickfix'
            lclose
            return
        endif
    endfor
    lopen
endfunction

nnoremap <F2> :call ToggleLocList()<CR>

let g:ale_set_loclist = 1
let g:ale_set_quickfix = 0
let g:ale_virtualtext_cursor = 1
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'python': ['black', 'autopep8', 'yapf', 'isort']
\}
let g:ale_fix_on_save = 1

set background=dark
colorscheme base16-tomorrow-night

let g:NERDShutUp=1
map <C-e> :NERDTreeToggle<CR>:NERDTreeMirror<CR>
map <leader>e :NERDTreeFind<CR>
nmap <leader>nt :NERDTreeFind<CR>

let NERDTreeRespectWildIgnore=1
set wildignore+=.git,.hg,.svn,.idea,.pytest_cache,__pycache__,.DS_Store,tags

let NERDTreeShowBookmarks=1
let NERDTreeChDirMode=2
let NERDTreeQuitOnOpen=1
let NERDTreeMouseMode=2
let NERDTreeShowHidden=1
let NERDTreeKeepTreeInNewTab=1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

" always open tagbar on BufEnter into supported files
" autocmd BufEnter * nested :call tagbar#autoopen(0)

let g:tagbar_width = 30
let g:tagbar_foldlevel = 1
nnoremap <silent> <F3> :TagbarToggle<CR>

set tags=./tags;/,~/.vimtags

" no scrollbars
set guioptions-=L
set guioptions-=l
set guioptions-=R
set guioptions-=r

set showtabline=1

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


" auto-adjust splits when window is resized
" https://vi.stackexchange.com/questions/201/make-panes-resize-when-host-window-is-resized
autocmd VimResized * wincmd =
set equalalways


" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" don't show docstring when completing
autocmd FileType python setlocal completeopt-=preview

set nofoldenable
set backspace=indent,eol,start


" https://vi.stackexchange.com/questions/16148/slow-vim-escape-from-insert-mode
set timeoutlen=1000
set ttimeoutlen=5

" type ,p to insert breakpoint. ^[ is at the end.  Insert with ctrl v and then esc
" (the github web gui doesn't display control characters, but it is there)
nnoremap <leader>b oimport pdb;pdb.set_trace()

" common typos .. (W, Wq WQ)
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
