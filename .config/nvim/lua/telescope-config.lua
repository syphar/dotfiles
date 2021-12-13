-- telescope helpers
local M = {}

-- pick from git-files if inside git repository,
-- if that breaks, use find_files from CWD
M.project_files = function()
	local opts = {}
	local ok = pcall(require("telescope.builtin").git_files, opts)
	if not ok then
		require("telescope.builtin").find_files(opts)
	end
end

-- choose from files inside current virtualenv
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
