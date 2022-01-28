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
			[".env.sample"] = "bash",
			[".luacheckrc"] = "lua",
		},
		complex = {
			["requirements*.txt"] = "requirements",
			["requirements*.in"] = "requirements",
		},
		shebang = {
			tl = "teal",
			bash = "bash",
		},
	},
})
