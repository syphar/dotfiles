return {
	"akinsho/git-conflict.nvim",
	version = "*",
	opts = {
		default_mappings = true,
		disable_diagnostics = true,
		highlights = { -- They must have background color, otherwise the default color will be used
			incoming = "DiffText",
			current = "DiffAdd",
		},
	},
}

-- default mappings
-- vim.keymap.set("n", "co", "<Plug>(git-conflict-ours)")
-- vim.keymap.set("n", "cb", "<Plug>(git-conflict-both)")
-- vim.keymap.set("n", "c0", "<Plug>(git-conflict-none)")
-- vim.keymap.set("n", "ct", "<Plug>(git-conflict-theirs)")
-- vim.keymap.set("n", "[x", "<Plug>(git-conflict-next-conflict)")
-- vim.keymap.set("n", "]x", "<Plug>(git-conflict-prev-conflict)")
