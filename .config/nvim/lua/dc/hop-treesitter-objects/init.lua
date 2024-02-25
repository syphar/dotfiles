local M = {}
M.opts = {}

M.hint_objects = function(opts)
	local hop = require("hop")

	opts = setmetatable(opts or {}, { __index = M.opts })
	hop.hint_with(require("dc.hop-treesitter-objects.treesitter").nodes(), opts)
end

function M.register(opts)
	M.opts = opts
end

return M
