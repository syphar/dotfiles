local cfg = require("lsp")
require("lspconfig").rust_analyzer.setup({
	flags = cfg.global_flags(),
	capabilities = cfg.capabilities(),
	on_attach = function(client, bufnr)
		cfg.lsp_on_attach_without_formatting(client, bufnr)

		-- show inlay hints, only for rust-analyzer
		vim.api.nvim_create_autocmd({ "InsertLeave", "BufEnter", "BufWinEnter", "TabEnter", "BufWritePost" }, {
			pattern = "<buffer>",
			callback = require("lsp").show_inlay_hints,
			group = vim.api.nvim_create_augroup("update_inlay_hints",{}),
		})
	end,
	settings = {
		["rust-analyzer"] = {
			assist = {
				importGranularity = "crate",
				importPrefix = "by_self",
			},
			-- cache = {
			-- 	warmup = false,
			-- },
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
