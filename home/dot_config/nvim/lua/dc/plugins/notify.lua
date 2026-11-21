vim.notify = function(...)
	require("notify")(...)
end

return {
	"rcarriga/nvim-notify",
	lazy = true,
	opts = {
		render = "wrapped-compact",
		stages = "static",
		timeout = 1000,
	},
}
