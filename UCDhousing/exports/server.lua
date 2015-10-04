db = exports.UCDsql:getConnection()

function isPlayerInHouse(plr)
	if (not plr) or (not isElement(plr)) then return end
	if (getElementType(plr) ~= "player") then return false end
	
	local plrDim = getElementDimension(plr)
	local plrInt = getElementInterior(plr)
	
	if (plrDim > 0) and (plrDim <= 3440) then
		if (plrInt > 0) and (plrInt <= 15) then
			return true
		else
			return false
		end
	else
		return false
	end
end

function getHighestHouseID()
	local result
	result = #housingData
	if (not result) or (result == nil) then
		result = db:query("SELECT LAST_INSERT_ID() AS `houseID`"):poll(-1)[1].houseID
	end
	return result or nil
end