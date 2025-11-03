local default_adapter = "openai"        -- "gemini"
local gemini_model = "gemini-2.5-flash" -- "gemini-2.5-pro"
local openai_model = "gpt-5-mini"       -- gpt-4o" "gpt-5"

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
				http = {
					gemini = function()
						return require("codecompanion.adapters").extend("gemini", {
							schema = {
								model = {
									default = gemini_model,
								},
							},
						})
					end,
					openai = function()
						return require("codecompanion.adapters").extend("openai", {
							schema = {
								model = {
									default = openai_model,
								},
							},
						})
					end,
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
