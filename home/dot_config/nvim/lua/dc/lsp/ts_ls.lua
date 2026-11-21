local M = {}

function M.config(cfg)
	return cfg.base({
		cmd = { "/opt/homebrew/bin/node", "/opt/homebrew/bin/typescript-language-server", "--stdio" },
	})
end

return M
