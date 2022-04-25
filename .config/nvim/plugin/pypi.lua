local Job = require("plenary.job")
local curl = require("plenary.curl")

local custom_ns = vim.api.nvim_create_namespace("pypi.nvim")

local endpoint = "https://pypi.org/pypi/%s/json"
local useragent = vim.fn.shellescape("pypi.nvim (https://github.com/syphar/pypi.nvim)")
local json_decode_opts = { luanil = { object = true, array = true } }
local cache = {}

local parse_version = function(s)
	local pieces = {}
	for _, p in ipairs(vim.split(s, ".", { plain = true })) do
		if not string.match(p, "^%d+$") then
			return nil
		end
		local n = tonumber(p)
		if n == nil then
			return nil
		else
			table.insert(pieces, n)
		end
	end
	while #pieces < 4 do
		table.insert(pieces, 0)
	end
	return pieces
end

local update_package = function(buf, releases, version, i)
	local latest_version = nil
	local latest_version_parsed = nil
	for v, r in pairs(releases) do
		local parsed = parse_version(v)
		if parsed ~= nil and #r > 0 and r[1].yanked == false then
			if
				latest_version_parsed == nil
				or parsed[1] > latest_version_parsed[1]
				or (parsed[1] == latest_version_parsed[1] and parsed[2] > latest_version_parsed[2])
				or (parsed[1] == latest_version_parsed[1] and parsed[2] == latest_version_parsed[2] and parsed[3] > latest_version_parsed[3])
				or (
					parsed[1] == latest_version_parsed[1]
					and parsed[2] == latest_version_parsed[2]
					and parsed[3] == latest_version_parsed[3]
					and parsed[4] > latest_version_parsed[4]
				)
			then
				latest_version = v
				latest_version_parsed = parsed
			end
		end
	end
	local fmt, hi
	if latest_version == version then
		fmt = "   %s"
		hi = "DiagnosticVirtualTextInfo"
	else
		fmt = "   %s"
		hi = "DiagnosticVirtualTextWarn"
	end

	vim.schedule(function()
		vim.api.nvim_buf_clear_namespace(buf, custom_ns, i - 1, i)
		vim.api.nvim_buf_set_extmark(buf, custom_ns, i - 1, -1, {
			virt_text = { { string.format(fmt, latest_version), hi } },
			virt_text_pos = "eol",
			hl_mode = "combine",
		})
	end)
end

local fetch_package = function(buf, package, version, i)
	curl.get(string.format(endpoint, package), {
		callback = function(out)
			local success, result = pcall(vim.json.decode, out.body, json_decode_opts)
			if not success then
				return
			end
			cache[package] = result.releases
			update_package(buf, result.releases, version, i)
		end,
	})
end

local update = function()
	local buf = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_clear_namespace(buf, custom_ns, 0, -1)

	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

	for i, l in ipairs(lines) do
		local _, _, package, _, version = string.find(l, "([^%[%]=]+)%[([^%[%]]+)%]==([%.%d]+).*")

		if not package then
			_, _, package, version = string.find(l, "([^=]+)==([%.%d]+).*")
		end
		if package then
			if cache[package] then
				update_package(buf, cache[package], version, i)
			else
				fetch_package(buf, package, version, i)
			end
		end
	end
end

local group = vim.api.nvim_create_augroup("Pypi", {})
vim.api.nvim_create_autocmd({ "BufRead", "TextChanged" }, {
	group = group,
	pattern = "*",
	callback = function()
		if vim.bo.filetype == "requirements" then
			update()
		end
	end,
})
