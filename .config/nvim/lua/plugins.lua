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

		use("lewis6991/impatient.nvim")
		use("tweekmonster/startuptime.vim")

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
			end,
		})

		-- status line
		use("itchyny/lightline.vim")
		use("josa42/nvim-lightline-lsp")
		use("drzel/vim-line-no-indicator")

		-- general plugins
		use("zhimsel/vim-stay") --save/restore sessions properly
		use("christoomey/vim-tmux-navigator") --nativate between vim and tmux panes
		use("tmux-plugins/vim-tmux-focus-events")
		use("RyanMillerC/better-vim-tmux-resizer") --easily resize vim and tmux panes through meta+hjkl
		use("terryma/vim-expand-region") -- intelligently expand selection with V / CTRL+V
		use("machakann/vim-highlightedyank") --highlight yanked area
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
							-- the default case_mode is "smart_case"
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
		use({ "cespare/vim-toml", ft = { "toml" } })
		use({ "elzr/vim-json", ft = { "json" } })
		use({ "plasticboy/vim-markdown", ft = { "md", "markdown" } })
		use({
			"raimon49/requirements.txt.vim",
			ft = { "requirements" },
			config = function()
				vim.cmd([[let g:requirements#detect_filename_pattern = '\vrequirement?s\_.*\.(txt|in)$']])
			end,
		})
		use({ "rust-lang/rust.vim", ft = { "rust" } })
		use({
			"simrat39/rust-tools.nvim",
			ft = { "rust" },
			config = function()
				local my_lsp_cfg = require("lsp_config")
				local opts = {
					tools = { -- rust-tools options
						-- automatically set inlay hints (type hints)
						-- There is an issue due to which the hints are not applied on the first
						-- opened file. For now, write to the file to trigger a reapplication of
						-- the hints or just run :RustSetInlayHints.
						-- default: true
						autoSetHints = true,

						-- whether to show hover actions inside the hover window
						-- this overrides the default hover handler
						-- default: true
						hover_with_actions = true,

						runnables = {
							-- whether to use telescope for selection menu or not
							-- default: true
							use_telescope = true,

							-- rest of the opts are forwarded to telescope
						},

						inlay_hints = {
							-- wheter to show parameter hints with the inlay hints or not
							-- default: true
							show_parameter_hints = true,

							-- prefix for parameter hints
							-- default: "<-"
							parameter_hints_prefix = "<-",

							-- prefix for all the other hints (type, chaining)
							-- default: "=>"
							other_hints_prefix = "=>",

							-- whether to align to the lenght of the longest line in the file
							max_len_align = false,

							-- padding from the left if max_len_align is true
							max_len_align_padding = 1,

							-- whether to align to the extreme right or not
							right_align = false,

							-- padding from the right if right_align is true
							right_align_padding = 7,
						},

						hover_actions = {
							-- the border that is used for the hover window
							-- see vim.api.nvim_open_win()
							border = {
								{ "╭", "FloatBorder" },
								{ "─", "FloatBorder" },
								{ "╮", "FloatBorder" },
								{ "│", "FloatBorder" },
								{ "╯", "FloatBorder" },
								{ "─", "FloatBorder" },
								{ "╰", "FloatBorder" },
								{ "│", "FloatBorder" },
							},
						},
					},

					-- all the opts to send to nvim-lspconfig
					-- these override the defaults set by rust-tools.nvim
					-- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
					server = {
						capabilities = my_lsp_cfg.updated_capabilities(),
						on_attach = my_lsp_cfg.lsp_on_attach_without_formatting,
						settings = {
							["rust-analyzer"] = {
								checkOnSave = {
									command = "clippy",
								},
							},
						},
					},
				}
				require("rust-tools").setup(opts)
			end,
		})
		use({ "dag/vim-fish", ft = { "fish" } })

		-- generic software dev stuff
		use("kyazdani42/nvim-web-devicons")
		use({
			"folke/trouble.nvim",
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
		use("tpope/vim-projectionist") --A alternate command to switch between tests and implementation
		use({
			"chaoren/vim-wordmotion",
			config = function()
				vim.cmd(
					"let g:wordmotion_uppercase_spaces = ['.', ',', '(', ')', '[', ']', '{', '}', ' ', '<', '>', ':']"
				)
			end,
		})
		use("vim-scripts/argtextobj.vim")
		use("michaeljsmith/vim-indent-object")

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
			config = function()
				local null_ls = require("null-ls")
				null_ls.config({
					sources = {
						null_ls.builtins.code_actions.gitsigns,
						null_ls.builtins.diagnostics.flake8,
						null_ls.builtins.diagnostics.luacheck,
						null_ls.builtins.diagnostics.shellcheck,
						null_ls.builtins.formatting.black,
						null_ls.builtins.formatting.isort,
						null_ls.builtins.formatting.rustfmt,
						null_ls.builtins.formatting.stylua,
						null_ls.builtins.formatting.trim_whitespace,
            -- null_ls.builtins.formatting.sqlformat,
            null_ls.builtins.diagnostics.selene,
            null_ls.builtins.diagnostics.vint,
            null_ls.builtins.formatting.trim_newlines,
					},
				})
				require("lspconfig")["null-ls"].setup({
					on_attach = require("lsp_config").lsp_on_attach,
				})
			end,
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

		-- Automatically set up your configuration after cloning packer.nvim
		-- Put this at the end after all plugins
		if packer_bootstrap then
			require("packer").sync()
		end
	end,
	config = {
		-- Move to lua dir so impatient.nvim can cache it
		compile_path = vim.fn.stdpath("config") .. "/lua/packer_compiled.lua",
	},
})
