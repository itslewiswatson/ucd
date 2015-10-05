function disableAdministratorDamage(attacker, weapon, bodypart, loss)
	if source:getTeam() then
		if (attacker and attacker:getType() == "ped") then return end
		if (source:getTeam():getName() == "Admins" and source:getModel() == 217 or source:getModel() == 211) then
			cancelEvent()
		end
	end
end
addEventHandler("onClientPlayerDamage", root, disableAdministratorDamage)

function toggleVehicleDamage()
	if (localPlayer:getTeam():getName() ~= "Admins") then return end
	local theVehicle = localPlayer:getOccupiedVehicle()
	if (not theVehicle) then return end

	if (not theVehicle:isDamageProof()) then
		exports.UCDdx:new("Disabled damage for your "..theVehicle:getName(), 255, 255, 0)
	else
		exports.UCDdx:new("Your "..theVehicle:getName().." is no longer damage proof", 255, 255, 0)
	end
	theVehicle:setDamageProof(not theVehicle:isDamageProof())
end
addCommandHandler("dmgproof", toggleVehicleDamage)

-- Rework this cmd
addCommandHandler("invis",
	function ()
		if (localPlayer:getTeam():getName() ~= "Admins") then return end
		if (localPlayer:getAlpha() == 0) then
			triggerServerEvent("staff.visible", localPlayer)
		else
			triggerServerEvent("staff.invis", localPlayer)
			exports.UCDdx:new("You are now invisible", 0, 255, 0)
		end
	end
)

function onClientVehicleExit(plr, seat)
	if (plr ~= localPlayer) or (localPlayer:getTeam():getName() ~= "Admins") then return end	
	if (source:isDamageProof()) then
		source:setDamageProof(false)
		exports.UCDdx:new("Your "..source:getName().." is no longer damage proof", 255, 255, 0)
	end
end
addEventHandler("onClientVehicleExit", root, onClientVehicleExit)

function flipVehicle()
	if (localPlayer:getTeam():getName() ~= "Admins") then return end	
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if vehicle then
		local rX, rY, rZ = getElementRotation(vehicle)
		setElementRotation(vehicle, 0, 0, (rX > 90 and rX < 270) and (rZ + 180) or rZ)
	end
end
addCommandHandler("flip", flipVehicle)
