return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			copilot_model = "gpt-4o-copilot",
			suggestion = { enabled = true, auto_trigger = true, debounce = 500 },
			panel = { enabled = false },
			copilot_node_command = "/opt/homebrew/bin/node",
		},
	},
	{
		"olimorris/codecompanion.nvim",
		lazy = true,
		opts = {},
		cmd = {
			"CodeCompanionChat",
			"CodeCompanion",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
	},
}
