local null_ls = require("null-ls")
local Path = require("plenary.path")
local helpers = require("null-ls.helpers")
local utils = require("null-ls.utils")

return {
	method = null_ls.methods.DIAGNOSTICS,
	name = "bandit",
	filetypes = { "python" },
	generator = helpers.generator_factory({
		command = "bandit",
		name = "bandit",
		args = {
			"-",
			"--format",
			"json",
		},
		to_stdin = true,
		from_stderr = false,
		ignore_stderr = true,
		format = "json",
		check_exit_code = { 0, 1 },
		condition = function(utils)
			return utils.root_has_file({ ".bandit" })
		end,
		runtime_condition = function(params)
			-- HACK: mimic bandit excludes so I can use it with null-ls for now
			local bandit_ini = Path:new(utils.get_root() .. "/" .. ".bandit")

			-- see
			-- https://github.com/PyCQA/bandit/blob/a2ac371f30812e1c393dfacb7611c6c162564988/bandit/core/manager.py#L230-L234
			-- https://github.com/PyCQA/bandit/blob/a2ac371f30812e1c393dfacb7611c6c162564988/bandit/core/manager.py#L411-L415
			-- when searching subdirectories bandit just checks if the exclude-string is anywhere in the path

			if bandit_ini:exists() and bandit_ini:is_file() then
				for _, line in ipairs(bandit_ini:readlines()) do
					local excludes = string.match(line, "^exclude%:%s*(.*)")
					if excludes then
						for _, pattern in ipairs(vim.split(excludes, ",", { plain = true })) do
							if string.find(params.bufname, pattern) then
								return false
							end
						end
					end
				end
				return true
			else
				return false
			end
		end,
		on_output = function(params)
			local parse = helpers.diagnostics.from_json({
				attributes = {
					row = "line_number",
					col = "col_offset",
					code = "test_id",
					message = "issue_text",
					severity = "issue_severity",
				},
				offsets = {
					col = 1,
				},
				severities = {
					HIGH = helpers.diagnostics.severities["error"],
					MEDIUM = helpers.diagnostics.severities["warning"],
					LOW = helpers.diagnostics.severities["information"],
				},
			})

			if params.output then
				params.output = params.output.results
				return parse(params)
			end

			return {}
		end,
	}),
}
