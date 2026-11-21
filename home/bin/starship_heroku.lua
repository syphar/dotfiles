local get_app = function()
	return os.getenv("HEROKU_APP") or ""
end

local get_account = function()
	local netrc_file = assert(io.open(os.getenv("HOME") .. "/.netrc", "r"))
	local netrc = netrc_file:read("*all")
	netrc_file:close()

	local last_token = nil
	local last_machine_was_heroku = false

	for token in netrc:gmatch("[^%s]+") do
		if last_token == "machine" then
			last_machine_was_heroku = (token == "api.heroku.com")
		elseif last_token == "login" and last_machine_was_heroku then
			return token
		end
		last_token = token
	end
end

local app = get_app()
app = app:gsub("automagically%-", " ")
app = app:gsub("medicaljobs%-", "MJ ")
app = app:gsub("thermondo%-", "⭘ ")

local account = get_account()
if account == "denis@cornehl.org" then
	account = ""
elseif account == "denis.cornehl@thermondo.de" then
	account = ""
end

print(app .. " " .. account)
