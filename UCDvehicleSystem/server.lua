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
		{0, 0, 5, 0}, {0, 0, 5, 0}, {0, 0, 5, 0}
	},
	["Helicopter"] = {
		{0, 0, 5, 0}, {0, 0, 5, 0}, {0, 0, 5, 0}
	},
	["Boat"] = {
		{0, 0, 5, 0}, {0, 0, 5, 0}, {0, 0, 5, 0}
	},
	["Bike"] = {
		{0, 0, 5, 0}, {0, 0, 5, 0}, {0, 0, 5, 0}
	},
	["General"] = {
		{-500, 6, 20, 0}, {80, 10, 5, 0}, {400, -60, 5, 0}, {0, 0, 5, 0}
	},
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
	for _, vehicleID in pairs(playerVehicles[source]) do
		if (idToVehicle[vehicleID]) then
			triggerEvent("UCDvehicleSystem.hideVehicle", resourceRoot, vehicleID)
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
	for i, vehicleData in pairs(vehicles) do
		if (vehicleData.ownerID == acccountID) then
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
	for i, _ in pairs(idToVehicle) do
		if (idToVehicle[i]) then
			triggerEvent("UCDvehicleSystem.hideVehicle", resourceRoot, i, false)
		end
	end
end
addEventHandler("onResourceStop", resourceRoot, saveAllVehicles)

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
	
	-- Get the car's data form the table
	local c1, c2, c3, c4 = unpack(fromJSON(getVehicleData(vehicleID, "colour"))) -- Get the colour data
	local model = getVehicleData(vehicleID, "model") -- Get the vehicle model
	local vX, vY, vZ = unpack(fromJSON(getVehicleData(vehicleID, "xyz"))) -- Get the vehicle's position
	local rot = getVehicleData(vehicleID, "rotation") -- Get its rotation
	
	-- Spawn the vehicle and set it's properties
	local vehicle = Vehicle(model, vX, vY, vZ + 0.5, 0, 0, rot)
	vehicle:setColor(c1, c2, c3, c4)
	vehicle:setData("owner", client:getName())
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
	if (exports.UCDadmin:isPlayerOwner(client)) then
		client:warpIntoVehicle(vehicle)
	end
	
	exports.UCDdx:new(client, "You have successfully spawned your "..vehicle:getName(), 0, 255, 0)
	triggerClientEvent(root, "UCDvehicleSystem.syncIdToVehicle", client, idToVehicle) -- Maybe change this to only sync to the owner
end
addEvent("UCDvehicleSystem.spawnVehicle", true)
addEventHandler("UCDvehicleSystem.spawnVehicle", root, spawnVehicle)

function hideVehicle(vehicleID, tosync)
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
	local c1, c2, c3, c4  = vehicle:getColor()
	
	if (tosync == false) then
		setVehicleData(vehicleID, "rotation", rot.z)
		setVehicleData(vehicleID, "xyz", toJSON({pos.x, pos.y, pos.z}))
		setVehicleData(vehicleID, "health", health)
		setVehicleData(vehicleID, "colour", toJSON({c1, c2, c3, c4}))
		outputDebugString("hideVehicle, tosync == false")
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
		if (occupant:getType() == "player") then
			exports.UCDdx:new(occupant, "You have been ejected from the vehicle as it has been hidden.", 255, 0, 0)
		end
	end
	
	vehicle:destroy()
	
	-- We check for client because the onResourceStop event saves all vehicles by triggering this one and we don't want lots of client events being triggered at once, especially when the resource is going to stop anyway
	if (client) then
		exports.UCDdx:new(client, "You have successfully hidden your "..Vehicle.getNameFromModel(vehicles[vehicleID].model), 0, 255, 0)
		triggerClientEvent(Element.getAllByType("player"), "UCDvehicleSystem.syncIdToVehicle", resourceRoot, idToVehicle)
	end
end
addEvent("UCDvehicleSystem.hideVehicle", true)
addEventHandler("UCDvehicleSystem.hideVehicle", root, hideVehicle)

function recoverVehicle(vehicleID)
	local vehicle
	local vehicleEle
	local distances = {}
	local points = {}
	local vehicleType = _getVehicleType(vehicleID)
	
	if (idToVehicle[vehicleID]) then
		vehicleEle = idToVehicle[vehicleID]
		vehicle = vehicleEle:getPosition()
	else
		vehicle = Vector3(unpack(fromJSON(getVehicleData(vehicleID, "xyz")))) -- This looks inefficient
	end
	
	-- Loop through to find the smallest distance
	for i = 1, #recLocs[vehicleType] do
		local distance_ = getDistanceBetweenPoints3D(vehicle.z, vehicle.y, vehicle.z, recLocs[vehicleType][i][1], recLocs[vehicleType][i][2], recLocs[vehicleType][i][3])
		table.insert(distances, distance_)
		points[distance_] = Vector4(recLocs[vehicleType][i][1], recLocs[vehicleType][i][2], recLocs[vehicleType][i][3], recLocs[vehicleType][i][4])
	end
	table.sort(distances) -- Sort the table to find the smallest distance
	
	--[[
	for k, v in ipairs(distances) do
		outputDebugString(v) -- distances[1] should be the smallest because of the ipairs loop
	end
	outputDebugString("Smallest should be ".. distances[1])
	--]]
	
	local smallest = points[distances[1]] -- returns a 4D vector [x, y, z, rot]
	
	if (idToVehicle[vehicleID]) then
		-- Check for people in it
		for seat, occupant in pairs(vehicleEle:getOccupants()) do
			occupant:removeFromVehicle()
			if (occupant:getType() == "player") then
				exports.UCDdx:new(occupant, "You have been ejected from the vehicle as it has been hidden.", 255, 0, 0)
			end
		end
		vehicleEle:setDamageProof(true)	
		vehicleEle:setPosition(smallest.x, smallest.y, smallest.z + 2)
		vehicleEle:setRotation(Vector3(0, 0, smallest.w))
		Timer(function (vehicleEle) if (vehicleEle and isElement(vehicleEle)) then vehicleEle:setDamageProof(false) end end, 5000, 1, vehicleEle)
	end
	setVehicleData(vehicleID, "xyz", toJSON({smallest.x, smallest.y, smallest.z + 2}))
	setVehicleData(vehicleID, "rotation", smallest.w)
	exports.UCDdx:new(client, "Your "..getVehicleNameFromModel(getVehicleData(vehicleID, "model")).." has been recovered to "..getZoneName(smallest.x, smallest.y, smallest.z).."!", 0, 255, 0)
end
addEvent("UCDvehicleSystem.recoverVehicle", true)
addEventHandler("UCDvehicleSystem.recoverVehicle", root, recoverVehicle)

function sellVehicle(vehicleID)
	-- Hide the vehicle, but don't sync it to the database
	if (idToVehicle[vehicleID]) then
		triggerEvent("UCDvehicleSystem.hideVehicle", resourceRoot, vehicleID, false)
	end
	
		
end
addEvent("UCDvehicleSystem.sellVehicle", true)
addEventHandler("UCDvehicleSystem.sellVehicle", root, sellVehicle)

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
addEvent("UCDvehicleSystem.toggleLock", true)
addEventHandler("UCDvehicleSystem.toggleLock", root, toggleLock_)
