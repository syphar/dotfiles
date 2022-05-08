require("treesitter-context").setup({
	enable = true,
	throttle = true,
	max_lines = 0,
	patterns = {
		default = {
			"class",
			"function",
			"method",
			"for",
			"while",
			"if",
			"else",
			"switch",
			"case",
		},
		rust = {
			"impl_item",
			"mod_item",
			"match",
			"struct",
			"loop",
			"closure",
			"async_block",
			"block",
		},
		python = {
			"elif",
			"with",
			"try",
			"except",
		},
		json = {
			"object",
			"pair",
		},
		javascript = {
			"object",
			"pair",
		},
		yaml = {
			"block_mapping_pair",
			"block_sequence_item",
		},
		toml = {
			"table",
			"pair",
		},
	},
})
