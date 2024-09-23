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

		lint.linters.sqlfluff.condition = function(ctx)
			return dc_utils.pyproject_toml()["tool.sqlfluff"] or dc_utils.setup_cfg_sections().sqlfluff
		end

		lint.linters.eslint_d.condition = function(ctx)
			return vim.fs.find(
				{ ".eslintrc.js", ".eslintrc.json", ".eslintrc" },
				{ path = ctx.filename, upward = true }
			)[1]
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

		lint.linters.buf = {
			cmd = "buf",
			stdin = true,
			append_fname = false,
			args = { "lint", "--error-format=json" },
			ignore_exitcode = true,
			parser = function(output, bufnr, linter_cwd)
				if not vim.api.nvim_buf_is_valid(bufnr) then
					return {}
				end
				local result = {}
				for _, line in ipairs(vim.fn.split(output, "\n")) do
					local data = vim.json.decode(line)
					table.insert(result, {
						lnum = data.start_line - 1,
						end_lnum = data.end_line - 1,
						col = data.start_column - 1,
						end_col = data.end_column - 1,
						severity = vim.diagnostic.severity.ERROR,
						message = data.message,
						code = data.type,
						source = "buf",
					})
				end
				return result
			end,
		}

		vim.api.nvim_create_autocmd({
			"BufWritePost",
			"BufReadPost",
			-- "InsertLeave",
			-- "TextChanged"
		}, {
			group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
			callback = dc_utils.debounce(100, function()
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
			elixir = { "credo" },
			fish = { "fish" },
			gitcommit = { "gitlint" },
			htmldjango = { "curlylint" },
			["jinja.html"] = { "curlylint" },
			json = { "jsonlint" },
			lua = { "selene" },
			markdown = { "markdownlint" },
			proto = { "buf" },
			sh = { "shellcheck" },
			sql = { "sqlfluff" },
			vim = { "vint" },
			yaml = { "yamllint" },
		}
	end,
}
