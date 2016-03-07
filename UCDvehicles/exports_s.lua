-------------------------------------------------------------------
--// PROJECT: Union of Clarity and Diversity
--// RESOURCE: UCDvehicles
--// DEVELOPER(S): Lewis Watson (Noki)
--// DATE: 09/12/2015
--// PURPOSE: Storing miscellaneous server-side functions.
--// FILE: \server2.lua [server]
-------------------------------------------------------------------

-- Functions

function getVehicleOwner(vehicle)
	if (not vehicle) then return nil end
	if (vehicle.type ~= "vehicle") then return false end
	local owner = vehicle:getData("owner") -- Set it to a player name
	
	if (not owner) then
		local vehicleID = vehicle:getData("vehicleID")
		if (vehicleID and vehicles[vehicleID]) then
			local owner = vehicles[vehicleID].owner
			local player = Account(owner).player
			if (not player) then
				return false
			end
			return player
		end
	end
	
	return Player(owner)
end

-- Used for determining the spawn location
function _getVehicleType(vehicleID)
	if (not vehicleID) then return nil end
	local vehicle = idToVehicle[vehicleID]
	if not vehicle then vehicle = getVehicleData(vehicleID, "model") end
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

-- Events

function onVehicleHidden()
	-- source = vehicle that was hidden
end
addEvent("onVehicleHidden")
addEventHandler("onVehicleHidden", root, onVehicleHidden)

function onVehicleFixed(whatFixed)
	outputDebugString("onVehicleFixed called -> exports.UCDvehicles:fix(element:vehicle veh) instead")
	-- This should pass the vehicle with it's prior state to being fixed
	if (exports.UCDvehicles:isVehicleBrokenDown(source)) then
		
		source:setEngineState(true)
		source:setDamageProof(false)
 	end
	-- source = the vehicle that was fixed
	-- whatFixed = the element that fixed it (can be a resource or player etc)
end
addEvent("onVehicleFixed")
addEventHandler("onVehicleFixed", root, onVehicleFixed)

function fix(vehicle)
	if (vehicle and isElement(vehicle)) then
		if (exports.UCDvehicles:isVehicleBrokenDown(source)) then
			source:setEngineState(true)
			source:setDamageProof(false)
		end
		vehicle:fix()
	end
end
