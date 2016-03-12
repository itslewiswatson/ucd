-------------------------------------------------------------------
--// PROJECT: Union of Clarity and Diversity
--// RESOURCE: UCDhousing
--// DEVELOPER(S): Lewis Watson (Noki)
--// DATE: 09/12/2015
--// PURPOSE: Process client housing requests on the server.
--// FILE: \server.lua [server]
-------------------------------------------------------------------

--[[
-- Maybe use a table of permissions for people using these houses
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
	--[27] = {1, 245.78, 305.12, 999.14},
	[27] = {5, 140.33, 1368.78, 1083.86},
	[28] = {6, 234.21, 1066.84, 1084.2},
	[29] = {9, 83.52, 1324.48, 1083.85},
	[30] = {10, 24.15, 1341.64, 1084.37},
	[31] = {15, 374.34, 1417.51, 1081.32},
	[32] = {1, 2525.0420, -1679.1150, 1015.4990},
}

db = exports.UCDsql:getConnection()

function fetchHouse(houseID)
	local houseTable = {}
	houseTable[1] = houseID
	houseTable[2] = getHouseData(houseID, "owner")
	houseTable[3] = getHouseData(houseID, "houseName")
	houseTable[4] = getHouseData(houseID, "initialPrice")
	houseTable[5] = getHouseData(houseID, "currentPrice")
	houseTable[6] = getHouseData(houseID, "boughtForPrice")
	houseTable[7] = getHouseData(houseID, "interiorID")
	houseTable[8] = getHouseData(houseID, "open")
	houseTable[9] = getHouseData(houseID, "sale")
	
	--triggerClientEvent("UCDhousing.createGUI", client, client, houseTable)
	triggerClientEvent(client, "UCDhousing.createGUI", client, houseTable)
end
addEvent("UCDhousing.fetchHouse.server", true)
addEventHandler("UCDhousing.fetchHouse.server", root, fetchHouse)

function leaveHouse(houseID)
	if (not client or not houseID) then return nil end
	-- if (client:getType() ~= "player") then return false end -- Don't need this check as client is always a player
	
	-- A check for house robbing
	if (houseID >= 30000) then
		houseID = houseID - 30000
	end
	
	-- Get the coordinates
	local hX, hY, hZ = getHouseData(houseID, "x"), getHouseData(houseID, "y"), getHouseData(houseID, "z")
	
	-- Check to see if we have the coordinates
	if (hX == nil or hY == nil or hZ == nil) then
		-- Shit, we don't. Some sort of bug. Let the player know and make sure that it's shown in debugscript
		outputChatBox("[UCDhousing] We could not get the coordinates for this house. Contact a developer as soon as possible.", client)
		outputDebugString("[UCDhousing] Player ("..client.name..") was not able to exit house with houseID = "..houseID)
		return
	end
	
	client:setDimension(0)
	client:setInterior(0)
	client:setPosition(hX, hY, hZ)
end
addEvent("UCDhousing.leaveHouse", true)
addEventHandler("UCDhousing.leaveHouse", root, leaveHouse)

function enterHouse(houseID, rob)
	if (not houseID) then return false end
	--if (getHouseData(houseID, "open") == 0) and (not ) then return false end -- The owner needs to enter, so disregard this
	
	local interiorID = getHouseData(houseID, "interiorID")
	local houseInt, hX, hY, hZ = unpack(intIDs[interiorID])
	source:setInterior(houseInt)
	if (rob) then
		source:setDimension(houseID + 30000)
	else
		source:setDimension(houseID + 30000)
	end
	source:setPosition(hX, hY, hZ + 1)
end
addEvent("UCDhousing.enterHouse", true)
addEventHandler("UCDhousing.enterHouse", root, enterHouse)

function purchaseHouse(houseID)
	-- Maybe we can add a thing to check their bank balance as well
	local accountName = exports.UCDaccounts:getPlayerAccountName(client)
	local housePrice, houseName = getHouseData(houseID, "currentPrice"), getHouseData(houseID, "houseName")
	local houseOwner = getHouseData(houseID, "owner")
	
	if (getHouseData(houseID, "sale") ~= 1) then
		exports.UCDdx:new(client, "You can't buy this house because it is no longer for sale", 255, 255, 0)
		return
	end
	
	client:takeMoney(housePrice)
	-- By default we'll make the player choose to open their house or not
	setHouseData(houseID, "owner", accountName)
	setHouseData(houseID, "boughtForPrice", housePrice)
	setHouseData(houseID, "sale", 0)
	setHouseData(houseID, "open", 0)

	exports.UCDdx:new(client, "Congratulations! You have bought '"..houseName.."' for $"..exports.UCDutil:tocomma(housePrice).."!", 0, 255, 0)
	triggerClientEvent("UCDhousing.closeGUI", client)
	createHouse(houseID, getHouseData(houseID, "*"))
	
	if (houseOwner ~= "UCDhousing") then
		--[[
		local qh = db:query("SELECT `id` FROM `accounts` WHERE `accName`=? LIMIT 1", houseOwner)
		local accountID = qh:poll(-1)[1].id
		--]]
		local ownerPlayer = Account(getHouseData(houseID, "owner")).player
		
		--outputChatBox("Owner player: "..tostring(ownerPlayer))
		if (ownerPlayer) then
			-- Give to the player in cash money and notify them
			ownerPlayer:giveMoney(housePrice)
			exports.UCDdx:new(ownerPlayer, client.name.. " has bought your house '"..getHouseData(houseID, "houseName").."' for $"..exports.UCDutil:tocomma(housePrice), 0, 255, 0)
			
			if (isPlayerInHouse(ownerPlayer) and ownerPlayer.dimension == houseID) then
				triggerEvent("UCDhousing.leaveHouse", ownerPlayer, houseID)
			end
		else
			-- Put in their bank account
		end
	end
	
	exports.UCDlogging:new(client, "UCDhousing", "Bought houseID ["..houseID.."]", price)
end
addEvent("UCDhousing.purchaseHouse", true)
addEventHandler("UCDhousing.purchaseHouse", root, purchaseHouse)

function setHousePrice(houseID, price)
	if (not houseID or not price) then return end
	if (exports.UCDaccounts:getPlayerAccountName(client) ~= getHouseData(houseID, "owner")) then
		exports.UCDdx:new(client, "You are not the owner of this house, you cannot set its price.", 255, 0, 0)
		return false
	end
	
	setHouseData(houseID, "currentPrice", tonumber(price))
	triggerClientEvent("UCDhousing.closeGUI", client)
	exports.UCDdx:new(client, "You have successfully set the price of your house to $"..tostring(exports.UCDutil:tocomma(exports.UCDutil:mathround(price))), 0, 255, 0)
	exports.UCDlogging:new(client, "UCDhousing", "Set price of houseID ["..houseID.."]", price)
end
addEvent("UCDhousing.setHousePrice", true)
addEventHandler("UCDhousing.setHousePrice", root, setHousePrice)

function toggleSale(houseID, state)
	if (exports.UCDaccounts:getPlayerAccountName(client) ~= getHouseData(houseID, "owner")) then
		exports.UCDdx:new(client, "You are not the owner of this house, you cannot toggle a sale.", 255, 0, 0)
		return false
	end
	
	if (state == true) then state = 1 else state = 0 end
	
	setHouseData(houseID, "sale", state)
	triggerClientEvent("UCDhousing.closeGUI", client)
	createHouse(houseID, getHouseData(houseID, "*"))
	
	if (state == 1) then
		exports.UCDdx:new(client, "You have successfully put your house up for sale!", 0, 255, 0)
	else
		exports.UCDdx:new(client, "Your house is no longer for sale.", 0, 255, 0)
	end
	
	if (state == 1) then state = true else state = false end
	exports.UCDlogging:new(client, "UCDhousing", "Toggled sale of ["..houseID.."]", tostring(state))
end
addEvent("UCDhousing.toggleSale", true)
addEventHandler("UCDhousing.toggleSale", root, toggleSale)

function toggleOpen(houseID, state)
	if (exports.UCDaccounts:getPlayerAccountName(client) ~= getHouseData(houseID, "owner")) then
		exports.UCDdx:new(client, "You are not the owner of this house, you cannot toggle open status.", 255, 0, 0)
		return false
	end
	
	if (state == true) then state = 1 else state = 0 end
	
	setHouseData(houseID, "open", state)
	triggerClientEvent("UCDhousing.closeGUI", client)
	
	if (state == 1) then
		exports.UCDdx:new(client, "You have successfully opened your house!", 0, 255, 0)
	else
		exports.UCDdx:new(client, "Your house is now closed. Only you can enter it.", 0, 255, 0)
	end
	
	if (state == 1) then state = true else state = false end
	exports.UCDlogging:new(client, "UCDhousing", "Toggled open of ["..houseID.."]", tostring(state))
end
addEvent("UCDhousing.toggleOpen", true)
addEventHandler("UCDhousing.toggleOpen", root, toggleOpen)

function sellHouseToBank(houseID)
	if (exports.UCDaccounts:getPlayerAccountName(client) ~= getHouseData(houseID, "owner")) then
		exports.UCDdx:new(client, "You are not the owner of this house, you cannot sell it to the bank.", 255, 0, 0)
		-- possibly put an anticheat notification here in debugscript
		return false
	end
	
	local rate, fluc = exports.UCDmarket:getHouseRate()
	local price = getHouseData(houseID, "boughtForPrice")
	
	setHouseData(houseID, "owner", "UCDhousing")
	setHouseData(houseID, "sale", 1)
	setHouseData(houseID, "open", 1)
	triggerClientEvent("UCDhousing.closeGUI", client)
	
	local jewmoney = math.floor(price * (rate / 100))
	
	client:giveMoney(jewmoney)
	exports.UCDdx:new(client, "You have sold your house to the bank for $"..tostring(exports.UCDutil:tocomma((jewmoney))).." which is "..tostring(rate).."% of what you bought it for!", 0, 255, 0)
end
addEvent("UCDhousing.sellHouseToBank", true)
addEventHandler("UCDhousing.sellHouseToBank", root, sellHouseToBank)

function warpToHouseExterior(plr, _, houseID)
	-- Check to see if everything is valid
	if (not houseID) then return end
	local houseID = tonumber(houseID)
	if (not exports.UCDadmin:isPlayerDeveloper(plr)) then return false end
	
	local hX, hY, hZ = getHouseData(houseID, "x"), getHouseData(houseID, "y"), getHouseData(houseID, "z")
	
	if hX ~= nil or hY ~= nil or hZ ~= nil then
		plr:setPosition(hX, hY, hZ)
		plr:setDimension(0)
		plr:setInterior(0)
	else
		outputDebugString("No house matching "..id)
		return false
	end
	
	exports.UCDlogging:new(plr, "UCDhousing", "Warped to ["..houseID.."]")
end
addCommandHandler("gotohouse", warpToHouseExterior)

-- Temporary fix for some annoying bugs [it is actually a sync issue with setHouseData] - will keep this here just in case
--[[
function modelloop()
	for i, v in pairs(housePickup) do
		if (v:getModel() == 1272 and getHouseData(i, "sale") == 1) then
			v:setModel(1273)
		elseif (v:getModel() == 1273 and getHouseData(i, "sale") ~= 1) then
			v:setModel(1272)
		end
	end
end
setTimer(modelloop, 5000, 0)
--]]
