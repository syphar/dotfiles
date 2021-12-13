local Job = require("plenary.job")

local source = {}

source.new = function()
	local self = setmetatable({ cache = {} }, { __index = source })
	return self
end

function source:is_available()
	return vim.bo.filetype == "gitcommit"
end

function source:get_debug_name()
	return "jira_issues"
end

function source:get_trigger_characters(params)
	return { "-" }
end

function source:get_keyword_pattern(params)
	return [=[[0-9A-Z\\-]\+]=]
end

function source:complete(params, callback)
	local input = string.sub(params.context.cursor_before_line, params.offset)

	local _, _, project, issue_prefix = string.find(input, "(%u+)-(%d*)")
	if not project then
		return callback()
	end

	if not self.cache[project] then
		Job
			:new({
				"jira",
				"issue",
				"list",
				"--plain",
				"--no-truncate",
				"--no-headers",
				"--columns=key,status,summary",
				"--project=" .. project,
				"--limit",
				"10000",
				"--jql",
				"statusCategory != Done",
				on_stderr = function(_, data, _)
					if not string.find(data, "Fetching issues") then
						print("GOT ERROR FROM JIRA CLI: " .. data)
					end
				end,
				on_exit = function(job, _, _)
					local items = {}
					for _, line in ipairs(job:result()) do
						local parts = vim.tbl_filter(function(item)
							return string.len(vim.trim(item)) > 0
						end, vim.split(line, "\t"))

						if #parts >= 3 then
							table.insert(items, {
								label = parts[1] .. " - " .. parts[3],
								insertText = parts[1],
							})
						end
					end
					callback({
						items = items,
						isIncomplete = false,
					})
					self.cache[project] = items
				end,
			})
			:start()
	else
		callback({ items = self.cache[project], isIncomplete = false })
	end
end

require("cmp").register_source("jira_issues", source.new())
