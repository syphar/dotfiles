require("bufignore").setup({
	auto_start = true,
	ignore_sources = {
		git = true,
		patterns = { "/%.git/" },
	},
	pre_unlist = nil,
})
