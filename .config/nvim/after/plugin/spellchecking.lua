require("spellsitter").setup({
	-- Whether enabled, can be a list of filetypes, e.g. {'python', 'lua'}
	enable = true,
})

-- vim.opt.spell  true
vim.opt.spelllang = { "en_us" }
vim.opt.spellsuggest = "best,9"

local set_keymap = require("utils").set_keymap
set_keymap("n", "<leader>ss", "<cmd>Telescope spell_suggest<cr>")
