local M = {}

function M.config(cfg)
	return cfg.base({
		settings = {
			yaml = {
				schemaStore = {
					enable = true,
				},
				schemas = {
					["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
					["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] =
					"/docker-compose.yml",
					["https://json.schemastore.org/dependabot-2.0.json"] = "/.github/dependabot.yml",
					["https://www.asyncapi.com/schema-store/all.schema-store.json"] = "asyncapi.yml",
				},
			},
		},
	})
end

return M
