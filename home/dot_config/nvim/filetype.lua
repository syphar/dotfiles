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
		["docker-bake.hcl"] = "hcl.docker-bake",
		["docker-bake.json"] = "json.docker-bake",
		["docker-bake.override.hcl"] = "hcl.docker-bake",
		["docker-bake.override.json"] = "json.docker-bake",
		["poetry.lock"] = "toml",
		["nginx.conf.erb"] = "nginx",
		[".luacheckrc"] = "lua",
		[".envrc"] = "direnv",
	},
	pattern = {
		["%.env%.%w+"] = "sh",
		["Dockerfile%-.+"] = "dockerfile",
		["Dockerfile%..+"] = "dockerfile",
		["justfile%.%w+"] = "just",
		["Justfile%.%w+"] = "just",
	},
})
