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

	vim.api.nvim_buf_set_option(0, "omnifunc", "v:lua.vim.lsp.omnifunc")
	vim.api.nvim_buf_set_option(0, "formatexpr", "v:lua.vim.lsp.formatexpr()")

	-- better mappings for omnifunc
	-- up/down with tab/shift-tab
	-- tab => start omni complete, I don't need tab for other things.
	-- old default tab expr = `\<Tab>`
	-- vim.cmd([[inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"]])
	vim.cmd([[inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<C-X><C-O>"]])
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
					allFeatures = true,
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

	-- needs
	-- * global: npm install -g typescript-language-server
	-- * local: npm install typescript
	lsp.tsserver.setup({
		on_attach = cfg.lsp_on_attach_without_formatting,
	})
	-- I like deno more, but it doesn't use npm/node_modules,
	-- which leads to many errors in normal projects.

	-- lsp.denols.setup({
	-- 	on_attach = cfg.lsp_on_attach_without_formatting,
	-- 	init_options = {
	-- 		enable = true,
	-- 		lint = false,
	-- 		unstable = false,
	-- 	},
	-- })

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

	lsp.gopls.setup({
		on_attach = cfg.lsp_on_attach_without_formatting,
	})

	local null_ls = require("null-ls")

	local function has_any_config(filenames)
		local function checker(utils)
			for _, fn in pairs(filenames) do
				if utils.root_has_file(fn) then
					return true
				end
			end
		end

		return checker
	end

	local function has_eslint_rc(utils)
		return has_any_config({ ".eslintrc.js", ".eslintrc.json", ".eslintrc" })(utils)
	end

	local custom = require("null_ls_custom")

	null_ls.config({
		-- debug = true,
		sources = {
			null_ls.builtins.code_actions.gitsigns,
			null_ls.builtins.diagnostics.eslint_d.with({ condition = has_eslint_rc }),
			null_ls.builtins.diagnostics.flake8,
			null_ls.builtins.diagnostics.hadolint,
			null_ls.builtins.diagnostics.luacheck,
			null_ls.builtins.diagnostics.markdownlint,
			null_ls.builtins.diagnostics.shellcheck,
			null_ls.builtins.diagnostics.vint,
			null_ls.builtins.diagnostics.yamllint,
			null_ls.builtins.formatting.black,
			null_ls.builtins.formatting.eslint_d.with({ condition = has_eslint_rc }),
			null_ls.builtins.formatting.fish_indent,
			null_ls.builtins.formatting.gofmt,
			null_ls.builtins.formatting.isort,
			null_ls.builtins.formatting.prettierd.with({
				condition = has_any_config({ ".prettierrc.js", ".prettierrc.json", ".prettierrc" }),
			}),
			null_ls.builtins.formatting.rustfmt,
			null_ls.builtins.formatting.stylua,
			null_ls.builtins.formatting.trim_newlines,
			custom.curlylint,
			custom.gitlint,
			custom.pydocstyle,
			-- custom.dj_html,
		},
		debounce = 1000,
		update_on_insert = false,
		diagnostics_format = "[#{c}] #{m} (#{s})",
	})

	lsp["null-ls"].setup({
		on_attach = cfg.lsp_on_attach,
	})

	-- automatically show line diagnostics in a hover window
	vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.lsp.diagnostic.show_line_diagnostics({focusable=false})]])

	-- update loclist with diagnostics for the current file
	vim.api.nvim_command(
		[[autocmd! User LspDiagnosticsChanged lua vim.lsp.diagnostic.set_loclist({open_loclist=false})]]
	)
end

return cfg
