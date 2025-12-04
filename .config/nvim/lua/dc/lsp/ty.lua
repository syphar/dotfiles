local M = {}

function M.config(cfg)
	-- https://github.com/astral-sh/ty/blob/main/docs/README.md#neovim
	return {
		flags = cfg.global_flags(),
		capabilities = cfg.capabilities(),
		on_attach = cfg.lsp_on_attach,
		init_options = {},
		settings = {
			ty = {
				-- https://docs.astral.sh/ty/reference/editor-settings/#diagnosticmode
				diagnosticMode = "workspace",
				-- https://docs.astral.sh/ty/reference/editor-settings/#inlayhints
				inlayHints = {
					variableTypes = false, -- too much noise?
					callArgumentNames = true,
				},
				experimental = {
					-- https://docs.astral.sh/ty/reference/editor-settings/#rename
					rename = true,
					-- https://docs.astral.sh/ty/reference/editor-settings/#autoimport
					autoImport = true,
				},
			},
		},
	}
end

return M
