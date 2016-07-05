function fixAdminVeh( client )
	local theVehicle = getPedOccupiedVehicle( client )
	if not theVehicle then return end
	if ( getTeamName( getPlayerTeam( client ) ) ~= "Admins" ) then return end
	
	local vehicleHealth = getElementHealth( theVehicle ) / 10
	if ( vehicleHealth ~= 100 ) then
		exports.UCDvehicles:fix(theVehicle)
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
		local rX, rY, rZ = getElementRotation(plr.vehicle)
		plr.vehicle:setRotation(0, 0, (rX > 90 and rX < 270) and (rZ + 180) or rZ)
	end
end
addCommandHandler("flip", flipVehicle)

function damageProof(plr)
	if (isPlayerAdmin(plr)) then
		if (plr.vehicle) then
			plr.vehicle.damageProof = not plr.vehicle.damageProof
			exports.UCDdx:new(plr, "Your "..tostring(plr.vehicle.name).." is "..tostring((plr.vehicle.damageProof and "now") or "no longer").." damage proof", 0, 255, 0)
		end
	end
end
addCommandHandler("dmgproof", damageProof)