-------------------------------------------------------------------
--// PROJECT: Union of Clarity and Diversity
--// RESOURCE: UCDhousing
--// DEVELOPER(S): Lewis Watson (Noki)
--// DATE: 09/12/2015
--// PURPOSE: A network of exports for housing.
--// FILE: \exports\server.lua [server]
-------------------------------------------------------------------

db = exports.UCDsql:getConnection()
count = 0

function isPlayerInHouse(plr, houseID)
	if (not plr or not isElement(plr)) then return end
	if (plr.type ~= "player" or not isElement(plr) or tonumber(houseID) == nil) then return false end
	
	if (houseID) then
		if (plr.interior == getHouseData(houseID, "interiorID") and plr.dimension == houseID) then
			return true
		end
	else
		if (plr.interior > 0 and plr.interior <= 32 and plr.dimension > 0 and plr.dimension <= getHouseCount) then -- Put number of houses here
			return true
		end
	end
	return false
end

function getHouseCount()
	local result
	result = #housingData
	if (not result or result == nil) then
		result = db:query("SELECT Count(*) AS `foo` FROM `housing`"):poll(-1)[1].foo
	end
	count = result
	return result or false
end

