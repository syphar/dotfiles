" TODO: nice custom statusline
" https://www.reddit.com/r/vimporn/comments/efjcv0/gruvboxxx/?utm_source=share&utm_medium=ios_app&utm_name=iossmf
" https://raw.githubusercontent.com/ginkobab/dots/master/.config/nvim/statusline.vim

let g:lightline = {}

let g:lightline.separator = { 'left': "\ue0b0", 'right': "\ue0b2" }
let g:lightline.subseparator = { 'left': "\ue0b1", 'right': "\ue0b3" }
let g:lightline.tabline_separator = { 'left': "\ue0b0", 'right': "\ue0b2" }
let g:lightline.tabline_subseparator = { 'left': "\ue0b1", 'right': "\ue0b3" }

let g:lightline#ale#indicator_checking = "\uf110"
let g:lightline#ale#indicator_warnings = "\uf071"
let g:lightline#ale#indicator_errors = "\uf05e"
let g:lightline#ale#indicator_ok = "\uf00c"


let g:lightline.active = {
            \ 'left': [
            \  [ 'paste' ],
            \  [ 'readonly', 'filename', 'modified', 'gitbranch' ],
            \ ],
            \ 'right': [
            \   [ 'lineinfo' ],
            \   [ 'filetype' ],
            \   [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok'],
            \ ]
            \ }

let g:lightline.inactive = {
            \ 'left': [ [ 'filename' , 'modified' ]],
            \ 'right': [
            \   [ 'lineinfo' ],
            \   [ 'fileformat' ],
            \ ]
            \ }

let g:lightline.tabline = {
            \ 'left': [ [ 'tabs' ] ],
            \ 'right': [ ]
            \ }

let g:lightline.tab = {
            \ 'active': [ 'tabnum', 'filename', 'modified' ],
            \ 'inactive': [ 'tabnum', 'filename', 'modified' ] }


let g:lightline.component = {
            \ 'lineinfo': '%2p%% %3l:%-2v',
            \ }

let g:lightline.component_function = {
            \ 'gitbranch': 'fugitive#head',
            \ }

let g:lightline.component_expand = {
            \ 'linter_checking': 'lightline#ale#checking',
            \ 'linter_warnings': 'lightline#ale#warnings',
            \ 'linter_errors': 'lightline#ale#errors',
            \ 'linter_ok': 'lightline#ale#ok',
            \ }

let g:lightline.component_type = {
            \ 'linter_warnings': 'warning',
            \ 'linter_errors': 'error'
            \ }

autocmd VimEnter * call SetupLightlineColors()
function SetupLightlineColors() abort
  " statusbar, middle background = editor background
  " transparent look-a-like
  let l:palette = lightline#palette()

  let l:palette.normal.middle = [ [ 'NONE', 'NONE', 'NONE', 'NONE' ] ]
  let l:palette.inactive.middle = l:palette.normal.middle
  let l:palette.tabline.middle = l:palette.normal.middle

  call lightline#colorscheme()
endfunction


" vim: et ts=2 sts=2 sw=2
