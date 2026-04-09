vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function(args)
		local bufnr = args.buf
		local filetype = vim.bo[bufnr].filetype
		if vim.bo[bufnr].buftype ~= "" then
			return
		end

		local lang = vim.treesitter.language.get_lang(filetype)
		if lang and vim.tbl_contains(require("nvim-treesitter").get_available(), lang) then
			local installed = require("nvim-treesitter").get_installed("parsers")
			if not vim.tbl_contains(installed, lang) then
				require("nvim-treesitter").install(lang)
				return
			end
		end

		local ok = pcall(vim.treesitter.start)
		if ok == false then
			return
		end

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
		require("nvim-treesitter").setup()
	end,
}
