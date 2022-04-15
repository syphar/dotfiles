local M = {}

function M.set_keymap(mode, mapping, command)
	vim.api.nvim_set_keymap(mode, mapping, command, { noremap = true, silent = false })
end
function M.set_lua_keymap(mode, mapping, fn)
	vim.api.nvim_set_keymap(mode, mapping, "", { noremap = true, silent = false, callback = fn })
end
function M.set_keymap_silent(mode, mapping, command)
	vim.api.nvim_set_keymap(mode, mapping, command, { noremap = true, silent = true })
end

function M.tc(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

return M
