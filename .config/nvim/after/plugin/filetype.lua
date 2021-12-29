require("filetype").setup({
	overrides = {
		extensions = {
			crs = "rust",
			tl = "teal",
		},
		literal = {
			["poetry.lock"] = "toml",
			["Pipfile"] = "toml",
			["Pipfile.lock"] = "json",
			[".envrc"] = "bash",
			[".direnvrc"] = "bash",
			[".env"] = "bash",
		},
		complex = {
			["requirements*.txt"] = "requirements",
			["requirements*.in"] = "requirements",
		},
		shebang = {
			tl = "teal",
		},
	},
})
