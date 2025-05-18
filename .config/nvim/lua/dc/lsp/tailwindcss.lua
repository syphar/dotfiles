local M = {}

function M.config(cfg)
	return {
		flags = cfg.global_flags(),
		capabilities = cfg.capabilities(),
		on_attach = cfg.lsp_on_attach,
	}
end

return M
