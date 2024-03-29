return { --automatically set root directory to project directory
	"airblade/vim-rooter",
	event = { "VimEnter", "BufReadPost", "BufEnter", "BufWritePost" },
	config = function()
		vim.cmd([[
			let g:rooter_targets = '/,*'
			let g:rooter_patterns = ['.null-ls-root', '.git', 'Makefile', '.marksman.toml']
			let g:rooter_change_directory_for_non_project_files = ''
			let g:rooter_cd_cmd = 'cd'
			let g:rooter_silent_chdir = 0
		]])
	end,
}
