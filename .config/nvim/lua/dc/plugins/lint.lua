local dc_utils = require("dc.utils")
-- these conditional helpers and the debounce are coming from LazyVim:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/linting/nvim-lint.lua

return {
	"mfussenegger/nvim-lint",
	event = dc_utils.lazy_file_events,
	config = function()
		local lint = require("lint")

		-- lint.linters.flake8.condition = function(ctx)
		-- 	return dc_utils.setup_cfg_sections().flake8
		-- end

		-- lint.linters.ruff.condition = function(ctx)
		-- 	-- always use ruff when flake8 is _not_ configured
		-- 	return not dc_utils.setup_cfg_sections().flake8
		-- end

		lint.linters.selene.condition = function(ctx)
			return vim.fs.find({ "selene.toml" }, { path = ctx.filename, upward = true })[1]
		end

		-- lint.linters.pydocstyle.condition = function(ctx)
		-- 	return dc_utils.pyproject_toml()["tool.pydocstyle"] or dc_utils.setup_cfg_sections().pydocstyle
		-- end

		lint.linters.eslint_d.condition = function(ctx)
			return vim.fs.find(
				{ ".eslintrc.js", ".eslintrc.json", ".eslintrc" },
				{ path = ctx.filename, upward = true }
			)[1]
		end

		-- we run shellcheck via pre-commit in the repo root,
		-- so I want to do the same for nvim-lint
		lint.linters.shellcheck.cwd = function(ctx)
			local root = vim.fs.find(".git", { path = ctx.filename, upward = true })[1]
			if root then
				return vim.fs.dirname(root)
			end
			return vim.fn.fnamemodify(ctx.filename, ":h")
		end

		lint.linters.clippy.args = {
			"clippy",
			"--message-format=json",
			"--all-features",
			"--all-targets",
			"--workspace",
			"--locked",
			"--fix",
			"--allow-dirty",
			"--allow-staged",
			"--",
			"-D",
			"warnings",
		}

		-- temporary until we have more memory again:
		-- run `cargo check` as normal linter, since we don't have RA
		lint.linters.cargo_check = {
			cmd = "cargo",
			args = { "check", "--all-targets", "--message-format=json" },
			stdin = false,
			append_fname = false,
			parser = lint.linters.clippy.parser,
		}

		-- nvim-lint cancels previous runs per buffer. cargo check operates on the
		-- whole workspace, though, so a run started from another Rust buffer can
		-- still overlap. Keep only one cargo_check process alive globally.
		local lint_process = lint.lint
		local cargo_check_process
		lint.lint = function(linter, opts)
			if linter.name == "cargo_check" and cargo_check_process then
				cargo_check_process:cancel()
			end

			local process = lint_process(linter, opts)
			if linter.name == "cargo_check" then
				cargo_check_process = process
			end
			return process
		end

		vim.api.nvim_create_autocmd({
			"BufReadPost",
			"BufWritePost",
		}, {
			group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
			callback = dc_utils.debounce(300, function()
				local names = lint.linters_by_ft[vim.bo.filetype] or {}

				local ctx = { filename = vim.api.nvim_buf_get_name(0) }
				ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
				names = vim.tbl_filter(function(name)
					local linter = lint.linters[name]
					return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
				end, names)

				if #names > 0 then
					lint.try_lint(names)
				end
			end),
		})

		lint.linters_by_ft = {
			dockerfile = { "hadolint" },
			editorconfig = { "editorconfig-checker" },
			elixir = { "credo" },
			fish = { "fish" },
			gitcommit = { "gitlint" },
			htmldjango = { "curlylint" },
			["jinja.html"] = { "curlylint" },
			json = { "jsonlint" },
			lua = { "selene" },
			markdown = { "markdownlint-cli2" },
			proto = { "buf_lint" },
			sh = { "shellcheck" },
			sql = { "sqruff" },
			vim = { "vint" },
			yaml = { "yamllint" },
			-- temporary until we have more memory again:
			rust = { "cargo_check" },
		}
	end,
}
