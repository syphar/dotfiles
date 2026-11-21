return {
	"niekdomi/conflict.nvim",
	opts = {
		default_mappings = {
			current = "cc",
			incoming = "ci",
			both = "cb",
			none = false,
			next = "]x",
			prev = "[x",
		},
		show_actions = false,
		disable_diagnostics = true,
		highlights = {
			incoming = "DiffAdd",
			current = "DiffText",
		},
	},
}
