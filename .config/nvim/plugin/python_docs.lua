local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local entry_display = require("telescope.pickers.entry_display")
local conf = require("telescope.config").values

local python_package_documentation = function()
	local displayer = entry_display.create({
		separator = "▏",
		items = {
			{ width = 15 },
			{ width = 20 },
			{ remaining = true },
		},
	})

	pickers.new({}, {
		prompt_title = "python package documentation",
		finder = finders.new_oneshot_job({
			"python3",
			vim.fn.expand("$HOME/src/dotfiles/print_documentation_urls.py"),
		}, {
			entry_maker = function(entry)
				local parts = vim.fn.split(entry, ";")
				return {
					value = parts[3],
					display = function()
						return displayer(parts)
					end,
					ordinal = entry,
				}
			end,
		}),
		previewer = nil,
		sorter = conf.generic_sorter({}),
		attach_mappings = function(_, _)
			actions.select_default:replace(function(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				if selection == nil then
					return
				end
				actions.close(prompt_bufnr)

				vim.fn["netrw#BrowseX"](selection.value, 0)
			end)
			return true
		end,
	}):find()
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	group = vim.api.nvim_create_augroup("python_docs", {}),
	callback = function()
		vim.keymap.set("n", "gh", python_package_documentation)
	end,
})
