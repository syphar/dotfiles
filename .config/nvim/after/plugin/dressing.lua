require("dressing").setup({
	input = {
		-- Set to false to disable the vim.ui.input implementation
		enabled = true,

		-- Default prompt string
		default_prompt = "➤ ",

		-- When true, <Esc> will close the modal
		insert_only = true,

		-- These are passed to nvim_open_win
		anchor = "SW",
		relative = "cursor",
		row = 0,
		col = 0,
		border = "rounded",

		-- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
		prefer_width = 40,
		max_width = nil,
		min_width = 20,

		-- Window transparency (0-100)
		winblend = 0,
		-- Change default highlight groups (see :help winhl)
		winhighlight = "",

		-- see :help dressing_get_config
		get_config = nil,
	},
	select = {
		-- Set to false to disable the vim.ui.select implementation
		enabled = true,

		-- Priority list of preferred vim.select implementations
		backend = { "telescope" },

		-- Options for telescope selector
		telescope = {
			-- can be 'dropdown', 'cursor', or 'ivy'
			theme = "dropdown",
		},

		-- Used to override format_item. See :help dressing-format
		format_item_override = {},

		-- see :help dressing_get_config
		get_config = nil,
	},
})
