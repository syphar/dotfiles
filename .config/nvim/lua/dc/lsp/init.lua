local cfg = {}

local nlspsettings = require("nlspsettings")

nlspsettings.setup({
	config_home = vim.fn.stdpath("config") .. "/nlsp-settings",
	local_settings_dir = ".nlsp-settings",
	local_settings_root_markers_fallback = { ".git" },
	append_default_schemas = true,
	loader = "json",
})

function cfg.open_diagnostics_float()
	-- open diagnostics float, to be used by CursorHold & CursorHoldI
	-- separate method because I don't want diagnostics when the auto
	-- complete popup is opened.
	if vim.fn.pumvisible() ~= 1 then
		vim.diagnostic.open_float(0, { focusable = false, scope = "line" })
	end
end

function cfg.lsp_on_attach_without_formatting(client, bufnr)
	vim.lsp.set_log_level("error")
	-- vim.lsp.set_log_level("debug")

	local opts = { buffer = bufnr, silent = true }

	vim.keymap.set("n", "<leader>d", require("dc.lsp").open_diagnostics_float, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, opts)
	vim.keymap.set("n", "gI", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, opts)

	vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")

	if client.server_capabilities.documentHighlightProvider then
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

	require("lsp_signature").on_attach({
		doc_lines = 0,
		-- always show siganture on top, if possible
		max_height = vim.opt.scrolloff:get() - 3,
		floating_window_above_cur_line = true,
		-- window borders
		handler_opts = {
			border = "rounded",
		},
	})
	require("lsp-inlayhints").on_attach(client, bufnr, true)
end

function cfg.lsp_on_attach(client, bufnr)
	cfg.lsp_on_attach_without_formatting(client, bufnr)

	local format_this_buffer = function()
		vim.lsp.buf.format({
			async = false,
			bufnr = bufnr,
			-- id = client,
		})
	end

	vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
	vim.keymap.set("n", "<leader>gq", format_this_buffer, { buffer = bufnr })

	-- autoformat for certain file-types
	local ft = vim.api.nvim_buf_get_option(bufnr, "ft")
	local conditional_utils = require("null-ls.utils").make_conditional_utils()

	if ft == "terraform" or ft == "rust" or (ft == "lua" and conditional_utils.root_has_file("stylua.toml")) then
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = vim.api.nvim_create_augroup("lsp_format_on_save_" .. client.name .. "_" .. bufnr, {}),
			buffer = bufnr,
			callback = format_this_buffer,
		})
	end
end

function cfg.capabilities()
	return require("cmp_nvim_lsp").default_capabilities()
end

function cfg.global_flags()
	return {
		debounce_text_changes = vim.opt.updatetime:get(),
	}
end

function cfg.lsp_setup()
	-- nice diagnostic icons in sign-column
	-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#neovim-060-1
	local signs = { Error = "", Warn = "", Hint = "", Info = "" }
	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
	end

	local servers = {
		"bashls",
		"clangd",
		"gopls",
		"jdtls",
		"kotlin_language_server",
		"marksman",
		"null_ls",
		"pylsp",
		"rust_analyzer",
		"sumneko_lua",
		"tailwindcss",
		"taplo",
		"terraformls",
		"tsserver",
		"vimls",
		"yamlls",
	}

	for _, name in ipairs(servers) do
		require("dc.lsp." .. name)
	end

	-- update loclist with diagnostics for the current file
	vim.api.nvim_create_autocmd({ "DiagnosticChanged" }, {
		pattern = "*",
		callback = function()
			vim.diagnostic.setloclist({ open = false })
		end,
		group = vim.api.nvim_create_augroup("update_diagnostic_loclist", {}),
	})

	vim.diagnostic.config({
		signs = true,
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
