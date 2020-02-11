
" Deoplete {{{
" ______________________________________________________________________

let g:deoplete#enable_at_startup = 1

" disable some deoplete sources. (aka all default ones + ale)
" _ = all file types, but more can be added per type
"
" all default sources
" https://github.com/Shougo/deoplete.nvim/blob/840c46aed8033efe19c7a5a809713c809b4a6bb5/doc/deoplete.txt#L567-L703
let g:deoplete#ignore_sources ={
  \ '_': ['tag', 'buffer', 'ale', 'around', 'file', 'member', 'omni']
  \ }

" }}}

" ALE {{{
" ______________________________________________________________________

let g:ale_set_loclist = 1
let g:ale_set_quickfix = 0
let g:ale_virtualtext_cursor = 1

" filetype specific fixers and linters in ftplugin
let g:ale_fixers = { '*': ['remove_trailing_lines', 'trim_whitespace']}
let g:ale_fix_on_save = 1

" }}}

" Vista {{{
" ______________________________________________________________________

" python stays through ctags, looks better
let g:vista#renderer#enable_icon = 1
let g:vista_fzf_preview = ['right:50%']
let g:vista_echo_cursor_strategy = 'floating_win'
let g:vista#renderer#icons = {
\   "function": "\uf794",
\   "variable": "\uf71b",
\  }

" }}}

" FZF {{{

" default fzf on the shell ignores based on gitignore, in vim I don't want
" this. Fot the cases where I want this, I'll use git ls-files
let $FZF_DEFAULT_COMMAND="fd --type f --type l --no-ignore-vcs --hidden --follow"


" this currently breaks together with context.vim
" let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

autocmd FileType fzf IndentLinesDisable

command! -bang GitFiles
  \ call fzf#vim#gitfiles(
  \   '--cached --exclude-standard --others',
  \   fzf#vim#with_preview('right')
  \ )

command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, fzf#vim#with_preview('right'))


" custom BTags and Tags to include preview
" inspired by https://github.com/junegunn/fzf.vim/issues/800
command! -bang BTags
  \ call fzf#vim#buffer_tags('', {
  \     'options': '--with-nth 1,2
  \                 --preview-window=right
  \                 --reverse
  \                 --preview "
  \                     bat {2} --color=always |
  \                     tail -n +\$(echo {3} | tr -d \";\\\"\")
  \                     "'
  \ })

command! -bang Tags
  \ call fzf#vim#tags('', {
  \     'options': '--with-nth 1,2
  \                 --preview-window=right
  \                 --reverse
  \                 --preview "
  \                     bat {2} --color=always |
  \                     tail -n +\$(echo {3} | tr -d \";\\\"\")
  \                     "'
  \ })

"
" }}}

" Echodoc {{{
let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'virtual'
" }}}

" indentline {{{
let g:indentLine_char = '│'
let g:indentLine_enabled = 1
" }}}

" Notational {{{

let g:nv_search_paths = ['~/Dropbox/notes/']
let g:nv_create_note_window = 'split'

" }}}

" vim-test {{{
let g:test#strategy = "vimux"
let g:test#preserve_screen = 0
let g:test#python#runner = 'pytest'
"

" }}}

" vimux {{{
let g:VimuxUseNearest = 1
" }}}


" context {{{
" default presenter (nvim-float) has rendering errors and adds flickering. try
" again later
let g:context_presenter = 'nvim-float' "preview
let g:context_border_char = '─' " '▬'
let g:context_enabled = 1

" }}}

" goyo / limelight {{{
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!
" }}}


" vinegar / netwrk {{{
" CTRL-6 should go back to the last file, not netrw/vinegar
let g:netrw_altfile = 1
" }}}

" vim: et ts=2 sts=2 sw=2 foldmethod=marker foldlevel=0
