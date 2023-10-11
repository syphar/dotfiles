vim.api.nvim_create_autocmd("BufWritePost", {
	group = vim.api.nvim_create_augroup("format_on_save", { clear = true }),
	callback = function(args)
		-- autoformat for certain file-types
		local ft = vim.api.nvim_buf_get_option(args.buf, "ft")

		if ft == "terraform" or ft == "rust" or ft == "go" or ft == "python" or ft == "caddyfile" or ft == "lua" then
			vim.cmd([[FormatWrite]])
		end
	end,
})

local function djhtml()
	return {
		exe = "djhtml",
		args = { "--tabwidth", vim.api.nvim_buf_get_option(0, "shiftwidth"), "-" },
		stdin = true,
	}
end

return {
	"mhartington/formatter.nvim",
	config = function()
		local util = require("formatter.util")
		local defaults = require("formatter.defaults")
		local dc_utils = require("dc.utils")

		require("formatter").setup({
			logging = true,
			log_level = vim.log.levels.WARN,
			filetype = {
				caddyfile = {
					function()
						return {
							exe = "caddy",
							args = { "fmt", "-" },
							stdin = true,
						}
					end,
				},
				htmldjango = {
					djhtml,
				},
				django = { djhtml },
				["jinja.html"] = {
					djhtml,
				},
				lua = {
					require("formatter.filetypes.lua").stylua,
				},
				go = {
					require("formatter.filetypes.go").gofmt,
				},
				python = {
					function()
						if not dc_utils.pyproject_toml()["tool.black"] then
							return nil
						end
						local black = require("formatter.filetypes.python").black()
						table.insert(black.args, "--fast")
						return black
					end,
					function()
						if not (dc_utils.pyproject_toml()["tool.isort"] or dc_utils.setup_cfg_sections().isort) then
							return nil
						end
						return require("formatter.filetypes.python").isort()
					end,
					function()
						if not dc_utils.pyproject_toml()["tool.ruff"] then
							return nil
						end
						return {
							exe = "ruff",
							args = {
								"--fix",
								"-e",
								"-n",
								"--stdin-filename",
								util.escape_path(util.get_current_buffer_file_path()),
								"-",
							},
							stdin = true,
						}
					end,
				},
				sql = {
					function()
						return {
							exe = "sqlfluff",
							args = {
								"fix",
								"--disable-progress-bar",
								"-f",
								"-n",
								"-",
								"--dialect",
								"postgres",
							},
							stdin = true,
						}
					end,
				},
				toml = {
					require("formatter.filetypes.toml").taplo,
				},
				terraform = {
					require("formatter.filetypes.terraform").terraformfmt,
				},
				xml = {
					function()
						return {
							exe = "xmllint",
							args = { "--format", "-" },
							stdin = true,
						}
					end,
				},
				just = {
					function()
						return {
							exe = "just",
							args = {
								"--fmt",
								"--unstable",
								"-f",
							},
							stdin = false,
						}
					end,
				},
				rust = {
					require("formatter.filetypes.rust").rustfmt,
				},
				markdown = {
					function()
						local denofmt = util.copyf(defaults.denofmt)()
						table.insert(denofmt.args, "--ext")
						table.insert(denofmt.args, "md")
						return denofmt
					end,
					require("formatter.filetypes.any").remove_trailing_whitespace,
				},
				json = {
					require("formatter.filetypes.json").jq,
				},
				yaml = {
					require("formatter.filetypes.any").remove_trailing_whitespace,
				},
				gitcommit = {
					require("formatter.filetypes.any").remove_trailing_whitespace,
				},
				fish = {
					require("formatter.filetypes.fish").fishindent,
				},
				["*"] = {
					require("formatter.filetypes.any").remove_trailing_whitespace,
					function()
						-- TODO: contribute back to formatter.nvim?
						-- taken from null-ls builtin `trim_newlines`
						return {
							command = "awk",
							args = { 'NF{print s $0; s=""; next} {s=s ORS}' },
							to_stdin = true,
						}
					end,
				},
			},
		})
	end,
	keys = {
		{ "<leader>gq", "<cmd>FormatWrite<cr>" },
	},
	cmd = { "Format", "FormatWrite", "FormatLock", "FormatWriteLock" },
}
