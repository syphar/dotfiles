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

local check_back_space = function()
	local col = vim.fn.col(".") - 1
	if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
		return true
	else
		return false
	end
end

_G.tab_complete = function()
	if vim.fn.pumvisible() == 1 then
		return t("<C-n>")
	elseif luasnip.expand_or_jumpable() then
		return t("<Plug>luasnip-expand-or-jump")
	elseif check_back_space() then
		return t("<Tab>")
	else
		return t("<C-X><C-O>")
	end
end

_G.s_tab_complete = function()
	if vim.fn.pumvisible() == 1 then
		return t("<C-p>")
	elseif luasnip.jumpable(-1) then
		return t("<Plug>luasnip-jump-prev")
	else
		return t("<S-Tab>")
	end
end

-- MUtils.completion_confirm=function()
--   if vim.fn.pumvisible() ~= 0  then
--     if vim.fn.complete_info()["selected"] ~= -1 then
--       require'completion'.confirmCompletion()
--       return npairs.esc("<c-y>")
--     else
--       vim.api.nvim_select_popupmenu_item(0 , false , false ,{})
--       require'completion'.confirmCompletion()
--       return npairs.esc("<c-n><c-y>")
--     end
--   else
--     return npairs.autopairs_cr()
--   end
-- end

-- remap('i' , '<CR>','v:lua.MUtils.completion_confirm()', {expr = true , noremap = true})

_G.enter_complete = function()
	if vim.fn.pumvisible() == 1 then
		if luasnip.expandable() then
			return t("<C-y><cmd>lua require'luasnip'.expand()<CR>")
		else
			return t("<C-y>")
		end
	else
		return npairs.autopairs_cr()
		-- return t("<CR>")
	end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", { expr = true })
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", { expr = true })
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })

-- enter selects entry from autocomplete, directly expands snippet when possible
vim.api.nvim_set_keymap("i", "<CR>", "v:lua.enter_complete()", { expr = true, noremap = true })

-- show omnicomplete on C-space
set_keymap_silent("i", "<C-Space>", "<C-X><C-O>")

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
