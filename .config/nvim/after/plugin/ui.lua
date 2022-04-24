require("focus").setup({ cursorline = false, signcolumn = false, autoresize = false })

-- default focus.nvim autocmd,
-- calling WinScrolled afterwards so _incline_ floats
-- are updated correctly.
-- upstream fix: https://github.com/beauwilliams/focus.nvim/pull/83
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
	pattern = "*",
	group = vim.api.nvim_create_augroup("focus_nvim", {}),
	callback = function()
		vim.schedule(function()
			require("focus").resize()
			vim.cmd([[doautocmd WinScrolled]])
		end)
	end,
})

-- auto-adjust splits when window is resized
-- https://vi.stackexchange.com/questions/201/make-panes-resize-when-host-window-is-resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
	pattern = "*",
	command = "wincmd =",
})

vim.opt.equalalways = true

-- line numbers and relative number
vim.opt.number = true
vim.opt.relativenumber = true

-- enable mouse support
vim.opt.mouse = "a"

vim.opt.showtabline = 0

-- no cursor line
vim.opt.cursorline = false

-- Redraw only when essential
vim.opt.lazyredraw = true
vim.opt.redrawtime = 10000

-- Just sync some lines of a large file
vim.opt.synmaxcol = 400
vim.cmd("syntax sync minlines=256")

-- When scrolling, keep cursor 10 lines away from screen border
vim.opt.scrolloff = 10
