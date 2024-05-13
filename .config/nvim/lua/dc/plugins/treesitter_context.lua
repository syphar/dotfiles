return {
	-- dir = "~/src/nvim-treesitter-context/",
	"nvim-treesitter/nvim-treesitter-context",
	event = "VeryLazy",
	opts = {
		enable = true,
		throttle = true,
		line_numbers = false,
		max_lines = 10,
		trim_scope = "inner", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
		multiline_threshold = 10,
		mode = "topline", -- choices: 'cursor', 'topline'
	},
}
