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

local recoveryLocs = {
	--[vehicleType] = {x, y, z, rot}
	["Plane"] = {{0, 0, 5, 0}, {0, 0, 5, 0}, {0, 0, 5, 0}},
	["Helicopter"] = {{0, 0, 5, 0}, {0, 0, 5, 0}, {0, 0, 5, 0}},
	["Boat"] = {{0, 0, 5, 0}, {0, 0, 5, 0}, {0, 0, 5, 0}},
	["Bike"] = {{0, 0, 5, 0}, {0, 0, 5, 0}, {0, 0, 5, 0}},
	["General"] = {{0, 0, 5, 0}, {0, 0, 5, 0}, {0, 0, 5, 0}},
}

function syncIdToVehicle()
	triggerClientEvent("UCDvehicleSystem.syncIdToVehicle", client, client, idToVehicle)
end
addEvent("UCDvehicleSystem.getIdToVehicleTable", true)
addEventHandler("UCDvehicleSystem.getIdToVehicleTable", root, syncIdToVehicle)

function onPlayerQuit()
	if (not playerVehicles[source]) then
		return
	end
	for _, vehicle in pairs(playerVehicles[source]) do
		if (idToVehicle[vehicle]) then
			triggerEvent("UCDvehicleSystem.hideVehicle", resourceRoot, vehicle)
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
	local acccountID = exports.UCDaccounts:getPlayerAccountID(plr)
	for i, v in pairs(vehicles) do
		if v.ownerID == acccountID then
			table.insert(playerVehicles[plr], i)
		end
	end
	triggerClientEvent(plr, "UCDvehicleSystem.playerVehiclesTable", plr, playerVehicles[plr])
end
addEvent("UCDvehicleSystem.loadPlayerVehicles", true)
addEventHandler("UCDvehicleSystem.loadPlayerVehicles", root, loadPlayerVehicles)
addEventHandler("onPlayerLogin", root, function () loadPlayerVehicles(source) end)
--addEventHandler("onResourceStart", resourceRoot, function () for _, v in pairs(Element.getAllByType("player")) do loadPlayerVehicles(v) end end) -- Now handled in vehicleData.slua

-- If the resource is to stop, we need to save all the vehicles
-- That is why there are checks for 'client' in hideVehicle
function saveAllVehicles()
	-- Loop through all of them [we use pairs instead of ipairs because ipairs would break at the first nil pair, which means no vehicles would get saved]
	for i, _ in pairs(idToVehicle) do
		if (idToVehicle[i]) then
			triggerEvent("UCDvehicleSystem.hideVehicle", resourceRoot, i)
		end
	end
end
addEventHandler("onResourceStop", resourceRoot, saveAllVehicles)

function deleteVehicle(vehicleID)
	-- TODO
end

function spawnVehicle(vehicleID)
	if (not vehicleID) then return end
	
	-- If the selected vehicle is already in the world
	if (idToVehicle[vehicleID]) then
		exports.UCDdx:new(client, "That vehicle is already spawned in!", 255, 0, 0)
		return false
	end
	
	-- If the player has more than 2 active vehicles in the world
	if (activeVehicles[client] and #activeVehicles[client] >= 2) then
		exports.UCDdx:new(client, "You cannot have more than 2 vehicles in the world at one time.", 255, 0, 0)
		return false
	end
	
	local c1, c2, c3, c4 = unpack(fromJSON(getVehicleData(vehicleID, "colour")))
	local model = getVehicleData(vehicleID, "model")
	
	local vX, vY, vZ = unpack(fromJSON(getVehicleData(vehicleID, "xyz")))
	local rot = getVehicleData(vehicleID, "rotation")
	
	local vehicle = Vehicle(model, vX, vY, vZ + 0.5, 0, 0, rot)
	vehicle:setColor(c1, c2, c3, c4)
	vehicle:setData("owner", client:getName())
	vehicle:setData("vehicleID", vehicleID)
	vehicle:setRotation(0, 0, vehicles[vehicleID].rotation)
	vehicle:setHealth(vehicles[vehicleID].health)
	
	-- Do stuff with tables
	idToVehicle[vehicleID] = vehicle
	if (not activeVehicles[client]) then
		activeVehicles[client] = {}
	end
	table.insert(activeVehicles[client], vehicle)
	
	-- Debug purposes while resource is still being made
	if (exports.UCDadmin:isPlayerOwner(client)) then
		client:warpIntoVehicle(vehicle)
	end
	
	exports.UCDdx:new(client, "You have successfully spawned your "..vehicle:getName(), 0, 255, 0)
	triggerClientEvent(root, "UCDvehicleSystem.syncIdToVehicle", client, idToVehicle) -- Maybe change this to only sync to the owner
end
addEvent("UCDvehicleSystem.spawnVehicle", true)
addEventHandler("UCDvehicleSystem.spawnVehicle", root, spawnVehicle)

function hideVehicle(vehicleID)
	if (not vehicleID) then return end
	local vehicle = idToVehicle[vehicleID]
	if (vehicle:getData("vehicleID") ~= vehicleID) then return end
	
	if (client and exports.UCDutil:getElementSpeed(vehicle) >= 100) then
		exports.UCDdx:new(client, "You can't hide your vehicle when it's travelling faster than 100km/h!", 255, 0, 0)
		return false
	end
	
	local health = vehicle:getHealth()
	local pos = vehicle:getPosition()
	local rot = vehicle:getRotation()
	local c1, c2, c3, c4  = vehicle:getColor()
	
	setVehicleData(vehicleID, "rotation", rot.z)
	setVehicleData(vehicleID, "xyz", toJSON({pos.x, pos.y, pos.z}))
	setVehicleData(vehicleID, "health", health)
	setVehicleData(vehicleID, "colour", toJSON({c1, c2, c3, c4}))
	
	idToVehicle[vehicleID] = nil
	if (client and activeVehicles[client]) then
		for k, v in pairs(activeVehicles[client]) do
			if v == vehicle then
				table.remove(activeVehicles[client], k) -- Remove it at its current index
				break
			end
		end
	end
	
	-- Loop through steats, check for players and manually eject them
	for seat, occupant in pairs(vehicle:getOccupants()) do
		if (occupant and occupant:getType() == "player") then
			occupant:removeFromVehicle()
		end
	end
	
	vehicle:destroy()
	
	-- We check for client because the onResourceStop event saves all vehicles by triggering this one
	if (client) then
		exports.UCDdx:new(client, "You have successfully hidden your "..Vehicle.getNameFromModel(vehicles[vehicleID].model), 0, 255, 0)
		triggerClientEvent(root, "UCDvehicleSystem.syncIdToVehicle", client, idToVehicle)
	end
end
addEvent("UCDvehicleSystem.hideVehicle", true)
addEventHandler("UCDvehicleSystem.hideVehicle", root, hideVehicle)

function toggleLock(enteringPlayer)
	-- On duty admins are allowed to jack a player's car
	if (not exports.UCDteams:isPlayerInTeam(enteringPlayer, "Admins")) or (enteringPlayer:getName() ~= source:getData("owner")) then -- If they aren't an admin or the owner
		exports.UCDdx:new(enteringPlayer, "This "..source:getName()..", owned by "..source:getData("owner")..", is locked.", 255, 0, 0)
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
		exports.UCDdx:new(client, "You have successfully unlocked your "..vehicleEle:getName(), 0, 255, 0)
	else
		vehicleEle:setData("locked", true)
		addEventHandler("onVehicleStartEnter", vehicleEle, toggleLock)
		exports.UCDdx:new(client, "You have successfully locked your "..vehicleEle:getName(), 0, 255, 0)
	end
end
addEvent("UCDvehicleSystem.toggleLock", true)
addEventHandler("UCDvehicleSystem.toggleLock", root, toggleLock_)

--addCommandHandler("sv", function (plr) triggerEvent("UCDvehicleSystem.spawnVehicle", plr, 1) end)

-- We need the owner's name to be synced
function onPlayerChangeNick(old, new)
	if (exports.UCDaccounts:isPlayerLoggedIn(source) and activeVehicles[source] and #activeVehicles[source] > 0) then
		for _, vehicle in pairs(activeVehicles[source]) do
			if (old == vehicle:getData("owner")) then
				vehicle:setData("owner", new)
			end
		end
	end
end
addEventHandler("onPlayerChangeNick", root, onPlayerChangeNick)

function getPlayerVehicleTable(plr)
	-- Avoid MySQL as much as possible
	if (not plr) or (plr:getType() ~= "player") then return false end
	
	local vehicleTable = {}
	vehicleTable[plr] = {}
	local accountID = exports.UCDaccounts:getPlayerAccountID(plr)
	
	for i, v in pairs(vehicles) do
		if v.ownerID == accountID then
			vehicleTable[plr][i] = v
		end
	end
	return vehicleTable[plr]
end


-- Used for determining the spawn location
function _getVehicleType(vehicleID)
	--[[
	local vehicleType = vehicle:getVehicleType()
	
	if (vehicleType == "Automobile" or vehicleType == "Monster Truck") then
		return "General"
	elseif (vehicleType == "Bike" or vehicleType == "BMX" or vehicleType == "Quad") then
		return "Bike"
	elseif (vehicleType == "Helicopter") then
		return "Helicopter"
	elseif (vehicleType == "Plane") then
		return vehicleType
	elseif (vehicleType == "Boat") then
		return vehicleType
	else
		return false
	end
 	--]]
end

-- UNTESTED
-- This could also conflict with a law system of sorts
function onVehicleStartEnter(plr, seat, jacked, door)
	if (not source:getData("owner")) then return end
	if (seat == 0 and door == 0 and jacked) then
		local driver = source:getOccupant(0)
		if (exports.UCDaccounts:getPlayerAccountName(driver) == source:getData("owner")) then
			cancelEvent()
		end
	end
	-- source is vehicle
end
addEventHandler("onVehicleStartEnter", root, onVehicleStartEnter)
