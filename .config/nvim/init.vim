lua <<EOF
-- see https://github.com/nathom/filetype.nvim#usage
vim.g.did_load_filetypes = 1

require('impatient')
require('plugins')

local lsp = require('lsp_config')
lsp.lsp_setup()
lsp.cmp_setup()
require('vim_options')
EOF

source ~/.config/nvim/keyboard.vim

hi! link TreesitterContext NormalFloat

" I don't know where this is always reset, but here I just force it back
augroup FixOverrides
  au!
  au VimEnter,WinEnter,BufWinEnter,BufEnter,TabEnter,WinLeave * set nocursorline
augroup END

" vim: et ts=2 sts=2 sw=2
