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

local set_keymap = require("utils").set_keymap
set_keymap("n", "<leader>f", "<cmd>Telescope treesitter <cr>")
set_keymap("n", "<leader>F", "<cmd>Telescope tags<cr>")
set_keymap("n", "<leader>m", "<cmd>Telescope buffers <cr>")
set_keymap("n", "<leader>ht", "<cmd>Telescope help_tags <cr>")
set_keymap("n", "<leader>a", "<cmd>Telescope lsp_code_actions<cr>")
set_keymap("n", "<leader>rg", "<cmd>Telescope live_grep <cr>")
set_keymap("n", "<leader>ag", "<cmd>Telescope grep_string <cr>")
set_keymap("n", "<leader>td", "<cmd>TodoTelescope<cr>")
set_keymap("n", "<C-P>", [[<cmd>lua require('telescope-config').project_files()<cr>]])
set_keymap("n", "<leader>p", [[<cmd>lua require('telescope-config').virtualenv_files()<cr>]])
set_keymap("n", "<leader>q", "<cmd>lua require'telescope'.extensions.project.project{}<CR>")
