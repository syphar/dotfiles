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
		use({
			"antoinemadec/FixCursorHold.nvim",
			config = function()
				vim.g.cursorhold_updatetime = vim.opt.updatetime:get()
			end,
		})
		use("nathom/filetype.nvim")
		use("tpope/vim-projectionist")

		use({
			"nvim-lualine/lualine.nvim",
			requires = {
				{ "arkav/lualine-lsp-progress" },
				{ "kyazdani42/nvim-web-devicons" },
			},
		})

		use({ "rebelot/kanagawa.nvim", after = "lualine.nvim" })

		-- general plugins
		use("farmergreg/vim-lastplace") --jump to last edited line in files
		use({ -- jump between vim and tmux splits with C+hjkl
			"numToStr/Navigator.nvim",
			config = function()
				require("Navigator").setup()
			end,
		})
		use("RyanMillerC/better-vim-tmux-resizer") --easily resize vim and tmux panes through meta+hjkl

		use({ "phaazon/hop.nvim", after = "kanagawa.nvim" })
		use({
			--auto focus / resize for splits
			"beauwilliams/focus.nvim",
			config = function()
				require("focus").setup({ cursorline = false, signcolumn = false })
			end,
		})
		use({
			"nvim-treesitter/nvim-treesitter",
		})
		use("nvim-treesitter/playground")
		use("nvim-treesitter/nvim-treesitter-textobjects")
		use({
			"romgrk/nvim-treesitter-context",
			after = {
				"kanagawa.nvim",
				"nvim-treesitter",
			},
		})
		use("RRethy/nvim-treesitter-textsubjects")
		use("SmiteshP/nvim-gps")

		use({
			"hrsh7th/nvim-cmp",
			after = "LuaSnip",
			requires = {
				"onsails/lspkind-nvim",
				"hrsh7th/cmp-nvim-lua",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-path",
				"saadparwaiz1/cmp_luasnip",
				"ray-x/cmp-treesitter",
			},
		})
		use({
			"tzachar/cmp-tabnine",
			run = "./install.sh",
			requires = "hrsh7th/nvim-cmp",
		})

		use({
			"Saecki/crates.nvim",
			requires = { "nvim-lua/plenary.nvim" },
			config = function()
				require("crates").setup({})
			end,
		})

		-- file management / search
		use("tpope/vim-vinegar") --simple 'dig through current folder'  on the - key
		use("airblade/vim-rooter") --automatically set root directory to project directory
		use({
			"blackCauldron7/surround.nvim",
			config = function()
				require("surround").setup({ mappings_style = "sandwich" })
			end,
		})
		use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
		use("nvim-telescope/telescope-project.nvim")
		use({ "folke/todo-comments.nvim", requires = "nvim-lua/plenary.nvim" })
		use({ "nvim-telescope/telescope.nvim", requires = { { "nvim-lua/plenary.nvim" } } })

		-- GIT integration
		use("tpope/vim-fugitive") --git commands
		use("tpope/vim-rhubarb") --fugitive and github integration
		use({
			"lewis6991/gitsigns.nvim",
			requires = { "nvim-lua/plenary.nvim" },
			config = function()
				require("gitsigns").setup()
			end,
		})

		-- specific file types
		use({ "ellisonleao/glow.nvim", filetype = { "markdown" } })
		use("Glench/Vim-Jinja2-Syntax")
		use({
			"raimon49/requirements.txt.vim",
			ft = { "requirements" },
		})
		use({ "rust-lang/rust.vim", ft = { "rust" } })
		use({ "dag/vim-fish", ft = { "fish" } })

		-- generic software dev stuff
		use({ -- auto-update global tag-file on save
			"ludovicchabant/vim-gutentags",
			config = function()
				vim.g.gutentags_file_list_command = "fd . --type f"
			end,
		})
		use("L3MON4D3/LuaSnip")
		use({
			"rafamadriz/friendly-snippets",
			requires = { "L3MON4D3/LuaSnip" },
		})
		use({
			"windwp/nvim-autopairs",
			config = function()
				local npairs = require("nvim-autopairs")
				npairs.setup({
					map_cr = false,
					map_bs = true,
					map_c_w = false,
					check_ts = true, -- treesitter support
				})
			end,
		})
		use("rafcamlet/nvim-luapad")
		use("kyazdani42/nvim-web-devicons")
		use({ --comment/uncomment on gcc
			"numToStr/Comment.nvim",
			config = function()
				require("Comment").setup({
					padding = true,
					ignore = "^$", -- ignore empty lines
					mappings = {
						---operator-pending mapping
						---Includes `gcc`, `gcb`, `gc[count]{motion}` and `gb[count]{motion}`
						basic = true,
						---extra mapping
						---Includes `gco`, `gcO`, `gcA`
						extra = true,
						---extended mapping
						---Includes `g>`, `g<`, `g>[count]{motion}` and `g<[count]{motion}`
						extended = true,
					},
				})
			end,
		})
		use("gpanders/editorconfig.nvim") -- read editorconfig and configure vim
		use("direnv/direnv.vim") -- read direnv for vim env
		use({
			"chaoren/vim-wordmotion",
			config = function()
				-- uppercase spaces would stop the upper case motion (full words)
				vim.g.wordmotion_uppercase_spaces = { ".", ",", "(", ")", "[", "]", "{", "}", " ", "<", ">", ":" }
				-- normal spaces would stop the lower-case (x-case subword) motion
				-- let g:wordmotion_spaces = ['\w\@<=-\w\@=', '\.']
			end,
		})

		use({
			"Vimjas/vim-python-pep8-indent",
			ft = { "python" },
		})
		use("5long/pytest-vim-compiler")

		use("neovim/nvim-lspconfig")
		use({
			"ray-x/lsp_signature.nvim",
			config = function()
				require("lsp_signature").setup({
					bind = true,
					doc_lines = 0,
					floating_window = false,
					floating_window_above_cur_line = true,
					fix_pos = false,
					hint_enable = true,
					hint_scheme = "String",
					max_height = 12,
					max_width = 120,
					always_trigger = false,
					zindex = 20,
					timer_interval = 200,
					transparency = 50,
				})
			end,
		})
		use({ "nvim-lua/lsp_extensions.nvim", ft = { "rust" } })

		use({
			"jose-elias-alvarez/null-ls.nvim",
			requires = { "nvim-lua/plenary.nvim" },
		})
	end,
})
