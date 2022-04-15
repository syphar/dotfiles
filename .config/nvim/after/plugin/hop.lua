local hop = require("hop")
hop.setup({})

local function add_hop(mapping, method, direction)
	local fn = function()
		hop[method]({ direction = require("hop.hint").HintDirection[direction], current_line_only = false })
	end

	vim.api.nvim_set_keymap("n", mapping, "", { noremap = true, silent = false, callback = fn })
	-- "o" is "operator pending mode", which enables us to use hops as range
	vim.api.nvim_set_keymap("o", mapping, "", { noremap = true, silent = false, callback = fn })
end
add_hop("<leader>hw", "hint_words", "AFTER_CURSOR")
add_hop("<leader>hW", "hint_words", "BEFORE_CURSOR")
add_hop("<leader>hl", "hint_lines_skip_whitespace", "AFTER_CURSOR")
add_hop("<leader>hL", "hint_lines_skip_whitespace", "BEFORE_CURSOR")
