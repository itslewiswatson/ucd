-------------------------------------------------------------------
--// PROJECT: Union of Clarity and Diversity
--// RESOURCE: UCDhousing
--// DEVELOPER(S): Lewis Watson (Noki)
--// DATE: 07/03/2016
--// PURPOSE: Client-side house robbing.
--// FILE: \rob\rob_c.lua [client]
-------------------------------------------------------------------

function nToRob(_, _, plr, thePickup)
	if (not UCDhousing) then
		removeHouseNotification()
		local houseID = thePickup:getData("houseID")
		outputDebugString("Robbing houseID = "..tostring(houseID))
		-- triggerServerEvent("UCDhousing.enterHouse", localPlayer, houseID, true) -- true on the end because we are robbing it
		triggerServerEvent("UCDhousing.robHouse", localPlayer, houseID)
	else
		exports.UCDdx:new("You need to close the house panel to rob this house", 255, 0, 0)
	end
end
