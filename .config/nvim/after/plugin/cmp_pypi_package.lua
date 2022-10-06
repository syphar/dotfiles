local Job = require("plenary.job")

local source = {}

source.new = function()
	local self = setmetatable({}, { __index = source })
	return self
end

function source:is_available()
	return vim.bo.filetype == "requirements"
end

function source:complete(request, callback)
	local q = string.sub(request.context.cursor_before_line, request.offset)
	Job:new({
		"rg",
		"^" .. q,
		"--smart-case",
		"--max-count",
		10,
		vim.env.HOME .. "/.cache/pypi_packages.txt",
		on_stderr = function(_, data, _)
			print("GOT ERROR FROM ripgrep : " .. data)
		end,
		on_exit = function(job, _, _)
			local items = {}
			for _, line in ipairs(job:result()) do
				table.insert(items, {
					label = line,
				})
			end
			callback({
				items = items,
				isIncomplete = true,
			})
		end,
	}):start()
end

require("cmp").register_source("pypi_package", source.new())
