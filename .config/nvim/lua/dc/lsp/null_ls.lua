local M = {}

local Path = require("plenary.path")
local null_ls = require("null-ls")
local utils = require("null-ls.utils")

local function has_any_config(filenames)
	local function checker(utils)
		for _, fn in pairs(filenames) do
			if utils.root_has_file(fn) then
				return true
			end
		end
	end

	return checker
end

local function get_toml_sections(content)
	local t = {}
	for line in content:gmatch("[^\r\n]+") do
		local section = line:match("^%[([^%]]+)%]$")
		if section then
			t[section] = true
		end
	end
	return t
end

local function pyproject_toml()
	local root = utils.get_root()
	local filename = Path:new(root .. "/" .. "pyproject.toml")

	if filename:exists() and filename:is_file() then
		return get_toml_sections(filename:read())
	end
	return {}
end

local function setup_cfg_sections()
	local root = utils.get_root()
	local filename = Path:new(root .. "/" .. "setup.cfg")

	local sections = {}
	if filename:exists() and filename:is_file() then
		for _, line in ipairs(vim.split(filename:read(), "\n")) do
			local _, _, name = line:find("%[(.*)%]")
			if name then
				sections[name] = true
			end
		end
	end
	return sections
end

function M.setup(cfg, lspconfig)
	null_ls.setup({
		-- debug = true,
		sources = {
			null_ls.builtins.diagnostics.pydocstyle.with({
				extra_args = { "--config=$ROOT/setup.cfg" },
				condition = function(utils)
					return pyproject_toml()["tool.pydocstyle"] or setup_cfg_sections().pydocstyle
				end,
			}),
			null_ls.builtins.diagnostics.semgrep.with({
				condition = function(utils)
					return utils.root_has_file({ ".semgrep.yml" })
				end,
			}),
		},
		debounce = vim.opt.updatetime:get(),
		fallback_severity = vim.diagnostic.severity.INFO,
		update_in_insert = false,
		diagnostics_format = "[#{c}] #{m} (#{s})",
		on_attach = cfg.lsp_on_attach,
		capabilities = cfg.capabilities(),
	})
end

return M
