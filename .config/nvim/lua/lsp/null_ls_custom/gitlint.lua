local null_ls = require("null-ls")
local helpers = require("null-ls.helpers")

return {
	method = null_ls.methods.DIAGNOSTICS,
	filetypes = { "gitcommit" },
	name = "gitlint",
	generator = helpers.generator_factory({
		command = "gitlint",
		args = { "--msg-filename", "$FILENAME" },
		to_temp_file = true,
		from_stderr = true,
		to_stdin = true,
		format = "line",
		check_exit_code = { 0, 1 },
		on_output = helpers.diagnostics.from_patterns({
			{
				pattern = [[(%d+): (%w+) (.+)]],
				groups = { "row", "code", "message" },
			},
		}),
	}),
}
