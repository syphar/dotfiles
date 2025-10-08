local M = {}

function M.config(cfg)
	-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/tflint.lua
	return {
		flags = cfg.global_flags(),
		capabilities = cfg.capabilities(),
		on_attach = cfg.lsp_on_attach,
		init_options = {},
	}
end

return M
