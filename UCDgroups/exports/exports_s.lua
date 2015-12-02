function getPlayerOnlineTime(plr)
	if (not plr) then return end
	if (not isElement(plr) or plr.type ~= "player") then return false end
	if (onlineTime[plr]) then
		return math.floor((getRealTime().timestamp - onlineTime[plr]) / 60)
	else
		if (playerGroupCache[plr]) then
			return playerGroupCache[plr][7] or 0
		end
	end
	return 0
end

function getGroupNameFromID(groupID)
	return groupTable[groupID].name
end

function getGroupIDFromName(name)
	for _, row in pairs(groupTable) do
		if (row.name == name) then
			return row.groupID
		end
	end
	return false
end

function getGroupData(groupID, column)
	return groupTable[groupID][column]
end