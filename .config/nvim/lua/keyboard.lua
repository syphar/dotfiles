local luasnip = require("luasnip")
local npairs = require("nvim-autopairs")

vim.g.mapleader = ","

local function set_keymap(mode, mapping, command)
	vim.api.nvim_set_keymap(mode, mapping, command, { noremap = true, silent = false })
end
local function set_keymap_silent(mode, mapping, command)
	vim.api.nvim_set_keymap(mode, mapping, command, { noremap = true, silent = true })
end

local function t(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

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
set_keymap("v", "<space>", "zf")

-- telescope mapping
set_keymap("n", "<leader>f", "<cmd>Telescope treesitter <cr>")
set_keymap("n", "<leader>F", "<cmd>Telescope tags<cr>")
set_keymap("n", "<leader>m", "<cmd>Telescope buffers <cr>")
set_keymap("n", "<leader>ht", "<cmd>Telescope help_tags <cr>")
set_keymap("n", "<leader>a", "<cmd>Telescope lsp_code_actions<cr>")
set_keymap("n", "<leader>rg", "<cmd>Telescope live_grep <cr>")
set_keymap("n", "<leader>ag", "<cmd>Telescope grep_string <cr>")
set_keymap("n", "<C-P>", [[<cmd>lua require('telescope-config').project_files()<cr>]])
set_keymap("n", "<leader>p", [[<cmd>lua require('telescope-config').virtualenv_files()<cr>]])
set_keymap("n", "<leader>q", "<cmd>lua require'telescope'.extensions.project.project{}<CR>")

-- show current file on master
set_keymap("n", "<leader>em", ":Gedit master:%<CR>")

-- show git log for current file
set_keymap("n", "<leader>gl", "<cmd>Telescope git_bcommits<cr>")
set_keymap("n", "<leader>gr", "<cmd>Telescope git_branches<cr>")
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

-- tmux navigation
set_keymap("n", "<C-h>", "<CMD>lua require('Navigator').left()<CR>")
set_keymap("n", "<C-k>", "<CMD>lua require('Navigator').up()<CR>")
set_keymap("n", "<C-l>", "<CMD>lua require('Navigator').right()<CR>")
set_keymap("n", "<C-j>", "<CMD>lua require('Navigator').down()<CR>")

-- common typos .. (W, Wq WQ)
vim.cmd([[
cnoreabbrev E e
cnoreabbrev W w
cnoreabbrev WQ wq
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev WA wa
cnoreabbrev Q q
cnoreabbrev QA qa
cnoreabbrev Qa qa
cnoreabbrev Vsp vsp
]])
