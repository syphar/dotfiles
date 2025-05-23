vim.g.mapleader = ","

-- don't count {} as jumps for the jumplist
-- see https://superuser.com/a/836924/1124707
local opts = { silent = true }
vim.keymap.set("n", "}", [[:<C-u>execute "keepjumps norm! " . v:count1 . "}"<CR>]], opts)
vim.keymap.set("n", "{", [[:<C-u>execute "keepjumps norm! " . v:count1 . "{"<CR>]], opts)

-- Y should be yank until the end of the line
-- see :help Y
vim.keymap.set({ "n", "v", "o" }, "Y", "y$")

-- turn off search highlight
vim.keymap.set("n", "<leader><space>", ":nohlsearch<CR>")

-- open/close folds with spacebar
vim.keymap.set("n", "<space>", "za")

-- show current file on master
vim.keymap.set("n", "<leader>em", function()
	-- Check if 'master' exists
	local branches = vim.fn.systemlist("git branch -a")
	if vim.tbl_contains(branches, "  remotes/origin/master") then
		vim.cmd(":Gedit master:%")
	elseif vim.tbl_contains(branches, "  remotes/origin/main") then
		vim.cmd(":Gedit main:%")
	else
		vim.notify("Neither 'master' nor 'main' branch found", vim.log.levels.ERROR)
	end
end, { desc = "Edit current file on main branch" })

-- set workspace diagnostics into quickfix
vim.keymap.set("n", "<leader>qf", function()
	vim.diagnostic.setqflist({ open = true })
end)

-- delete current file
vim.keymap.set("n", "<leader>rm", ":!rm %<CR>")

-- git blame for the current file
vim.keymap.set("n", "<leader>gb", ":Git blame <CR>")

-- terminal mode
-- back to normal mode for scrolling via <Esc>
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])

-- https://vim.fandom.com/wiki/Search_for_current_word_in_multiple_files
vim.keymap.set("n", "gw", ":silent grep <cword> <CR>")
vim.keymap.set("n", "gW", ":silent grep '\\b<cword>\\b' <CR>")
-- grep selection
vim.keymap.set(
	"v",
	"gw",
	[[y:execute 'silent grep "' . escape('<C-r>"', '\^$.|?*+"()[]{}-') . '"' <CR>]],
	{ replace_keycodes = true, expr = true }
)

vim.keymap.set("n", "<F3>", "<cmd>lwindow<cr>") -- only open with content, close when empty
vim.keymap.set("n", "<F4>", "<cmd>cwindow<cr>") --  same
vim.keymap.set("n", "<F9>", "<cmd>lprevious<cr>")
vim.keymap.set("n", "<F10>", "<cmd>lnext<cr>")
vim.keymap.set("n", "<F11>", "<cmd>cprevious<cr>")
vim.keymap.set("n", "<S-F11>", "<cmd>cpfile<cr>")
vim.keymap.set("n", "<F12>", "<cmd>cnext<cr>")
vim.keymap.set("n", "<S-F12>", "<cmd>cnfile<cr>")

-- Visual shifting (does not exit Visual mode)
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Substitute in line
-- from https://www.reddit.com/r/vim/comments/umo2kt/tiny_keymap_that_can_replace_a_lot/
vim.cmd([[vnoremap sw "zy:%s/<C-r>z//g<Left><Left>]])
vim.cmd([[nnoremap sw "zyiw:%s/<C-r>z//g<Left><Left>]])

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
	-- grep should always be silent
	grep = "silent grep",
	-- real abbreviations
	CC = "CodeCompanion",
	CCC = "CodeCompanionChat",
}
for old, new in pairs(command_abbrev) do
	vim.cmd("cnoreabbrev " .. old .. " " .. new)
end

-- open quickfix after grep
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	pattern = "grep",
	group = vim.api.nvim_create_augroup("quickfix", {}),
	command = "botright copen", -- cwindow
})

-- disable ex mode mappings, I always end up
-- in ex-mode and never need it. Then I have
-- to remember how to exit it.
-- https://vi.stackexchange.com/q/457/27498
vim.cmd("map q: <Nop>")
vim.cmd("nnoremap Q <nop>")

-- ; as <C-w> to quickly reach window/split control
vim.keymap.set("n", ";", "<C-w>")

-- new mapping, new file next to the currently open one
vim.keymap.set("n", "<leader>n", function()
	vim.ui.input({ prompt = "filename" }, function(input)
		if not input then
			return
		end
		vim.cmd("e %:h/" .. input)
	end)
end)
