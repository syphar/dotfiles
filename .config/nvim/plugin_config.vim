" LanguageClient_Neovim {{{
" ______________________________________________________________________

" pyls only works when run in a venv with version smaller than the smallest
" project python runtime
let g:LanguageClient_serverCommands = {
    \ 'python': ['~/src/pyls/venv/bin/pyls'],
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls']
    \ }

let g:LanguageClient_diagnosticsEnable = 0  " disable LC-Checks because I'm using ALE

" }}}

" Deoplete {{{
" ______________________________________________________________________

let g:deoplete#enable_at_startup = 1
" call deoplete#custom#source('tabnine', 'rank', 100)
let g:deoplete#auto_complete_delay = 100  " needed for semshi
" call deoplete#custom#source('LanguageClient',
"             \ 'min_pattern_length',
"             \ 2)

" }}}

" ALE {{{
" ______________________________________________________________________

let g:ale_set_loclist = 1
let g:ale_set_quickfix = 0
let g:ale_virtualtext_cursor = 1

let g:ale_linters = {'rust': ['cargo', 'rls']}
let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')
let g:ale_rust_rls_executable = '/Users/syphar/.cargo/bin/rls'
let g:ale_rust_rls_toolchain = 'stable'

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'python': ['black', 'autopep8', 'yapf', 'isort'],
\   'rust': ['rustfmt']
\}
let g:ale_fix_on_save = 1

" }}}

" NerdTree {{{
" ______________________________________________________________________
let g:NERDShutUp=1
let NERDTreeRespectWildIgnore=1
let NERDTreeShowBookmarks=1
let NERDTreeChDirMode=2
let NERDTreeQuitOnOpen=1
let NERDTreeMouseMode=2
let NERDTreeShowHidden=1
let NERDTreeKeepTreeInNewTab=1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

" }}}

" Vista {{{
" ______________________________________________________________________

let g:vista_executive_for = {
  \ 'rust': 'lcn',
  \ }
let g:vista#renderer#enable_icon = 1
let g:vista_echo_cursor_strategy = 'floating_win'
let g:vista#renderer#icons = {
\   "function": "\uf794",
\   "variable": "\uf71b",
\  }

" By default vista.vim never run if you don't call it explicitly.
"
" If you want to show the nearest function in your statusline automatically,
" you can add the following line to your vimrc
autocmd VimEnter * call vista#RunForNearestMethodOrFunction()

" }}}

" floaterm {{{

let g:floaterm_position = 'topright'
let g:floaterm_type = 'floating'

" }}}

" vim: et ts=2 sts=2 sw=2 foldmethod=marker foldlevel=0
