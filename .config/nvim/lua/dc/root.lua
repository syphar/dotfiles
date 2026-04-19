local markers = { ".null-ls-root", ".git", "Makefile", ".marksman.toml" }

local function update_cwd(bufnr)
	local name = vim.api.nvim_buf_get_name(bufnr)
	if name == "" then
		return
	end

	local root = vim.fs.root(bufnr, markers)
	if not root or root == vim.fn.getcwd() then
		return
	end

	vim.cmd.cd(vim.fn.fnameescape(root))
end

vim.api.nvim_create_autocmd({ "VimEnter", "BufEnter" }, {
	group = vim.api.nvim_create_augroup("dc_root", { clear = true }),
	callback = function(args)
		update_cwd(args.buf)
	end,
})
