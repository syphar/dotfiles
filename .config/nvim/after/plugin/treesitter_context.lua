require("treesitter-context").setup({
	enable = true,
	throttle = true,
	line_numbers = false,
	max_lines = 10,
	multiline_threshold = 10,
	mode = "topline", -- choices: 'cursor', 'topline'
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
			"enum_item",
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
			"expression",
		},
		json = {
			"object",
			"pair",
		},
		javascript = {
			"object",
			"pair",
		},
		typescriptreact = {
			"jsx_element",
			"jsx_self_closing_element",
			"jsx_fragment",
			"declaration",
		},
		terraform = {
			"block",
			"attribute",
		},
		yaml = {
			"block_mapping_pair",
			"block_sequence_item",
		},
		toml = {
			"table",
			"pair",
		},
		markdown = {
			"section",
		},
		scss = {
			"rule_set",
			"at_rule",
		},
	},
})
