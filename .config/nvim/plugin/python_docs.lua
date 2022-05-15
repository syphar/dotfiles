_G.python_package_documentation = function(selected_text)
	local url = require("net.url")
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local finders = require("telescope.finders")
	local pickers = require("telescope.pickers")
	local entry_display = require("telescope.pickers.entry_display")
	local conf = require("telescope.config").values

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
					url = parts[3],
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

				-- TODO: find existing RTD page when it's not in metadata? example: geopy

				if selected_text then
					if string.find(selection.url, "https://github.com") then
						-- use github search for github repos
						local u = url.parse(selection.url .. "/search")
						u.query.q = selected_text
						vim.fn["netrw#BrowseX"](tostring(u), 0)
					else
						-- google site search for the rest
						local u = url.parse("http://www.google.com/search")
						u.query.q = selected_text .. " site: " .. selection.url
						vim.fn["netrw#BrowseX"](tostring(u), 0)
					end
				else
					vim.fn["netrw#BrowseX"](selection.url, 0)
				end
			end)
			return true
		end,
	}):find()
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	group = vim.api.nvim_create_augroup("python_docs", {}),
	callback = function()
		vim.keymap.set("n", "gh", python_package_documentation, { silent = true })
		vim.keymap.set(
			"v",
			"gh",
			[["zy:lua python_package_documentation("<C-r>z")<cr>]],
			{ silent = true, replace_keycodes = true }
		)
	end,
})
