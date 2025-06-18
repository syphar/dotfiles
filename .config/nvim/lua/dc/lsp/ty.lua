local M = {}

function M.config(cfg)
	-- https://github.com/astral-sh/ty/blob/main/docs/README.md#neovim
	return {
		flags = cfg.global_flags(),
		capabilities = cfg.capabilities(),
		on_attach = cfg.lsp_on_attach,
		init_options = {
			settings = {
				-- ty language server settings go here
			},
		},
	}
end

return M
