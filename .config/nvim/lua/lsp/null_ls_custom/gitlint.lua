local null_ls = require("null-ls")
local helpers = require("null-ls.helpers")

return {
	method = null_ls.methods.DIAGNOSTICS,
	filetypes = { "gitcommit" },
	generator = helpers.generator_factory({
		command = "gitlint",
		args = { "lint" },
		to_stdin = true,
		format = "line",
		from_stderr = true,
		check_exit_code = { 0, 1 },
		on_output = helpers.diagnostics.from_pattern([[(%d+): (%w+) (.*)]], { "line", "code", "message" }),
	}),
}
