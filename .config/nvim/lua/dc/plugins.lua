return {
	"wbthomason/packer.nvim",
	"lewis6991/impatient.nvim",
	"tpope/vim-projectionist",
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			{ "kyazdani42/nvim-web-devicons" },
		},
	},
	"drzel/vim-line-no-indicator",

	{ "rebelot/kanagawa.nvim",           config = nil },

	-- general plugins
	"farmergreg/vim-lastplace",         --jump to last edited line in files
	"numToStr/Navigator.nvim",          -- jump between vim and tmux splits with C+hjkl
	"RyanMillerC/better-vim-tmux-resizer", --easily resize vim and tmux panes through meta+hjkl

	"folke/flash.nvim",                 -- hop to lines or words with shortcuts
	{                                   -- small filename-status when using global statusline
		-- "~/src/incline.nvim/",
		"b0o/incline.nvim",
	},
	"stevearc/dressing.nvim", -- nvim 0.6 interface improvement
	"nvim-focus/focus.nvim", --auto focus / resize for splits
	{ "nvim-treesitter/nvim-treesitter", config = nil },
	"nvim-treesitter/playground",
	"nvim-treesitter/nvim-treesitter-textobjects",
	{
		-- "~/src/nvim-treesitter-context/"
		"nvim-treesitter/nvim-treesitter-context",
	},
	"tpope/vim-repeat",
	"rizzatti/dash.vim",

	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"onsails/lspkind-nvim",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"saadparwaiz1/cmp_luasnip",
			"ray-x/cmp-treesitter",
		},
	},
	{
		"tzachar/cmp-tabnine",
		build = "./install.sh",
		dependencies = "hrsh7th/nvim-cmp",
	},
	{
		"zbirenbaum/copilot.lua",
		-- cmd = "Copilot",
		-- event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = { enabled = false },
				panel = { enabled = false },
			})
		end,
	},
	{ "Saecki/crates.nvim",                       dependencies = { "nvim-lua/plenary.nvim" } },

	-- file management / search
	"tamago324/lir.nvim", -- file manager
	"tamago324/lir-git-status.nvim",
	"airblade/vim-rooter", --automatically set root directory to project directory
	"ur4ltz/surround.nvim", -- fork of "blackCauldron7/surround.nvim",
	"Matt-A-Bennett/vim-surround-funk",
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	{ "folke/todo-comments.nvim",                 dependencies = "nvim-lua/plenary.nvim" },
	{ "nvim-telescope/telescope.nvim",            dependencies = { { "nvim-lua/plenary.nvim" } } },
	{ "ThePrimeagen/git-worktree.nvim",           dependencies = { "nvim-telescope/telescope.nvim" } },
	{
		"nvim-telescope/telescope-live-grep-args.nvim",
		dependencies = { { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" } },
	},
	{
		"syphar/python-docs.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
	},

	-- GIT integration
	"tpope/vim-fugitive", --git commands
	"tpope/vim-rhubarb", --fugitive and github integration
	{ "lewis6991/gitsigns.nvim",  dependencies = { "nvim-lua/plenary.nvim" } },
	{ "akinsho/git-conflict.nvim" },

	-- specific file types
	{ "isobit/vim-caddyfile",     filetype = "caddyfile" },
	{ "pest-parser/pest.vim",     filetype = { "pest" } },
	{ "NoahTheDuke/vim-just",     filetype = "just" },
	"Glench/Vim-Jinja2-Syntax",
	-- FIXME: re-add with better filetype detection
	-- { "raimon49/requirements.txt.vim",    ft = { "requirements" } },
	{ "rust-lang/rust.vim",               ft = { "rust" } },
	{ "dag/vim-fish",                     ft = { "fish" } },
	{ "varnishcache-friends/vim-varnish", ft = { "vcl" } },

	-- generic software dev stuff
	"rhysd/committia.vim",
	"L3MON4D3/LuaSnip",
	"windwp/nvim-autopairs",
	"RRethy/nvim-treesitter-endwise",
	"rafcamlet/nvim-luapad",
	"kyazdani42/nvim-web-devicons",
	"numToStr/Comment.nvim", --comment/uncomment on gcc
	"direnv/direnv.vim",  -- read direnv for vim env
	"chaoren/vim-wordmotion",

	{ "udalov/kotlin-vim",             ft = { "kotlin" } },
	{ "teal-language/vim-teal",        ft = { "teal" } },
	{ "Vimjas/vim-python-pep8-indent", ft = { "python" } },
	"LhKipp/nvim-nu",
	"5long/pytest-vim-compiler",

	{ "j-hui/fidget.nvim", tag = "legacy" },
	"neovim/nvim-lspconfig",
	"ray-x/lsp_signature.nvim",
	{
		-- "~/src/rust-tools.nvim/",
		"simrat39/rust-tools.nvim",
	},
	"yioneko/nvim-type-fmt",
	"lvimuser/lsp-inlayhints.nvim",

	{
		-- "~/src/null-ls.nvim/",
		"jose-elias-alvarez/null-ls.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		--simple test running
		"janko/vim-test",
		dependencies = {
			"tpope/vim-dispatch",
			"radenling/vim-dispatch-neovim",
		},
		ft = { "rust", "python" },
	},
}
