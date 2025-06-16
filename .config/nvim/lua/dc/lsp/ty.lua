local M = {}

function M.config(cfg)
	-- https://github.com/astral-sh/ty/blob/main/docs/README.md#neovim
	return {
		init_options = {
			settings = {
				-- ty language server settings go here
			},
		},
	}
end

return M
