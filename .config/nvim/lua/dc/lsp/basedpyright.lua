local M = {}

function M.setup(cfg, lspconfig)
	lspconfig.basedpyright.setup({
		flags = cfg.global_flags(),
		on_attach = function(client, bufnr)
			cfg.lsp_on_attach(client, bufnr)

			-- disable LSP server highlighting, I prefer treesitter for now
			client.server_capabilities.semanticTokensProvider = nil
		end,
		settings = {
			basedpyright = {
				disableOrganizeImports = true, -- covered by ruff
				-- this is the pyright default, we don't want it stricter for now,
				-- too many false positives with django
				typeCheckingMode = "basic",
				analysis = {
					diagnosticSeverityOverrides = {
						reportUnreachable = "none", -- lint has annoying false positives

						-- lints covered by ruff
						reportUnusedImport = "none",
						reportUndefinedVariable = "none", -- covered by ruff
					},
				},
			},
		},
	})
end

return M
