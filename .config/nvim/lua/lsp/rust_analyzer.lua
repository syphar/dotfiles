local cfg = require("lsp")
require("lspconfig").rust_analyzer.setup({
	flags = cfg.global_flags(),
	capabilities = cfg.capabilities(),
	on_attach = function(client, bufnr)
		cfg.lsp_on_attach_without_formatting(client, bufnr)

		-- show inlay hints, only for rust-analyzer
		vim.cmd([[
		  augroup update_inlay_hints
			autocmd! * <buffer>
			autocmd InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost <buffer> :lua require("lsp").show_inlay_hints()
		  augroup end
		]])
	end,
	settings = {
		["rust-analyzer"] = {
			assist = {
				importGranularity = "crate",
				importPrefix = "by_self",
			},
			checkOnSave = {
				enable = true,
				command = "clippy",
				allTargets = true,
				allFeatures = true,
			},
			cargo = {
				loadOutDirsFromCheck = true,
			},
			procMacro = {
				enable = true,
			},
		},
	},
})
