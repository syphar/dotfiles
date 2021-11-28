local null_ls = require("null-ls")
local helpers = require("null-ls.helpers")

return {
	method = null_ls.methods.FORMATTING,
	filetypes = { "jinja.html", "htmldjango" },
	generator = helpers.formatter_factory({
		command = "djhtml",
		args = {
			"--tabwidth",
			"2",
		},
		to_stdin = true,
	}),
}
