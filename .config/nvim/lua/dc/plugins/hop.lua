local function hop_after(method)
	local HintDirection = require("hop.hint").HintDirection
	method({ direction = HintDirection.AFTER_CURSOR, current_line_only = false })
end

local function hop_before(method)
	local HintDirection = require("hop.hint").HintDirection
	method({ direction = HintDirection.BEFORE_CURSOR, current_line_only = false })
end

return {
	"smoka7/hop.nvim",
	version = "*",
	opts = {},
	keys = {
		{
			"<leader>hw",
			function()
				hop_after(require("hop").hint_words)
			end,
		},
		{
			"<leader>hW",
			function()
				hop_before(require("hop").hint_words)
			end,
		},
		{
			"<leader>hl",
			function()
				hop_after(require("hop").hint_lines_skip_whitespace)
			end,
		},
		{
			"<leader>hL",
			function()
				hop_before(require("hop").hint_lines_skip_whitespace)
			end,
		},
		{
			"<leader>hn",
			function()
				hop_after(require("hop-treesitter").hint_nodes)
			end,
		},
		{
			"<leader>hN",
			function()
				hop_before(require("hop-treesitter").hint_nodes)
			end,
		},
	},
}
