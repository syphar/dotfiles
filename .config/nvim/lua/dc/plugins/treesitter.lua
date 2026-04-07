vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function(args)
		local bufnr = args.buf
		-- local filetype = vim.bo[bufnr].filetype
		-- local lang = vim.treesitter.language.get_lang(filetype) or filetype

		if vim.bo[bufnr].buftype ~= "" then
			return
		end

		vim.treesitter.start()
		vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.wo.foldmethod = "expr"
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup({
			auto_install = true,
		})
	end,
}
