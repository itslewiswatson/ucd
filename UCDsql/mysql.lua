-- Have to make this a normal person with ability to do everything but delete, truncate, drop, empty etc
local dbname = "mta"
local host = "noki.zorque.xyz"
local usr = "root"
local passwd = "Amazing69"

db = Connection("mysql", "dbname="..dbname..";host="..host..";port=3306", usr, passwd)

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

function getForumDatabase()
	return forum
end
