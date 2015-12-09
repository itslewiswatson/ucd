-------------------------------------------------------------------
--// PROJECT: Union of Clarity and Diversity
--// RESOURCE: UCDhousing
--// DEVELOPER(S): Lewis Watson (Noki)
--// DATE: 09/12/2015
--// PURPOSE: A network of exports for housing.
--// FILE: \client\client.lua [client]
-------------------------------------------------------------------

function isPlayerInHouse(plr)
	if (not plr or not isElement(plr)) then return end
	if (plr.type ~= "player") then return false end
	
	if (plr.interior > 0 and plr.interior <= 32 and plr.dimension > 0 and plr.dimension <= 100) then -- Put number of houses here
		return true
	end
	return false
end
