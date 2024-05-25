local M = {}

function M.setup(cfg, lspconfig)
	lspconfig.jedi_language_server.setup({
		flags = cfg.global_flags(),
		capabilities = cfg.capabilities(),
		on_attach = cfg.lsp_on_attach,
		init_options = {
			diagnostics = {
				enable = false,
				didOpen = true,
				didChange = true,
				didSave = true,
			},
		},
	})
end

return M
