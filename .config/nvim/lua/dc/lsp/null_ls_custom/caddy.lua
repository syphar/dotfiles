local null_ls = require("null-ls")
local helpers = require("null-ls.helpers")

return {
	method = null_ls.methods.FORMATTING,
	name = "caddy",
	filetypes = { "caddyfile" },
	generator = helpers.formatter_factory({
		command = "caddy",
		name = "caddy",
		args = {
			"fmt",
			"-",
		},
		to_stdin = true,
	}),
}
