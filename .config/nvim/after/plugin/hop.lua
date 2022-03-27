require("hop").setup({})

local function add_hop(mapping, method, direction)
	local cmd = "<cmd>lua require'hop'."
		.. method
		.. "({ direction = require'hop.hint'.HintDirection."
		.. direction
		.. ", current_line_only = false })<cr>"

	vim.api.nvim_set_keymap("n", mapping, cmd, { noremap = true, silent = false })
	-- "o" is "operator pending mode", which enables us to use hops as range
	vim.api.nvim_set_keymap("o", mapping, cmd, { noremap = true, silent = false })
end
add_hop("<leader>hw", "hint_words", "AFTER_CURSOR")
add_hop("<leader>hW", "hint_words", "BEFORE_CURSOR")
add_hop("<leader>hl", "hint_lines_skip_whitespace", "AFTER_CURSOR")
add_hop("<leader>hL", "hint_lines_skip_whitespace", "BEFORE_CURSOR")
