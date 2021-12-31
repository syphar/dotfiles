require("neoclip").setup({
	history = 1000,
	enable_persistant_history = true,
	preview = true,
	default_register = "unnamed",
	content_spec_column = true,
	on_paste = {
		-- also set the register to be able to continue
		-- pasting this with `p`
		set_reg = true,
	},
	keys = {
		telescope = {
			i = {
				paste = "<cr>",
				-- select = "<cr>",
				-- paste = "<c-p>",
				-- paste_behind = "<c-k>",
				-- custom = {},
			},
			n = {
				paste = "<cr>",
				-- select = "<cr>",
				-- paste = "p",
				-- paste_behind = "P",
				-- custom = {},
			},
		},
	},
})

local set_keymap = require("utils").set_keymap
set_keymap("n", "<leader>cb", "<cmd>Telescope neoclip unnamed <CR>")
