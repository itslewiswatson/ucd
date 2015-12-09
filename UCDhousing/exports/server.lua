-------------------------------------------------------------------
--// PROJECT: Union of Clarity and Diversity
--// RESOURCE: UCDhousing
--// DEVELOPER(S): Lewis Watson (Noki)
--// DATE: 09/12/2015
--// PURPOSE: A network of exports for housing.
--// FILE: \exports\server.lua [server]
-------------------------------------------------------------------

db = exports.UCDsql:getConnection()

function isPlayerInHouse(plr)
	if (not plr or not isElement(plr)) then return end
	if (plr.type ~= "player") then return false end
	
	if (plr.interior > 0 and plr.interior <= 32 and plr.dimension > 0 and plr.dimension <= getHighestHouseID()) then -- Put number of houses here
		return true
	end
	return false
end

function getHighestHouseID()
	local result
	result = #housingData
	if (not result or result == nil) then
		result = db:query("SELECT MAX(`housing`) AS `houseID`"):poll(-1)[1].houseID
	end
	return result or nil
end
