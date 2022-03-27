local cfg = require("lsp")

-- TOML language server with schemas
require("lspconfig").taplo.setup({
	cmd = { "taplo", "lsp", "stdio" },
	flags = cfg.global_flags(),
	capabilities = cfg.capabilities(),
	on_attach = cfg.lsp_on_attach_without_formatting,
})
