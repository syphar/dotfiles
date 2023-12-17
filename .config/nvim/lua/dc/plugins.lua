return {
	"lewis6991/impatient.nvim",
	"tpope/vim-projectionist",
	"tpope/vim-unimpaired",

	-- general plugins
	{ --jump to last edited line in files
		"farmergreg/vim-lastplace",
		event = { "BufRead", "BufWinEnter" },
	},
	{ "tpope/vim-repeat", event = "VeryLazy" },

	{
		"Saecki/crates.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		ft = { "toml" },
		config = true,
	},

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
		event = "InsertEnter",
		opts = {
			map_cr = false,
			map_bs = true,
			map_c_w = false,
			check_ts = true, -- treesitter support
		},
	},
	{ "kyazdani42/nvim-web-devicons", lazy = true },
	{ -- read direnv for vim env
		"direnv/direnv.vim",
		event = "VeryLazy",
	},

	{ "udalov/kotlin-vim", ft = { "kotlin" } },
	{ "teal-language/vim-teal", ft = { "teal" } },
	{ "Vimjas/vim-python-pep8-indent", ft = { "python" } },
	{ "LhKipp/nvim-nu", ft = { "nu" }, build = ":TSInstall nu", opts = { use_lsp_features = false } },
	{
		"5long/pytest-vim-compiler",
		ft = { "python" },
		config = function()
			vim.cmd([[
				if executable('pytest')
					compiler pytest
					" nmap <leader>ts :make<CR>
					" nmap <leader>tf :make %<CR>
				endif
			]])
		end,
	},

	{ "neovim/nvim-lspconfig", lazy = true },
	{ "ray-x/lsp_signature.nvim", lazy = true },
	{
		-- "~/src/rust-tools.nvim/",
		"simrat39/rust-tools.nvim",
		lazy = true,
	},
	{ "yioneko/nvim-type-fmt", lazy = true },
	{
		"Canop/nvim-bacon",
		opts = {
			quickfix = {
				enabled = true,
				event_trigger = true,
			},
		},
		cmd = { "BaconLoad", "BaconShow", "BaconList", "BaconPrevious", "BaconNext" },
		keys = {
			{
				"<leader>bl",
				function()
					vim.cmd("BaconLoad")
					vim.cmd("botright copen")
				end,
				"n",
			},
		},
	},
}
