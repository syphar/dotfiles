local default_adapter = "openai"
-- local default_adapter = "gemini"
-- local default_adapter = "gemini_cli"

-- local gemini_model = "gemini-2.5-flash"
-- local gemini_model = "gemini-2.5-pro"
local gemini_model = "gemini-3-pro-preview"
local openai_model = "gpt-5-nano" -- gpt-5-mini gpt-4o gpt-5

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
			interactions = {
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
				acp = {
					gemini_cli = function()
						-- based on:
						-- https://github.com/olimorris/codecompanion.nvim/pull/2057#issuecomment-3418147957
						-- I don't want to use a separate gemini API token for vim, but just the oauth session
						-- from the gemini CLI tool.
						return require("codecompanion.adapters").extend("gemini_cli", {
							defaults = {
								---@type string
								oauth_credentials_path = vim.fs.abspath("~/.gemini/oauth_creds.json"),
							},
							handlers = {
								auth = function(self)
									---@type string|nil
									local oauth_credentials_path = self.defaults.oauth_credentials_path
									return (oauth_credentials_path and vim.fn.filereadable(oauth_credentials_path)) == 1
								end,
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
