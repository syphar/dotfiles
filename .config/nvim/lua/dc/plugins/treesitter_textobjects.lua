return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	event = "VeryLazy",
	config = function()
		local dc_utils = require("dc.utils")
		require("nvim-treesitter.configs").setup({
			textobjects = {
				select = {
					enable = true,

					-- Automatically jump forward to textobj, similar to targets.vim
					lookahead = true,

					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						["am"] = "@function.outer",
						["im"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
						["ab"] = "@block.outer",
						["ib"] = "@block.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["]m"] = "@function.outer",
						["]b"] = "@block.outer",
						["]]"] = "@class.outer",
						["|"] = { query = dc_utils.treesitter_context_move_targets },
					},
					goto_next_end = {
						["]M"] = "@function.outer",
						["]B"] = "@block.outer",
						["]["] = "@class.outer",
					},
					goto_previous_start = {
						["[m"] = "@function.outer",
						["[b"] = "@block.outer",
						["[["] = "@class.outer",
						['"'] = { query = dc_utils.treesitter_context_move_targets },
					},
					goto_previous_end = {
						["[M"] = "@function.outer",
						["[B"] = "@block.outer",
						["[]"] = "@class.outer",
					},
				},
			},
		})
	end,
}
