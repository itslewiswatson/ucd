--[[
-- DEV NOTES
-- The system works so the dimension you go in is the ID of your house, it's just the interior is dependent on the list below
-- We should use a function to get the amount of houses
--]]

local intIDs = {
	-- House interiors with locations
	[1] = {3, 235.22, 1188.84, 1080.25},
	[2] = {2, 225.13, 1240.07, 1082.14},
	[3] = {1, 223.2, 1288.84, 1082.13},
	[4] = {15, 328.03, 1479.42, 1084.43},
	[5] = {2, 2466.27, -1698.18, 1013.5},
	[6] = {5, 227.76, 1114.44, 1080.99},
	[7] = {15, 385.72, 1471.91, 1080.18},
	[8] = {7, 225.83, 1023.95, 1084},
	[9] = {8, 2807.61, -1172.83, 1025.57},
	[10] = {10, 2268.66, -1210.38, 1047.56},
	[11] = {3, 2495.79, -1694.12, 1014.74},
	[12] = {10, 2261.62, -1135.71, 1050.63},
	[13] = {8, 2365.2, -1133.07, 1050.87},
	[14] = {5, 2233.68, -1113.33, 1050.88},
	[15] = {11, 2283, -1138.13, 1050.89},
	[16] = {6, 2194.83, -1204.12, 1049.02},
	[17] = {6, 2308.73, -1210.88, 1049.02},
	[18] = {1, 2215.42, -1076.06, 1050.48},
	[19] = {2, 2237.74, -1078.89, 1049.02},
	[20] = {9, 2318.03, -1024.64, 1050.21},
	[21] = {6, 2333.03, -1075.38, 1049.02},
	[22] = {5, 1263.44, -785.63, 1091.9},
	[23] = {1, 245.98, 305.13, 999.14},
	[24] = {2, 269.09, 305.15, 999.14},
	[25] = {12, 2324.39, -1145.2, 1050.71},
	[26] = {5, 318.56, 1118.2, 1083.88},
	[27] = {1, 245.78, 305.12, 999.14},
	[28] = {5, 140.33, 1368.78, 1083.86},
	[29] = {6, 234.21, 1066.84, 1084.2},
	[30] = {9, 83.52, 1324.48, 1083.85},
	[31] = {10, 24.15, 1341.64, 1084.37},
	[32] = {15, 374.34, 1417.51, 1081.32},
	[33] = {1, 2525.0420, -1679.1150, 1015.4990},
}

db = exports.UCDsql:getConnection()

function leaveHouse(houseID)
	-- Do some obligatory checks
	if (not source) or (not houseID) then return nil end
	if (getElementType(source) ~= "player") then return false end
	
	-- Query for the coordinates
	local qh = dbQuery(db, "SELECT `x`,`y`,`z` FROM `housing_old` WHERE `houseID`=? LIMIT 1", houseID)
	local houseInfo = dbPoll(qh, -1)
	if (houseInfo) and (#houseInfo > 0) then
		exitX, exitY, exitZ = houseInfo[1].x, houseInfo[1].y, houseInfo[1].z
	else
		outputChatBox("[UCDhousing] We could not get the coordinates for this house. Contact a developer", source)
		outputDebugString("[UCDhousing] Player ("..getPlayerName(source)..") was not able to exit house with houseID = "..houseID)
	end
	setElementPosition(source, exitX, exitY, exitZ)
	setElementDimension(source, 0)
	setElementInterior(source, 0)
end
addEvent("UCDhousing.leaveHouse", true)
addEventHandler("UCDhousing.leaveHouse", root, leaveHouse)

function enterHouse(houseID, interiorID)
	if (not houseID) or (not interiorID) then return false end
	outputDebugString("Entered house - houseID: "..houseID)
	outputDebugString("interiorID = "..interiorID)
	
	local interiorID = tonumber(interiorID)
	local houseInt, hX, hY, hZ = unpack(intIDs[interiorID])
	setElementPosition(source, hX, hY, hZ + 1)
	setElementInterior(source, houseInt)
	setElementDimension(source, houseID)
end
addEvent("UCDhousing.enterHouse", true)
addEventHandler("UCDhousing.enterHouse", root, enterHouse)

function warpToHouseExterior(plr, cmd, houseID)
	-- Check to see if everything is valid
	if (not houseID) then return end
	--if (tonumber(houseID) == nil) then return false end
	if (type(houseID) ~= "number") then return false end
	
	-- Check if the player is an admin, specifically developer
	if (not exports.UCDadmin:isPlayerDeveloper(plr)) then return false end
	
	-- Checks completed, let's query
	local qh = dbQuery(db, "SELECT `x`,`y`,`z` FROM `housing_old` WHERE `houseID`=?", houseID)
	local result = dbPoll(qh, -1)

	if (result) and (#result > 0) then
		-- If we got the coords for the houseID, let's get them
		local hX, hY, hZ = result[1].x, result[1].y, result[1].z
		setElementPosition(plr, hX, hY, hZ)
	else
		-- No house with that ID (houseID == nil)
		outputDebugString("No house matching "..id)
		return false
	end
end
addCommandHandler("gotohouse", warpToHouseExterior)

-- We use this server-side function to create the GUI, as it triggers the client func. and passes the data (while performing necessary checks)
function createGUI(houseData)
	if (not houseData) then
		outputDebugString("Server: createGUI() - houseData var not passed or nil")
		return false
	end
	
	if (type(houseData) ~= "table") then
		outputDebugString("Server: createGUI() - type not table")
		return false
	end
	
	triggerClientEvent("UCDhousing.createGUI", client, houseData)
end

addEvent("getHouseDataTable", true)
function getHouseDataTable(houseID)
	if (not houseID) then return nil end
	
	local qh = dbQuery(db, "SELECT * FROM `housing_old` WHERE `houseID`=?", houseID)
	local result = dbPoll(qh, -1)
	
	-- Create the table
	-- We could use bandwidth optimization and assign the indexes as numbers instead of strings
	local houseData = {}
	houseData["houseID"] = houseID
	houseData["owner"] = result[1].owner
	houseData["streetName"] = result[1].street
	houseData["initPrice"] = result[1].initialPrice
	houseData["interiorID"] = result[1].interiorID
	houseData["open"] = result[1].open
	houseData["sale"] = result[1].sale
	
	-- Trigger createGUI on the server
	createGUI(houseData)
	
	-- We'll have to test whether we need to clear the table or not after this. Have to see how we go with resource usage. Probably a good idea.
end
addEventHandler("getHouseDataTable", root, getHouseDataTable)

--Backup
--[[
function lol()
	local file = fileCreate("oko.txt")
	if (file) then
		local query = dbQuery(db, "SELECT * FROM `housing`")
		local result = dbPoll(query, -1)
		if (#result > 0) then
			for i=1,#result do
				--outputChatBox(houses[i].id)
				--local housePickup = createPickup(result[i].x, result[i].y, result[i].z, 3, 1273, 0)
				--createBlipAttachedTo(housePickup)
				fileWrite(file, "["..i.."] = {"..result[i].interiorid..", "..result[i].x..", "..result[i].y..", "..result[i].z..", '"..result[i].housename.."', "..result[i].originalPrice.."},\n ")
			end
		end
		fileClose(file)
	end
end
addCommandHandler("hs", lol)
]]