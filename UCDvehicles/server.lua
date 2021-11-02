-------------------------------------------------------------------
--// PROJECT: Union of Clarity and Diversity
--// RESOURCE: UCDvehicles
--// DEVELOPER(S): Lewis Watson (Noki)
--// DATE: 09/12/2015
--// PURPOSE: Handling vehicles on the server.
--// FILE: \server.lua [server]
-------------------------------------------------------------------

-- DEV NOTES:
-- Find efficient way to update gridlist [afaik DONE - still keeping just in case]
-- Avoid ipairs as much as possible as the table will not always have perfect pairs

-- vehicles table [always loaded]
-- [vehicleID] = {owner, [r, g, b], } -- It's just from SQL

-- player's vehicles [loaded when the player logs in, and cleared when the player leaves - use this to check how many vehicles a player has]
-- Will need to use table.remove when a vehicle is deleted, or sold
-- [owner] = {vehicleID, vehicleID, vehicleID} -- onPlayerLogin => SELECT vehicleID FROM vehiclesTable WHERE ownerID=exports.UCDaccounts:getPlayerAccountID(source) => store that in lua table

-- table for spawned in vehicles -- only be done when vehicle is spawned in
-- [vehicleID] = vehicle:element -- [idToVehicle]

-- sql
-- vehicleID, ownerID, [x, y, z], rotation, [r, g, b], plates, health, fuel, 
-- Add more columns for upgrading the vehicle (secondary colour, nitro, wheels etc)

db = exports.UCDsql:getConnection()
idToVehicle = {}
activeVehicles = {}
playerVehicles = {}

local recLocs = {
	--[vehicleType] = {x, y, z, rot}
	["Plane"] = {
		{-1653.6453, -641.566, 14.1484, 280},
		{1983.8809, -2621.5383, 13.5469, 0},
		{1523.3285, 1775.4574, 10.8203, 180},
	},
	["Helicopter"] = {
		{-1613.2408, -649.3304, 14.1484, 200}, 
		{-1494.9352, -558.2144, 14.144, 206}, 
		{1339.6415, 1614.3076, 10.820, 270},
		{1280.5967, 1536.5463, 10.8203, 270},
		{1730.1738, -2546.8081, 13.5469, 0},
	},
	["Boat"] = {
		{2257.1284, 524.9557, 0.5, 180},
		{170.4941, 186.6853, 0.5, 0},
		{929.5446, -1927.4025, 0.5, 150},
		{-2986.4221, 525.1015, 0.5, 0},
	},
	["General"] = {
		{1745.9404, 2013.3558, 11, 270},
		{1729.0573, 2012.6602, 11, 90},
		{1730.1738, -2546.8081, 13.5469, 0},
		{1804.8962, -2547.7786, 13.5469, 0},
		{1943.8475, -2545.2771, 13.5469, 0},
		{-1926.9241, 262.1635, 41.0391, 180},
		{1704.8297, -1059.6635, 23.9063, 270},
		{1628.0961, -1095.7555, 23.9063, 270},
	},
}

function getPlayerSpecificIDToVehicle(plr)
	local plr_idToVehicle = {}
	for i, v in pairs(vehicles) do
		if v.owner == plr.account.name then
			if idToVehicle[i] then
				plr_idToVehicle[i] = idToVehicle[i]
			end
		end
	end
	return plr_idToVehicle
end

function syncIdToVehicle(refreshGridlist)
	if not refreshGridlist then
		triggerClientEvent(source, "UCDvehicles.syncIdToVehicle", source, getPlayerSpecificIDToVehicle(source))
	else
		triggerClientEvent(source, "UCDvehicles.syncIdToVehicle", source, getPlayerSpecificIDToVehicle(source), true)
	end
	
	-- This part synced the whole table, let's only sync selected bits
	--[[
	if not refreshGridlist then
		triggerClientEvent("UCDvehicles.syncIdToVehicle", source, source, idToVehicle)
	else
		triggerClientEvent("UCDvehicles.syncIdToVehicle", source, source, idToVehicle, true)
	end
	--]]
end
addEvent("UCDvehicles.getIdToVehicleTable", true)
addEventHandler("UCDvehicles.getIdToVehicleTable", root, syncIdToVehicle)

function onPlayerQuit()
	if (not playerVehicles[source]) then
		return
	end
	for _, vehicleID in pairs(playerVehicles[source]) do
		if (idToVehicle[vehicleID]) then
			triggerEvent("UCDvehicles.hideVehicle", resourceRoot, vehicleID)
		end
	end
	if (activeVehicles[source]) then
		activeVehicles[source] = nil
	end
	playerVehicles[source] = nil
end
addEventHandler("onPlayerQuit", root, onPlayerQuit)

-- Database shit
function loadPlayerVehicles(plr)
	if not plr then plr = client end -- Warning: You should use the global variable client serverside instead of passing the localPlayer by parameter or source. Otherwise event faking (passing another player instead of the localPlayer) would be possible. More information at addEventHandler
	playerVehicles[plr] = {}
	--local acccountID = exports.UCDaccounts:getPlayerAccountID(plr)
	for i, vehicleData in pairs(vehicles) do
		if (vehicleData.owner == plr.account.name) then
			table.insert(playerVehicles[plr], i)
		end
	end
	triggerClientEvent(plr, "UCDvehicles.playerVehiclesTable", plr, playerVehicles[plr])
end
addEvent("UCDvehicles.loadPlayerVehicles", true)
addEventHandler("UCDvehicles.loadPlayerVehicles", root, loadPlayerVehicles)
addEventHandler("onPlayerLogin", root, function () loadPlayerVehicles(source) end)
--addEventHandler("onResourceStart", resourceRoot, function () for _, v in pairs(Element.getAllByType("player")) do loadPlayerVehicles(v) end end) -- Now handled in vehicleData.slua

-- If the resource is to stop, we need to save all the vehicles
-- That is why there are checks for 'client' in hideVehicle
function saveAllVehicles()
	for i, _ in pairs(idToVehicle) do
		if (idToVehicle[i]) then
			triggerEvent("UCDvehicles.hideVehicle", resourceRoot, i, true, false)
		end
	end
end
addEventHandler("onResourceStop", resourceRoot, saveAllVehicles)

function purchase(plr, model, xyz, rot, colour, price)
	local _xyz = toJSON({xyz.x, xyz.y, xyz.z})
	local _colour = toJSON(colour)
	
	--outputDebugString(_colour)
	--outputDebugString(price)
	
	plr.money = plr.money - price
	
	db:exec("INSERT INTO `vehicles` SET `model`=?, `owner`=?, `xyz`=?, `rotation`=?, `colour`=?, `plates`=?, `health`=?, `fuel`=?, `price`=?",
		model,
		plr.account.name,
		_xyz,
		rot,
		_colour,
		"UCD",
		1000,
		100,
		price
	)
	local vehicleID = db:query("SELECT Max(`vehicleID`) AS `id` FROM `vehicles` WHERE `owner`=?", plr.account.name):poll(-1)[1].id
	vehicles[vehicleID] = {["model"] = model, ["owner"] = plr.account.name, ["xyz"] =  _xyz, ["rotation"] = rot, ["colour"] = _colour, ["plates"] = "UCD", ["health"] = 1000, ["fuel"] = 100, ["price"] = price}
	
	syncSpecific(plr, vehicleID, vehicles[vehicleID])
	
	if (activeVehicles[plr]) then
		if (#activeVehicles[plr] >= 2) then
			hideVehicle(activeVehicles[plr][1]:getData("vehicleID"), true, true)
		end
	else
		activeVehicles[plr] = {}
	end
	
	
	local vehicle = Vehicle(model, xyz)
	vehicle:setRotation(0, 0, rot)
	vehicle:setColor(unpack(colour))
	vehicle:setData("vehicleID", vehicleID)
	vehicle:setData("owner", plr.name)
	table.insert(activeVehicles[plr], vehicle)
	idToVehicle[vehicleID] = vehicle
	triggerClientEvent(plr, "UCDvehicles.syncIdToVehicle", plr, getPlayerSpecificIDToVehicle(plr))
	
	return vehicle
end

function spawnVehicle(vehicleID)
	if (not vehicleID) then return end
	
	-- If the selected vehicle is already in the world
	if (idToVehicle[vehicleID]) then
		exports.UCDdx:new(client, "That vehicle is already spawned in", 255, 0, 0)
		return false
	end
	
	-- If the player has more than 2 active vehicles in the world
	if (activeVehicles[client] and #activeVehicles[client] >= 2) then
		exports.UCDdx:new(client, "You cannot have more than 2 vehicles in the world at one time", 255, 0, 0)
		return false
	end
	
	-- Get the car's data form the table
	local r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4 = unpack(fromJSON(getVehicleData(vehicleID, "colour"))) -- Get the colour data
	local model = getVehicleData(vehicleID, "model") -- Get the vehicle model
	local vX, vY, vZ = unpack(fromJSON(getVehicleData(vehicleID, "xyz"))) -- Get the vehicle's position
	local rot = getVehicleData(vehicleID, "rotation") -- Get its rotation
	
	-- Spawn the vehicle and set it's properties
	local vehicle = Vehicle(model, vX, vY, vZ + 0.5, 0, 0, rot)
	vehicle:setColor(r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4)
	vehicle:setData("owner", client.name)
	vehicle:setData("vehicleID", vehicleID)
	vehicle:setRotation(0, 0, vehicles[vehicleID].rotation)
	
	if (getVehicleData(vehicleID, "health") <= 250) then
		-- So it doesn't blow on spawning
		-- Add future checks to see if it's in LV or not
		vehicle:setHealth(250)
		vehicle:setEngineState(false)
		vehicle:setDamageProof(true)
	else
		vehicle:setHealth(vehicles[vehicleID].health)
	end
	
	-- Insert necessities in the tables
	idToVehicle[vehicleID] = vehicle
	if (not activeVehicles[client]) then
		activeVehicles[client] = {}
	end
	table.insert(activeVehicles[client], vehicle)
	
	-- Debug purposes while resource is still being made
	----if (exports.UCDadmin:isPlayerOwner(client)) then
	--	vehicle.position = Vector3(client.position.x, client.position.y, client.position.z + 1)
	--	vehicle.rotation = Vector3(0, 0, client.rotation.z)
	--	client:warpIntoVehicle(vehicle)
	--end
	
	exports.UCDdx:new(client, "You have successfully spawned your "..vehicle:getName(), 0, 255, 0)
	triggerClientEvent(client, "UCDvehicles.syncIdToVehicle", client, getPlayerSpecificIDToVehicle(client)) -- Maybe change this to only sync to the owner
	triggerClientEvent(client, "UCDvehicles.updateVehicleGrid", client, vehicleID)
	
	syncSpecific(client, vehicleID, vehicles[vehicleID])
end
addEvent("UCDvehicles.spawnVehicle", true)
addEventHandler("UCDvehicles.spawnVehicle", root, spawnVehicle)

function hideVehicle(vehicleID, tosync, sendToClient)
	if (not vehicleID) then return nil end
	local vehicle = idToVehicle[vehicleID]
	if (not vehicle or vehicle:getData("vehicleID") ~= vehicleID) then return end
	
	if (client and exports.UCDutil:getElementSpeed(vehicle) >= 100) then
		exports.UCDdx:new(client, "You can't hide your vehicle when it's travelling faster than 100km/h!", 255, 0, 0)
		return false
	end
	
	local health = vehicle:getHealth()
	local pos = vehicle:getPosition()
	local rot = vehicle:getRotation()	
	
	if (tosync ~= false) then
		setVehicleData(vehicleID, "rotation", rot.z)
		setVehicleData(vehicleID, "xyz", toJSON({pos.x, pos.y, pos.z}))
		setVehicleData(vehicleID, "health", health)
		setVehicleData(vehicleID, "colour", toJSON({vehicle:getColor(true)}))
	end
	
	idToVehicle[vehicleID] = nil
	
	if (client and activeVehicles[client]) then
		for k, v in pairs(activeVehicles[client]) do
			if (v == vehicle) then
				table.remove(activeVehicles[client], k) -- Remove it at its current index
				break
			end
		end
	end
	
	-- Loop through steats, check for players and manually eject them
	for _, occupant in pairs(vehicle:getOccupants()) do
		occupant:removeFromVehicle()
		if (occupant.type == "player") then
			if (occupant.account.name ~= getVehicleData(vehicleID, "owner")) then
				exports.UCDdx:new(occupant, "You have been ejected from the vehicle as it has been hidden.", 255, 0, 0)
			end
		end
	end
	
	-- This is our custom event for when a vehicle is hidden
	triggerEvent("onVehicleHidden", vehicle)
	
	local ownerPlayer = Player(vehicle:getData("owner"))
	if (ownerPlayer and ownerPlayer.type == "player" and sendToClient == true) then
		triggerClientEvent(ownerPlayer, "UCDvehicles.syncIdToVehicle", resourceRoot, getPlayerSpecificIDToVehicle(ownerPlayer))
		triggerClientEvent(ownerPlayer, "UCDvehicles.onVehicleHidden", ownerPlayer, vehicleID)
		triggerClientEvent(ownerPlayer, "UCDvehicles.updateVehicleGrid", ownerPlayer, vehicleID)
		syncSpecific(ownerPlayer, vehicleID, vehicles[vehicleID])
		exports.UCDdx:new(ownerPlayer, "Your "..Vehicle.getNameFromModel(vehicles[vehicleID].model).." has been hidden", 0, 255, 0)
	end
	
	vehicle:destroy()
	
	-- We check for client because the onResourceStop event saves all vehicles by triggering this one and we don't want lots of client events being triggered at once, especially when the resource is going to stop anyway
	
	-- We need this here for if someone sells their vehicle
	-- triggerClientEvent(Element.getAllByType("player"), "UCDvehicles.syncIdToVehicle", resourceRoot, idToVehicle)
end
addEvent("UCDvehicles.hideVehicle", true)
addEventHandler("UCDvehicles.hideVehicle", root, hideVehicle)

function getClosestRecoveryLocation(vehicleType, x, y, z)
	local distances = {}
	local points = {}
	for i = 1, #recLocs[vehicleType] do
		local distance_ = getDistanceBetweenPoints3D(x, y, z, recLocs[vehicleType][i][1], recLocs[vehicleType][i][2], recLocs[vehicleType][i][3])
		table.insert(distances, distance_)
		points[distance_] = Vector4(recLocs[vehicleType][i][1], recLocs[vehicleType][i][2], recLocs[vehicleType][i][3], recLocs[vehicleType][i][4])
	end
	table.sort(distances) -- Sort the table to find the smallest distance	
	return points[distances[1]]
end

function recoverVehicle(spawnOptions)
	local vehicleID = spawnOptions[1]
	local premiumRecovery = spawnOptions[2]

	local vehicleEle
	local vehicleType = _getVehicleType(vehicleID)
	local smallest
	
	if (idToVehicle[vehicleID]) then
		vehicleEle = idToVehicle[vehicleID]
		
		for _, occupant in ipairs(vehicleEle:getOccupants()) do
			occupant:removeFromVehicle()
			if (occupant.type == "player") then
				exports.UCDdx:new(occupant, "You have been ejected from the vehicle as it has been recovered", 255, 0, 0)
			end
		end

		--if (exports.UCDadmin:isPlayerOwner(client)) then
		if (premiumRecovery) then	
			if (client.vehicle) then
				exports.UCDdx:new(client, "You can't recover a vehicle to yourself while you're already in one", 255, 0, 0)
				return
			end

			if (client.money < 25000) then
				exports.UCDdx:new(client, "You don't have enough money to recover this vehicle to you", 255, 0, 0)
				return
			end
			
			local _, _, r = getElementRotation(client)
			local pos 
			pos = client.matrix.position + client.matrix.forward * 6
			pos = pos + client.matrix.up
			vehicleEle.position = pos
			vehicleEle:setRotation(0, 0, r + 90)
			smallest = Vector4(vehicleEle.position.x, vehicleEle.position.y, vehicleEle.position.z, r + 90)
			
			exports.UCDdx:new(client, "Your "..getVehicleNameFromModel(getVehicleData(vehicleID, "model")).." has been recovered just in front of you!", 0, 255, 0)
			
			client.money = client.money - 25000
		else
			-- Loop through to find the smallest distance
			smallest = getClosestRecoveryLocation(vehicleType, vehicleEle.position.x, vehicleEle.position.y, vehicleEle.position.z)
			vehicleEle:setPosition(smallest.x, smallest.y, smallest.z + 2)
			vehicleEle:setRotation(Vector3(0, 0, smallest.w))
			exports.UCDdx:new(client, "Your "..vehicleEle.name.." has been recovered to "..getZoneName(smallest.x, smallest.y, smallest.z).."!", 0, 255, 0)
		end
	else
		local last = Vector3(unpack(fromJSON(getVehicleData(vehicleID, "xyz"))))
		smallest = getClosestRecoveryLocation(vehicleType, last.x, last.y, last.z)
		exports.UCDdx:new(client, "Your "..getVehicleNameFromModel(getVehicleData(vehicleID, "model")).." has been recovered to "..getZoneName(smallest.x, smallest.y, smallest.z).."!", 0, 255, 0)
	end

	syncSpecific(client, vehicleID, vehicles[vehicleID])
	setVehicleData(vehicleID, "xyz", toJSON({smallest.x, smallest.y, smallest.z + 1}))
	setVehicleData(vehicleID, "rotation", smallest.w)
	triggerClientEvent(client, "UCDvehicles.updateVehicleGrid", client, vehicleID)
end
addEvent("UCDvehicles.recoverVehicle", true)
addEventHandler("UCDvehicles.recoverVehicle", root, recoverVehicle)

function sellVehicle(vehicleID)
	-- Hide the vehicle, but don't sync it to the database
	if (idToVehicle[vehicleID]) then
		triggerEvent("UCDvehicles.hideVehicle", resourceRoot, vehicleID, false, true)
	end
	for _, v in ipairs(playerVehicles[client]) do
		if (v == vehicleID) then
			table.remove(playerVehicles[client], v)
			break
		end
	end
	local price = getVehicleData(vehicleID, "price")
	if (not price) then
		exports.UCDdx:new(client, "You can't sell your vehicle - please report this bug and include 'vehicleID = "..tostring(vehicleID).."'", 255, 0, 0)
	end
	
	local rate = root:getData("vehicles.rate")
	local newPrice = math.floor(price * (rate / 100))
	exports.UCDdx:new(client, "You have successfully sold your "..getVehicleNameFromModel(getVehicleData(vehicleID, "model")).." for $"..exports.UCDutil:tocomma(newPrice), 0, 255, 0)
	client:giveMoney(newPrice)
	vehicles[vehicleID] = nil
	db:exec("DELETE FROM `vehicles` WHERE `vehicleID`=?", vehicleID)
	-- Remove it from SQL, sync to player
	--triggerEvent("UCDvehicles.requestVehicleTableSync", client)
	triggerEvent("UCDvehicles.getIdToVehicleTable", client, true)
	--forceSync(client)
	syncVehicleTable(client)
end
addEvent("UCDvehicles.sellVehicle", true)
addEventHandler("UCDvehicles.sellVehicle", root, sellVehicle)

function toggleLock(enteringPlayer)
	-- On duty admins are allowed to jack a player's car
	if (not exports.UCDteams:isPlayerInTeam(enteringPlayer, "Admins") or enteringPlayer:getName() ~= source:getData("owner")) then -- If they aren't an admin or the owner [debug]
		exports.UCDdx:new(enteringPlayer, "This "..source.name..", owned by "..source:getData("owner")..", is locked.", 255, 0, 0)
		cancelEvent()
	end
end
function toggleLock_(vehicleID)
	local vehicleEle = idToVehicle[vehicleID]
	if (not vehicleEle or not isElement(vehicleEle)) then
		return false
	end
	if (#getEventHandlers("onVehicleStartEnter", vehicleEle) > 0) then
		removeEventHandler("onVehicleStartEnter", vehicleEle, toggleLock)
		vehicleEle:setData("locked", false)
		exports.UCDdx:new(client, "You have successfully unlocked your "..vehicleEle.name, 0, 255, 0)
	else
		vehicleEle:setData("locked", true)
		addEventHandler("onVehicleStartEnter", vehicleEle, toggleLock)
		exports.UCDdx:new(client, "You have successfully locked your "..vehicleEle.name, 0, 255, 0)
	end
end
addEvent("UCDvehicles.toggleLock", true)
addEventHandler("UCDvehicles.toggleLock", root, toggleLock_)
