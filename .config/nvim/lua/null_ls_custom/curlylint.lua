local null_ls = require("null-ls")
local helpers = require("null-ls.helpers")

return {
	method = null_ls.methods.DIAGNOSTICS,
	filetypes = { "jinja.html", "htmldjango" },
	generator = helpers.generator_factory({
		command = "curlylint",
		args = {
			-- no logging output
			"--quiet",
			-- read from stdin
			"-",
			-- output in JSON
			"--format",
			"json",
			-- still define filepath so curlylint knows about it
			"--stdin-filepath",
			"$FILENAME",
		},
		to_stdin = true,
		format = "json",
		check_exit_code = function(code)
			return code <= 1
		end,
		on_output = helpers.diagnostics.from_json({
			attributes = {
				row = "line",
				col = "column",
				code = "code",
				message = "message",
			},
		}),
	}),
}
