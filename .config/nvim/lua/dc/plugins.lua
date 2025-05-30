return {
	"tpope/vim-projectionist",
	"tpope/vim-unimpaired",

	-- general plugins
	{ --jump to last edited line in files
		"farmergreg/vim-lastplace",
		event = { "BufRead", "BufWinEnter" },
	},
	{ "tpope/vim-repeat",                 event = "VeryLazy" },

	{
		"Saecki/crates.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = { "BufRead Cargo.toml" },
		config = true,
	},

	-- specific file types
	{ "isobit/vim-caddyfile",             ft = "caddyfile" },
	{ "pest-parser/pest.vim",             ft = "pest" },
	{ "NoahTheDuke/vim-just",             ft = "just" },
	{ "rust-lang/rust.vim",               ft = "rust" },
	{ "dag/vim-fish",                     ft = "fish" },
	{ "varnishcache-friends/vim-varnish", ft = "vcl" },

	-- generic software dev stuff
	{ "rhysd/committia.vim",              ft = "gitcommit" },
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {
			map_cr = false,
			map_bs = true,
			map_c_w = false,
			check_ts = true, -- treesitter support
		},
	},
	{
		"nvim-tree/nvim-web-devicons",
		lazy = true,
	},
	{ -- read direnv for vim env
		"direnv/direnv.vim",
		event = "VeryLazy",
	},

	{ "udalov/kotlin-vim",             ft = { "kotlin" } },
	{ "teal-language/vim-teal",        ft = { "teal" } },
	{ "Vimjas/vim-python-pep8-indent", ft = { "python" } },
	{ "LhKipp/nvim-nu",                ft = { "nu" },    build = ":TSInstall nu", opts = { use_lsp_features = false } },

	{ "neovim/nvim-lspconfig",         lazy = true },
	{ "ray-x/lsp_signature.nvim",      lazy = true },
	{ "yioneko/nvim-type-fmt",         lazy = true },
}
