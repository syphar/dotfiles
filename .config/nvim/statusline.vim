" don't show mode since we want it in the statusline
set noshowmode

" always show status
set laststatus=2

let g:lightline#ale#indicator_checking = "\uf110"
let g:lightline#ale#indicator_warnings = "\uf071"
let g:lightline#ale#indicator_errors = "\uf05e"
let g:lightline#ale#indicator_ok = "\uf00c"


let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ 'mode_map': {
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
        \ },
      \ }

let g:lightline.active = {
            \ 'left': [
            \  [ 'mode', 'paste' ],
            \  [ 'gitbranch', 'relativepath', 'modified', 'readonly' ],
            \ ],
            \ 'right': [
            \   [ 'lineinfo', 'filetype' ],
            \   [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ],
            \ ]
            \ }

let g:lightline.inactive = {
            \ 'left': [
            \  [ 'paste' ],
            \  [ 'readonly', 'relativepath', 'modified' ],
            \ ],
            \ 'right': [ ]
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

" vim: et ts=2 sts=2 sw=2
