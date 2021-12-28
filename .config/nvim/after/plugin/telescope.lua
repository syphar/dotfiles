require("todo-comments").setup({})

local config_with_preview = {
	layout_config = {
		preview_cutoff = 40,
		prompt_position = "bottom",
	},
}
require("telescope").setup({
	defaults = {
		scroll_stratecy = "cycle",
		layout_strategy = "center",
		layout_config = {
			width = 0.6,
			height = 0.5,
			preview_cutoff = 120,
			prompt_position = "bottom",
		},
		theme = "dropdown",
	},
	pickers = {
		tags = config_with_preview,
		treesitter = config_with_preview,
		live_grep = config_with_preview,
		grep_string = config_with_preview,
		git_bcommits = config_with_preview,
		git_branches = config_with_preview,
	},
	extensions = {
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
		},
	},
})
require("telescope").load_extension("fzf")
require("telescope").load_extension("project")
