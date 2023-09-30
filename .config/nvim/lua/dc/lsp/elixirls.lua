local M = {}

function M.setup(cfg, lspconfig)
	lspconfig.elixirls.setup({
		cmd = { "elixir-ls" },
		flags = cfg.global_flags(),
		capabilities = cfg.capabilities(),
		on_attach = cfg.lsp_on_attach_without_formatting,
	})
end

return M
