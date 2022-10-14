local navigator = require("Navigator")
navigator.setup({})

vim.keymap.set("n", "<C-h>", navigator.left)
vim.keymap.set("n", "<C-k>", navigator.up)
vim.keymap.set("n", "<C-l>", navigator.right)
vim.keymap.set("n", "<C-j>", navigator.down)
