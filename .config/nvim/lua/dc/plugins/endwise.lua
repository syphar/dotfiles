return {
	"RRethy/nvim-treesitter-endwise",
	event = "InsertEnter",
	config = function()
		require("nvim-treesitter.configs").setup({
			endwise = {
				enable = true,
			},
		})
	end,
}
