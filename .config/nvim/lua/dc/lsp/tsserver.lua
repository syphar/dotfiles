local M = {}

function M.setup(cfg, lspconfig)
	lspconfig.ts_ls.setup({
		cmd = { "/opt/homebrew/bin/node", "/opt/homebrew/bin/typescript-language-server", "--stdio" },
		flags = cfg.global_flags(),
		capabilities = cfg.capabilities(),
		on_attach = cfg.lsp_on_attach,
	})
end

return M
