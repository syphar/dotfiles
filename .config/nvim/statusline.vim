" don't show mode since we want it in the statusline
set noshowmode

" always show status
set laststatus=2

let g:lightline = {
      \ 'colorscheme': 'ayu',
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
  \   [ 'lsp_info', 'lsp_hints', 'lsp_errors', 'lsp_warnings', 'lsp_ok' ], 
  \   [ 'lsp_status' ],
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

let g:lightline.component_expand = {
  \   'lsp_warnings': 'lightline#lsp#warnings',
  \   'lsp_errors': 'lightline#lsp#errors',
  \   'lsp_info': 'lightline#lsp#info',
  \   'lsp_hints': 'lightline#lsp#hints',
  \   'lsp_ok': 'lightline#lsp#ok',
  \   'lsp_status': 'lightline#lsp#status',
  \ }

let g:lightline.component_type = {
  \   'lsp_warnings': 'warning',
  \   'lsp_errors': 'error',
  \   'lsp_info': 'info',
  \   'lsp_hints': 'hints',
  \   'lsp_ok': 'right',
  \ }

let g:lightline.component_function = {
  \ 'gitbranch': 'fugitive#head',
  \ }

" vim: et ts=2 sts=2 sw=2
