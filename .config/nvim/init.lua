-- see https://github.com/nathom/filetype.nvim#usage
-- vim.lsp.set_log_level("debug")
require("impatient")
require("vim_options")
require("plugins")

require("lsp").lsp_setup()
require("keyboard")
