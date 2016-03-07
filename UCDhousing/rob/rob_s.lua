-------------------------------------------------------------------
--// PROJECT: Union of Clarity and Diversity
--// RESOURCE: UCDhousing
--// DEVELOPER(S): Lewis Watson (Noki)
--// DATE: 07/03/2016
--// PURPOSE: Server-side house robbing.
--// FILE: \rob\rob_s.lua [server]
-------------------------------------------------------------------

local robbed = {} -- A table containing all houses that have been robbed recently

function robHouse(houseID)
	if (client) then
		if (robbed[houseID]) then
			exports.UCDdx:new(client, "This house has been robbed recently, come back later", 255, 0, 0)
			return
		end
		if (client:getData("Occupation") ~= "Criminal" and client:getData("Occupation") ~= "Gangster") then
			return
		end
		triggerEvent("UCDhousing.enterHouse", client, houseID, true)
	else
		outputDebugString("FUARK")
	end
end
addEvent("UCDhousing.robHouse", true)
addEventHandler("UCDhousing.robHouse", root, robHouse)
