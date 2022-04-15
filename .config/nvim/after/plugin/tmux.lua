local utils = require("utils")
local navigator = require("Navigator")
navigator.setup()

utils.set_lua_keymap("n", "<C-h>", navigator.left)
utils.set_lua_keymap("n", "<C-k>", navigator.up)
utils.set_lua_keymap("n", "<C-l>", navigator.right)
utils.set_lua_keymap("n", "<C-j>", navigator.down)
