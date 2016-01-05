-------------------------------------------------------------------
--// PROJECT: Union of Clarity and Diversity
--// RESOURCE: UCDvehicles
--// DEVELOPER(S): Lewis Watson (Noki)
--// DATE: 04/01/2016
--// PURPOSE: Handling server-sided damage.
--// FILE: \vehicleDamage_s.lua [server]
-------------------------------------------------------------------

function isVehicleBrokenDown(vehicle)
	if (not vehicle) then return end
	if (not isElement(vehicle) or vehicle.type ~= "vehicle") then return false end
	if (vehicle.health <= 250 and vehicle.damageProof == true and vehicle.engineState == false) then
		return true
	end
	return false
end

-- We use this to make sure the vehicle does not explode
function foo()
	if (source.occupant and source.damageProof ~= true) then
		exports.UCDdx:new(source.occupant, "This vehicle is critically damaged. It must be repaired!", 255, 0, 0)
	end
	source:setDamageProof(true)
	source:setEngineState(false)
end
addEvent("dmgproof", true)
addEventHandler("dmgproof", root, foo)
