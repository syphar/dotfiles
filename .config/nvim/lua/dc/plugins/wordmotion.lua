return {
	"chaoren/vim-wordmotion",
	event = "VeryLazy",
	config = function()
		vim.cmd([[
			let g:wordmotion_spaces = [ '\\"' ]
			" uppercase spaces would stop the upper case motion (full words)
			let g:wordmotion_uppercase_spaces = [ '.', ',', '(', ')', '[', ']', '{', '}', ' ', '<', '>', ':', '"' ]
			call wordmotion#reload()
		]])
	end,
}
