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
