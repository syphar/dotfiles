return {
	"nvim-treesitter/playground",
	config = function()
		require("nvim-treesitter.configs").setup({
			playground = {
				enable = true,
				disable = {},
				updatetime = vim.opt.updatetime:get(),
				persist_queries = true,
			},
			query_linter = {
				enable = true,
				use_virtual_text = true,
				lint_events = { "BufWrite", "CursorHold", "CursorHoldI" },
			},
		})
	end,
}
