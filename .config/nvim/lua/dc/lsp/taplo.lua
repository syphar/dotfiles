local M = {}

function M.config(cfg)
	-- TOML language server with schemas
	return {
		cmd = { "taplo", "lsp", "stdio" },
		flags = cfg.global_flags(),
		capabilities = cfg.capabilities(),
		on_attach = cfg.lsp_on_attach,
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
	}
end

return M
