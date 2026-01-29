local M = {}

function M.config(cfg)
	return {
		flags = cfg.global_flags(),
		capabilities = cfg.capabilities(),
		on_attach = cfg.lsp_on_attach_without_semantic_highlighting,
		init_options = {
			experimentalFeatures = {
				validateOnSave = true,
				prefillRequiredFields = true,
			},
		},
	}
end

return M
