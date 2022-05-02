local cfg = require("lsp")

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

			vim.keymap.set("n", "<leader>x", function()
				local response = vim.lsp.buf_request_sync(
					bufnr,
					"experimental/externalDocs",
					vim.lsp.util.make_position_params()
				)

				if response then
					for _, v in pairs(response) do
						if v == nil or v["result"] == nil then
							-- no response
							return
						end
						vim.fn["netrw#BrowseX"](v["result"], 0)
					end
				end
			end, { buffer = bufnr })
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
