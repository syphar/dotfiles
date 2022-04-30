require("nvim-treesitter.configs").setup({
	-- this costs 20ms startup time.
	-- As a replacement I'm doing `TSInstallSync maintained` in my daily update.
	-- ensure_installed = "maintained",
	ignore_install = {},
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
