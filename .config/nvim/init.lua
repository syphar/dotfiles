-- see https://github.com/nathom/filetype.nvim#usage
vim.g.did_load_filetypes = 1
-- vim.lsp.set_log_level("debug")
require("impatient")
require("vim_options")
require("plugins")

require("lsp_config").lsp_setup()
require("keyboard")
vim.cmd([[hi! link TreesitterContext NormalFloat]])
