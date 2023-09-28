return {
	"tzachar/cmp-tabnine",
	build = "./install.sh",
	dependencies = { "hrsh7th/nvim-cmp" },
	config = function()
		local cmp_tabnine = require("cmp_tabnine.config")
		cmp_tabnine:setup({
			max_lines = 1000,
			max_num_results = 20,
			sort = true,
			run_on_every_keystroke = true,
			snippet_placeholder = "..",
			ignored_file_types = {},
			show_prediction_strength = true,
		})

		-- require("tabnine").setup({
		-- 	disable_auto_comment = true,
		-- 	accept_keymap = "<Tab>",
		-- 	dismiss_keymap = "<C-]>",
		-- 	debounce_ms = 800,
		-- 	suggestion_color = { gui = "#808080", cterm = 244 },
		-- 	exclude_filetypes = { "TelescopePrompt" },
		-- 	log_file_path = nil, -- absolute path to Tabnine log file
		-- })

		-- vim.keymap.set({ "x", "i", "n" }, "<leader>q", require("tabnine.chat").open)
	end,
}
