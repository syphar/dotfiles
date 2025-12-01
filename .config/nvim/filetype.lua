vim.filetype.add({
	extension = {
		crs = "rust",
		soql = "soql",
		tl = "teal",
		kdl = "kdl",
	},
	filename = {
		[".sqlfluff"] = "cfg",
		["Justfile"] = "just",
		["Caddyfile"] = "caddyfile",
		["poetry.lock"] = "toml",
		["nginx.conf.erb"] = "nginx",
		[".luacheckrc"] = "lua",
		[".envrc"] = "direnv",
	},
	pattern = {
		["%.env%.%w+"] = "sh",
		["Dockerfile%-%w+"] = "dockerfile",
		["Dockerfile%.%w+"] = "dockerfile",
		["justfile%.%w+"] = "just",
		["Justfile%.%w+"] = "just",
	},
})
