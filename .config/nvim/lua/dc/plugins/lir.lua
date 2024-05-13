-- file manager
return {
	"tamago324/lir.nvim",
	lazy = false,
	keys = {
		{
			"-",
			function()
				require("lir.float").toggle()
			end,
			"n",
		},
	},

	dependencies = {
		"tamago324/lir-git-status.nvim",
	},
	config = function()
		local actions = require("lir.actions")
		require("lir").setup({
			show_hidden_files = false,
			devicons = {
				enable = true,
				highlight_dirname = true,
			},
			mappings = {
				["<CR>"] = actions.edit,
				["<C-s>"] = actions.split,
				["<C-v>"] = actions.vsplit,
				-- ["<C-t>"] = actions.tabedit,

				["h"] = actions.up,
				["p"] = actions.up,
				["q"] = actions.quit,
				["<ESC>"] = actions.quit,

				-- ["K"] = actions.mkdir,
				-- ["N"] = actions.newfile,
				-- ["R"] = actions.rename,
				-- ["@"] = actions.cd,
				-- ["Y"] = actions.yank_path,
				-- ["."] = actions.toggle_show_hidden,
				-- ["D"] = actions.delete,

				-- ["J"] = function()
				-- 	mark_actions.toggle_mark()
				-- 	vim.cmd("normal! j")
				-- end,
				-- ["C"] = clipboard_actions.copy,
				-- ["X"] = clipboard_actions.cut,
				-- ["P"] = clipboard_actions.paste,
			},
			float = {
				winblend = 0,
				curdir_window = {
					enable = false,
					highlight_dirname = false,
				},
			},
			hide_cursor = true,
		})
		require("lir.git_status").setup({
			show_ignored = false,
		})
	end,
}
