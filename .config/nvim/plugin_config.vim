" LanguageClient_Neovim {{{
" ______________________________________________________________________

" pyls only works when run in a venv with version smaller than the smallest
" project python runtime
let g:LanguageClient_serverCommands = {
    \ 'python': ['~/src/pyls/venv/bin/pyls'],
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
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

" disable some deoplete sources. (aka all default ones + ale)
" _ = all file types, but more can be added per type
"
" all default sources
" https://github.com/Shougo/deoplete.nvim/blob/840c46aed8033efe19c7a5a809713c809b4a6bb5/doc/deoplete.txt#L567-L703
let g:deoplete#ignore_sources ={
  \ '_': ['tag', 'buffer', 'ale', 'around', 'file', 'member', 'omni']
  \ }

" call deoplete#custom#source('buffer', 'mark', '♐')
" call deoplete#custom#source('tern', 'mark', '')
" call deoplete#custom#source('omni', 'mark', '⌾')
" call deoplete#custom#source('file', 'mark', '')
" call deoplete#custom#source('jedi', 'mark', '')
" call deoplete#custom#source('neosnippet', 'mark', '')
" call deoplete#custom#source('LanguageClient', 'mark', '♚')
" call deoplete#custom#source('tabnine', 'mark', '9')



" }}}

" ALE {{{
" ______________________________________________________________________

let g:ale_set_loclist = 1
let g:ale_set_quickfix = 0
let g:ale_virtualtext_cursor = 1

let g:ale_linters = {'rust': ['cargo', 'rls']}
let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')
let g:ale_rust_rustfmt_options = '--edition 2018'
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

" FZF {{{

" default fzf on the shell ignores based on gitignore, in vim I don't want
" this. Fot the cases where I want this, I'll use git ls-files
let $FZF_DEFAULT_COMMAND="fd --type f --type l --no-ignore-vcs --hidden --follow"

" }}}

" Vista {{{
" ______________________________________________________________________

" python stays through ctags, looks better
let g:vista_executive_for = {
  \ 'rust': 'lcn',
  \ }
let g:vista#renderer#enable_icon = 1
let g:vista_fzf_preview = ['right:50%']
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

" FZF {{{
let g:fzf_layout = { 'window': 'call FloatingFZF()' }
function! FloatingFZF()
  let buf = nvim_create_buf(v:false, v:true)
  call setbufvar(buf, '&signcolumn', 'no')

  let height = float2nr(&lines * 0.6) " 60% of screen
  let width = float2nr(&columns * 0.8) " 80% of screen
  let horizontal = float2nr((&columns - width) / 2)
  let vertical = float2nr(&lines * 0.2) " space to top: 20

  let opts = {
        \ 'relative': 'editor',
        \ 'row': vertical,
        \ 'col': horizontal,
        \ 'width': width,
        \ 'height': height,
        \ 'anchor': 'NW',
        \ 'style': 'minimal'
        \ }

  call nvim_open_win(buf, v:true, opts)
endfunction

" custom BTags and Tags to include preview
" inspired by https://github.com/junegunn/fzf.vim/issues/800
command! -bang BTags
  \ call fzf#vim#buffer_tags('', {
  \     'options': '--with-nth 1,2
  \                 --preview-window=down
  \                 --reverse
  \                 --preview "
  \                     bat {2} --color=always |
  \                     tail -n +\$(echo {3} | tr -d \";\\\"\")
  \                     "'
  \ })

command! -bang Tags
  \ call fzf#vim#tags('', {
  \     'options': '--with-nth 1,2
  \                 --preview-window=down
  \                 --reverse
  \                 --preview "
  \                     bat {2} --color=always |
  \                     tail -n +\$(echo {3} | tr -d \";\\\"\")
  \                     "'
  \ })

"
" }}}

" Markdown {{{
let g:markdown_syntax_conceal = 0
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'json', 'javascript', 'css']
" }}}

" Echodoc {{{
let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'virtual'
" }}}

" indentline {{{
let g:indentLine_char = '⎸'

" no indent-guides for python
autocmd FileType python IndentLinesDisable
" }}}

" vim: et ts=2 sts=2 sw=2 foldmethod=marker foldlevel=0
