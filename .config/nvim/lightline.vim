
let g:lightline = {}
let g:lightline.separator = { 'left': "\ue0b8", 'right': "\ue0be" }
let g:lightline.subseparator = { 'left': "\ue0b9", 'right': "\ue0b9" }
let g:lightline.tabline_separator = { 'left': "\ue0bc", 'right': "\ue0ba" }
let g:lightline.tabline_subseparator = { 'left': "\ue0bb", 'right': "\ue0bb" }
let g:lightline#ale#indicator_checking = "\uf110"
let g:lightline#ale#indicator_warnings = "\uf071"
let g:lightline#ale#indicator_errors = "\uf05e"
let g:lightline#ale#indicator_ok = "\uf00c"


let g:lightline.active = {
            \ 'left': [
            \  [ 'mode', 'paste' ],
            \  [ 'readonly', 'filename', 'modified', 'gitbranch' ],
            \  [ 'currenttag' ]
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

function! NearestSymbol() abort
  if !exists('t:vista')
    return ''
  endif
  if get(b:, 'vista_nearest_method_or_function', '') == ''
    return ''
  endif
  return vista#cursor#NearestSymbol()
endfunction

let g:lightline.component_function = {
            \ 'gitbranch': 'fugitive#head',
            \ 'currenttag': 'NearestSymbol',
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

" make mode only one character
let g:lightline.mode_map = {
        \ 'n' : 'N',
        \ 'i' : 'I',
        \ 'R' : 'R',
        \ 'v' : 'V',
        \ 'V' : 'VL',
        \ "\<C-v>": 'VB',
        \ 'c' : 'C',
        \ 's' : 'S',
        \ 'S' : 'SL',
        \ "\<C-s>": 'SB',
        \ 't': 'T',
        \ }

" vim: et ts=2 sts=2 sw=2
