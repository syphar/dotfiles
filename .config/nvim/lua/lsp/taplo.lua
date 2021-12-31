local cfg = require("lsp")

-- TOML language server with schemas
-- schemas broken for now in LSP
require("lspconfig").taplo.setup({
	flags = cfg.global_flags(),
	capabilities = cfg.capabilities(),
	on_attach = cfg.lsp_on_attach_without_formatting,
})
