local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap = false
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

return require("packer").startup({
	function(use)
		use("wbthomason/packer.nvim")
		use("lewis6991/impatient.nvim")
		use("tweekmonster/startuptime.vim")
		use({
			"antoinemadec/FixCursorHold.nvim",
			config = function()
				vim.g.cursorhold_updatetime = 1000
			end,
		})
		use({
			"nathom/filetype.nvim",
			config = function()
				require("filetype").setup({
					overrides = {
						extensions = {
							crs = "rust",
						},
						literal = {
							["poetry.lock"] = "toml",
							["Pipfile"] = "toml",
							["Pipfile.lock"] = "json",
							[".envrc"] = "bash",
							[".direnvrc"] = "bash",
							[".env"] = "bash",
						},
						complex = {
							["requirements*.txt"] = "requirements",
							["requirements*.in"] = "requirements",
						},
					},
				})
			end,
		})
		use("tpope/vim-projectionist")

		use({
			"nvim-lualine/lualine.nvim",
			requires = { "kyazdani42/nvim-web-devicons", opt = true },
			config = function()
				local gps = require("nvim-gps")

				local function diff_source()
					-- https://github.com/nvim-lualine/lualine.nvim/wiki/Component-snippets#using-external-source-for-diff
					local gitsigns = vim.b.gitsigns_status_dict
					if gitsigns then
						return {
							added = gitsigns.added,
							modified = gitsigns.changed,
							removed = gitsigns.removed,
						}
					end
				end

				require("lualine").setup({
					options = {
						theme = "github",
						component_separators = "|",
						section_separators = "",
						always_divide_middle = false,
					},
					sections = {
						lualine_a = {
							{
								"mode",
								fmt = function(str)
									-- only show first character of mode
									return str:sub(1, 1)
								end,
							},
						},
						lualine_b = {
							{ "b:gitsigns_head", icon = "" },
							{ "diff", source = diff_source },
							{ "diagnostics", sources = { "nvim_lsp" } },
						},
						lualine_c = {
							{
								"filename",
								path = 1, -- 1 => relativepath
								-- shorting_target = 60,
							},
							{ gps.get_location, cond = gps.is_available },
						},
						lualine_x = {
							{
								"lsp_progress",
								display_components = {
									{ "title", "percentage" },
									"spinner",
								},
								spinner_symbols = {
									"🌑 ",
									"🌒 ",
									"🌓 ",
									"🌔 ",
									"🌕 ",
									"🌖 ",
									"🌗 ",
									"🌘 ",
								},
							},
						},
						lualine_y = {
							{ "filetype", icon_only = false },
						},
						lualine_z = { "progress", "location" },
					},
					inactive_sections = {
						lualine_a = {},
						lualine_b = {},
						lualine_c = { { "filename", path = 1 } },
						lualine_x = {},
						lualine_y = {},
						lualine_z = { "progress", "location" },
					},
					tabline = {},
					extensions = {
						"fugitive",
						"quickfix",
					},
				})
			end,
		})

		use("arkav/lualine-lsp-progress")

		use({
			"projekt0n/github-nvim-theme",
			config = function()
				vim.opt.background = "dark"
				require("github-theme").setup({
					-- theme_style = "light",
					-- theme_style = "dark_default",
					theme_style = "dark",
					transparent = true,
					comment_style = "italic",
					keyword_style = "NONE",
					function_style = "NONE",
					variable_style = "NONE",
				})
				vim.cmd([[hi! link TreesitterContext NormalFloat]])
			end,
		})

		-- general plugins
		use("farmergreg/vim-lastplace") --jump to last edited line in files
		use({ -- jump between vim and tmux splits with C+hjkl
			"numToStr/Navigator.nvim",
			config = function()
				require("Navigator").setup()
			end,
		})
		use("RyanMillerC/better-vim-tmux-resizer") --easily resize vim and tmux panes through meta+hjkl

		use({
			"phaazon/hop.nvim",
			after = "github-nvim-theme", -- so hilight works
			config = function()
				require("hop").setup({})

				local function add_hop(mapping, method, direction)
					local cmd = "<cmd>lua require'hop'."
						.. method
						.. "({ direction = require'hop.hint'.HintDirection."
						.. direction
						.. ", current_line_only = false })<cr>"

					vim.api.nvim_set_keymap("n", mapping, cmd, { noremap = true, silent = false })
				end
				add_hop("<leader>hw", "hint_words", "AFTER_CURSOR")
				add_hop("<leader>hW", "hint_words", "BEFORE_CURSOR")
				add_hop("<leader>hl", "hint_lines_skip_whitespace", "AFTER_CURSOR")
				add_hop("<leader>hL", "hint_lines_skip_whitespace", "BEFORE_CURSOR")
			end,
		})
		use({
			--auto focus / resize for splits
			"beauwilliams/focus.nvim",
			config = function()
				require("focus").setup()
			end,
		})
		use({
			"nvim-treesitter/nvim-treesitter",
			branch = "0.5-compat",
			config = function()
				require("nvim-treesitter.configs").setup({
					ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
					ignore_install = {}, -- List of parsers to ignore installing
					highlight = {
						enable = true, -- false will disable the whole extension
						disable = {}, -- list of language that will be disabled
					},
					textobjects = {
						select = {
							enable = true,

							-- Automatically jump forward to textobj, similar to targets.vim
							lookahead = true,

							keymaps = {
								-- You can use the capture groups defined in textobjects.scm
								["af"] = "@function.outer",
								["if"] = "@function.inner",
								["ac"] = "@class.outer",
								["ic"] = "@class.inner",
								["aa"] = "@parameter.outer",
								["ia"] = "@parameter.inner",
								["ab"] = "@block.outer",
								["ib"] = "@block.inner",
							},
						},
						move = {
							enable = true,
							set_jumps = true,
							goto_next_start = {
								["]m"] = "@function.outer",
								["]b"] = "@block.outer",
								["]]"] = "@class.outer",
							},
							goto_next_end = {
								["]M"] = "@function.outer",
								["]B"] = "@block.outer",
								["]["] = "@class.outer",
							},
							goto_previous_start = {
								["[m"] = "@function.outer",
								["[b"] = "@block.outer",
								["[["] = "@class.outer",
							},
							goto_previous_end = {
								["[M"] = "@function.outer",
								["[B"] = "@block.outer",
								["[]"] = "@class.outer",
							},
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
			end,
		})
		use({ "nvim-treesitter/nvim-treesitter-textobjects", branch = "0.5-compat" })
		use({
			"romgrk/nvim-treesitter-context",
			after = { "github-nvim-theme", "nvim-treesitter" },
			config = function()
				require("treesitter-context.config").setup({
					enable = true,
					throttle = true,
					max_lines = 0,
					patterns = {
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
				vim.cmd([[hi! link TreesitterContext NormalFloat]])
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
		use({
			"SmiteshP/nvim-gps",
			config = function()
				require("nvim-gps").setup({
					icons = {
						["class-name"] = " ",
						["function-name"] = " ",
						["method-name"] = " ",
						["container-name"] = " ",
						["tag-name"] = "» ",
					},
					languages = {},
					separator = " > ",
					depth = 0,
					depth_limit_indicator = "..",
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
				local config_with_preview = {
					layout_config = {
						preview_cutoff = 40,
						prompt_position = "bottom",
					},
				}
				require("telescope").setup({
					defaults = {
						scroll_stratecy = "cycle",
						layout_strategy = "center",
						layout_config = {
							width = 0.6,
							height = 0.5,
							preview_cutoff = 120,
							prompt_position = "bottom",
						},
						theme = "dropdown",
					},
					pickers = {
						tags = config_with_preview,
						treesitter = config_with_preview,
						live_grep = config_with_preview,
						grep_string = config_with_preview,
					},
					extensions = {
						fzf = {
							fuzzy = true, -- false will only do exact matching
							override_generic_sorter = true, -- override the generic sorter
							override_file_sorter = true, -- override the file sorter
							case_mode = "smart_case", -- or "ignore_case" or "respect_case"
						},
						dash = {
							search_engine = "google",
							debounce = 100,
							file_type_keywords = {
								python = { "python3", "django", "sopython" },
							},
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
		})
		use({ "rust-lang/rust.vim", ft = { "rust" } })
		use({ "dag/vim-fish", ft = { "fish" } })

		-- generic software dev stuff
		use("kyazdani42/nvim-web-devicons")
		use({
			"folke/trouble.nvim",
			config = function()
				require("trouble").setup({
					mode = "lsp_workspace_diagnostics",
					-- mode = "lsp_document_diagnostics",
					auto_open = false,
					auto_close = true,
					auto_preview = true,
				})
			end,
		})
		use({
			"mrjones2014/dash.nvim",
			run = "make install",
			after = "telescope.nvim",
		})
		use("rhysd/committia.vim") --Better COMMIT_EDITMSG editing
		use({ --comment/uncomment on gcc
			"numToStr/Comment.nvim",
			config = function()
				require("Comment").setup({
					padding = true,
					ignore = "^$",
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
		use("editorconfig/editorconfig-vim") -- read editorconfig and configure vim
		use("direnv/direnv.vim") -- read direnv for vim env
		use({
			"janko/vim-test", --simple test running
			config = function()
				vim.g["test#strategy"] = "dispatch"
				vim.g["test#preserve_screen"] = 0
				vim.g["test#python#runner"] = "pytest"
			end,
		})
		use({
			"tpope/vim-dispatch",
			config = function()
				vim.g.dispatch_quickfix_height = 20
				vim.g.dispatch_tmux_height = 20
			end,
		})
		use({
			"chaoren/vim-wordmotion",
			config = function()
				-- uppercase spaces would stop the upper case motion (full words)
				-- vim.g.wordmotion_uppercase_spaces = { ".", ",", "(", ")", "[", "]", "{", "}", " ", "<", ">", ":" }
				-- normal spaces would stop the lower-case (x-case subword) motion
				-- let g:wordmotion_spaces = ['\w\@<=-\w\@=', '\.']
			end,
		})

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
			"nvim-lua/lsp_extensions.nvim",
			ft = { "rust" },
			config = function()
				vim.cmd([[
				  augroup update_inlay_hints
					autocmd!
					autocmd InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *.rs :lua require'lsp_config'.show_inlay_hints()
				  augroup end
				]])
			end,
		})

		use({
			"jose-elias-alvarez/null-ls.nvim",
			requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		})

		if packer_bootstrap then
			require("packer").sync()
		end
	end,
	--config = {
	--	-- Move to lua dir so impatient.nvim can cache it
	--	compile_path = vim.fn.stdpath("config") .. "/lua/packer_compiled.lua",
	--},
})
