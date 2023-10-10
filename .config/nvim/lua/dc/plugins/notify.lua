vim.notify = function(...)
	require("notify")(...)
end

return {
	"rcarriga/nvim-notify",
	lazy = true,
	opts = {
		render = "compact",
		stages = "static",
		timeout = 1000,
	},
}
