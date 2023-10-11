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
	-- FIXME: re-add
	-- 	extra_args = function(params)
	-- 		return {
	-- 			"--tabwidth",
	-- 			vim.api.nvim_buf_get_option(params.bufnr, "shiftwidth"),
	-- 			"-",
	-- 		}
	-- 	end,

	return {
		exe = "djhtml",
		args = { "--tabwidth", "2", "-" },
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
			logging = false,
			-- log_level = vim.log.levels.WARN,
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

-- TODO
-- null_ls.builtins.formatting.gofmt,
-- null_ls.builtins.formatting.jq,
-- null_ls.builtins.formatting.ruff.with({
-- 	condition = function(utils)
-- 		return pyproject_toml()["tool.ruff"]
-- 	end,
-- }),
-- null_ls.builtins.formatting.sqlfluff.with({
-- 	extra_args = { "--dialect", "postgres" },
-- 	timeout = 30000,
-- }),
-- null_ls.builtins.formatting.taplo,
-- null_ls.builtins.formatting.terraform_fmt,
-- null_ls.builtins.formatting.xmllint,
