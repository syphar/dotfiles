stringy = require("stringy")

local app = os.getenv("HEROKU_APP")
if app then
	app = app:gsub("automagically%-", " ")
	app = app:gsub("medicaljobs%-", "MJ ")
	app = app:gsub("thermondo%-", "⭘ ")
else 
	app = ""
end

local netrc_file = assert(io.open(os.getenv("HOME") .. "/.netrc", "r"))
local last_machine_was_heroku = false
local account = ""
for line in netrc_file:lines() do
	local line = stringy.strip(line)
	local key, value = table.unpack(stringy.split(line, " "))

	if key == "machine" then
		if value == "api.heroku.com" then
			last_machine_was_heroku = true
		else
			last_machine_was_heroku = false
		end
	elseif key == "login" then
		if last_machine_was_heroku then
			account = value
			break
		end
	end
end
netrc_file:close()

if account == "denis@cornehl.org" then
	account = ""
elseif account == "denis.cornehl@thermondo.de" then
	account = ""
end

print(app .. " " .. account)
