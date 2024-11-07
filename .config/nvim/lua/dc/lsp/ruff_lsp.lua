local M = {}

function M.setup(cfg, lspconfig)
	local on_attach = function(client, bufnr)
		cfg.lsp_on_attach(client, bufnr)

		local dc_utils = require("dc.utils")
		if dc_utils.pyproject_toml()["tool.ruff"] then
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.code_action({
						context = {
							only = { "source.fixAll.ruff" },
						},
						apply = true,
					})
				end,
				group = vim.api.nvim_create_augroup("fixall_on_save_lsp", { clear = true }),
			})
		elseif dc_utils.pyproject_toml()["tool.isort"] or dc_utils.setup_cfg_sections().isort then
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.code_action({
						context = {
							only = { "source.organizeImports.ruff" },
						},
						apply = true,
					})
				end,
				group = vim.api.nvim_create_augroup("fixall_on_save_lsp", { clear = true }),
			})
		end
	end

	lspconfig.ruff.setup({
		flags = cfg.global_flags(),
		capabilities = cfg.capabilities(),
		on_attach = on_attach,
	})
end

return M
