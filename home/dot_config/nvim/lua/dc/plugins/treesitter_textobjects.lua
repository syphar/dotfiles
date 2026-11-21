return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	branch = "main",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = function()
		local dc_utils = require("dc.utils")
		require("nvim-treesitter-textobjects").setup({
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
				},
				move = {
					enable = true,
					set_jumps = true,
				},
			},
		})

		local select_keymaps = {
			-- You can use the capture groups defined in textobjects.scm
			["am"] = "@function.outer",
			["im"] = "@function.inner",
			["ac"] = "@class.outer",
			["ic"] = "@class.inner",
			["aa"] = "@parameter.outer",
			["ia"] = "@parameter.inner",
			["ab"] = "@block.outer",
			["ib"] = "@block.inner",
		}
		for lhs, query in pairs(select_keymaps) do
			vim.keymap.set({ "x", "o" }, lhs, function()
				require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
			end)
		end

		for lhs, query in pairs({
			["]m"] = "@function.outer",
			["]b"] = "@block.outer",
			["]]"] = "@class.outer",
			["|"] = dc_utils.treesitter_context_move_targets,
		}) do
			vim.keymap.set({ "n", "x", "o" }, lhs, function()
				require("nvim-treesitter-textobjects.move").goto_next_start(query, "textobjects")
			end)
		end

		for lhs, query in pairs({
			["]M"] = "@function.outer",
			["]B"] = "@block.outer",
			["]["] = "@class.outer",
		}) do
			vim.keymap.set({ "n", "x", "o" }, lhs, function()
				require("nvim-treesitter-textobjects.move").goto_next_end(query, "textobjects")
			end)
		end

		for lhs, query in pairs({
			["[m"] = "@function.outer",
			["[b"] = "@block.outer",
			["[["] = "@class.outer",
			['"'] = dc_utils.treesitter_context_move_targets,
		}) do
			vim.keymap.set({ "n", "x", "o" }, lhs, function()
				require("nvim-treesitter-textobjects.move").goto_previous_start(query, "textobjects")
			end)
		end

		for lhs, query in pairs({
			["[M"] = "@function.outer",
			["[B"] = "@block.outer",
			["[]"] = "@class.outer",
		}) do
			vim.keymap.set({ "n", "x", "o" }, lhs, function()
				require("nvim-treesitter-textobjects.move").goto_previous_end(query, "textobjects")
			end)
		end
	end,
}
