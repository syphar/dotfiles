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
			-- sometimes I already exited insert-mode when the debounce
			-- kicks in and wants to start completion.
			if vim.fn.mode() == "i" then
				cmp.complete({ reason = cmp.ContextReason.Auto })
			end
		end)
	)
end

return M
