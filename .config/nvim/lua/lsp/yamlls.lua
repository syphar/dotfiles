local cfg = require("lsp")

require("lspconfig").yamlls.setup({
	flags = cfg.global_flags(),
	capabilities = cfg.capabilities(),
	on_attach = cfg.lsp_on_attach_without_formatting,
	settings = {
		yaml = {
			schemas = {
				["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
			},
		},
	},
})
