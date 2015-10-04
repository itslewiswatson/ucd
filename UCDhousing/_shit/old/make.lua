-- This is used to make the actual houses

db = exports.UCDsql:getConnection()

function makeHouses()
	-- owner, interiorID, x, y, z, houseName, currentPrice, boughtForPrice, initialPrice, sale, open
	if (type(houseName) ~= "string") then return false end
	if (type(x) ~= "number") or (type(y) ~= "number") or (type(z) ~= "number") or (type(currentPrice) ~= "number") or (type(boughtForPrice) ~= "number")
	or (type(initialPrice) ~= "number") or (type(interiorID) ~= "number") then return false end
	
	dbExec(db, "INSERT INTO `housing` VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", "UCDhousing", interiorID, x, y, z, houseName, currentPrice, boughtForPrice, initialPrice, 1, 1)
end
addEvent("UCDhousing.makeHouse", true)
addEventHandler("UCDhousing.makeHouse", root, makeHouses)
