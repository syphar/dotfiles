local null_ls = require("null-ls")
local helpers = require("null-ls.helpers")

return {
	method = null_ls.methods.FORMATTING,
	name = "sqlfluff_fix",
	filetypes = { "sql" },
	generator = helpers.formatter_factory({
		command = "sqlfluff",
		name = "sqlfluff_fix",
		args = {
			"fix",
			"-",
			"--dialect",
			"postgres",
			"--disable_progress_bar",
			"--force",
		},
		ignore_stderr = true,
		to_stdin = true,
		timeout = 30000, -- 30 seconds
	}),
}
