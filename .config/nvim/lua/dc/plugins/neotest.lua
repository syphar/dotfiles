return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		{ "nvim-neotest/neotest-python", lazy = true },
		{ "nvim-neotest/neotest-go", lazy = true },
		{ "rouge8/neotest-rust", lazy = true },
	},
	config = function()
		require("neotest").setup({
			-- status = { virtual_text = true },
			-- output = { open_on_run = true },
			adapters = {
				require("neotest-python")({
					-- args = { "--log-level", "DEBUG" },
					runner = "pytest",
					-- Returns if a given file path is a test file.
					-- NB: This function is called a lot so don't perform any heavy tasks within it.
					-- is_test_file = function(file_path)
					-- 	vim.notify(file_path)
					-- 	return true
					-- end,
					-- !!EXPERIMENTAL!! Enable shelling out to `pytest` to discover test
					-- instances for files containing a parametrize mark (default: false)
					pytest_discover_instances = true,
				}),
				require("neotest-rust")({
					-- args = { "--no-capture" },
				}),
				require("neotest-go")({
					experimental = {
						test_table = true,
					},
					-- args = { "-count=1", "-timeout=60s" },
				}),
			},
		})
		vim.diagnostic.config({ virtual_text = true })
	end,
	keys = {
		{
			"<leader>tn",
			function()
				require("neotest").summary.open()
				require("neotest").run.run()
			end,
		},
		{
			"<leader>tf",
			function()
				require("neotest").summary.open()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
		},
		{
			"<leader>tl",
			function()
				require("neotest").summary.open()
				require("neotest").run.run_last()
			end,
		},
		{
			"<leader>tT",
			function()
				require("neotest").summary.open()
				require("neotest").run.run(vim.loop.cwd())
			end,
		},
		{
			"<leader>ts",
			function()
				require("neotest").summary.toggle()
			end,
		},
		{
			"<leader>to",
			function()
				require("neotest").output.open({ enter = true, auto_close = true })
			end,
		},
		{
			"<leader>tO",
			function()
				require("neotest").output_panel.toggle()
			end,
		},
		{
			"<leader>tS",
			function()
				require("neotest").run.stop()
			end,
		},
	},
}
