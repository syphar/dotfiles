vim.cmd([[packadd packer.nvim]])

vim.api.nvim_create_autocmd("BufWritePost", {
	command = "source <afile> | PackerCompile",
	group = vim.api.nvim_create_augroup("Packer", {}),
	pattern = "plugins.lua",
})

return require("packer").startup({
	function(use, use_rocks)
		use("wbthomason/packer.nvim")
		use("lewis6991/impatient.nvim")
		use("antoinemadec/FixCursorHold.nvim")
		use("tpope/vim-projectionist")

		use_rocks("toml")

		use({
			"nvim-lualine/lualine.nvim",
			requires = {
				{ "kyazdani42/nvim-web-devicons" },
			},
		})
		use("drzel/vim-line-no-indicator")

		use("rebelot/kanagawa.nvim")

		-- general plugins
		use("farmergreg/vim-lastplace") --jump to last edited line in files
		use("numToStr/Navigator.nvim") -- jump between vim and tmux splits with C+hjkl
		use("RyanMillerC/better-vim-tmux-resizer") --easily resize vim and tmux panes through meta+hjkl

		use("phaazon/hop.nvim") -- hop to lines or words with shortcuts
		use({ -- small filename-status when using global statusline
			-- "~/src/incline.nvim/",
			"b0o/incline.nvim",
		})
		use("stevearc/dressing.nvim") -- nvim 0.6 interface improvement
		use("beauwilliams/focus.nvim") --auto focus / resize for splits
		use("nvim-treesitter/nvim-treesitter")
		use("nvim-treesitter/playground")
		use("nvim-treesitter/nvim-treesitter-textobjects")
		use(
			-- "~/src/nvim-treesitter-context/"
			"nvim-treesitter/nvim-treesitter-context"
		)
		use("mfussenegger/nvim-treehopper")
		use("tpope/vim-repeat")
		use("RRethy/nvim-treesitter-textsubjects")
		use("rizzatti/dash.vim")

		use({
			"hrsh7th/nvim-cmp",
			requires = {
				"onsails/lspkind-nvim",
				"hrsh7th/cmp-nvim-lua",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-path",
				"saadparwaiz1/cmp_luasnip",
				"ray-x/cmp-treesitter",
				"hrsh7th/cmp-nvim-lsp-signature-help",
			},
		})
		use({
			"tzachar/cmp-tabnine",
			run = "./install.sh",
			requires = "hrsh7th/nvim-cmp",
		})
		use({
			"zbirenbaum/copilot.lua",
			cmd = "Copilot",
			event = "InsertEnter",
			config = function()
				require("copilot").setup({
					suggestion = { enabled = false },
					panel = { enabled = false },
				})
			end,
		})
		use({
			"zbirenbaum/copilot-cmp",
			after = { "copilot.lua" },
			config = function()
				require("copilot_cmp").setup()
			end,
		})
		use({ "Saecki/crates.nvim", requires = { "nvim-lua/plenary.nvim" } })

		-- file management / search
		use("tamago324/lir.nvim") -- file manager
		use("tamago324/lir-git-status.nvim")
		use("airblade/vim-rooter") --automatically set root directory to project directory
		use("ur4ltz/surround.nvim") -- fork of use("blackCauldron7/surround.nvim")
		use("Matt-A-Bennett/vim-surround-funk")
		use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
		use({ "folke/todo-comments.nvim", requires = "nvim-lua/plenary.nvim" })
		use({ "nvim-telescope/telescope.nvim", requires = { { "nvim-lua/plenary.nvim" } } })
		use({ "ThePrimeagen/git-worktree.nvim", requires = { "nvim-telescope/telescope.nvim" } })
		use({
			"nvim-telescope/telescope-live-grep-args.nvim",
			requires = { { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" } },
		})
		use({
			-- "~/src/python-docs.nvim",
			"syphar/python-docs.nvim",
			rocks = { "net-url" },
			requires = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
		})

		-- GIT integration
		use("tpope/vim-fugitive") --git commands
		use("tpope/vim-rhubarb") --fugitive and github integration
		use({ "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" } })
		use({ "akinsho/git-conflict.nvim", tag = "*" })

		-- specific file types
		use({ "pest-parser/pest.vim", filetype = { "pest" } })
		use({ "ellisonleao/glow.nvim", filetype = { "markdown" } })
		use({ "NoahTheDuke/vim-just", filetype = "just" })
		-- use({ "IndianBoy42/tree-sitter-just", filetype = "just" })
		use("Glench/Vim-Jinja2-Syntax")
		use({ "raimon49/requirements.txt.vim", ft = { "requirements" } })
		use({ "rust-lang/rust.vim", ft = { "rust" } })
		use({ "dag/vim-fish", ft = { "fish" } })
		use({ "varnishcache-friends/vim-varnish", ft = { "vcl" } })

		-- generic software dev stuff
		use("rhysd/committia.vim")
		use("L3MON4D3/LuaSnip")
		use("windwp/nvim-autopairs")
		use("RRethy/nvim-treesitter-endwise")
		use("rafcamlet/nvim-luapad")
		use("kyazdani42/nvim-web-devicons")
		use("numToStr/Comment.nvim") --comment/uncomment on gcc
		use("gpanders/editorconfig.nvim") -- read editorconfig and configure vim
		use("direnv/direnv.vim") -- read direnv for vim env
		use("chaoren/vim-wordmotion")
		use({ "Wansmer/treesj", requires = { "nvim-treesitter" } })

		use({ "udalov/kotlin-vim", ft = { "kotlin" } })
		use({ "teal-language/vim-teal", ft = { "teal" } })
		use({ "Vimjas/vim-python-pep8-indent", ft = { "python" } })
		use("5long/pytest-vim-compiler")

		use("j-hui/fidget.nvim")
		use("neovim/nvim-lspconfig")
		use("tamago324/nlsp-settings.nvim")
		use("ray-x/lsp_signature.nvim")
		use({
			-- "~/src/rust-tools.nvim/",
			"simrat39/rust-tools.nvim",
		})
		use("yioneko/nvim-type-fmt")
		use("lvimuser/lsp-inlayhints.nvim")
		use({ "weilbith/nvim-code-action-menu", cmd = "CodeActionMenu" })

		use({
			-- "~/src/null-ls.nvim/",
			"jose-elias-alvarez/null-ls.nvim",
			requires = { "nvim-lua/plenary.nvim" },
		})
		use("lewis6991/spellsitter.nvim")
		use({
			--simple test running
			"janko/vim-test",
			requires = {
				"tpope/vim-dispatch",
				"radenling/vim-dispatch-neovim",
			},
			ft = { "rust", "python" },
		})
	end,
})
