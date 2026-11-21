local jump_target = require("hop.jump_target")

local T = {}

T.nodes = function()
	return function(opts)
		-- vim.print(opts)
		local Locations = T.parse(opts.direction)
		jump_target.sort_indirect_jump_targets(Locations.indirect_jump_targets, opts)
		return Locations
	end
end

local function duplicate(targets, row, col)
	for _, t in pairs(targets) do
		if t.cursor.row == row and t.cursor.col == col then
			return true
		end
	end
	return false
end

T.parse = function(direction)
	local locations = {
		jump_targets = {},
		indirect_jump_targets = {},
	}

	local function append(row, col)
		if duplicate(locations.jump_targets, row, col) then
			return
		end

		local len = #locations.jump_targets + 1
		-- Increment column to convert it to 1-index
		locations.jump_targets[len] = { buffer = 0, cursor = { row = row + 1, col = col }, length = 0, window = 0 }
		locations.indirect_jump_targets[len] = { index = len, score = len }
	end

	local first_visible_line = vim.fn.line("w0")
	local last_visible_line = vim.fn.line("w$")
	local current_line = vim.api.nvim_win_get_cursor(0)[1]
	local HintDirection = require("hop.hint").HintDirection

	local function show_line(line)
		if line < first_visible_line or line > last_visible_line then
			return false
		end
		if line == current_line then
			return false
		end

		if line > current_line and direction == HintDirection.BEFORE_CURSOR then
			return false
		end
		if line < current_line and direction == HintDirection.AFTER_CURSOR then
			return false
		end

		return true
	end

	local queries = require("nvim-treesitter.query")
	local dc_utils = require("dc.utils")
	for _, group in ipairs(dc_utils.treesitter_context_jump_targets) do
		local matches = queries.get_capture_matches_recursively(0, group, "textobjects")

		for _, match in ipairs(matches) do
			local a, b, c, d = match.node:range()
			if show_line(a) then
				append(a, b)
			end
			if show_line(c) then
				append(c, d)
			end
		end
	end

	return locations
end

return T
