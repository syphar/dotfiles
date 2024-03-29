local M = {}

local Path = require("plenary.path")

M.treesitter_context_move_targets = {
	"@class.outer",
	"@function.outer",
}

M.treesitter_context_jump_targets = {
	"@class.outer",
	"@function.outer",
	"@block.outer",
	"@statement.outer",
}

M.lazy_file_events = { "BufReadPost", "BufNewFile", "BufWritePre" }

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

M.setup_cfg_sections = function()
	local root = vim.fn.getcwd()
	local filename = Path:new(root .. "/" .. "setup.cfg")

	local sections = {}
	if filename:exists() and filename:is_file() then
		for _, line in ipairs(vim.split(filename:read(), "\n")) do
			local _, _, name = line:find("%[(.*)%]")
			if name then
				sections[name] = true
			end
		end
	end
	return sections
end

function M.debounce(ms, fn)
	local timer = vim.loop.new_timer()
	return function(...)
		local argv = { ... }
		timer:start(ms, 0, function()
			timer:stop()
			vim.schedule_wrap(fn)(unpack(argv))
		end)
	end
end

return M
