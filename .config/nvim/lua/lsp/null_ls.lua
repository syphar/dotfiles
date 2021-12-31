local cfg = require("lsp")
local Path = require("plenary.path")
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
		require("lsp.null_ls_custom.curlylint"),
		require("lsp.null_ls_custom.gitlint"),
		require("lsp.null_ls_custom.pydocstyle"),
	},
	debounce = vim.opt.updatetime:get(),
	update_on_insert = false,
	diagnostics_format = "[#{c}] #{m} (#{s})",
	on_attach = cfg.lsp_on_attach,
	capabilities = cfg.capabilities(),
})
