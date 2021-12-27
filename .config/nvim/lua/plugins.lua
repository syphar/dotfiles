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
			requires = {
				{ "arkav/lualine-lsp-progress" },
				{ "kyazdani42/nvim-web-devicons", opt = true },
			},
			config = function()
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

				local gps = require("nvim-gps")
				require("lualine").setup({
					options = {
						theme = "kanagawa",
						component_separators = "|",
						section_separators = "",
						always_divide_middle = false,
					},
					sections = {
						lualine_a = {
							{
								"mode",
								fmt = function(str)
									-- only show first character of modeq
									return str:sub(1, 1)
								end,
							},
						},
						lualine_b = {
							{
								"b:gitsigns_head",
								icon = "",
								fmt = function(str)
									if string.len(str) > 20 then
										return string.sub(str, 1, 20) .. "…"
									else
										return str
									end
								end,
							},
							{ "diff", source = diff_source },
							{ "diagnostics", sources = { "nvim_diagnostic" } },
						},
						lualine_c = {
							{
								"filename",
								path = 1, -- 1 => relativepath
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
								-- https://github.com/sindresorhus/cli-spinners
								spinner_symbols = {
									"⠋ ",
									"⠙ ",
									"⠹ ",
									"⠸ ",
									"⠼ ",
									"⠴ ",
									"⠦ ",
									"⠧ ",
									"⠇ ",
									"⠏ ",
								},
								timer = { progress_enddelay = 500, spinner = 80, lsp_client_name_enddelay = 1000 },
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

		use({
			"rebelot/kanagawa.nvim",
			after = "lualine.nvim",
			config = function()
				local default_colors = require("kanagawa.colors")
				require("kanagawa").setup({
					undercurl = true, -- enable undercurls
					commentStyle = "italic",
					functionStyle = "NONE",
					keywordStyle = "bold",
					statementStyle = "bold",
					typeStyle = "NONE",
					variablebuiltinStyle = "italic",
					specialReturn = true,
					specialException = false,
					transparent = true,
					colors = {},
					overrides = {
						-- brighter background for context
						TreesitterContext = { bg = default_colors.bg_light0 },
						NormalFloat = { bg = default_colors.bg_light1 },
					},
				})
				vim.cmd("colorscheme kanagawa")
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
			after = "kanagawa.nvim",
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
				require("focus").setup({ cursorline = false, signcolumn = false })
			end,
		})
		use({
			"nvim-treesitter/nvim-treesitter",
			config = function()
				require("nvim-treesitter.configs").setup({
					ensure_installed = "maintained",
					sync_install = true,
					ignore_install = {},
					playground = {
						enable = true,
						disable = {},
						updatetime = vim.opt.updatetime:get(),
						persist_queries = false,
					},
					highlight = {
						enable = true,
						disable = {},
					},
					-- indent = {
					-- 	enable = true,
					-- },
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
		use("nvim-treesitter/playground")
		use("nvim-treesitter/nvim-treesitter-textobjects")
		use({
			"romgrk/nvim-treesitter-context",
			after = {
				"kanagawa.nvim",
				"nvim-treesitter",
			},
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
			config = function()
				local has_words_before = function()
					local line, col = unpack(vim.api.nvim_win_get_cursor(0))
					return col ~= 0
						and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
				end

				local lspkind = require("lspkind")
				local luasnip = require("luasnip")
				local cmp = require("cmp")
				cmp.setup({
					completion = {
						-- autocomplete through manual debounce, not right now
						-- autocomplete = false,
					},
					snippet = {
						expand = function(args)
							require("luasnip").lsp_expand(args.body)
						end,
					},
					mapping = {
						["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
						["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
						["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
						["<C-y>"] = cmp.config.disable,
						["<C-e>"] = cmp.mapping({
							i = cmp.mapping.abort(),
							c = cmp.mapping.close(),
						}),
						["<CR>"] = cmp.mapping.confirm({ select = true }),
						["<Tab>"] = cmp.mapping(function(fallback)
							if cmp.visible() then
								cmp.select_next_item()
							elseif luasnip.expand_or_jumpable() then
								luasnip.expand_or_jump()
							elseif has_words_before() then
								cmp.complete()
							else
								fallback()
							end
						end, { "i", "s" }),
						["<S-Tab>"] = cmp.mapping(function(fallback)
							if cmp.visible() then
								cmp.select_prev_item()
							elseif luasnip.jumpable(-1) then
								luasnip.jump(-1)
							else
								fallback()
							end
						end, { "i", "s" }),
					},
					sources = cmp.config.sources({
						{ name = "nvim_lua" },
						{ name = "nvim_lsp" },
						{ name = "luasnip" },
						{ name = "cmp_tabnine" },
						{ name = "path" },
						{ name = "treesitter" },
						{ name = "crates" },
						{ name = "jira_issues" },
					}),
					formatting = {
						format = lspkind.cmp_format({
							with_text = true,
							maxwidth = 50,
							menu = {
								nvim_lsp = "[LSP]",
								luasnip = "[LuaSnip]",
								nvim_lua = "[Lua]",
								cmp_tabnine = "[T9]",
								path = "[Path]",
								crates = "[Crates]",
								treesitter = "[TS]",
								jira_issues = "[JIRA]",
							},
						}),
					},
					experimental = {
						native_menu = true,
						ghost_text = true,
					},
				})

				-- vim.cmd([[
				--   augroup CmpDebounceAuGroup
				-- 	au!
				-- 	au TextChangedI * lua require("debounce").debounce()
				--   augroup end
				-- ]])
			end,
		})
		use({
			"tzachar/cmp-tabnine",
			run = "./install.sh",
			requires = "hrsh7th/nvim-cmp",
			config = function()
				local tabnine = require("cmp_tabnine.config")
				tabnine:setup({
					max_lines = 1000,
					max_num_results = 20,
					sort = true,
					run_on_every_keystroke = false,
					snippet_placeholder = "..",
					ignored_file_types = {},
				})
			end,
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
		use({
			"folke/todo-comments.nvim",
			requires = "nvim-lua/plenary.nvim",
			config = function()
				require("todo-comments").setup({})
			end,
		})
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
						git_bcommits = config_with_preview,
						git_branches = config_with_preview,
					},
					extensions = {
						fzf = {
							fuzzy = true, -- false will only do exact matching
							override_generic_sorter = true, -- override the generic sorter
							override_file_sorter = true, -- override the file sorter
							case_mode = "smart_case", -- or "ignore_case" or "respect_case"
						},
					},
				})
				require("telescope").load_extension("fzf")
				require("telescope").load_extension("project")
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
		use({
			"L3MON4D3/LuaSnip",
			config = function()
				require("snippets")
			end,
		})
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
					floating_window = true,
					floating_window_above_cur_line = true,
					fix_pos = false,
					hint_enable = true,
					hint_scheme = "String",
					max_height = 12,
					max_width = 120,
					always_trigger = false,
					zindex = 20,
					timer_interval = 200,
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
