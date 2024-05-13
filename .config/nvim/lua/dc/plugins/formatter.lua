-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = "*",
--   callback = function(args)
--     require("conform").format({ bufnr = args.buf })
--   end,
-- })

return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>gq",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	opts = {
		formatters_by_ft = {
			caddyfile = { "caddy" },
			htmldjango = { "djhtml" },
			django = { "djhtml" },
			["jinja.html"] = { "djhtml" },
			sql = { "sqlfluff" },
			just = { "just" },
			markdown = { "deno_fmt" },
			json = { "jq" },
			fish = { "fish_indent" },
			["*"] = { "trim_newlines", "trim_whitespace" },
		},
		format_on_save = { timeout_ms = 500, lsp_fallback = true },
		formatters = {
			caddy = {
				command = "caddy",
				args = { "fmt", "-" },
			},
			djhtml = function()
				return {
					command = "djhtml",
					args = { "--tabwidth", vim.api.nvim_buf_get_option(0, "shiftwidth"), "-" },
				}
			end,
			sqlfluff = {
				args = { "fix", "--dialect=postgres", "-" },
			}
		},
	},
	init = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
