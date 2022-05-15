local null_ls = require("null-ls")
local helpers = require("null-ls.helpers")

return {
	method = null_ls.methods.DIAGNOSTICS,
	name = "perflint",
	filetypes = { "python" },
	generator = helpers.generator_factory({
		command = "perflint",
		name = "perflint",
		args = {
			"--output-format=json",
			"--from-stdin",
			"$FILENAME",
		},
		to_stdin = true,
		from_stderr = false,
		ignore_stderr = true,
		-- format = "json",
		format = "raw",
		check_exit_code = { 0, 1, 4 },
		-- on_output = helpers.diagnostics.from_json({
		-- 	attributes = {
		-- 		row = "line",
		-- 		end_row = "endLine",
		-- 		col = "column",
		-- 		end_col = "endColumn",
		-- 		code = "message-id",
		-- 		message = "message",
		-- 	},
		-- 	offsets = {
		-- 		col = 1,
		-- 		end_col = 1,
		-- 	},
		-- }),
		on_output = function(params, done)
			local parse = helpers.diagnostics.from_json({
				attributes = {
					row = "line",
					end_row = "endLine",
					col = "column",
					end_col = "endColumn",
					code = "message-id",
					message = "message",
				},
				offsets = {
					col = 1,
					end_col = 1,
				},
			})

			if params.output then
				--sometimes the first lines can contains an error message (on stdout)
				local lines = vim.split(params.output, "\n")
				while #lines and string.sub(lines[1], 1, 1) ~= "[" do
					table.remove(lines, 1)
				end

				params.output = vim.json.decode(table.concat(lines, "\n"))
				done(parse(params))
			else
				done()
			end
		end,
	}),
}
