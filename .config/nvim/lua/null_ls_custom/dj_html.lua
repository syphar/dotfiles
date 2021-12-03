local null_ls = require("null-ls")
local helpers = require("null-ls.helpers")

return {
	method = null_ls.methods.FORMATTING,
	filetypes = { "jinja.html", "htmldjango" },
	generator = helpers.formatter_factory({
		command = "djhtml",
		args = function(params)
			return {
				"--tabwidth",
				vim.api.nvim_buf_get_option(params.bufnr, "shiftwidth"),
			}
		end,
		to_stdin = true,
	}),
}
