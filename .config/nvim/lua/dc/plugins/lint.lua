local dc_utils = require("dc.utils")

return {
	"mfussenegger/nvim-lint",
	event = dc_utils.lazy_file_events,
	config = function()
		local lint = require("lint")

		vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave", "TextChanged" }, {
			group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
			callback = dc_utils.debounce(100, function()
				local names = lint.linters_by_ft[vim.bo.filetype] or {}
				-- local ctx = { filename = vim.api.nvim_buf_get_name(0) }
				-- ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
				-- names = vim.tbl_filter(function(name)
				-- 	local linter = lint.linters[name]
				-- 	return linter
				-- 		and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
				-- end, names)

				if #names > 0 then
					lint.try_lint(names)
				end
			end),
		})

		lint.linters_by_ft = {
			python = {
				"flake8",
				-- flake8 = {
				-- 	condition = function(ctx)
				-- 		return dc_utils.setup_cfg_sections().flake8
				-- 	end,
				-- },
			},
		}
	end,
}
