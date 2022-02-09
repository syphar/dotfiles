vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

return require("packer").startup({
	function(use)
		use("wbthomason/packer.nvim")
		use("lewis6991/impatient.nvim")
		use("tweekmonster/startuptime.vim")
		use("antoinemadec/FixCursorHold.nvim")
		use("nathom/filetype.nvim")
		use("tpope/vim-projectionist")

		use({
			"nvim-lualine/lualine.nvim",
			requires = {
				{ "kyazdani42/nvim-web-devicons" },
			},
		})
		use("drzel/vim-line-no-indicator")

		use("rebelot/kanagawa.nvim")

		use("chentau/marks.nvim")

		-- general plugins
		use("farmergreg/vim-lastplace") --jump to last edited line in files
		use("numToStr/Navigator.nvim") -- jump between vim and tmux splits with C+hjkl
		use("RyanMillerC/better-vim-tmux-resizer") --easily resize vim and tmux panes through meta+hjkl

		use("phaazon/hop.nvim")
		use("stevearc/dressing.nvim") -- nvim 0.6 interface improvement
		use("beauwilliams/focus.nvim") --auto focus / resize for splits
		use("sunjon/shade.nvim") -- dim inactive windows
		use("nvim-treesitter/nvim-treesitter")
		use("nvim-treesitter/playground")
		use("nvim-treesitter/nvim-treesitter-textobjects")
		use({
			"~/src/nvim-treesitter-context",
			-- "romgrk/nvim-treesitter-context"
		})
		use("RRethy/nvim-treesitter-textsubjects")

		use({
			"hrsh7th/nvim-cmp",
			requires = {
				"onsails/lspkind-nvim",
				"hrsh7th/cmp-nvim-lua",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-emoji",
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

		use({ "Saecki/crates.nvim", requires = { "nvim-lua/plenary.nvim" } })

		-- file management / search
		use("tpope/vim-vinegar") --simple 'dig through current folder'  on the - key
		use("airblade/vim-rooter") --automatically set root directory to project directory
		use("blackCauldron7/surround.nvim")
		use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
		use({ "folke/todo-comments.nvim", requires = "nvim-lua/plenary.nvim" })
		use({ "nvim-telescope/telescope.nvim", requires = { { "nvim-lua/plenary.nvim" } } })

		-- GIT integration
		use("tpope/vim-fugitive") --git commands
		use("tpope/vim-rhubarb") --fugitive and github integration
		use({ "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" } })

		-- specific file types
		use({ "pest-parser/pest.vim", filetype = { "pest" } })
		use({ "ellisonleao/glow.nvim", filetype = { "markdown" } })
		use("Glench/Vim-Jinja2-Syntax")
		use({ "raimon49/requirements.txt.vim", ft = { "requirements" } })
		use({ "rust-lang/rust.vim", ft = { "rust" } })
		use({ "dag/vim-fish", ft = { "fish" } })

		-- generic software dev stuff
		use("rhysd/committia.vim")
		use("L3MON4D3/LuaSnip")
		use({ "rafamadriz/friendly-snippets", requires = { "L3MON4D3/LuaSnip" } })
		use("windwp/nvim-autopairs")
		use("RRethy/nvim-treesitter-endwise")
		use("rafcamlet/nvim-luapad")
		use("kyazdani42/nvim-web-devicons")
		use("numToStr/Comment.nvim") --comment/uncomment on gcc
		use("gpanders/editorconfig.nvim") -- read editorconfig and configure vim
		use("direnv/direnv.vim") -- read direnv for vim env
		use("chaoren/vim-wordmotion")

		use({ "teal-language/vim-teal", ft = { "teal" } })
		use({ "Vimjas/vim-python-pep8-indent", ft = { "python" } })
		use("5long/pytest-vim-compiler")

		use("j-hui/fidget.nvim")
		use("neovim/nvim-lspconfig")
		use({ "nvim-lua/lsp_extensions.nvim", ft = { "rust" } })

		use({
			-- "~/src/null-ls.nvim/",
			"jose-elias-alvarez/null-ls.nvim",
			requires = { "nvim-lua/plenary.nvim" },
		})
		use("jvgrootveld/telescope-zoxide")
		use("lewis6991/spellsitter.nvim")
		use({ --simple test running
			"janko/vim-test",
			requires = {
				"tpope/vim-dispatch",
				"radenling/vim-dispatch-neovim",
			},
			ft = { "rust", "python" },
		})
	end,
})
