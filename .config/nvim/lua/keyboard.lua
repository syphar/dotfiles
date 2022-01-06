local t = require("utils").tc
local set_keymap = require("utils").set_keymap
local set_keymap_silent = require("utils").set_keymap

vim.g.mapleader = ","

-- don't count {} as jumps for the jumplist
-- see https://superuser.com/a/836924/1124707
set_keymap_silent("n", "}", ":" .. t("<C-u>") .. [[execute "keepjumps norm! " . v:count1 . "}"<CR>]])
set_keymap_silent("n", "{", ":" .. t("<C-u>") .. [[execute "keepjumps norm! " . v:count1 . "{"<CR>]])

-- Y should be yank until the end of the line
-- see :help Y
vim.cmd([[map Y y$]])

-- turn off search highlight
set_keymap("n", "<leader><space>", ":nohlsearch<CR>")

-- open/close folds with spacebar
set_keymap("n", "<space>", "za")

-- show current file on master
set_keymap("n", "<leader>em", ":Gedit master:%<CR>")

-- git blame for the current file
set_keymap("n", "<leader>gb", ":Git blame <CR>")

set_keymap("n", "<F3>", "<cmd>lwindow<cr>") -- only open with content, close when empty
set_keymap("n", "<F4>", "<cmd>cwindow<cr>") --  same
set_keymap("n", "<F9>", "<cmd>lprevious<cr>")
set_keymap("n", "<F10>", "<cmd>lnext<cr>")
set_keymap("n", "<F11>", "<cmd>cprevious<cr>")
set_keymap("n", "<F12>", "<cmd>cnext<cr>")

-- Visual shifting (does not exit Visual mode)
set_keymap("v", "<", "<gv")
set_keymap("v", ">", ">gv")

-- common command typos .. (W, Wq WQ)
local command_abbrev = {
	E = "e",
	W = "w",
	WQ = "wq",
	Wq = "wq",
	Wa = "wa",
	WA = "wa",
	Q = "q",
	QA = "qa",
	Qa = "qa",
	Vsp = "vsp",
	On = "on",
}
for old, new in pairs(command_abbrev) do
	vim.cmd("cnoreabbrev " .. old .. " " .. new)
end

-- disable ex mode mappings, I always end up
-- in ex-mode and never need it. Then I have
-- to remember how to exit it.
-- https://vi.stackexchange.com/q/457/27498
vim.cmd("map q: <Nop>")
vim.cmd("nnoremap Q <nop>")
