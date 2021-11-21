local M = {}

M.project_files = function()
	local opts = {}
	local ok = pcall(require("telescope.builtin").git_files, opts)
	if not ok then
		require("telescope.builtin").find_files(opts)
	end
end

M.virtualenv_files = function()
	require("telescope.builtin").find_files({
		find_command = {
			"fd",
			"--type",
			"f",
			"--hidden",
			"--ignore-file",
			"~/src/dotfiles/gitignore/python.gitignore",
			-- I'll have to change the path after py310, or just start
			-- search from the virtualenv
			"--base-directory",
			vim.env.VIRTUAL_ENV .. "/lib/python3.9/site-packages/",
			".",
		},
	})
end

return M
