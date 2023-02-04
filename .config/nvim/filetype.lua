vim.filetype.add({
	extension = {
		crs = "rust",
		soql = "soql",
	},
	filename = {
		["Justfile"] = "just",
		["poetry.lock"] = "toml",
		[".env.sample"] = function()
			-- take from the `.env` definition in the vim runtime
			vim.fn["dist#ft#SetFileTypeSH"](vim.fn.getline(1))
		end,
		[".luacheckrc"] = "lua",
	},
	pattern = {},
})
