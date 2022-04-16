local hop = require("hop")
hop.setup({})

local function add_hop(mapping, method, direction)
	vim.keymap.set({ "n", "o" }, mapping, function()
		method({ direction = direction, current_line_only = false })
	end)
end

local HintDirection = require("hop.hint").HintDirection

add_hop("<leader>hw", hop.hint_words, HintDirection.AFTER_CURSOR)
add_hop("<leader>hW", hop.hint_words, HintDirection.BEFORE_CURSOR)
add_hop("<leader>hl", hop.hint_lines_skip_whitespace, HintDirection.AFTER_CURSOR)
add_hop("<leader>hL", hop.hint_lines_skip_whitespace, HintDirection.BEFORE_CURSOR)
