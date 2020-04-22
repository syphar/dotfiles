
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

" FZF {{{

" default fzf on the shell ignores based on gitignore, in vim I don't want
" this. Fot the cases where I want this, I'll use git ls-files
let $FZF_DEFAULT_COMMAND="fd --type f --type l --no-ignore-vcs --hidden --follow"


" adds c-q to move the currently selected items from fzf into quickfix
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }


" new floating layout
let g:fzf_layout = { 'window': { 'width': 0.6, 'height': 0.6 } }


" custom GitFiles, to also show unstaged files
command! -bang GitFiles call fzf#vim#gitfiles('--cached --exclude-standard --others', 0)


" customer Ag, only for preview
command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, fzf#vim#with_preview('down'))
cnoreabbrev Ag Rg


command! -bang BTags
  \ call fzf#vim#buffer_tags('', {
  \     'options': '--with-nth 1,5
  \                 --delimiter "\t"
  \                 --reverse'
  \ })

command! -bang Tags
  \ call fzf#vim#tags('', {
  \     'options': '--with-nth 1,5,2
  \                 --delimiter "\t"
  \                 --reverse'
  \ })

" just the default Buffers/Helptext beause they disappeared when I updated
" from homebrew-fzf to github-fzf. No time to research for now.
command! -bar -bang -nargs=? -complete=buffer Buffers  call fzf#vim#buffers(<q-args>, <bang>0)
command! -bar -bang Helptags                           call fzf#vim#helptags(<bang>0)

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
let g:test#strategy = "dispatch"
let g:test#preserve_screen = 0
let g:test#python#runner = 'pytest'


" }}}

" dispatch {{{
"
let g:dispatch_quickfix_height = 20
let g:dispatch_tmux_height = 20

" }}}


" context {{{
" default presenter (nvim-float) has rendering errors and adds flickering. try
" again later
let g:context_presenter = 'nvim-float' "preview
let g:context_border_char = '─' " '▬'
let g:context_enabled = 1

" }}}


" vinegar / netwrk {{{
" CTRL-6 should go back to the last file, not netrw/vinegar
let g:netrw_altfile = 1

let g:netrw_banner = 0 " disable banner
let g:netrw_liststyle = 3 " tree view
let g:netrw_altv = 1 " open split on the right

" let g:netrw_list_hide=netrw_gitignore#Hide()

" }}}


" goyo / limelight {{{
" autocmd! User GoyoEnter Limelight
" autocmd! User GoyoLeave Limelight!
let g:goyo_width=90  " default is 80, but 88 python lines should also fit
" }}}



" vim: et ts=2 sts=2 sw=2 foldmethod=marker foldlevel=0
