local function hop_after(method)
	local HintDirection = require("hop.hint").HintDirection
	method({ direction = HintDirection.AFTER_CURSOR, current_line_only = false })
end

local function hop_before(method)
	local HintDirection = require("hop.hint").HintDirection
	method({ direction = HintDirection.BEFORE_CURSOR, current_line_only = false })
end

return {
	-- dir = "~/src/hop.nvim/",
	"smoka7/hop.nvim",
	version = "*",
	opts = {
		extensions = { "dc.hop-treesitter-objects" },
	},
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
				hop_after(require("dc.hop-treesitter-objects").hint_objects)
			end,
		},
		{
			"<leader>hN",
			function()
				hop_before(require("dc.hop-treesitter-objects").hint_objects)
			end,
		},
	},
}
