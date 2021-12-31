local null_ls = require("null-ls")
local helpers = require("null-ls.helpers")

return {
	method = null_ls.methods.DIAGNOSTICS,
	name = "sqlfluff_diagnostic",
	filetypes = { "sql" },
	generator = helpers.generator_factory({
		command = "sqlfluff",
		args = {
			"lint",
			"-",
			"--format",
			"json",
			"--dialect",
			"postgres",
			"--disable_progress_bar",
		},
		to_stdin = true,
		from_stderr = false,
		format = "json",
		check_exit_code = { 0, 65 },
		on_output = function(params)
			local parse = helpers.diagnostics.from_json({
				attributes = {
					row = "line_no",
					col = "line_pos",
					code = "code",
					message = "description",
				},
			})

			if params.output then
				for _, file_diagnostics in ipairs(params.output) do
					local violations = file_diagnostics.violations
					params.output = violations
					return parse(params)
				end
			end

			return {}
		end,
	}),
}
