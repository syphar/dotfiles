local cfg = require("dc.lsp")
local Path = require("plenary.path")
local null_ls = require("null-ls")
local utils = require("null-ls.utils")

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

local function pyproject_toml()
	local root = utils.get_root()
	local filename = Path:new(root .. "/" .. "pyproject.toml")

	if filename:exists() and filename:is_file() then
		local toml = require("toml")
		local data = toml.decode(filename:read())
		return data
	end
	return {
		tool = {},
	}
end

local function setup_cfg_sections()
	local root = utils.get_root()
	local filename = Path:new(root .. "/" .. "setup.cfg")

	local sections = {}
	if filename:exists() and filename:is_file() then
		for _, line in ipairs(vim.split(filename:read(), "\n")) do
			local _, _, name = line:find("%[(.*)%]")
			if name then
				sections[name] = true
			end
		end
	end
	return sections
end

null_ls.setup({
	-- debug = true,
	sources = {
		null_ls.builtins.code_actions.gitsigns,
		null_ls.builtins.code_actions.proselint,
		null_ls.builtins.code_actions.shellcheck,
		null_ls.builtins.completion.spell.with({
			filetypes = { "markdown", "gitcommit" },
		}),
		null_ls.builtins.diagnostics.alex,
		null_ls.builtins.diagnostics.curlylint,
		null_ls.builtins.diagnostics.credo,
		null_ls.builtins.diagnostics.eslint_d.with({ condition = has_eslint_rc }),
		null_ls.builtins.diagnostics.fish,
		null_ls.builtins.diagnostics.flake8.with({
			condition = function(utils)
				return setup_cfg_sections().flake8
			end,
		}),
		null_ls.builtins.diagnostics.gitlint,
		null_ls.builtins.diagnostics.hadolint,
		null_ls.builtins.diagnostics.jsonlint,
		null_ls.builtins.diagnostics.markdownlint,
		null_ls.builtins.diagnostics.proselint,
		null_ls.builtins.diagnostics.pydocstyle.with({
			extra_args = { "--config=$ROOT/setup.cfg" },
			condition = function(utils)
				return pyproject_toml().tool.pydocstyle or setup_cfg_sections().pydocstyle
			end,
		}),
		null_ls.builtins.diagnostics.ruff.with({
			condition = function(utils)
				return pyproject_toml().tool.ruff
			end,
		}),
		null_ls.builtins.diagnostics.selene.with({
			condition = function(utils)
				return utils.root_has_file({ "selene.toml" })
			end,
		}),
		null_ls.builtins.diagnostics.semgrep,
		null_ls.builtins.diagnostics.shellcheck,
		null_ls.builtins.diagnostics.sqlfluff.with({
			extra_args = { "--dialect", "postgres" },
			timeout = 30000,
			condition = function(utils)
				return pyproject_toml().tool.sqlfluff or setup_cfg_sections().sqlfluff
			end,
		}),
		null_ls.builtins.diagnostics.teal,
		null_ls.builtins.diagnostics.vint,
		null_ls.builtins.diagnostics.yamllint,
		null_ls.builtins.formatting.black.with({
			extra_args = { "--fast" },
			condition = function(utils)
				return pyproject_toml().tool.black
			end,
		}),
		null_ls.builtins.formatting.clang_format.with({
			filetypes = { "c", "cpp" },
		}),
		null_ls.builtins.formatting.deno_fmt.with({
			filetypes = { "markdown" },
		}),
		null_ls.builtins.formatting.djhtml.with({
			extra_args = function(params)
				return {
					"--tabwidth",
					vim.api.nvim_buf_get_option(params.bufnr, "shiftwidth"),
					"-",
				}
			end,
		}),
		null_ls.builtins.formatting.eslint_d.with({ condition = has_eslint_rc }),
		null_ls.builtins.formatting.fish_indent,
		null_ls.builtins.formatting.gofmt,
		null_ls.builtins.formatting.google_java_format,
		null_ls.builtins.formatting.isort.with({
			condition = function(utils)
				return pyproject_toml().tool.isort or setup_cfg_sections().isort
			end,
		}),
		null_ls.builtins.formatting.jq,
		null_ls.builtins.formatting.just,
		null_ls.builtins.formatting.ktlint.with({
			-- when we don't add this, ktlint prints the following line to stdout:
			--   09:20:23.742 [main] INFO com.pinterest.ktlint.internal.KtlintCommandLine - Enable default patterns [**/*.kt, **/*.kts]
			-- Which then ends up in the format result / the file.
			extra_args = { "**/*.kt", "**/*.kts" },
		}),
		null_ls.builtins.formatting.mix,
		null_ls.builtins.formatting.prettierd.with({
			condition = has_any_config({ ".prettierrc.js", ".prettierrc.json", ".prettierrc" }),
			filetypes = {
				-- "jsonc",
				"handlebars",
				"javascriptreact",
				"vue",
				"less",
				"graphql",
				-- "json",
				-- "html",
				"css",
				-- "markdown.mdx",
				"typescriptreact",
				-- "markdown",
				-- "yaml",
				"typescript",
				"scss",
			},
		}),
		null_ls.builtins.formatting.ruff.with({
			condition = function(utils)
				return pyproject_toml().tool.ruff
			end,
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
					local toml = require("toml")
					local data = toml.decode(cargo_toml:read())
					if data and data.package.edition then
						return { "--edition=" .. data.package.edition }
					end
				end
				-- default edition when we don't find `Cargo.toml` or the `edition` in it.
				return { "--edition=2021" }
			end,
		}),
		null_ls.builtins.formatting.surface,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.sqlfluff.with({
			extra_args = { "--dialect", "postgres" },
			timeout = 30000,
		}),
		null_ls.builtins.formatting.taplo,
		null_ls.builtins.formatting.terraform_fmt,
		null_ls.builtins.formatting.trim_newlines,
		null_ls.builtins.formatting.trim_whitespace.with({
			-- I don't want this for all filetypes since it
			-- also removes whitespace inside string literals.
			filetypes = { "markdown", "yaml", "gitcommit" },
		}),
		null_ls.builtins.formatting.xmllint,
		null_ls.builtins.hover.dictionary,
		require("dc.lsp.null_ls_custom.bandit"),
		-- require("dc.lsp.null_ls_custom.perflint"),
	},
	debounce = vim.opt.updatetime:get(),
	fallback_severity = vim.diagnostic.severity.INFO,
	update_in_insert = false,
	diagnostics_format = "[#{c}] #{m} (#{s})",
	on_attach = cfg.lsp_on_attach,
	capabilities = cfg.capabilities(),
})
