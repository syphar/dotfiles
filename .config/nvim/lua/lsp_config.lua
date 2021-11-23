local cfg = {}

function cfg.show_inlay_hints()
	require("lsp_extensions").inlay_hints({
		highlight = "Comment",
		prefix = " » ",
		aligned = false,
		only_current_line = false,
		enabled = { "TypeHint", "ChainingHint" },
	})
	-- not included : ParameterHint
end

function cfg.lsp_on_attach(client, bufnr)
	-- generic on_attach, should be passed to all language servers.
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end

	local opts = { noremap = true, silent = true }
	buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
	buf_set_keymap("n", "<F2>", "<Cmd>lua vim.lsp.buf.rename()<CR>", opts)
	buf_set_keymap("n", "<leader>gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
	buf_set_keymap("n", "<leader>n", "<Cmd>lua vim.lsp.buf.references()<CR>", opts)

	-- Use LSP as the handler for omnifunc.
	--    See `:help omnifunc` and `:help ins-completion` for more information.
	vim.api.nvim_buf_set_option(0, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Use LSP as the handler for formatexpr.
	--    See `:help formatexpr` for more information.
	vim.api.nvim_buf_set_option(0, "formatexpr", "v:lua.vim.lsp.formatexpr()")

	-- better mappings for omnifunc
	-- up/down with tab/shift-tab
	vim.cmd([[inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"]])
	vim.cmd([[inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"]])
	-- enter selects entry
	vim.cmd([[inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"]])
	-- show omnicomplete on C-space
	buf_set_keymap("i", "<C-Space>", "<C-X><C-O>", opts)

	if client.resolved_capabilities.document_formatting then
		vim.cmd([[
			augroup AutoFormatOnSave
			autocmd! * <buffer>
			autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)
			augroup END
		]])
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

function cfg.lsp_setup()
	local lsp = require("lspconfig")

	-- nice diagnostic icons in sign-column
	-- https://github.com/neovim/nvim-lspconfig/wiki/UI-customization#neovim-051
	local signs = { Error = " ", Warning = " ", Hint = " ", Information = " " }
	for type, icon in pairs(signs) do
		local hl = "LspDiagnosticsSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
	end

	lsp.rust_analyzer.setup({
		on_attach = cfg.lsp_on_attach_without_formatting,
		settings = {
			["rust-analyzer"] = {
				checkOnSave = {
					enable = true,
					command = "clippy",
					allTargets = true,
				},
				procMacro = {
					enable = true,
				},
			},
		},
	})

	-- based on https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#sumneko_lua
	local sumneko_root_path = vim.fn.expand("$HOME/src/lua-language-server")
	local sumneko_binary = sumneko_root_path .. "/bin/MacOS/lua-language-server"

	local runtime_path = vim.split(package.path, ";")
	table.insert(runtime_path, "lua/?.lua")
	table.insert(runtime_path, "lua/?/init.lua")

	lsp.sumneko_lua.setup({
		cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT",
					path = runtime_path,
				},
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
				},
				telemetry = {
					enable = false,
				},
			},
		},
	})

	lsp.pylsp.setup({
		on_attach = cfg.lsp_on_attach_without_formatting,
		settings = {
			pylsp = {
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
	local helpers = require("null-ls.helpers")
	local pydocstyle = {
		method = null_ls.methods.DIAGNOSTICS,
		filetypes = { "python" },
		generator = helpers.generator_factory({
			command = "pydocstyle",
			args = {
				-- Default config discovery ignores CWD and uses the directory the temp-file is in.
				-- we want to use the config in the project.
				"--config=$ROOT/setup.cfg",
				-- pydocstyle doesn't support receiving the file via STDIN
				"$FILENAME",
			},
			to_stdin = false,
			to_temp_file = true,
			format = "raw",
			check_exit_code = function(code)
				return code <= 1
			end,
			on_output = function(params, done)
				local output = params.output
				if not output then
					return done()
				end

				-- pydocstyle output is in two lines for each error,
				-- which is why we cannot use `format = "line"` and have to
				-- split lines on our own.

				-- Example:
				--     nsync/tasks.py:48 in public function `send_stored_draft`:
				--         D403: First word of the first line should be properly capitalized ('Send', not 'send')

				local diagnostics = {}
				local current_line = nil

				for _, line in ipairs(vim.split(output, "\n")) do
					if line ~= "" then
						if current_line == nil then
							current_line = tonumber(line:match(":(%d+) "))
						else
							local code, message = line:match("%s+(D%d+): (.*)")

							table.insert(diagnostics, {
								row = current_line,
								source = "pydocstyle(" .. code .. ")",
								message = message,
								severity = 3, -- "info" severity
							})

							current_line = nil
						end
					end
				end
				done(diagnostics)
			end,
		}),
	}

	null_ls.config({
		-- debug = true,
		sources = {
			null_ls.builtins.code_actions.gitsigns,
			null_ls.builtins.diagnostics.flake8,
			null_ls.builtins.diagnostics.hadolint,
			null_ls.builtins.diagnostics.luacheck,
			null_ls.builtins.diagnostics.shellcheck,
			null_ls.builtins.diagnostics.vint,
			null_ls.builtins.diagnostics.yamllint,
			null_ls.builtins.formatting.black,
			null_ls.builtins.formatting.isort,
			null_ls.builtins.formatting.rustfmt,
			null_ls.builtins.formatting.stylua,
			null_ls.builtins.formatting.trim_newlines,
			pydocstyle,
		},
	})

	lsp["null-ls"].setup({
		on_attach = cfg.lsp_on_attach,
	})

	-- automatically show line diagnostics in a hover window
	vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.lsp.diagnostic.show_line_diagnostics({focusable=false})]])
end

return cfg
