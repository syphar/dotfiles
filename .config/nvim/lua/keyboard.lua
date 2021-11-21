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

set_keymap("n", "<leader>d", "<cmd>DashWord<cr>")

-- show current file on master
set_keymap("n", "<leader>em", ":Gedit master:%<CR>")

-- show git log for current file
set_keymap("n", "<leader>gl", ":0Gclog <CR>")
set_keymap("v", "<leader>gl", ":Gclog <CR>")

-- git blame for the current file
set_keymap("n", "<leader>gb", ":Git blame <CR>")

-- trouble
set_keymap("n", "<F3>", "<cmd>TroubleToggle lsp_document_diagnostics<cr>")
set_keymap("n", "<F4>", "<cmd>TroubleToggle lsp_workspace_diagnostics<cr>")
-- nnoremap <F9> <cmd>lua require("trouble").next({skip_groups = true, jump = true})<cr>
-- nnoremap <F10> <cmd>lua require("trouble").previous({skip_groups = true, jump = true})<cr>

-- Visual shifting (does not exit Visual mode)
set_keymap("v", "<", "<gv")
set_keymap("v", ">", ">gv")

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
