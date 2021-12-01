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
		path_display = { "smart" },
		find_command = {
			"fd",
			"--strip-cwd-prefix",
			"--type",
			"f",
			"--hidden",
			"--no-ignore",
			[[.*\.py$]],
			vim.env.VIRTUAL_ENV,
		},
	})
end

return M
