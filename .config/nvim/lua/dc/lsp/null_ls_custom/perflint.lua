local null_ls = require("null-ls")
local helpers = require("null-ls.helpers")

return {
	method = null_ls.methods.DIAGNOSTICS,
	name = "perflint",
	filetypes = { "python" },
	generator = helpers.generator_factory({
		command = "perflint",
		name = "perflint",
		args = {
			"--output-format=json",
			"--from-stdin",
			"$FILENAME",
		},
		to_stdin = true,
		from_stderr = false,
		ignore_stderr = true,
		format = "json",
		check_exit_code = { 0, 1, 4 },
		on_output = helpers.diagnostics.from_json({
			attributes = {
				row = "line",
				end_row = "endLine",
				col = "column",
				end_col = "endColumn",
				code = "message-id",
				message = "message",
			},
			offsets = {
				col = 1,
				end_col = 1,
			},
		}),
	}),
}
