function fixAdminVeh( client )
	local theVehicle = getPedOccupiedVehicle( client )
	if not theVehicle then return end
	if ( getTeamName( getPlayerTeam( client ) ) ~= "Admins" ) then return end
	
	local vehicleHealth = getElementHealth( theVehicle ) / 10
	if ( vehicleHealth ~= 100 ) then
		triggerEvent("onVehicleFixed", theVehicle, client)
		fixVehicle( theVehicle )
		exports.UCDdx:new( client, "Your "..getVehicleName( theVehicle ).." has been fixed", 255, 255, 0 )
	else
		exports.UCDdx:new( client, "Your "..getVehicleName( theVehicle ).." is at full health", 255, 255, 0 )
	end
end
addCommandHandler("fix", fixAdminVeh)

function toggleJetpack(plr)
	if (Resource.getFromName("freeroam").state == "running") then return end
	if (doesPedHaveJetPack(plr)) then
		removePedJetPack(plr)
	else
		givePedJetPack(plr)
	end
end
addCommandHandler("jetpack", toggleJetpack)

function flipVehicle(plr)
	if (not exports.UCDteams:isPlayerInTeam(plr, "Admins")) then return end	
	if (plr.vehicle) then
		local rX, rY, rZ = getElementRotation(vehicle)
		vehicle:setRotation(0, 0, (rX > 90 and rX < 270) and (rZ + 180) or rZ)
	end
end
addCommandHandler("flip", flipVehicle)
