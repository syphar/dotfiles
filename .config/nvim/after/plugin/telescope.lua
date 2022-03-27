require("todo-comments").setup({})

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
require("telescope").load_extension("fzf")

local entry_display = require("telescope.pickers.entry_display")
local utils = require("telescope.utils")

-- ctags also showing class etc
_G.telescope_project_tags = function()
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
	require("telescope.builtin").tags({
		debounce = 100,
		entry_maker = function(line)
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
		end,
	})
end

_G.telescope_treesitter_tags = function()
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

	require("telescope.builtin").treesitter({
		debounce = 100,
		entry_maker = function(entry)
			local ts_utils = require("nvim-treesitter.ts_utils")
			local start_row, start_col, end_row, _ = ts_utils.get_node_range(entry.node)
			local node_text = ts_utils.get_node_text(entry.node, bufnr)[1]

			local node_line = ts_utils.get_node_range(entry.node)

			local parent_name = ""
			local parent = entry.node:parent()
			while parent ~= nil do
				-- TODO: reuse ts context for parent finding?
				local parent_text = ts_utils.get_node_text(parent, bufnr)[1]
				local parent_line = ts_utils.get_node_range(parent)
				if parent_text ~= node_text and node_line ~= parent_line then
					parent_name = parent_text
					break
				end
				parent = parent:parent()
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

-- pick from git-files if inside git repository,
-- if that breaks, use find_files from CWD
-- selene: allow(global_usage)
_G.telescope_project_files = function()
	local opts = {}
	local ok = pcall(require("telescope.builtin").git_files, opts)
	if not ok then
		require("telescope.builtin").find_files(opts)
	end
end

-- choose from files inside current virtualenv
-- selene: allow(global_usage)
_G.telescope_virtualenv_files = function()
	require("telescope.builtin").find_files({
		path_display = { "smart" },
		find_command = {
			"fd",
			"--type",
			"f",
			"--hidden",
			"--no-ignore",
			[[.*\.pyi?$]],
			vim.env.VIRTUAL_ENV,
		},
	})
end

local set_keymap = require("utils").set_keymap
-- set_keymap("n", "<leader>f", "<cmd>Telescope treesitter <cr>")
set_keymap("n", "<leader>f", "<cmd>lua telescope_treesitter_tags()<cr>")
set_keymap("n", "<leader>F", "<cmd>lua telescope_project_tags()<cr>")
set_keymap("n", "<leader>m", "<cmd>Telescope buffers <cr>")
set_keymap("n", "<leader>ht", "<cmd>Telescope help_tags <cr>")
-- set_keymap("n", "<leader>a", "<cmd>Telescope lsp_code_actions<cr>")
-- set_keymap("v", "<leader>a", "<cmd>Telescope lsp_range_code_actions<cr>")
set_keymap("n", "<leader>rg", "<cmd>Telescope live_grep debounce=100 <cr>")
set_keymap("n", "<leader>ag", "<cmd>Telescope grep_string <cr>")
set_keymap("n", "<leader>td", "<cmd>TodoTelescope<cr>")
set_keymap("n", "<C-P>", "<cmd>lua telescope_project_files()<cr>")
set_keymap("n", "<leader>p", "<cmd>lua telescope_virtualenv_files()<cr>")
set_keymap("n", "<leader>gl", "<cmd>Telescope git_bcommits<cr>")
set_keymap("n", "<leader>gr", "<cmd>Telescope git_branches<cr>")
