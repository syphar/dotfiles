local null_ls = require("null-ls")
local helpers = require("null-ls.helpers")

return {
	method = null_ls.methods.DIAGNOSTICS,
	name = "pydocstyle",
	filetypes = { "python" },
	generator = helpers.generator_factory({
		command = "pydocstyle",
		name = "pydocstyle",
		args = {
			-- pydocstyle doesn't support receiving the file via STDIN
			"$FILENAME",
			-- Default config discovery ignores CWD and uses the directory the temp-file is in.
			-- we want to use the config in the project.
			"--config=$ROOT/setup.cfg",
		},
		to_stdin = false,
		to_temp_file = true,
		format = "raw",
		check_exit_code = function(code)
			return code <= 1
		end,
		on_output = function(params, done)
			local output = params.output
			if not output then
				return done()
			end

			-- pydocstyle output is in two lines for each error,
			-- which is why we cannot use `format = "line"` and have to
			-- split lines on our own.

			-- Example:
			--     example.py:48 in public function `send_stored_draft`:
			--         D403: First word of the first line should be properly capitalized ('Send', not 'send')

			local diagnostics = {}
			local current_line = nil

			for _, line in ipairs(vim.split(output, "\n")) do
				if line ~= "" then
					if current_line == nil then
						current_line = tonumber(line:match(":(%d+) "))
					else
						local code, message = line:match("%s+(D%d+): (.*)")

						table.insert(diagnostics, {
							row = current_line,
							code = code,
							source = "pydocstyle",
							message = message,
							severity = 3, -- "info" severity
						})

						current_line = nil
					end
				end
			end
			done(diagnostics)
		end,
	}),
}
