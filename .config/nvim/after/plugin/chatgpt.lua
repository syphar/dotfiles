local chatgpt = require("chatgpt")
chatgpt.setup({
	max_line_length = 88,
})

vim.keymap.set({ "n", "v" }, "<leader>v", chatgpt.edit_with_instructions)
