local cfg = require("lsp")
local util = require 'lspconfig.util'

-- based on https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#sumneko_lua
local sumneko_root_path = vim.fn.expand("$HOME/src/lua-language-server")
local sumneko_binary = sumneko_root_path .. "/bin/MacOS/lua-language-server"

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require("lspconfig").sumneko_lua.setup({
	cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
	root_dir = util.root_pattern(".git", ".null-ls-root"),
	single_file_support = false, -- manually disable for now
	capabilities = cfg.capabilities(),
	flags = cfg.global_flags(),
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				path = runtime_path,
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				preloadFileSize = 500,
			},
			telemetry = {
				enable = false,
			},
		},
	},
})
