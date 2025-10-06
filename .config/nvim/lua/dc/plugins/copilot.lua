local default_adapter = "gemini"

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
				-- set default adapters for strategies
				chat = {
					adapter = default_adapter,
				},
				inline = {
					adapter = default_adapter,
				},
				cmd = {
					adapter = default_adapter,
				},
			},
			-- set default models for some adapters
			adapters = {
				gemini = function()
					return require("codecompanion.adapters").extend("gemini", {
						schema = {
							model = {
								default = "gemini-2.5-pro",
							},
						},
					})
				end,
				openai = function()
					return require("codecompanion.adapters").extend("openai", {
						schema = {
							model = {
								default = "gpt-5",
							},
						},
					})
				end,
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
