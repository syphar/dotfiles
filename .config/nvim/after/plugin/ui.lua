-- auto-adjust splits when window is resized
-- https://vi.stackexchange.com/questions/201/make-panes-resize-when-host-window-is-resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
	pattern = "*",
	command = "wincmd =",
})

vim.opt.equalalways = true

-- line numbers and relative number
vim.opt.number = false
vim.opt.relativenumber = false

-- enable mouse support
vim.opt.mouse = "a"

vim.opt.showtabline = 0

-- no cursor line
vim.opt.cursorline = false

-- no command line
-- vim.opt.cmdheight = 0

-- Redraw only when essential
vim.opt.lazyredraw = true
vim.opt.redrawtime = 10000

-- Just sync some lines of a large file
vim.opt.synmaxcol = 400
vim.cmd("syntax sync minlines=256")

-- When scrolling, keep cursor 10 lines away from screen border
vim.opt.scrolloff = 10
