vim.filetype.add({
	extension = {
		crs = "rust",
		soql = "soql",
	},
	filename = {
		[".sqlfluff"] = "cfg",
		["Justfile"] = "just",
		["Caddyfile"] = "caddyfile",
		["poetry.lock"] = "toml",
		["nginx.conf.erb"] = "nginx",
		[".env.sample"] = function()
			-- take from the `.env` definition in the vim runtime
			vim.fn["dist#ft#SetFileTypeSH"](vim.fn.getline(1))
		end,
		[".luacheckrc"] = "lua",
	},
})
