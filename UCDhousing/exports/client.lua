-------------------------------------------------------------------
--// PROJECT: Union of Clarity and Diversity
--// RESOURCE: UCDhousing
--// DEVELOPER(S): Lewis Watson (Noki)
--// DATE: 09/12/2015
--// PURPOSE: A network of exports for housing.
--// FILE: \client\client.lua [client]
-------------------------------------------------------------------

function isPlayerInHouse(plr, houseID)
	if (not plr or not isElement(plr)) then return end
	if (plr.type ~= "player" or not isElement(plr) or tonumber(houseID) == nil) then return false end
	
	if (houseID) then
		if (plr.interior > 0 and plr.interior <= 32 and plr.dimension == houseID) then -- Put number of houses here
			return true
		end
	else
		if (plr.interior > 0 and plr.interior <= 32 and plr.dimension > 0 and plr.dimension <= 100) then -- Put number of houses here
			return true
		end
	end
	return false
end
