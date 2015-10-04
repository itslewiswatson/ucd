-- This is used to make the actual houses

db = exports.UCDsql:getConnection()

function makeHouses(houseInfo)
	if (not houseInfo) then outputDebugString("no houseInfo") return false end
	
	local interiorID = houseInfo["interiorID"]
	local x = houseInfo["x"]
	local y = houseInfo["y"]
	local z = houseInfo["z"]
	local houseName = houseInfo["name"]
	local currentPrice = houseInfo["price"]
	local boughtForPrice = houseInfo["price"]
	local initialPrice = houseInfo["price"]
	
	-- owner, interiorID, x, y, z, houseName, currentPrice, boughtForPrice, initialPrice, sale, open
	if (type(houseName) ~= "string") then outputDebugString("houseName not string") return false end
	if (tonumber(x) == nil) or (tonumber(y) == nil) or (tonumber(z) == nil) then outputDebugString("coords are fucked") return false end
	if (tonumber(interiorID) == nil) or (tonumber(currentPrice) == nil) then outputDebugString("ones that are supposed to be numbers aren't") return false end
	
	dbExec(db, "INSERT INTO `housing` SET `owner`=?, `interiorID`=?, `x`=?, `y`=?, `z`=?, `houseName`=?, `currentPrice`=?, `boughtForPrice`=?, `initialPrice`=?, `sale`=?, `open`=?", "UCDhousing", interiorID, x, y, z, houseName, currentPrice, boughtForPrice, initialPrice, 1, 1)
	houseInfo = {}
	
	-- Try creating it right afterwards
	local qh1 = db:query("SELECT LAST_INSERT_ID() AS `houseID`")
	local houseID = qh1:poll(-1)[1].houseID
	outputDebugString(houseID)
	
	if (houseID ~= nil) then
		outputDebugString("You have successfully created a new house with houseID = "..houseID)
	else
		outputDebugString("Something fucked up")
		return
	end
	
	local qh3 = db:query("SELECT * FROM `housing` WHERE `houseID`=?", houseID)
	local localHouse = qh3:poll(-1)
	createHouse(houseID, localHouse[1], true) -- Create it and sync to all clients

end
addEvent("UCDhousing.makeHouse", true)
addEventHandler("UCDhousing.makeHouse", root, makeHouses)
