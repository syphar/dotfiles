local null_ls = require("null-ls")
local helpers = require("null-ls.helpers")

return {
	method = null_ls.methods.DIAGNOSTICS,
	filetypes = { "python" },
	generator = helpers.generator_factory({
		command = "pydocstyle",
		args = function(params)
			-- by default pydocstyle searches for config-files not in the CWD,
			-- but starting from the file location. Since the file-location
			-- is a temp-directory, any config won't be found.
			--
			-- So we partially replicated the pydocstyle config discovery and
			-- then pass the config-file path to pydocstyle. We don't merge
			-- multiple existing config-files as pydocstyle itself does it.
			-- See also:
			-- https://www.pydocstyle.org/en/stable/usage.html#configuration-files
			local possible_config_files = {
				"setup.cfg",
				"tox.ini",
				".pydocstyle",
				".pydocstyle.ini",
				".pydocstylerc",
				".pydocstylerc.ini",
				"pyproject.toml",
			}

			local cfg = nil
			for _, fn in ipairs(possible_config_files) do
				local found = vim.fn.findfile(fn, params.root .. ";")
				if found then
					cfg = found
					break
				end
			end

			if cfg ~= nil then
				return {
					"--config=" .. params.root .. "/" .. cfg,
					"$FILENAME",
				}
			else
				return { "$FILENAME" }
			end
		end,
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
