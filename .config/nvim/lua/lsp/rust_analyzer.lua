local cfg = require("lsp")
-- require("lspconfig").rust_analyzer.setup({})

require("rust-tools").setup({
	tools = {
		autoSetHints = true,
		inlay_hints = {
			show_parameter_hints = false,
			other_hints_prefix = " » ",
			highlight = "LineNr",
		},
	},
	server = {
		standalone = false,
		flags = cfg.global_flags(),
		capabilities = cfg.capabilities(),
		on_attach = function(client, bufnr)
			cfg.lsp_on_attach_without_formatting(client, bufnr)
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
	},
})
