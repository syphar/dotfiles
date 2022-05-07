local cfg = require("dc.lsp")

require("lspconfig").vimls.setup({
	flags = cfg.global_flags(),
	capabilities = cfg.capabilities(),
	on_attach = cfg.lsp_on_attach_without_formatting,
})
