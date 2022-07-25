local cfg = require("dc.lsp")

require("lspconfig").terraformls.setup({
	flags = cfg.global_flags(),
	capabilities = cfg.capabilities(),
	on_attach = cfg.lsp_on_attach_without_formatting,
	init_options = {
		experimentalFeatures = {
			validateOnSave = true,
			prefillRequiredFields = true,
		},
	},
})
