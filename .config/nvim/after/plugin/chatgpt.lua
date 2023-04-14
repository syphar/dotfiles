local chatgpt = require("chatgpt")
chatgpt.setup({
	max_line_length = 88,
	-- yank_register = "+",
	-- keymaps = {
	-- 	close = "<esc>",
	-- 	submit = "<C-Enter>",
	-- 	-- the rest is default
	-- 	yank_last = "<C-y>",
	-- 	yank_last_code = "<C-k>",
	-- 	scroll_up = "<C-u>",
	-- 	scroll_down = "<C-d>",
	-- 	toggle_settings = "<C-o>",
	-- 	new_session = "<C-n>",
	-- 	cycle_windows = "<Tab>",
	-- 	-- in the Sessions pane
	-- 	select_session = "<Space>",
	-- 	rename_session = "r",
	-- 	delete_session = "d",
	-- },
})

vim.keymap.set({ "n", "v" }, "<leader>v", chatgpt.edit_with_instructions)
