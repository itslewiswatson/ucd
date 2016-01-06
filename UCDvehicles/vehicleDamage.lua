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
			if (source.health < 250 or (source.health - loss) < 250) then
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

addEventHandler("onClientVehicleEnter", root,
	function (plr)
		if (plr == localPlayer and isElement(source) and source.type == "vehicle") then
			if (source.health <= 250) then
				source:setEngineState(false)
				source:setDamageProof(true)
				triggerServerEvent("dmgproof", source)
				source.health = 250
				exports.UCDdx:new("This vehicle is critically damaged. It must be repaired!", 255, 0, 0)
			end
		end
	end
)