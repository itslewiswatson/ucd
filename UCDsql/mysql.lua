local db
local defaultJSON = toJSON({host = "", port = "", usr = "", passwd = "", dbname = ""})

-- Load the credentials in from credentials.json
local f = File("credentials.json")
if (not f) then
	f = File.new("credentials.json")
	f:write(defaultJSON, true) -- Must select a prettyType after 1.6 (https://wiki.multitheftauto.com/wiki/ToJSON)
	f:flush()
end
f.pos = 0
local credentials = fromJSON(f:read(f.size))
f:close()

local dbname = credentials.dbname
local host = credentials.host
local usr = credentials.usr
local passwd = credentials.passwd
local port = credentials.port

db = Connection("mysql", "dbname="..dbname..";host="..host..";port="..port, usr, passwd)

function returnConnection()
	if (db) then
		outputDebugString("Connection to the MySQL established")
		return
	end
	outputDebugString("Couldn't connect to MySQL")
end
addEventHandler("onResourceStart", resourceRoot, returnConnection)

function getConnection()
	if (db) then
		return db
	end
	return false
end
