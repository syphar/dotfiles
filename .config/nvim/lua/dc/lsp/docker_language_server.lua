local M = {}

function M.config(cfg)
	return cfg.base({
		filetypes = {
			"dockerfile",
			"yaml.docker-compose",
			"hcl.docker-bake",
			"json.docker-bake",
		},
		get_language_id = function(_, filetype)
			if filetype == "hcl.docker-bake" or filetype == "json.docker-bake" then
				return "dockerbake"
			elseif filetype == "yaml.docker-compose" then
				return "dockercompose"
			end

			return filetype
		end,
		on_attach = cfg.lsp_on_attach_without_semantic_highlighting,
		workspace_required = true,
	})
end

return M
