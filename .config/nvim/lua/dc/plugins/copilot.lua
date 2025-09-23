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
					adapter = "gemini",
				},
				inline = {
					adapter = "gemini",
				},
				cmd = {
					adapter = "gemini",
				},
			},
			-- strategies = {
			-- 	chat = {
			-- 		adapter = "gemini_cli",
			-- 	},
			-- 	inline = {
			-- 		adapter = "gemini_cli",
			-- 	},
			-- 	cmd = {
			-- 		adapter = "gemini_cli",
			-- 	},
			-- },
			-- adapters = {
			-- 	acp = {
			-- 		gemini_cli = function()
			-- 			return require("codecompanion.adapters").extend("gemini_cli", {
			-- 				defaults = {
			-- 					auth_method = "gemini-api-key", -- "oauth-personal"|"gemini-api-key"|"vertex-ai"
			-- 				},
			-- 			})
			-- 		end,
			-- 	},
			-- },
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
