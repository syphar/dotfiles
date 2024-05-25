local M = {}

function M.setup(cfg, lspconfig)
	lspconfig.pyright.setup({
		flags = cfg.global_flags(),
		capabilities = cfg.capabilities(),
		on_attach = cfg.lsp_on_attach,
	})
end

return M
