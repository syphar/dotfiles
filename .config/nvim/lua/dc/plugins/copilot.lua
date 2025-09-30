local _adapter = "gemini"
local _model = "gemini-2.5-pro"

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
		opts = {
			extensions = {
				spinner = {},
			},
			strategies = {
				chat = {
					adapter = _adapter,
					model = _model,
				},
				inline = {
					adapter = _adapter,
					model = _model,
				},
				cmd = {
					adapter = _adapter,
					model = _model,
				},
			},
		},
		cmd = {
			"CodeCompanionChat",
			"CodeCompanion",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"franco-ruggeri/codecompanion-spinner.nvim",
			"franco-ruggeri/codecompanion-lualine.nvim",
		},
	},
}
