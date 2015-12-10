-- Get the last rank of a gang, usually the founder
function getGroupLastRank(group)
	--if (ranksCache[group]) then
	--	for k, v in pairs(ranksCache[group]) do
	--		if (v[2] == -1) then
	--			return k
	--		end
	--	end
	--end
end

-- Get a given player's online time
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

-- 
function setDefaultRanks(group)
	if (not group) then return end
	db:exec("INSERT INTO `groups_ranks` (groupName, rankName, permissions, rankIndex) VALUES (?, ?, ?, ?)", group, "Trial", toJSON(defaultRanks["Trial"][1]), 0)
	db:exec("INSERT INTO `groups_ranks` (groupName, rankName, permissions, rankIndex) VALUES (?, ?, ?, ?)", group, "Regular", toJSON(defaultRanks["Regular"][1]), 1)
	db:exec("INSERT INTO `groups_ranks` (groupName, rankName, permissions, rankIndex) VALUES (?, ?, ?, ?)", group, "Trusted", toJSON(defaultRanks["Trusted"][1]), 2)
	db:exec("INSERT INTO `groups_ranks` (groupName, rankName, permissions, rankIndex) VALUES (?, ?, ?, ?)", group, "Deputy", toJSON(defaultRanks["Deputy"][1]), 3)
	db:exec("INSERT INTO `groups_ranks` (groupName, rankName, permissions, rankIndex) VALUES (?, ?, ?, ?)", group, "Leader", toJSON(defaultRanks["Leader"][1]), 4)
	db:exec("INSERT INTO `groups_ranks` (groupName, rankName, permissions, rankIndex) VALUES (?, ?, ?, ?)", group, "Founder", toJSON(defaultRanks["Founder"][1]), -1)
	ranksCache[group] = defaultRanks -- This table is from core.lua
end