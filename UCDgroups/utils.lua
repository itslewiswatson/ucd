function getPlayerGroup(plr)
	if (not plr) then return end
	if (not isElement(plr) or plr.type ~= "player") then return end
	if (not group[plr]) then
		--local accountID = exports.UCDaccounts:getPlayerAccountID(plr)
		local account = plr.account.name
		if (account and playerGroupCache[account] and playerGroupCache[account][1]) then
			return playerGroupCache[account][1]
		end
		return false
	end
	return group[plr]
end

-- Get a group's information
function getGroupInfo(groupName)
	if not groupName or groupName == "" then return end
	if (not groupTable[groupName] or not groupTable[groupName].info) then
		return false
	end
	return groupTable[groupName].info
end

-- Get the member count of a group
function getGroupMemberCount(groupName)
	if (not groupMembers[groupName] or not groupTable[groupName].memberCount) then return end
	return #groupMembers[groupName] or groupTable[groupName].memberCount
end

-- Get a given player's online time
function getPlayerOnlineTime(plr)
	if (not plr) then return end
	if (isElement(plr) or plr.type == "player") then
		if (onlineTime[plr]) then
			--outputChatBox(tostring(math.floor((getRealTime().timestamp - onlineTime[plr]) / 60)), root)
			outputDebugString("onlineTime = "..onlineTime[plr])
			outputDebugString("getRealTime().timestamp = "..getRealTime().timestamp)
			outputDebugString(getRealTime().timestamp - onlineTime[plr])
			return math.floor((getRealTime().timestamp - onlineTime[plr]) / 60)
		end
	else
		-- plr should be a number in this case
		if (playerGroupCache[plr]) then
			return playerGroupCache[plr][6] or 0
		end
	end
	return 0
end

function getPlayerGroupRank(plr)
	local groupName = group[plr]--getPlayerGang(plr)
	if (not groupName) then return end
	--local accountID = exports.UCDaccounts:getPlayerAccountID(plr)
	local account = plr.account.name
	if (not playerGroupCache or not playerGroupCache[account] or not playerGroupCache[account][3]) then	
		return getGroupFirstRank(groupName)
	end
	return playerGroupCache[account][3] 
end

-- Get the first rank in a group, which is what will be assigned to new players who join
function getGroupFirstRank(groupName)
	if (groupRanks[groupName]) then
		for k, v in pairs(groupRanks[groupName]) do
			if (v[2] == 0) then
				return k
			end
		end
	end
end

-- Get the last rank of a group, usually the founder
function getGroupLastRank(groupName)
	if (groupRanks[groupName]) then
		for k, v in pairs(groupRanks[groupName]) do
			if (v[2] == -1) then
				return k
			end
		end
	end
end

function getRankPermissions(groupName, rank)
	if (not groupName or not rank or not groupRanks[groupName] or not groupRanks[groupName][rank]) then return end
	if (rank == getGroupLastRank(groupName)) then
		local tempranks = {}
		tempranks[-1] = true
		for i = 1, 25 do
			tempranks[i] = true
		end
		return tempranks
	else
		return groupRanks[groupName][rank][1]
	end
end

-- 
function getMembersWithRank(groupName, rank)
	if (groupName and rank and groupRanks[groupName] and groupRanks[groupName][rank]) then
		local count = 0
		for _, v in pairs(playerGroupCache) do
			if (v[1] == groupName) then
				if (v[3] == rank) then
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
	local r, g, b = getGroupChatColour(groupName)
	if (not r or not g or not b) then
		r, g, b = 200, 0, 0
		outputDebugString(groupName.." chat colour is fucked up")
	end
	for _, plr in ipairs(getGroupOnlineMembers(groupName) or {}) do
		if (type_ == "chat") then
			outputChatBox(msg, plr, r, g, b, true) -- Group chat colours
		elseif (type_ == "info") then
			exports.UCDdx:new(plr, msg, r, g, b)
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

-- Move this to UCDutil
function getDayOfTheYear()
	local realtime = getRealTime()
	return realtime.yearday
end

function getAdvancedGroupMembers(groupName)
	local temp = {}
	local day = getDayOfTheYear()
	local rank
	local wl
	function lol(acc)
		if (playerGroupCache[acc]) then
			local data = playerGroupCache[acc]
			if (not data[2]) then
				outputDebugString("data[2] is nil in getAdvancedGroupMembers: acc: "..tostring(acc).." group: "..groupName)
			end
			if (data[1] == groupName) then
				local playername = "N/A"
				--local plr = getAccountPlayer(data[4])
				local plr = Account(data[2]).player
				if (plr and isElement(plr)) then	
					playername = plr.name
					online = true
				else
					-- Probably change this
					playername = exports.UCDaccounts:GAD(acc, "lastUsedName") --db:query("SELECT `lastUsedName` FROM `accounts` WHERE `account`=?", acc):poll(-1)[1].lastUsedName or "N/A"
					online = false
				end
				rank = data[3]
				days = tonumber(data[5]) or 0
				days = day - days
				wl = data[7]
				temp[#temp + 1] = {online, playername, acc, rank, days, getPlayerOnlineTime(plr or acc), wl}
			end
		else
			outputDebugString("acc = "..acc)
			local result = db:query("SELECT `groupName`, `rank`, `joined`, `lastOnline`, `timeOnline`, `warningLevel` FROM `groups_members` WHERE `account`=? LIMIT 1", acc):poll(-1)
			playerGroupCache[acc] = {result[1].groupName, acc, result[1].rank, result[1].joined, result[1].lastOnline, result[1].timeOnline, result[1].warningLevel}
			lol(acc)
		end
	end
	for _, acc in pairs(groupMembers[groupName]) do
		lol(acc)
	end
	return temp
end

-----
function getRankIndex(groupName, rank)
	if (not groupName or not rank) then return end
	if (groupRanks[groupName] and groupRanks[groupName][rank]) then
		for i, v in pairs(groupRanks[groupName]) do
			if (i == rank) then
				return v[2]
			end
		end
	end
end

function getRankFromIndex(groupName, rankIndex)
	if (not groupName or not rankIndex) then return end
	if (groupRanks[groupName]) then
		for i, v in pairs(groupRanks[groupName]) do
			if (v[2] == rankIndex) then
				return i
			end
		end
	end
end

function getGroupRankAmount(groupName)
	if (not groupName or not groupRanks[groupName]) then return end
	local count = 0
	for k, v in pairs(groupRanks[groupName]) do
		count = count + 1
	end
	return count
end

-- 
function getNextRank(groupName, rank)
	if (not groupName or not rank) then return end
	local rankIndex = getRankIndex(groupName, rank)
	if (rankIndex) then
		local newRank = getRankFromIndex(groupName, rankIndex + 1)
		if (newRank) then
			return newRank
		else
			if ((getGroupRankAmount(groupName) - 2) == rankIndex) then
				return getGroupLastRank(groupName)
			end
		end
	end
end

function getPreviousRank(groupName, rank)
	if (not groupName or not rank) then return end
	local rankIndex = getRankIndex(groupName, rank)
	if (rankIndex) then
		if (rankIndex == -1) then
			return getRankFromIndex(groupName, getGroupRankAmount(groupName) - 2)
		end
		if ((rankIndex - 1) > 0) then
			local newRank = getRankFromIndex(groupName, rankIndex - 1)
			if (newRank) then
				return newRank
			end
		else
			return getRankFromIndex(groupName, 0)
		end
	end
end

function canPlayerDoActionInGroup(plr, action)
	local actionIndex = _permissions[action]
	if (not actionIndex) then return end
	local groupName = getPlayerGroup(plr)
	if (not groupName) then return end
	local playerRank = getPlayerGroupRank(plr)
	if (not playerRank) then return end
	local perms = getRankPermissions(groupName, playerRank)
	if (perms and perms[actionIndex]) then
		return true
	end
	return false
end

function isRankHigherThan(groupName, rank1, rank2)
	if (groupTable[groupName] and groupRanks[groupName] and groupRanks[groupName][rank1] and groupRanks[groupName][rank2]) then
		local rankIndex1 = groupRanks[groupName][rank1][2]
		local rankIndex2 = groupRanks[groupName][rank2][2]
		if (rankIndex1 and rankIndex2) then
			if (rankIndex1 == -1 and rankIndex2 ~= -1) then return true end
			if (rankIndex2 == -1 and rankIndex1 ~= -1) then return false end
			if (rankIndex2 == 0 and rankIndex1 ~= 0) then return true end
			if (rankIndex1 == 0 and rankIndex2 ~= 0) then return false end
			if (rankIndex1 > rankIndex2) then return true end
			if (rankIndex2 > rankIndex1) then return false end
			if (rankIndex2 == rankIndex1) then return "equal" end
		end
	end
end

function getGroupColour(groupName)
	if (not groupName or not groupTable or not groupTable[groupName]) then
		return false
	end
	if (groupTable[groupName].colour ~= nil) then
		return unpack(fromJSON(groupTable[groupName].colour))
	end
	return 200, 0, 0
end

function getGroupChatColour(groupName)
	if (not groupName or not groupTable or not groupTable[groupName]) then
		return false
	end
	if (groupTable[groupName].chatColour ~= nil) then
		return unpack(fromJSON(groupTable[groupName].chatColour))
	end
	return 200, 0, 0
end

function createGroupLog(groupName, log_, important)
	if (groupName and log_) then
		if (groupTable[groupName]) then
			-- If it's an important log (meaning it is kept even if the group is deleted)
			if (important) then
				db:exec("INSERT INTO `groups_logs` (`groupName`, `log`, `important`) VALUES (?, CONCAT('[', CURDATE(), '] [', CURTIME(), '] ', ?), 1)", groupName, log_)
				return true
			end
			db:exec("INSERT INTO `groups_logs` (`groupName`, `log`) VALUES (?, CONCAT('[', CURDATE(), '] [', CURTIME(), '] ', ?))", groupName, log_)
			return true
		else
			outputDebugString("createGroupLog: could not create log - group does not exist")
			return false
		end
	end
end

function createAllianceLog(alliance, groupName, log_, important)
	if (alliance and groupName and log_) then
		if (groupTable[groupName] and g_alliance[groupName] == alliance) then
			if (important) then
				db:exec("INSERT INTO `groups_alliances_logs` (`alliance`, `groupName`, `log`, `important`) VALUES (?, ?, CONCAT('[', CURDATE(), '] [', CURTIME(), '] ', ?), 1)", alliance, groupName, log_)
				return true
			end
			db:exec("INSERT INTO `groups_alliances_logs` (`alliance`, `groupName`, `log`, `important`) VALUES (?, ?, CONCAT('[', CURDATE(), '] [', CURTIME(), '] ', ?), 0)", alliance, groupName, log_)
			return true
		else
			outputDebugString("Critial error - groupTable[groupName] or g_alliance[groupName] in 'createAllianceLog'")
		end
	end
	return false
end

function getGroupAlliance(groupName)
	if (g_alliance[groupName]) then
		return g_alliance[groupName]
	end
	return false
end

function isGroupInAlliance(groupName, alliance)
	if (allianceMembers and allianceMembers[alliance] and allianceMembers[alliance][groupName]) then
		return true
	end
	return false
end

function getAllianceGroups(alliance)
	if (allianceMembers and allianceMembers[alliance]) then
		local temp = {}
		for g in pairs(allianceMembers[alliance]) do
			table.insert(temp, g)
		end
		if (#temp == 0) then
			outputDebugString("Alliance '"..tostring(alliance).."' has 0 members")
		end
		return temp, true
	end
	return false, false
end
