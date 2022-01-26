require("nvim-treesitter.configs").setup({
	-- this costs 20ms startup time.
	-- As a replacement I'm doing `TSInstallSync maintained` in my daily update.
	-- ensure_installed = "maintained",
	ignore_install = {},
	playground = {
		enable = true,
		disable = {},
		updatetime = vim.opt.updatetime:get(),
		persist_queries = true,
	},
	query_linter = {
		enable = true,
		use_virtual_text = true,
		lint_events = { "BufWrite", "CursorHold", "CursorHoldI" },
	},
	highlight = {
		enable = true,
		disable = {},
		additional_vim_regex_highlighting = false,
	},
	indent = {
		enable = true,
		disable = {
			"python", -- https://github.com/nvim-treesitter/nvim-treesitter/issues/1573
			"rust", -- https://github.com/nvim-treesitter/nvim-treesitter/issues/1336
		},
	},
	textobjects = {
		select = {
			enable = true,

			-- Automatically jump forward to textobj, similar to targets.vim
			lookahead = true,

			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["am"] = "@function.outer",
				["im"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",
				["ab"] = "@block.outer",
				["ib"] = "@block.inner",
			},
		},
		move = {
			enable = true,
			set_jumps = true,
			goto_next_start = {
				["]m"] = "@function.outer",
				["]b"] = "@block.outer",
				["]]"] = "@class.outer",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]B"] = "@block.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[b"] = "@block.outer",
				["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[B"] = "@block.outer",
				["[]"] = "@class.outer",
			},
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
	textsubjects = {
		enable = true,
		keymaps = {
			["."] = "textsubjects-smart",
			[";"] = "textsubjects-container-outer",
		},
	},
})

require("treesitter-context.config").setup({
	enable = true,
	throttle = true,
	max_lines = 0,
	patterns = {
		default = {
			"class",
			"function",
			"method",
			"for",
			"while",
			"if",
			"else",
			"switch",
			"case",
		},
		rust = {
			"impl_item",
			"mod_item",
			"match",
			"struct",
			"loop",
			"closure",
			"async_block",
		},
		python = {
			"elif",
			"with",
			"try", 
			"except",
		},
		json = {
			"object",
			"pair",
		},
		yaml = {
			"block_mapping_pair",
			"block_sequence_item",
		},
		toml = {
			"table",
			"pair",
		},
	},
})
