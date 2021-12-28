require("Navigator").setup()

local set_keymap = require("utils").set_keymap
set_keymap("n", "<C-h>", "<CMD>lua require('Navigator').left()<CR>")
set_keymap("n", "<C-k>", "<CMD>lua require('Navigator').up()<CR>")
set_keymap("n", "<C-l>", "<CMD>lua require('Navigator').right()<CR>")
set_keymap("n", "<C-j>", "<CMD>lua require('Navigator').down()<CR>")
