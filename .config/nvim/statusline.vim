" don't show mode since we want it in the statusline
set noshowmode

" always show status
set laststatus=2

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
            \   [ 'indicator', 'lineinfo', 'filetype' ],
            \ ]
            \ }

let g:lightline.inactive = {
            \ 'left': [
            \  [ 'paste' ],
            \  [ 'readonly', 'relativepath', 'modified' ],
            \ ],
            \ 'right': [
            \   [ 'indicator', 'lineinfo', 'filetype' ],
            \ ]
            \ }

let g:lightline.component = {
      \   'indicator': '%{LineNoIndicator()}'
      \ }

let g:lightline.component_function = {
            \ 'gitbranch': 'fugitive#head',
            \ }

" vim: et ts=2 sts=2 sw=2
