--comment/uncomment on gcc
--TODO: add keys={} with the needed mappings?
return {
	"numToStr/Comment.nvim",
	event = "VeryLazy",
	opts = {
		padding = true,
		ignore = "^$", -- ignore empty lines
		mappings = {
			---operator-pending mapping
			---Includes `gcc`, `gcb`, `gc[count]{motion}` and `gb[count]{motion}`
			basic = true,
			---extra mapping
			---Includes `gco`, `gcO`, `gcA`
			extra = true,
			---extended mapping
			---Includes `g>`, `g<`, `g>[count]{motion}` and `g<[count]{motion}`
			-- extended = true,
		},
	},
}
