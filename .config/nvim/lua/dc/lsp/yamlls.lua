local cfg = require("dc.lsp")

require("lspconfig").yamlls.setup({
	flags = cfg.global_flags(),
	capabilities = cfg.capabilities(),
	on_attach = cfg.lsp_on_attach_without_formatting,
	settings = {
		yaml = {
			schemas = {
				["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
				["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "/docker-compose.yml",
				["https://json.schemastore.org/dependabot-2.0.json"] = "/.github/dependabot.yml",
			},
		},
	},
})
