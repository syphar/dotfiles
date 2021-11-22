-- see https://github.com/nathom/filetype.nvim#usage
vim.g.did_load_filetypes = 1
require("impatient")
require("plugins")

local lsp = require("lsp_config")
lsp.lsp_setup()
lsp.cmp_setup()
require("vim_options")
require("keyboard")
vim.cmd([[hi! link TreesitterContext NormalFloat]])

-- I don't really know which plugin re-enables cursorline all the time
-- but here I just disable it on certain events
vim.cmd([[
  augroup disable_cursorline
	autocmd!
	autocmd VimEnter,WinEnter,BufEnter,BufWinEnter,TabEnter,BufRead,BufNewFile,InsertLeave * set nocursorline
  augroup end
]])
