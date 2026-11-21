local M = {}

function M.config(cfg)
	-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/tflint.lua
	return cfg.base({
		init_options = {},
	})
end

return M
