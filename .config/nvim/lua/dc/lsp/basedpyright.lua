local M = {}

function M.setup(cfg, lspconfig)
	lspconfig.basedpyright.setup({
		flags = cfg.global_flags(),
		on_attach = function(client, bufnr)
			cfg.lsp_on_attach(client, bufnr)

			-- disable LSP server hilighting, I prefer treesitter for now
			client.server_capabilities.semanticTokensProvider = nil
		end,
		settings = {
			basedpyright = {
				-- this is the pyright default, we don't want it stricter for now
				typeCheckingMode = "basic", -- strict?
			},
		},
	})
end

return M
