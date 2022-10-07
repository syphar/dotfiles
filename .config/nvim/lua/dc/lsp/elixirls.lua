local cfg = require("dc.lsp")

require("lspconfig").elixirls.setup({
	cmd = { "elixir-ls" },
	flags = cfg.global_flags(),
	capabilities = cfg.capabilities(),
	on_attach = cfg.lsp_on_attach,
})
