return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = "VeryLazy",
	config = function()
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

		parser_config.graphql = {
			install_info = {
				url = "https://github.com/bkegley/tree-sitter-graphql",
				branch = "master",
				files = { "src/parser.c" },
			},
			filetype = "graphql",
			used_by = { "rust" },
		}

		-- temporarily override downgrade the rust parser
		parser_config.rust = {
			install_info = {
				url = "https://github.com/tree-sitter/tree-sitter-rust",
				files = { "src/parser.c", "src/scanner.c" },
				tag = "v0.20.4",
			},
			maintainers = { "@amaanq" },
			filetype = { "rust" },
		}

		parser_config.just = {
			install_info = {
				url = "https://github.com/IndianBoy42/tree-sitter-just",
				branch = "main",
				use_makefile = true,
				files = { "src/parser.c", "src/scanner.cc" },
			},
			filetype = "just",
		}

		require("nvim-treesitter.configs").setup({
			ignore_install = { "markdown" },
			auto_install = true,
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
	end,
}
