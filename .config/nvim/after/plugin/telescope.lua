require("todo-comments").setup({})
local config_with_preview = {
	layout_config = {
		preview_cutoff = 40,
		prompt_position = "bottom",
	},
}
require("telescope").setup({
	defaults = {
		scroll_strategy = "cycle",
		layout_strategy = "center",
		layout_config = {
			width = function(_, max_columns, _)
				return math.min(
					math.max(
						math.floor(max_columns * 0.6), -- 60% width
						80 -- minimum 80 chars
					),
					max_columns - 10 -- padding of 5
				)
			end,
			height = 0.5,
			preview_cutoff = 120,
			prompt_position = "bottom",
		},
		theme = "dropdown",
		dynamic_preview_title = true,
	},
	pickers = {
		tags = config_with_preview,
		treesitter = config_with_preview,
		live_grep = config_with_preview,
		grep_string = config_with_preview,
		git_bcommits = config_with_preview,
		git_branches = config_with_preview,
		lsp_code_actions = config_with_preview,
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

for _, ext in ipairs({ "fzf", "python_docs", "git_worktree" }) do
	require("telescope").load_extension(ext)
end

local entry_display = require("telescope.pickers.entry_display")

-- ctags also showing class etc
-- also only load filtered lines
local telescope_project_tags = function()
	local finders = require("telescope.finders")
	local action_state = require("telescope.actions.state")
	local action_set = require("telescope.actions.set")
	local conf = require("telescope.config").values
	local pickers = require("telescope.pickers")
	local previewers = require("telescope.previewers")
	local Path = require("plenary.path")
	local fzf = require("fzf_lib")

	local displayer = entry_display.create({
		separator = " │ ",
		items = {
			{ width = 1 },
			{ width = 30 },
			{ width = 1 },
			{ width = 20 },
			{ remaining = true },
		},
	})
	local make_display = function(entry)
		return displayer({
			entry.kind,
			entry.tag,
			entry.parent_kind or " ",
			entry.parent_name or " ",
			entry.filename,
			entry.scode,
		})
	end

	local entry_maker = function(line)
		if line == "" or line:sub(1, 1) == "!" then
			return nil
		end

		local tag, file, scode, kind, parent

		tag, file, scode, kind, parent = string.match(line, '([^\t]+)\t([^\t]+)\t/^?\t?(.*)/;"\t(%l?)\t([^\t]+)')
		if not tag then
			tag, file, scode, kind = string.match(line, '([^\t]+)\t([^\t]+)\t/^?\t?(.*)/;"\t(%l?)')
		end

		if kind == "c" then
			kind = "ﴯ"
		elseif kind == "v" then
			kind = ""
		elseif kind == "f" then
			kind = ""
		elseif kind == "m" then
			kind = ""
		end

		local parent_kind = " "
		local parent_name = " "

		if parent then
			local items = vim.split(parent, ":")
			parent_kind = items[1]
			parent_name = items[2]

			if parent_kind == "class" then
				parent_kind = "ﴯ"
			elseif parent_kind == "function" then
				parent_kind = ""
			else
				parent_kind = string.sub(parent_kind, 1, 1)
			end
		end

		-- needed so the pattern can be searched again
		scode = string.gsub(scode, "%[", "\\[")
		scode = string.gsub(scode, "%]", "\\]")

		return {
			ordinal = tag,
			display = make_display,
			scode = scode,
			tag = tag,
			filename = file,
			kind = kind,
			parent_kind = parent_kind,
			parent_name = parent_name,
			col = 1,
			lnum = 1,
		}
	end

	local generate_tag_lines = function(prompt)
		local results = {}
		if string.len(prompt) < 2 then
			return results
		end

		local slab = fzf.allocate_slab()
		local pattern_obj = fzf.parse_pattern(prompt, 0, true)

		for _, ctags_file in ipairs(vim.fn.tagfiles()) do
			for line in Path:new(vim.fn.expand(ctags_file, true)):iter() do
				if fzf.get_pos(line, pattern_obj, slab) then
					table.insert(results, line)
				end
			end
		end

		fzf.free_pattern(pattern_obj)
		fzf.free_slab(slab)

		return results
	end

	local opts = {
		debounce = 200,
	}
	pickers
		.new(opts, {
			prompt_title = "Tags",
			finder = finders.new_dynamic({
				entry_maker = entry_maker,
				fn = generate_tag_lines,
			}),
			previewer = previewers.ctags.new(opts),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function()
				action_set.select:enhance({
					post = function()
						local selection = action_state.get_selected_entry()

						if selection.scode then
							-- un-escape / then escape required
							-- special chars for vim.fn.search()
							-- ] ~ *
							local scode = selection.scode:gsub([[\/]], "/"):gsub("[%]~*]", function(x)
								return "\\" .. x
							end)

							vim.cmd("norm! gg")
							vim.fn.search(scode)
							vim.cmd("norm! zz")
						else
							vim.api.nvim_win_set_cursor(0, { selection.lnum, 0 })
						end
					end,
				})
				return true
			end,
		})
		:find()
end

local telescope_treesitter_tags = function()
	local display_items = {
		{ width = 25 },
		{ width = 10 },
		-- { width = 25 },
		{ remaining = true },
	}

	local displayer = entry_display.create({
		separator = " │ ",
		items = display_items,
	})

	local type_highlight = {
		["associated"] = "TSConstant",
		["constant"] = "TSConstant",
		["field"] = "TSField",
		["function"] = "TSFunction",
		["method"] = "TSMethod",
		["parameter"] = "TSParameter",
		["property"] = "TSProperty",
		["struct"] = "Struct",
		["var"] = "TSVariableBuiltin",
	}

	local make_display = function(entry)
		local display_columns = {
			entry.text,
			{ entry.kind, type_highlight[entry.kind], type_highlight[entry.kind] },
			entry.parent or " ",
		}

		return displayer(display_columns)
	end

	local bufnr = 0 -- find?

	local _node_text_first_line = function(node, buf)
		return vim.split(vim.treesitter.query.get_node_text(node, buf), "\n")[1]
	end

	require("telescope.builtin").treesitter({
		debounce = 100,
		entry_maker = function(entry)
			local ts_utils = require("nvim-treesitter.ts_utils")
			local start_row, start_col, end_row, _ = ts_utils.get_node_range(entry.node)
			local node_text = _node_text_first_line(entry.node, bufnr)

			local node_line = ts_utils.get_node_range(entry.node)

			local parent_name = ""
			local parent = entry.node:parent()
			while parent ~= nil do
				local node_type = parent:type()
				-- TODO: use treesitter-context logic for this? or nvim-gps?
				if
					node_type:find("class")
					-- rust
					or node_type:find("mod_item")
					or node_type:find("struct_item")
					or node_type:find("enum_item")
				then
					local parent_text = _node_text_first_line(parent, bufnr)
					local parent_line = ts_utils.get_node_range(parent)
					if parent_text ~= node_text and node_line ~= parent_line then
						parent_name = parent_text
						break
					end
				end
				parent = parent:parent()
			end

			if entry.kind == "import" or entry.kind == "var" or entry.kind == "parameter" then
				return nil
			end

			return {
				valid = true,

				value = entry.node,
				kind = entry.kind,
				parent = parent_name,
				ordinal = node_text .. " " .. (entry.kind or "unknown"),
				display = make_display,

				node_text = node_text,

				filename = vim.api.nvim_buf_get_name(bufnr),
				lnum = start_row + 1,
				col = start_col,
				text = node_text,
				start = start_row,
				finish = end_row,
			}
		end,
	})
end

vim.keymap.set("n", "<leader>f", telescope_treesitter_tags)
vim.keymap.set("n", "<leader>F", telescope_project_tags)
vim.keymap.set("n", "<leader>m", require("telescope.builtin").buffers)
vim.keymap.set("n", "<leader>ht", require("telescope.builtin").help_tags)
vim.keymap.set("n", "<leader>wt", require("telescope").extensions.git_worktree.git_worktrees)

vim.keymap.set("n", "<leader>rg", function()
	-- require("telescope.builtin").live_grep({ debounce = 100 })
	require("telescope").extensions.live_grep_args.live_grep_args({ debounce = 100 })
end)

vim.keymap.set("n", "<leader>td", "<cmd>TodoTelescope<cr>")

vim.keymap.set("n", "<C-P>", function()
	-- pick from git-files if inside git repository,
	-- otherwise use find_files from CWD
	local is_inside_working_tree = (vim.fn.trim(vim.fn.system("git rev-parse --is-inside-work-tree")) == "true")

	if is_inside_working_tree then
		require("telescope.builtin").git_files({ show_untracked = true })
	else
		require("telescope.builtin").find_files({})
	end
end)
