local cfg = require("lsp")

require("lspconfig").pylsp.setup({
	flags = cfg.global_flags(),
	capabilities = cfg.capabilities(),
	on_attach = cfg.lsp_on_attach_without_formatting,
	settings = {
		pylsp = {
			plugins = {
				pydocstyle = {
					enabled = false,
				},
				pycodestyle = {
					enabled = false,
				},
				pyflakes = {
					enabled = false,
				},
				jedi_signature_help = {
					enabled = true,
				},
				pylsp_mypy = {
					enabled = true,
					live_mode = false,
					dmypy = true,
				},
			},
		},
	},
})