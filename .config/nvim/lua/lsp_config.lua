local cfg = {}

function cfg.lsp_on_attach(client, bufnr)
	-- generic on_attach, should be passed to all language servers.
	-- rust-tools get it in `plugins` in its custom `config` method
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end

	local opts = { noremap = true, silent = true }
	buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
	buf_set_keymap("n", "<F2>", "<Cmd>lua vim.lsp.buf.rename()<CR>", opts)
	buf_set_keymap("n", "<leader>gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
	buf_set_keymap("n", "<leader>n", "<Cmd>lua vim.lsp.buf.references()<CR>", opts)

	if client.resolved_capabilities.document_formatting then
		vim.cmd([[augroup Format]])
		vim.cmd([[autocmd! * <buffer>]])
		vim.cmd([[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)]])
		vim.cmd([[augroup END]])
	end

	require("lsp_signature").on_attach({
		bind = true,
	})
end

function cfg.lsp_on_attach_without_formatting(client, bufnr)
	cfg.lsp_on_attach(client, bufnr)
	client.resolved_capabilities.document_formatting = false
	client.resolved_capabilities.document_range_formatting = false
end

function cfg.updated_capabilities()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	return require("cmp_nvim_lsp").update_capabilities(capabilities)
end

function cfg.lsp_setup()
	local lsp = require("lspconfig")

	lsp.rust_analyzer.setup({
		on_attach = cfg.lsp_on_attach_without_formatting,
		capabilities = cfg.updated_capabilities(),
		settings = {
			["rust-analyzer"] = {
				checkOnSave = {
					command = "clippy",
				},
			},
		},
	})

	lsp.pylsp.setup({
		capabilities = cfg.updated_capabilities(),
		on_attach = cfg.lsp_on_attach_without_formatting,
		settings = {
			pylsp = {
				-- configurationSources = {"flake8", "pycodestyle"},
				plugins = {
					pydocstyle = {
						enabled = false,
					},
					pycodestyle = {
						enabled = false,
					},
					pyflakes = {
						enabled = false,
					},
					jedi_signature_help = {
						enabled = false,
					},
					pylsp_mypy = {
						enabled = true,
						live_mode = false,
						dmypy = true,
					},
				},
			},
		},
	})

	local null_ls = require("null-ls")
	null_ls.config({
		-- debug = true,
		sources = {
			null_ls.builtins.code_actions.gitsigns,
			null_ls.builtins.diagnostics.flake8,
			null_ls.builtins.diagnostics.luacheck,
			null_ls.builtins.diagnostics.shellcheck,
			null_ls.builtins.formatting.black,
			null_ls.builtins.formatting.isort,
			-- null_ls.builtins.formatting.rustfmt,
			null_ls.builtins.formatting.stylua,
			null_ls.builtins.formatting.trim_whitespace,
			-- null_ls.builtins.formatting.sqlformat,
			null_ls.builtins.diagnostics.vint,
			null_ls.builtins.formatting.trim_newlines,
		},
	})
	local rustfmt_fixed = {
		method = null_ls.methods.FORMATTING,
		filetypes = { "rust" },
		generator = null_ls.generator({
			command = "rustfmt",
			args = { "--emit=stdout", "--edition=2018" },
			to_stdin = true,
			ignore_stderr = true,
			on_output = function(params, done)
				local output = params.output
				if not output then
					return done()
				end

				return done({
					{
						row = 1,
						col = 1,
						-- source: https://microsoft.github.io/language-server-protocol/specifications/specification-current/#range
						-- "... the end position is exclusive. If you want to specify a range that contains a line including the
						--  line ending character(s) then use an end position denoting the start of the next line."
						end_row = vim.tbl_count(params.content) + 1,
						end_col = 1,
						text = output,
					},
				})
			end,
		}),
	}

	null_ls.register(rustfmt_fixed)

	lsp["null-ls"].setup({
		on_attach = cfg.lsp_on_attach,
	})
end

function cfg.cmp_setup()
	local cmp = require("cmp")

	cmp.setup({
		completion = {
			completeopt = "menu,menuone,noselect",
			autocomplete = false,
			-- autocomplete = { "types.cmp.TriggerEvent.TextChanged" },
		},
		mapping = {
			["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
			["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
			["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
			["<C-y>"] = cmp.config.disable, -- If you want to remove the default `<C-y>` mapping, You can specify `cmp.config.disable` value.
			["<C-e>"] = cmp.mapping({
				i = cmp.mapping.abort(),
				c = cmp.mapping.close(),
			}),
			["<CR>"] = cmp.mapping.confirm({ select = true }),
			["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
			["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
		},
		sources = cmp.config.sources({
			{ name = "nvim_lsp" },
			{ name = "cmp_tabnine" },
		}, {
			{ name = "buffer" },
		}),
	})

	-- Use buffer source for `/`.
	cmp.setup.cmdline("/", {
		sources = {
			{ name = "buffer" },
		},
	})

	-- Use cmdline & path source for ':'.
	cmp.setup.cmdline(":", {
		sources = cmp.config.sources({
			{ name = "path" },
		}, {
			{ name = "cmdline" },
		}),
	})
end

return cfg
