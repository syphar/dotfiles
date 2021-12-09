--https://github.com/hrsh7th/nvim-cmp/issues/598

local M = {}

local cmp = require("cmp")
local timer = vim.loop.new_timer()

local DEBOUNCE_DELAY = vim.opt.updatetime:get()

function M.debounce()
	timer:stop()
	timer:start(
		DEBOUNCE_DELAY,
		0,
		vim.schedule_wrap(function()
			cmp.complete({ reason = cmp.ContextReason.Auto })
		end)
	)
end

return M
