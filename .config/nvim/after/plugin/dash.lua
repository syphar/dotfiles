require("dash").setup({
	search_engine = "google",
	debounce = vim.opt.updatetime:get(),
	file_type_keywords = {
		python = { "python3", "django" },
	},
})

vim.keymap.set("n", "<leader>k", ":DashWord<CR>")