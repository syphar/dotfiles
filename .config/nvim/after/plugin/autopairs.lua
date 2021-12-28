local npairs = require("nvim-autopairs")
npairs.setup({
	map_cr = false,
	map_bs = true,
	map_c_w = false,
	check_ts = true, -- treesitter support
})
