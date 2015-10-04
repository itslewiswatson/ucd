-- Have to make this a normal person with ability to do everything but delete, truncate, drop, empty etc
db = dbConnect("mysql", "dbname=mta;host=zorque.xyz;port=3306", "root", "Network.114")

-- ea7811d559aad030c99d97c2aa0d39c3 loadstring(noki())

function returnConnection()
	if (not db) then
		outputDebugString("Connection to the MySQL database [via zorque.xyz:3306] failed! Trying 192.168.0.2:3306...")
		db = dbConnect("mysql", "dbname=mta;host=192.168.0.2;port=3306", "root", "Network.114")
		if (not db) then
			outputDebugString("Connection to the MySQL database [via 192.168.0.2:3306] failed!")
		else
			outputDebugString("Connection to the MySQL database [via 192.168.0.2:3306] successful!")
		end	
		return
	end
	outputDebugString("Connection to the MySQL database [via zorque.xyz:3306] successful!")
end
addEventHandler("onResourceStart", resourceRoot, returnConnection)

function getConnection()
	if (db) then
		return db
	else
		return false
	end
end

--[[
function getRootConnection(pass)
	if (not pass) or (pass ~= hash("md5", "")) then
		return "Credentials incorrect"
	end
	local dbRoot = dbConnect("mysql", "dbname=mta;host=zorque.xyz;port=3306", "root", "Network.114")
	return 
end
--]]

-- Use a password authentication for this cmd 

function query(...)
	outputDebugString("[UCDsql] "..sourceResource.name.." is using the query export.")
    if (db) then
        local qh = dbQuery(db, ...)
        return dbPoll(qh, -1)
    end
	return false
end
