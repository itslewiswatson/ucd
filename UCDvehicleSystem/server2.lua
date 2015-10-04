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

