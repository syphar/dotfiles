require("flash").setup({})

vim.keymap.set({ "n", "x", "o" }, "z", function()
	-- default options: exact mode, multi window, all directions, with a backdrop
	require("flash").jump()
end)

vim.keymap.set({ "n", "x", "o" }, "Z", function()
	-- show labeled treesitter nodes around the cursor
	require("flash").treesitter()
end)

-- pontential optimization, hop to start of text in line, not start of line
-- local first_non_whitespace_character_in_line = [[(^\s*\)\@<=]]

vim.keymap.set({ "n", "o" }, "<leader>hl", function()
	require("flash").jump({
		search = { mode = "search", forward = true, wrap = false, multi_window = false },
		highlight = { label = { after = { 0, 0 } } },
		pattern = "^",
	})
end)

vim.keymap.set({ "n", "o" }, "<leader>hL", function()
	require("flash").jump({
		search = { mode = "search", forward = false, wrap = false, multi_window = false },
		highlight = { label = { after = { 0, 0 } } },
		pattern = "^",
	})
end)

vim.keymap.set({ "n", "o" }, "<leader>hw", function()
	require("flash").jump({
		search = {
			forward = true,
			wrap = false,
			multi_window = false,
			mode = function(str)
				return "\\<" .. str
			end,
		},
	})
end)

vim.keymap.set({ "n", "o" }, "<leader>hW", function()
	require("flash").jump({
		search = {
			forward = false,
			wrap = false,
			multi_window = false,
			mode = function(str)
				return "\\<" .. str
			end,
		},
	})
end)
