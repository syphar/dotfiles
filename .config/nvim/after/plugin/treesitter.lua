local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

parser_config.soql = {
	install_info = {
		url = "https://github.com/stephanspiegel/tree-sitter-soql",
		branch = "main",
		files = { "src/parser.c" },
	},
	filetype = "soql", -- if filetype does not agrees with parser name
	used_by = { "python" }, -- additional filetypes that use this parser
}

require("nvim-treesitter.configs").setup({
	-- this costs 20ms startup time.
	-- As a replacement I'm doing `TSInstallSync maintained` in my daily update.
	-- ensure_installed = "maintained",
	ignore_install = {},
	-- auto_install = true, -- FIXME: this is broken for me, hilight is not updated after installation
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
		disable = function(_, bufnr)
			-- Disable in large buffers
			return vim.api.nvim_buf_line_count(bufnr) > 50000
		end,
	},
	indent = {
		enable = true,
		disable = {
			"python", -- https://github.com/nvim-treesitter/nvim-treesitter/issues/1573
			"rust", -- https://github.com/nvim-treesitter/nvim-treesitter/issues/1336
		},
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "vv",
			node_incremental = "v",
			-- scope_incremental = "<C-v>",
			node_decremental = "<C-v>",
		},
	},
})

-- automatically install available treesitter parser for files that I open.
-- source: https://github.com/nvim-treesitter/nvim-treesitter/issues/2108
-- builtin auto-install breaks hilight directly after install.
-- https://github.com/nvim-treesitter/nvim-treesitter/pull/3130
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	group = vim.api.nvim_create_augroup("auto_install_treesitter_parsers", {}),
	callback = function()
		local parsers = require("nvim-treesitter.parsers")

		local lang = parsers.get_buf_lang()
		if lang ~= "markdown" and parsers.get_parser_configs()[lang] and not parsers.has_parser(lang) then
			vim.schedule_wrap(function()
				vim.cmd("TSInstallSync " .. lang)
			end)()
		end
	end,
})
