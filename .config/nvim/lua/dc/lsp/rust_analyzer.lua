local cfg = require("dc.lsp")

require("type-fmt").setup({
	-- In case if you only want to enable this for limited buffers
	-- We already filter it by checking capabilities of attached lsp client
	buf_filter = function(bufnr)
		return true
	end,
	-- If multiple clients are capable of onTypeFormatting, we use this to determine which will win
	-- This is a rare situation but we still provide it for the correctness of lsp client handling
	prefer_client = function(client_a, client_b)
		return client_a or client_b
	end,
})

require("rust-tools").setup({
	tools = {
		inlay_hints = {
			auto = false,
			-- 	show_parameter_hints = false,
			-- 	other_hints_prefix = " » ",
			-- 	highlight = "LineNr",
			-- 	auto = true,
		},
	},
	server = {
		standalone = false,
		flags = cfg.global_flags(),
		capabilities = cfg.capabilities(),
		on_attach = function(client, bufnr)
			cfg.lsp_on_attach_without_formatting(client, bufnr)

			vim.keymap.set("n", "gh", require("rust-tools.external_docs").open_external_docs, { buffer = bufnr })
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
				workspace = {
					symbol = {
						search = {
							scope = "workspace_and_dependencies", --  (default: "workspace")
						},
					},
				},
			},
		},
	},
})
