-------------------------------------------------------------------
--// PROJECT: Union of Clarity and Diversity
--// RESOURCE: UCDvehicleSystem
--// DEVELOPER(S): Lewis Watson (Noki)
--// DATE: 09/12/2015
--// PURPOSE: Storing miscellaneous server-side functions.
--// FILE: \server2.lua [server]
-------------------------------------------------------------------

-- Move this to some exports file
function getVehicleOwner(vehicle)
	if (not vehicle) then return nil end
	if (vehicle:getType() ~= "vehicle") then return false end
	
	local owner = vehicle:getData("owner") -- Set it to a player name
	
	if (not owner) then
		local vehicleID = vehicle:getData("vehicleID")
		if (vehicleID and vehicles[vehicleID]) then
			local ownerID = vehicles[vehicleID].ownerID
			local player = exports.UCDaccounts:getPlayerFromID(ownerID)
			if (not player) then
				return false
			end
			return player
		end
	end
	
	return Player(owner) -- OOP equivalent of getPlayerFromName
end

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

-- Used for determining the spawn location
function _getVehicleType(vehicleID)
	if (not vehicleID) then return nil end
	local vehicle = idToVehicle[vehicleID]
	if not vehicle then vehicle = getVehicleData(vehicleID, "model") end
	--outputDebugString(tostring(vehicle))
	
	local vehicleType = getVehicleType(vehicle)
	
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
end

