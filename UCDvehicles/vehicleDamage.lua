-------------------------------------------------------------------
--// PROJECT: Union of Clarity and Diversity
--// RESOURCE: UCDvehicles
--// DEVELOPER(S): Lewis Watson (Noki)
--// DATE: 04/01/2016
--// PURPOSE: Handling client-sided damage.
--// FILE: \vehicleDamage.lua [client]
-------------------------------------------------------------------

function isVehicleBrokenDown(vehicle)
	if (not vehicle) then return end
	if (not isElement(vehicle) or vehicle.type ~= "vehicle") then return false end
	if (vehicle.health <= 250 and vehicle.damageProof == true and vehicle.engineState == false) then
		return true
	end
	return false
end

addEventHandler("onClientVehicleDamage", root,
	function (_, _, loss)
		if (isElement(source) and source.type == "vehicle") then
			if (wasEventCancelled()) then
				return
			end
			local r  = source.rotation
			if (source.blown) then
				return
			end
			if (source.health < 250 or (source.health - loss) < 250 or (r.x > 90 and r.x < 270 and (source.health <= 250 or source.health - loss < 250))) then
				if (source.damageProof == false or source.engineState == true) then
					triggerServerEvent("dmgproof", source)
					source:setDamageProof(true)
					source:setEngineState(false)
				end
				source.health = 250
				cancelEvent()
			end
		end
	end
)

addEventHandler("onClientPlayerVehicleEnter", root,
	function (vehicle)
		if (vehicle == localPlayer.vehicle and isElement(source) and vehicle.type == "vehicle") then
			if (vehicle.health <= 250) then
				vehicle:setEngineState(false)
				vehicle:setDamageProof(true)
				triggerServerEvent("dmgproof", vehicle)
				vehicle.health = 250
				exports.UCDdx:new("This vehicle is critically damaged. It must be repaired!", 255, 0, 0)
			end
		end
	end
)

Timer(
	function ()
		local vehicle = localPlayer.vehicle
		if (vehicle) then
			if (vehicle.health <= 250) then
				if (vehicle.damageProof == false or vehicle.engineState == true) then
					triggerServerEvent("dmgproof", vehicle)
					vehicle:setDamageProof(true)
					vehicle:setEngineState(false)
					vehicle.health = 250
				end
			end
		end
	end, 1500, 0
)
