lua <<EOF
require('impatient')
require('plugins')

local lsp = require('lsp_config')
lsp.lsp_setup()
lsp.cmp_setup()
EOF

source ~/.config/nvim/vim_config.vim
source ~/.config/nvim/keyboard.vim

hi! link TreesitterContext NormalFloat

" I don't know where this is always reset, but here I just force it back
augroup FixOverrides
  au!
  au VimEnter,WinEnter,BufWinEnter,WinLeave * setlocal nocursorline
augroup END

" vim: et ts=2 sts=2 sw=2
