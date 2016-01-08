function disableAdministratorDamage(attacker, weapon, bodypart, loss)
	if (source.team) then
		if (attacker and attacker.type == "ped") then return end
		if (source.team.name == "Admins" and source.model == 217 or source.model == 211) then
			cancelEvent()
		end
	end
end
addEventHandler("onClientPlayerDamage", root, disableAdministratorDamage)

function flipVehicle()
	if (localPlayer:getTeam():getName() ~= "Admins") then return end	
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if vehicle then
		local rX, rY, rZ = getElementRotation(vehicle)
		setElementRotation(vehicle, 0, 0, (rX > 90 and rX < 270) and (rZ + 180) or rZ)
	end
end
addCommandHandler("flip", flipVehicle)
