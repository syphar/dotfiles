local M = {}

function M.config(cfg)
	-- TOML language server with schemas
	return cfg.base({
		cmd = { "taplo", "lsp", "stdio" },
		init_options = {
			cachePath = vim.fn.expand("$HOME/.cache/taplo/"),
		},
		settings = {
			evenBetterToml = {
				schema = {
					repositoryEnabled = true,
					associations = {
						[".*/\\.config/starship\\.toml"] = "https://raw.githubusercontent.com/starship/starship/master/.github/config-schema.json",
					},
				},
			},
		},
	})
end

return M
