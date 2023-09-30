local M = {}

local Path = require("plenary.path")

M.get_toml_sections = function(content)
	local t = {}
	for line in content:gmatch("[^\r\n]+") do
		local section = line:match("^%[([^%]]+)%]$")
		if section then
			t[section] = true
		end
	end
	return t
end

M.pyproject_toml = function()
	local root = vim.fn.getcwd()
	local filename = Path:new(root .. "/" .. "pyproject.toml")

	if filename:exists() and filename:is_file() then
		return M.get_toml_sections(filename:read())
	end
	return {}
end

return M
