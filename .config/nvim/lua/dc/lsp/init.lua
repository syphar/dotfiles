local cfg = {}
vim.lsp.log.set_level("error")
require("lspconfig")

function cfg.open_diagnostics_float() end

function cfg.lsp_on_attach(client, bufnr)
	vim.lsp.log.set_level("error")
	-- vim.lsp.log.set_level("debug")

	local opts = { buffer = bufnr, silent = true }

	vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, opts)
	vim.keymap.set("n", "gI", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

	local ft = vim.api.nvim_buf_get_option(bufnr, "ft")

	if client:supports_method("textDocument/codeAction") then
		vim.keymap.set({ "n", "v" }, "<leader>a", function()
			if ft == "rust" then
				vim.cmd.RustLsp("codeAction")
			else
				vim.lsp.buf.code_action()
			end
		end, opts)
	end

	vim.keymap.set("n", "<leader>d", function()
		-- Keep diagnostics floats out of the way when completion is visible.
		if vim.fn.pumvisible() ~= 1 then
			if ft == "rust" then
				vim.cmd.RustLsp({ "renderDiagnostic", "current" })
			else
				vim.diagnostic.open_float(0, { focusable = false, scope = "line" })
			end
		end
	end, opts)

	if client:supports_method("textDocument/documentHighlight") and ft ~= "lua" then
		local augroup = vim.api.nvim_create_augroup("lsp_document_highlight" .. client.name .. "_" .. bufnr, {})
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			group = augroup,
			buffer = bufnr,
			callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd("CursorMoved", {
			group = augroup,
			buffer = bufnr,
			callback = vim.lsp.buf.clear_references,
		})
	end

	if client:supports_method("textDocument/signatureHelp") then
		require("lsp_signature").on_attach({
			doc_lines = 0,
			-- Always show the signature popup above the cursor when possible.
			max_height = vim.opt.scrolloff:get() - 3,
			floating_window_above_cur_line = true,
			handler_opts = {
				border = "rounded",
			},
		})
	end

	if client:supports_method("textDocument/inlayHint") then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end
end

function cfg.lsp_on_attach_without_semantic_highlighting(client, bufnr)
	cfg.lsp_on_attach(client, bufnr)

	-- disable LSP server highlighting, I prefer treesitter for now
	client.server_capabilities.semanticTokensProvider = nil
end

function cfg.capabilities()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	if capabilities.workspace then
		capabilities.workspace.didChangeWatchedFiles = nil
	end
	return require("cmp_nvim_lsp").default_capabilities(capabilities)
end

function cfg.global_flags()
	return {
		debounce_text_changes = vim.opt.updatetime:get(),
	}
end

function cfg.base(opts)
	return vim.tbl_deep_extend("force", {
		flags = cfg.global_flags(),
		capabilities = cfg.capabilities(),
		on_attach = cfg.lsp_on_attach,
	}, opts or {})
end

function cfg.lsp_setup()
	local lsp_dir = vim.fn.stdpath("config") .. "/lua/dc/lsp"
	local lsp_files = vim.fn.globpath(lsp_dir, "*.lua", false, true)

	for _, file in ipairs(lsp_files) do
		local name = file:match("([^/]+)%.lua$")
		if name and name ~= "init" then
			vim.lsp.config(name, require("dc.lsp." .. name).config(cfg))
			vim.lsp.enable(name)
		end
	end

	vim.api.nvim_create_autocmd({ "DiagnosticChanged" }, {
		group = vim.api.nvim_create_augroup("update_diagnostic_loclist", {}),
		callback = function(ev)
			if ev.buf ~= vim.api.nvim_get_current_buf() then
				return
			end
			vim.diagnostic.setloclist({ open = false })
		end,
	})

	vim.diagnostic.config({
		-- signs = true,
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = "",
				[vim.diagnostic.severity.WARN] = "",
				[vim.diagnostic.severity.HINT] = "",
				[vim.diagnostic.severity.INFO] = "",
			},
		},
		underline = true,
		update_in_insert = false,
		severity_sort = true,
		virtual_text = {
			source = "if_many",
			prefix = "●",
		},
		float = {
			source = "always",
		},
	})
end

return cfg
