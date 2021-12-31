local aerial = require("aerial")

aerial.register_attach_cb(function(bufnr)
	-- Toggle the aerial window with <leader>a
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>t", "<cmd>AerialToggle!<CR>", {})
	-- Jump forwards/backwards with '{' and '}'
	vim.api.nvim_buf_set_keymap(bufnr, "n", "{", "<cmd>AerialPrev<CR>", {})
	vim.api.nvim_buf_set_keymap(bufnr, "n", "}", "<cmd>AerialNext<CR>", {})
	-- Jump up the tree with '[[' or ']]'
	vim.api.nvim_buf_set_keymap(bufnr, "n", "[[", "<cmd>AerialPrevUp<CR>", {})
	vim.api.nvim_buf_set_keymap(bufnr, "n", "]]", "<cmd>AerialNextUp<CR>", {})
end)

vim.g.aerial = {
	backends = { "treesitter" },
	close_behavior = "auto",
	default_bindings = true,
	default_direction = "prefer_right",
	disable_max_lines = 10000,
	filter_kind = {
		"Class",
		"Constructor",
		"Enum",
		"Function",
		"Interface",
		"Method",
		"Struct",
	},
	highlight_mode = "split_width",
	highlight_on_jump = 300,
	manage_folds = false,
	max_width = 40,
	min_width = 10,
	nerd_font = "auto",
	open_automatic = false,
	open_automatic_min_lines = 0,
	open_automatic_min_symbols = 0,
	treesitter = {
		update_delay = 300,
	},
}
