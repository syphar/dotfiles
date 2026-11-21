local M = {}

function M.config(cfg)
	return cfg.base({
		cmd = { "elixir-ls" },
	})
end

return M
