local M = {}

function M.config(cfg)
	return {
		cmd = { "/opt/homebrew/bin/node", "/opt/homebrew/bin/typescript-language-server", "--stdio" },
		flags = cfg.global_flags(),
		capabilities = cfg.capabilities(),
		on_attach = cfg.lsp_on_attach,
	}
end

return M
