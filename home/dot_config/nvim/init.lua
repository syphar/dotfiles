local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ","
vim.loader.enable()

require("lazy").setup("dc.plugins", { change_detection = { notify = false, enabled = false } })

require("dc.vim_options")
require("dc.root")

vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		require("dc.lsp").lsp_setup()
	end,
})
require("dc.keyboard")
