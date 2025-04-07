local TIMEOUT = 2000
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>gq",
			function()
				require("conform").format({ async = true, lsp_fallback = true, timeout_ms = TIMEOUT })
			end,
			mode = "",
		},
	},
	opts = {
		formatters_by_ft = {
			caddyfile = { "caddy" },
			css = { "biome", "biome-check" },
			htmldjango = { "djhtml" },
			django = { "djhtml" },
			lua = { "stylua" },
			["jinja.html"] = { "djhtml" },
			sql = { "sqruff" },
			just = { "just" },
			javascript = { "biome", "biome-check", "biome-organize-imports" },
			markdown = { "deno_fmt" },
			json = { "jq" },
			fish = { "fish_indent" },
			proto = { "buf" },
			python = function(bufnr)
				local dc_utils = require("dc.utils")

				if dc_utils.pyproject_toml()["tool.ruff"] then
					return { "ruff_fix", lsp_format = "last" }
				elseif dc_utils.pyproject_toml()["tool.isort"] or dc_utils.setup_cfg_sections().isort then
					return { "ruff_organize_imports", lsp_format = "last" }
				else
					return { lsp_format = "last" }
				end
			end,
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
				or ft == "proto"
				or ft == "javascript"
				or ft == "css"
			then
				return { timeout_ms = TIMEOUT, lsp_format = "last" }
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
			sqruff = {
				command = "sqruff",
				args = { "fix", "--config", "/Users/syphar/.sqruff", "--force", "$FILENAME" },
				stdin = false,
			},
		},
	},
	init = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
