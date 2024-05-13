local cfg = {
	lsp_loaded = {},
}
vim.lsp.set_log_level("error")

local lspconfig = require("lspconfig")

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
	vim.keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, opts)
	vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, opts)

	vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
	local ft = vim.api.nvim_buf_get_option(bufnr, "ft")

	if client.server_capabilities.documentHighlightProvider and ft ~= "lua" then
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

	-- local ft = vim.api.nvim_buf_get_option(bufnr, "ft")

	-- local dc_utils = require("dc.utils")

	-- if
	-- 	(ft == "python" and (dc_utils.pyproject_toml()["tool.ruff.format"] or dc_utils.pyproject_toml()["tool.black"]))
	-- 	or ft == "rust"
	-- then
	vim.api.nvim_create_autocmd("BufWritePre", {
		buffer = bufnr,
		callback = function()
			vim.lsp.buf.format({ async = false })
		end,
		group = vim.api.nvim_create_augroup("format_on_save_lsp", { clear = true }),
	})
	-- end
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
	local signs = { Error = "", Warn = "", Hint = "", Info = "" }
	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
	end

	local servers = {
		bashls = { "*.sh" }, -- FIXME: non-sh bash scripts?
		clangd = { "*.c", "*.cpp", "*.h", "*.hpp" },
		gopls = "*.go",
		jdtls = "*.java",
		kotlin_language_server = "*.kt",
		lua_ls = "*.lua",
		marksman = "*.md",
		-- pylsp = "*.py",
		pyright = "*.py",
		-- pylyzer = "*.py",
		ruff_lsp = "*.py",
		tailwindcss = "*.css",
		taplo = "*.toml",
		terraformls = "*.tf",
		tsserver = { "*.js", "*.ts", "*.jsx", "*.tsx" },
		vimls = "*.vim",
		yamlls = "*.yaml",
	}

	for name, filetypes in pairs(servers) do
		local group = vim.api.nvim_create_augroup("load_lsp_config_" .. name, { clear = true })
		-- event for lazy loading LSP
		-- https://github.com/folke/lazy.nvim/issues/1049#issuecomment-1735543671
		vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
			group = group,
			pattern = filetypes,
			callback = function()
				if cfg.lsp_loaded[name] == nil then
					require("dc.lsp." .. name).setup(cfg, lspconfig)
					cfg.lsp_loaded[name] = true
				end
			end,
		})
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
