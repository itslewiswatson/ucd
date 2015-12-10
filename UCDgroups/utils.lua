function getPlayerGroup(plr)
	if (not plr) then return end
	if (not isElement(plr) or plr.type ~= "player") then return end
	if (not group[plr]) then
		local accountID = exports.UCDaccounts:getPlayerAccountID(plr)
		if (accountID and playerGroupCache[accountID] and playerGroupCache[accountID][1]) then
			return playerGroupCache[accountID][1]
		end
		return false
	end
	return group[plr]
end

-- Get a group's information
function getGroupInfo(group)
	if not group or group == "" then return end
	if (not groupTable[group] or not groupTable[group].info) then
		return false
	end
	return groupTable[group].info
end

-- Get the member count of a group
function getGroupMemberCount(group)
	return #groupMembers[group] or false
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

function getPlayerGroupRank(plr)
	local group_ = group[plr]--getPlayerGang(plr)
	if (not group_) then return end
	local accountID = exports.UCDaccounts:getPlayerAccountID(plr)
	return playerGroupCache[accountID][4] or getGangFirstRank(group_)
end

-- Get the first rank in a group, which is what will be assigned to new players who join
function getGroupFirstRank(group)
	if (groupRanks[group]) then
		for k, v in pairs(groupRanks[group]) do
			if (v[2] == 0) then
				return k
			end
		end
	end
end

-- Get the last rank of a group, usually the founder
function getGroupLastRank(group)
	if (groupRanks[group]) then
		for k, v in pairs(groupRanks[group]) do
			if (v[2] == -1) then
				return k
			end
		end
	end
end

function getRankPermissions(group, rank)
	if (not group or not rank or not groupRanks[group] or not groupRanks[group][rank]) then return end
	if (rank == getGroupLastRank(group)) then
		local tempranks = {}
		for i = 1, 17 do
			tempranks[i] = true
		end
		return tempranks
	else
		return groupRanks[group][rank][1]
	end
end

-- 
function getMembersWithRank(group, rank)
	if (group and rank and groupRanks[group] and groupRanks[group][rank]) then
		local count = 0
		for _, v in pairs(playerGroupCache) do
			if (v[1] == group) then
				if (v[4] == rank) then
					count = count + 1
				end
			end
		end
		return count
	end
end

function getGroupOnlineMembers(groupName)
	if (not groupName) then return end
	local onlineMembers = {}
	for _, plr in pairs(Element.getAllByType("player")) do
		if (getPlayerGroup(plr) == groupName) then
			table.insert(onlineMembers, plr)
		end
	end
	return onlineMembers
end

function messageGroup(groupName, msg, type_)
	if (not groupName or not msg) then return end
	for _, plr in ipairs(getGroupOnlineMembers(groupName) or {}) do
		if (type_ == "chat") then
			outputChatBox("("..groupName..") "..msg, plr, 200, 0, 0, true) -- Group chat colours
		elseif (type_ == "info") then
			exports.UCDdx:new(plr, msg, 200, 0, 0)
		end
	end
end

-- Default ranks which are set when a group is created
function setDefaultRanks(group)
	if (not group) then return end
	db:exec("INSERT INTO `groups_ranks` (groupName, rankName, permissions, rankIndex) VALUES (?, ?, ?, ?)", group, "Trial", toJSON(defaultRanks["Trial"][1]), 0)
	db:exec("INSERT INTO `groups_ranks` (groupName, rankName, permissions, rankIndex) VALUES (?, ?, ?, ?)", group, "Regular", toJSON(defaultRanks["Regular"][1]), 1)
	db:exec("INSERT INTO `groups_ranks` (groupName, rankName, permissions, rankIndex) VALUES (?, ?, ?, ?)", group, "Trusted", toJSON(defaultRanks["Trusted"][1]), 2)
	db:exec("INSERT INTO `groups_ranks` (groupName, rankName, permissions, rankIndex) VALUES (?, ?, ?, ?)", group, "Deputy", toJSON(defaultRanks["Deputy"][1]), 3)
	db:exec("INSERT INTO `groups_ranks` (groupName, rankName, permissions, rankIndex) VALUES (?, ?, ?, ?)", group, "Leader", toJSON(defaultRanks["Leader"][1]), 4)
	db:exec("INSERT INTO `groups_ranks` (groupName, rankName, permissions, rankIndex) VALUES (?, ?, ?, ?)", group, "Founder", toJSON(defaultRanks["Founder"][1]), -1)
	groupRanks[group] = defaultRanks -- This table is from core.lua
end
