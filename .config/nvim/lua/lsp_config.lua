local Path = require("plenary.path")
local cfg = {}

function cfg.open_diagnostics_float()
	-- open diagnostics float, to be used by CursorHold & CursorHoldI
	-- separate method because I don't want diagnostics when the auto
	-- complete popup is opened.
	if vim.fn.pumvisible() ~= 1 then
		vim.diagnostic.open_float(0, { focusable = false, scope = "line" })
	end
end

function cfg.show_inlay_hints()
	require("lsp_extensions").inlay_hints({
		highlight = "LineNr",
		prefix = " » ",
		aligned = false,
		only_current_line = false,
		enabled = { "TypeHint", "ChainingHint" }, -- not: ParameterHint
	})
end

function cfg.lsp_on_attach(client, bufnr)
	-- generic on_attach, should be passed to all language servers.
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end

	local opts = { noremap = true, silent = true }
	buf_set_keymap("n", "<leader>d", [[<CMD>lua require"lsp_config".open_diagnostics_float()<CR>]], opts)
	buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
	buf_set_keymap("n", "<F2>", "<Cmd>lua vim.lsp.buf.rename()<CR>", opts)
	buf_set_keymap("n", "<leader>gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
	buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
	buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	buf_set_keymap("n", "gT", "<Cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
	buf_set_keymap("n", "<leader>gi", "<Cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	buf_set_keymap("n", "gi", "<Cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	buf_set_keymap("n", "<leader>n", "<Cmd>lua vim.lsp.buf.references()<CR>", opts)
	buf_set_keymap("n", "gr", "<Cmd>Telescope lsp_references<CR>", opts)
	buf_set_keymap("n", "gI", "<Cmd>Telescope lsp_implementations<CR>", opts)

	if client.resolved_capabilities.document_formatting then
		-- vim.cmd([[
		-- 	augroup AutoFormatOnSave
		-- 	autocmd! * <buffer>
		-- 	autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)
		-- 	augroup END
		-- ]])

		vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
		buf_set_keymap("n", "<leader>gq", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
	end

	if client.resolved_capabilities.document_highlight then
		vim.cmd([[
			augroup hilight_references
			autocmd! * <buffer>
			autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
			autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
			augroup END
		]])
	end
	if client.resolved_capabilities.goto_definition == true then
		vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
	end
	require("lsp_signature").on_attach(client, bufnr)
end

function cfg.lsp_on_attach_without_formatting(client, bufnr)
	cfg.lsp_on_attach(client, bufnr)
	client.resolved_capabilities.document_formatting = false
	client.resolved_capabilities.document_range_formatting = false
end

function cfg.lsp_setup()
	local lsp = require("lspconfig")

	local global_flags = {
		debounce_text_changes = vim.opt.updatetime:get(),
	}

	-- nice diagnostic icons in sign-column
	-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#neovim-060-1
	local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
	end

	local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

	-- TOML language server with schemas
	-- schemas broken for now in LSP
	lsp.taplo.setup({
		flags = global_flags,
		capabilities = capabilities,
		on_attach = cfg.lsp_on_attach_without_formatting,
	})

	lsp.rust_analyzer.setup({
		flags = global_flags,
		capabilities = capabilities,
		on_attach = function(client, bufnr)
			cfg.lsp_on_attach_without_formatting(client, bufnr)

			-- show inlay hints, only for rust-analyzer
			vim.cmd([[
			  augroup update_inlay_hints
				autocmd! * <buffer>
				autocmd InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost <buffer> :lua require'lsp_config'.show_inlay_hints()
			  augroup end
			]])
		end,
		settings = {
			["rust-analyzer"] = {
				assist = {
					importGranularity = "crate",
					importPrefix = "by_self",
				},
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

	-- based on https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#sumneko_lua
	local sumneko_root_path = vim.fn.expand("$HOME/src/lua-language-server")
	local sumneko_binary = sumneko_root_path .. "/bin/MacOS/lua-language-server"

	local runtime_path = vim.split(package.path, ";")
	table.insert(runtime_path, "lua/?.lua")
	table.insert(runtime_path, "lua/?/init.lua")

	lsp.sumneko_lua.setup({
		cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
		capabilities = capabilities,
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
					preloadFileSize = 500,
				},
				telemetry = {
					enable = false,
				},
			},
		},
	})

	lsp.tsserver.setup({
		flags = global_flags,
		capabilities = capabilities,
		on_attach = cfg.lsp_on_attach_without_formatting,
	})

	lsp.pylsp.setup({
		flags = global_flags,
		capabilities = capabilities,
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
						enabled = true,
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

	lsp.zeta_note.setup({
		capabilities = capabilities,
		cmd = {
			vim.fn.expand("$HOME/.local/bin/zeta-note"),
		},
	})

	lsp.gopls.setup({
		flags = global_flags,
		capabilities = capabilities,
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

	null_ls.setup({
		-- debug = true,
		sources = {
			null_ls.builtins.code_actions.proselint,
			null_ls.builtins.code_actions.shellcheck,
			null_ls.builtins.completion.spell.with({
				filetypes = { "markdown" },
			}),
			null_ls.builtins.diagnostics.eslint_d.with({ condition = has_eslint_rc }),
			null_ls.builtins.diagnostics.flake8,
			null_ls.builtins.diagnostics.hadolint,
			null_ls.builtins.diagnostics.luacheck,
			null_ls.builtins.diagnostics.markdownlint,
			null_ls.builtins.diagnostics.proselint,
			null_ls.builtins.diagnostics.selene,
			null_ls.builtins.diagnostics.shellcheck,
			null_ls.builtins.diagnostics.teal,
			null_ls.builtins.diagnostics.vint,
			null_ls.builtins.diagnostics.yamllint,
			null_ls.builtins.formatting.black,
			null_ls.builtins.formatting.djhtml.with({
				extra_args = function(params)
					return {
						"--tabwidth",
						vim.api.nvim_buf_get_option(params.bufnr, "shiftwidth"),
					}
				end,
			}),
			null_ls.builtins.formatting.eslint_d.with({ condition = has_eslint_rc }),
			null_ls.builtins.formatting.fish_indent,
			null_ls.builtins.formatting.gofmt,
			null_ls.builtins.formatting.isort,
			null_ls.builtins.formatting.json_tool, -- keep this or not?
			null_ls.builtins.formatting.markdownlint,
			null_ls.builtins.formatting.prettierd.with({
				condition = has_any_config({ ".prettierrc.js", ".prettierrc.json", ".prettierrc" }),
			}),
			null_ls.builtins.formatting.rustfmt.with({
				-- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Source-specific-Configuration#rustfmt
				-- added 2021 as default
				-- For bigger projects rust-analyzer takes ages to load the whole workspace.
				-- Since I want formatting to work before that, I use `rustfmt` instead of
				-- rust-analyzer here.
				extra_args = function(params)
					local cargo_toml = Path:new(params.root .. "/" .. "Cargo.toml")

					if cargo_toml:exists() and cargo_toml:is_file() then
						for _, line in ipairs(cargo_toml:readlines()) do
							local edition = line:match([[^edition%s*=%s*%"(%d+)%"]])
							if edition then
								return { "--edition=" .. edition }
							end
						end
					end
					-- default edition when we don't find `Cargo.toml` or the `edition` in it.
					return { "--edition=2021" }
				end,
			}),
			null_ls.builtins.formatting.stylua,
			null_ls.builtins.formatting.taplo,
			null_ls.builtins.formatting.trim_newlines,
			null_ls.builtins.formatting.trim_whitespace.with({
				-- I don't want this for all filetypes since it
				-- also removes whitespace inside string literals.
				filetypes = { "markdown", "yaml" },
			}),
			null_ls.builtins.hover.dictionary,
			custom.curlylint,
			custom.gitlint,
			custom.pydocstyle,
		},
		debounce = vim.opt.updatetime:get(),
		update_on_insert = false,
		diagnostics_format = "[#{c}] #{m} (#{s})",
		on_attach = cfg.lsp_on_attach,
		capabilities = capabilities,
	})

	-- update loclist with diagnostics for the current file
	vim.api.nvim_command([[autocmd DiagnosticChanged * lua vim.diagnostic.setloclist({open=false})]])

	vim.diagnostic.config({
		virtual_text = true,
		signs = true,
		underline = true,
		update_in_insert = false,
		severity_sort = true,
	})

	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
		virtual_text = {
			-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#show-source-in-diagnostics-neovim-06-only
			source = "if_many",
			prefix = "●",
		},
	})
end

return cfg
