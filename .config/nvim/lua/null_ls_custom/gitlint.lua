local null_ls = require("null-ls")
local helpers = require("null-ls.helpers")

return {
	method = null_ls.methods.DIAGNOSTICS,
	filetypes = { "gitcommit" },
	generator = helpers.generator_factory({
		command = "gitlint",
		args = {},
		to_stdin = true,
		format = "line",
		on_output = helpers.diagnostics.from_pattern([[(%d+): (%w+) (.*)]], { "line", "code", "message" }),
	}),
}
