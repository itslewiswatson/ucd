-- Have to make this a normal person with ability to do everything but delete, truncate, drop, empty etc
db = dbConnect("mysql", "dbname=mta;host=zorque.xyz;port=3306", "root", "Network.114")

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
	end
	return false
end
