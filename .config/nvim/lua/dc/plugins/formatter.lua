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
		},
	},
	opts = {
		formatters_by_ft = {
			caddyfile = { "caddy" },
			htmldjango = { "djhtml" },
			django = { "djhtml" },
			lua = { "stylua" },
			["jinja.html"] = { "djhtml" },
			sql = { "sqlfluff" },
			just = { "just" },
			markdown = { "deno_fmt" },
			json = { "jq" },
			fish = { "fish_indent" },
			proto = { "buf" },
			["*"] = { "trim_newlines", "trim_whitespace" },
		},
		format_on_save = function(bufnr)
			local ft = vim.api.nvim_buf_get_option(bufnr, "ft")

			if
				ft == "rust"
				or ft == "python"
				or ft == "terraform"
				or ft == "go"
				or ft == "caddyfile"
				or ft == "lua"
			then
				return { timeout_ms = 500, lsp_fallback = true }
			end
		end,
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
			},
		},
	},
	init = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
