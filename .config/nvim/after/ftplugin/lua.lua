vim.opt.expandtab = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.opt.suffixesadd:append({ ".lua", "init.lua" })

local ts_utils = require("nvim-treesitter.ts_utils")

local find_function_call = function()
	local node = ts_utils.get_node_at_cursor(0)

	while node ~= nil do
		if node:type() == "function_call" then
			return node
		end
		node = node:parent()
	end
end

local show_method_help = function()
	local buf = vim.api.nvim_get_current_buf()
	local function_call = find_function_call()
	if not function_call then
		print("cursor not on method call")
		return
	end

	local function_name_node = function_call:field("name")[1]
	local function_name = vim.treesitter.query.get_node_text(function_name_node, buf)

	-- first try to search by cutting prefixes and then searching
	local prefixes = {
		"^vim%.api%.",
		"^vim%.fn%.",
	}
	for _, p in ipairs(prefixes) do
		local search_string, count = string.gsub(function_name, p, "")

		if count > 0 then
			vim.cmd(":help " .. search_string)
			return
		end
	end

	-- fallback: everything starting with `vim.` directly to help
	if string.sub(function_name, 1, 4) == "vim." then
		vim.cmd(":help " .. function_name)
		return
	end
end

vim.keymap.set("n", "gh", show_method_help)
