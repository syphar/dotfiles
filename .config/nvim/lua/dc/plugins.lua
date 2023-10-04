return {
	"lewis6991/impatient.nvim",
	"tpope/vim-projectionist",
	"drzel/vim-line-no-indicator",

	-- general plugins
	"farmergreg/vim-lastplace", --jump to last edited line in files
	"tpope/vim-repeat",

	{
		"Saecki/crates.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		ft = { "toml" },
		config = true,
	},

	-- file management / search
	"Matt-A-Bennett/vim-surround-funk",

	-- GIT integration
	"tpope/vim-fugitive", --git commands
	"tpope/vim-rhubarb", --fugitive and github integration
	{ "lewis6991/gitsigns.nvim", dependencies = { "nvim-lua/plenary.nvim" }, config = true },

	-- specific file types
	{ "isobit/vim-caddyfile", ft = "caddyfile" },
	{ "pest-parser/pest.vim", ft = "pest" },
	{ "NoahTheDuke/vim-just", ft = "just" },
	{ "Glench/Vim-Jinja2-Syntax", ft = { "html", "htmldjango", "text", "jinja.html" } },
	{ "rust-lang/rust.vim", ft = "rust" },
	{ "dag/vim-fish", ft = "fish" },
	{ "varnishcache-friends/vim-varnish", ft = "vcl" },

	-- generic software dev stuff
	{ "rhysd/committia.vim", ft = "gitcommit" },
	{
		"windwp/nvim-autopairs",
		opts = {
			map_cr = false,
			map_bs = true,
			map_c_w = false,
			check_ts = true, -- treesitter support
		},
	},
	{ "kyazdani42/nvim-web-devicons", lazy = true },
	"direnv/direnv.vim", -- read direnv for vim env

	{ "udalov/kotlin-vim", ft = { "kotlin" } },
	{ "teal-language/vim-teal", ft = { "teal" } },
	{ "Vimjas/vim-python-pep8-indent", ft = { "python" } },
	{ "LhKipp/nvim-nu", ft = { "nu" }, config = true },
	"5long/pytest-vim-compiler",

	"neovim/nvim-lspconfig",
	{ "ray-x/lsp_signature.nvim", lazy = true },
	{
		-- "~/src/rust-tools.nvim/",
		"simrat39/rust-tools.nvim",
	},
	"yioneko/nvim-type-fmt",

	{
		-- "~/src/null-ls.nvim/",
		"jose-elias-alvarez/null-ls.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
}
