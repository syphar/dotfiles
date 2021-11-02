local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
end

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

-- Only required if you have packer configured as `opt`
vim.cmd([[packadd packer.nvim]])

return require("packer").startup({
	function()
		-- Packer can manage itself
		use("wbthomason/packer.nvim")

		use({
			"projekt0n/github-nvim-theme",
			config = function()
				require("github-theme").setup({
					theme_style = "light",
					transparent = true,
					comment_style = "italic",
					keyword_style = "bold",
					function_style = "NONE",
					variable_style = "NONE",
				})
				vim.cmd([[hi! link TreesitterContext Folded]])
			end,
		})

		-- status line
		use("itchyny/lightline.vim")
		use("josa42/nvim-lightline-lsp")

		-- general plugins
		use("zhimsel/vim-stay") --save/restore sessions properly
		use("christoomey/vim-tmux-navigator") --nativate between vim and tmux panes
		use("tmux-plugins/vim-tmux-focus-events")
		use("RyanMillerC/better-vim-tmux-resizer") --easily resize vim and tmux panes through meta+hjkl
		use("terryma/vim-expand-region") -- intelligently expand selection with V / CTRL+V
		use({
			--auto focus / resize for splits
			"beauwilliams/focus.nvim",
			config = function()
				require("focus").setup()
			end,
		})
		use({
			"nvim-treesitter/nvim-treesitter",
			config = function()
				require("nvim-treesitter.configs").setup({
					ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
					ignore_install = {}, -- List of parsers to ignore installing
					highlight = {
						enable = true, -- false will disable the whole extension
						disable = {}, -- list of language that will be disabled
					},
				})
			end,
		})
		use({
			--show context based on treesitter
			"romgrk/nvim-treesitter-context",
			config = function()
				require("treesitter-context.config").setup({
					enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
					throttle = true, -- Throttles plugin updates (may improve performance)
					max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
					patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
						-- For all filetypes
						-- Note that setting an entry here replaces all other patterns for this entry.
						-- By setting the 'default' entry below, you can control which nodes you want to
						-- appear in the context window.
						default = {
							"class",
							"function",
							"method",
							"for",
							"while",
							"if",
							"switch",
							"case",
						},
						rust = {
							"impl_item",
						},
					},
				})
				vim.cmd([[hi! link TreesitterContext Folded]])
			end,
		})
		use({
			"RRethy/nvim-treesitter-textsubjects",
			config = function()
				require("nvim-treesitter.configs").setup({
					textsubjects = {
						enable = true,
						keymaps = {
							["."] = "textsubjects-smart",
							[";"] = "textsubjects-container-outer",
						},
					},
				})
			end,
		})

		-- file management / search
		use("tpope/vim-vinegar") --simple 'dig through current folder'  on the - key
		use("airblade/vim-rooter") --automatically set root directory to project directory
		use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
		use({
			"nvim-telescope/telescope.nvim",
			requires = { { "nvim-lua/plenary.nvim" } },
			config = function()
				require("telescope").setup({
					extensions = {
						fzf = {
							fuzzy = true, -- false will only do exact matching
							override_generic_sorter = true, -- override the generic sorter
							override_file_sorter = true, -- override the file sorter
							case_mode = "smart_case", -- or "ignore_case" or "respect_case"
						},
					},
				})
				-- To get fzf loaded and working with telescope, you need to call
				-- load_extension, somewhere after setup function:
				require("telescope").load_extension("fzf")
			end,
		})

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
		use({ "plasticboy/vim-markdown", ft = { "md", "markdown" } })
		use({
			"raimon49/requirements.txt.vim",
			ft = { "requirements" },
			config = function()
				vim.cmd([[let g:requirements#detect_filename_pattern = '\vrequirement?s\_.*\.(txt|in)$']])
			end,
		})
		use({ "rust-lang/rust.vim", ft = { "rust" } })
		use({ "dag/vim-fish", ft = { "fish" } })

		-- generic software dev stuff
		use("kyazdani42/nvim-web-devicons")
		use({
			"folke/trouble.nvim",
			cmd = {
				"Trouble",
				"TroubleClose",
				"TroubleToggle",
				"TroubleRefresh",
			},
			config = function()
				require("trouble").setup({
					mode = "lsp_document_diagnostics",
				})
			end,
		})
		use("rizzatti/dash.vim")
		use("rhysd/committia.vim") --Better COMMIT_EDITMSG editing
		use("tpope/vim-commentary") --comment/uncomment on gcc
		use("editorconfig/editorconfig-vim") -- read editorconfig and configure vim
		use("direnv/direnv.vim") -- read direnv for vim env
		use({
			"janko/vim-test", --simple test running
			config = function()
				vim.cmd([[let g:test#strategy = "dispatch"]])
				vim.cmd([[let g:test#preserve_screen = 0]])
				vim.cmd([[let g:test#python#runner = 'pytest']])
			end,
		})
		use({
			"tpope/vim-dispatch",
			config = function()
				vim.cmd([[let g:dispatch_quickfix_height = 20]])
				vim.cmd([[let g:dispatch_tmux_height = 20]])
			end,
		})
		use({
			"chaoren/vim-wordmotion",
			config = function()
				vim.cmd(
					"let g:wordmotion_uppercase_spaces = ['.', ',', '(', ')', '[', ']', '{', '}', ' ', '<', '>', ':']"
				)
			end,
		})
		use("vim-scripts/argtextobj.vim")

		-- python stuff
		use({
			"Vimjas/vim-python-pep8-indent",
			ft = { "python" },
		})
		use({
			"jeetsukumaran/vim-pythonsense",
			ft = { "python" },
		})
		use({
			"5long/pytest-vim-compiler",
			ft = { "python" },
		})

		use("neovim/nvim-lspconfig")
		use("ray-x/lsp_signature.nvim")

		use({
			"jose-elias-alvarez/null-ls.nvim",
			requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		})

		use({
			"hrsh7th/nvim-cmp",
			requires = {
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-calc",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-nvim-lua",
				"hrsh7th/cmp-path",
				"octaltree/cmp-look",
			},
		})

		use({
			"tzachar/cmp-tabnine",
			run = "./install.sh",
			requires = "hrsh7th/nvim-cmp",
			event = "InsertEnter",
			config = function()
				require("cmp_tabnine.config"):setup({
					max_lines = 1000,
					max_num_results = 6,
					priority = 10,
					sort = false,
					run_on_every_keystroke = true,
				})
			end,
		})
	end,
})
