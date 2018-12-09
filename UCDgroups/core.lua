-- `groups`
-- [groupName] = {"info", count, "created", "colour"}
-- [string] = {text, nt, timestamp, bigint, varchar [json], }

-- We have groups_members query to basically queue the loading in of these to avoid lag

local settings = {
	max_members = 50,
	max_invites = 10, -- Maxmimum number of pending invites
	max_totalslots = 50, -- Pending invites and current members
	max_inactive = 14, -- 14 days
	
	default_info_text = "Enter information about your group here!",
	default_colour = {200, 0, 0},
	default_chat_colour = {200, 0, 0},
}
local forbidden = {
	whole = {
		"ucd", "noki", "zorque", "cunt", "cunts", "fuckserver", "cit", "ugc", "ngc", "nr7gaming", "a7a", 
	},
	partial = {
		"zorque", "cunt", "ngc", "arran", "cit ", "admin", "staff", "is shit", "isshit",
	},
}

_permissions = {
	["demote"] = 1,
	["promote"] = 2,
	["kick"] = 3,
	["promoteUntilOwnRank"] = 4,
	["editInfo"] = 5,
	["invite"] = 6,
	["delete"] = 7,
	["editWhitelist"] = 8,
	["editBlacklist"] = 9,
	["history"] = 10,
	["demoteWithSameRank"] = 11,
	["deposit"] = 12,
	["withdraw"] = 13,
	["groupColour"] = 14,
	["alliance"] = 15,
	["chatColour"] = 16,
	["warn"] = 17,
	["gsc"] = 18,
	["gmotd"] = 19,
	--
	--[[
	["groupJob"] = 20,
	["editBaseInfo"] = 21,
	["editJobInfo"] = 22,
	["modifySpawners"] = 23,
	--]]
}

defaultRanks = {
	-- [name] 	= {{permissions}, rankIndex},
	["Trial"] 	= {{}, 0},
	["Regular"] = {{[12] = true}, 1},
	["Trusted"] = {{[8] = true, [10] = true, [12] = true}, 2},
	["Deputy"] 	= {{[1] = true, [2] = true, [3] = true, [6] = true, [8] = true, [9] = true, [10] = true, [12] = true, [17] = true, [18] = true, [19] = true}, 3},
	["Leader"] 	= {{[1] = true, [2] = true, [3] = true, [4] = true, [6] = true, [8] = true, [9] = true, [10] = true, [12] = true, [15] = true, [16] = true, [17] = true, [18] = true, [19] = true}, 4},
	["Founder"] = {{}, -1},
}

db = exports.UCDsql:getConnection()

group = {} -- Resolves a player to a group (nil otherwise)
groupTable = {} -- Contains information from the groups_ table with the group name as the index
groupMembers = {} -- We can just get their player elements from their id since more caching was introduced
groupRanks = {} -- Contains group ranks from groups_ranks with the rank name as the index
playerInvites = {} -- When a player gets invited ([accName] = group_)
playerGroupCache = {} -- Player group cache with the account name as the key
onlineTime = {} -- Resolves player online time
blacklistCache = {} -- Cache's a group's blacklist
groupEditingRanks = {} -- A table that tells us when a group is editing ranks so we do not promote/demote anyone in the meantime

-- Alliances
g_alliance = {} -- Group to alliance
allianceTable = {} -- groups_alliances_
allianceMembers = {} -- groups_alliances_members
allianceInvites = {}

addEventHandler("onResourceStart", resourceRoot,
	function ()
		if (not db) then outputDebugString("["..Resource.getName(resourceRoot).."] Unable to load groups") return end
		db:query(cacheGroupTable, {}, "SELECT * FROM `groups_`")
	end
)

function cacheGroupTable(qh)
	local result = qh:poll(-1)
	for _, row in ipairs(result) do
		groupTable[row.groupName] = {}
		for column, data in pairs(row) do
			if (column ~= "groupName") then
				groupTable[row.groupName][column] = data
			end
		end
	end
	if (result and #result >= 1) then
		db:query(cacheGroupMembers, {}, "SELECT `groupName`, `account` FROM `groups_members`")
	end
end

function cacheGroupMembers(qh)
	local result = qh:poll(-1)
	for _, row in ipairs(result) do
		if (groupTable[row.groupName]) then
			if (not groupMembers[row.groupName]) then
				groupMembers[row.groupName] = {}
			end
			table.insert(groupMembers[row.groupName], row.account)
			if (Account(row.account)) then
				local member = Account(row.account).player
				if (member) then
					db:exec("UPDATE `groups_members` SET `lastOnline`=? WHERE `account`=?", getRealTime().yearday, row.account)
				end
			end
 		end
	end
	for name in pairs(groupTable) do
		if (not groupMembers[name] or #groupMembers[name] == 0) then
			outputDebugString("Group "..name.." has 0 members")
		end
	end
	db:query(cacheGroupRanks, {}, "SELECT * FROM `groups_ranks`")
	db:query(cacheGroupInvites, {}, "SELECT `account`, `groupName`, `by` FROM `groups_invites`")
end

function cacheGroupRanks(qh)
	local result = qh:poll(-1)
	for _, row in ipairs(result) do
		if (not groupRanks[row.groupName]) then groupRanks[row.groupName] = {} end
		if (row.rankIndex == -1) then
			groupRanks[row.groupName][row.rankName] = {nil, row.rankIndex}
		else
			local tbl = {}
			for i, v in pairs(fromJSON(row.permissions)) do
				tbl[tonumber(i)] = v
			end
			groupRanks[row.groupName][row.rankName] = {tbl, row.rankIndex}
		end
	end
	db:query(cacheAlliances, {}, "SELECT * FROM `groups_alliances_`")
end

function cacheGroupInvites(qh)
	local result = qh:poll(-1)
	for _, row in pairs(result) do
		if (not playerInvites[row.account]) then
			playerInvites[row.account] = {}
		end
		table.insert(playerInvites[row.account], {row.groupName, row.by})
	end
	-- Resource should be fully loaded by now, let's load things for existing players
	for _, plr in pairs(Element.getAllByType("player")) do
		if (not plr.account.guest) then
			handleLogin(plr)
		end
	end
end

function cacheAlliances(qh)
	local result = qh:poll(-1)
	for _, row in ipairs(result) do		
		allianceTable[row.alliance] = {row.info, row.colour, row.balance, row.created}
	end
	db:query(cacheAllianceMembers, {}, "SELECT * FROM `groups_alliances_members`")
end

function cacheAllianceMembers(qh)
	local result = qh:poll(-1)
	for _, row in ipairs(result) do
		if (not allianceMembers[row.alliance]) then
			allianceMembers[row.alliance] = {}
		end
		allianceMembers[row.alliance][row.groupName] = row.rank
		g_alliance[row.groupName] = row.alliance
	end
	db:query(cacheAllianceInvites, {}, "SELECT * FROM `groups_alliances_invites`")
end

function cacheAllianceInvites(qh)
	local result = qh:poll(-1)
	for _, row in ipairs(result) do
		if (not allianceInvites[row.groupName]) then
			allianceInvites[row.groupName] = {}
		end
		table.insert(allianceInvites[row.groupName], {row.alliance, row.groupBy, row.playerBy})
	end
end

function createGroup(name)
	local groupName = name
	if (client and groupName) then
		if (getPlayerGroup(client)) then
			exports.UCDdx:new(client, "You cannot create a group because you are already in one. Leave your current group first.", 255, 0, 0)
			return false
		end
		if (groupTable[groupName]) then
			exports.UCDdx:new(client, "A group with this name already exists", 255, 0, 0)
			return
		end
		for g, row in pairs(groupTable) do
			if (g == groupName) then
				exports.UCDdx:new("A group with this name already exists", 255, 0, 0)
				return false
			end
			if (g:lower() == groupName:lower()) then
				exports.UCDdx:new("A group with this name, but with different case, already exists", 255, 0, 0)
				return false
			end
		end
		for type_, row in pairs(forbidden) do
			for _, chars in pairs(row) do
				if type_ == "whole" then
					if (groupName == chars) then
						exports.UCDdx:new(client, "The specified group name is prohibited. If you believe this is a mistake, please notify an administrator.", 255, 0, 0)
						return false
					end
				else
					if (groupName:lower():find(chars)) then
						exports.UCDdx:new(client, "The specified group name contains forbidden phrases or characters. If you believe this is a mistake, please notify an administrator.", 255, 0, 0)
						return false
					end
				end
			end
		end
		
		local d, t = exports.UCDutil:getTimeStamp()
		db:exec("INSERT INTO `groups_` SET `groupName` = ?, `colour` = ?, `chatColour` = ?, `info` = ?, `created` = ?, `gmotd` = ?, `gmotd_setter` = ?", groupName, toJSON(settings.default_colour), toJSON(settings.default_chat_colour), settings.default_info_text, d.." "..t, "", "") -- Perform the inital group creation	
		db:exec("INSERT INTO `groups_members` (`account`, `groupName`, `rank`, `lastOnline`, `joined`, `timeOnline`, `warningLevel`) VALUES (?, ?, ?, ?, ?, ?, ?)", client.account.name, groupName, "Founder", getRealTime().yearday, d, getPlayerOnlineTime(client), 0) -- Make the client's membership official and grant founder status
		setDefaultRanks(groupName)
		
		groupTable[groupName] = {
			["info"] = settings.default_info_text, ["memberCount"] = 1, ["created"] = d.." "..t, ["colour"] = toJSON(settings.default_colour),
			["balance"] = 0, ["chatColour"] = toJSON(settings.default_chat_colour), ["gmotd"] = "",
		}
		
		createGroupLog(groupName, client.name.." ("..client.account.name..") has created "..groupName, true)
		groupMembers[groupName] = {}
		table.insert(groupMembers[groupName], client.account.name)
		client:setData("group", groupName)
		group[client] = groupName
		playerGroupCache[client.account.name] = {groupName, client.account.name, "Founder", d, getRealTime().yearday, 0, 0} -- Should I even bother?
		exports.UCDdx:new(client, "You have successfully created "..groupName, 0, 255, 0)
		triggerEvent("UCDgroups.viewUI", client, true)
	end
end
addEvent("UCDgroups.createGroup", true)
addEventHandler("UCDgroups.createGroup", root, createGroup)

function leaveGroup(reason)
	if (client) then
		local group_ = getPlayerGroup(client)
		if (group_) then
			local rank = getGroupLastRank(group_)
			if (getPlayerGroupRank(client) == rank) then -- If they are a founder
				if (getMembersWithRank(group_, rank) == 1) then
					exports.UCDdx:new(client, "You can't leave your group because you're the only one with the "..rank.." rank", 255, 255, 0)
					return
				end
			end
			if (not reason or reason == " " or reason == "" or reason:gsub(" ", "") == "") then
				reason = "No Reason"
			end
			
			createGroupLog(group_, client.name.." ("..client.account.name..") has left "..group_.." ("..reason..")")
			
			for k, v in pairs(groupMembers[group_]) do
				if (v == client.account.name) then
					table.remove(groupMembers[group_], k)
					break
				end	
			end
			
			client:removeData("group")
			group[client] = nil
			playerGroupCache[client.account.name] = nil
			db:exec("DELETE FROM `groups_members` WHERE `account` = ?", client.account.name)
			exports.UCDdx:new(client, "You have left "..group_.." ("..reason..")", 255, 0, 0)
			messageGroup(group_, " has left the group ("..reason..")")
			triggerEvent("UCDgroups.viewUI", client, true)
		end
	end
end
addEvent("UCDgroups.leaveGroup", true)
addEventHandler("UCDgroups.leaveGroup", root, leaveGroup)

function deleteGroup()
	if (client) then
		local groupName = getPlayerGroup(client)
		if (not groupName) then
			exports.UCDdx:new(client, "You are not in a group", 255, 0, 0)
			return
		end
		
		-- Must also check if they are in an alliance
		local alliance = g_alliance[groupName]
		if (alliance) then
			local leaderCount = 0
			for g, rank in pairs(allianceMembers[alliance]) do
				if (rank == "Leader" and g ~= groupName) then
					leaderCount = leaderCount + 1
				end
			end
			if (leaderCount == 0) then
				exports.UCDdx:new(client, "You cannot delete this group until you give leadership of the alliance to another group, or delete the alliance", 255, 0, 0)
				return false
			end
			
			db:exec("DELETE FROM `groups_alliances_members` WHERE `groupName` = ? AND `alliance` = ?", groupName, alliance)
			db:exec("DELETE FROM `groups_alliances_invites` WHERE `groupName` = ?", groupName)
			
			g_alliance[groupName] = nil
			allianceMembers[alliance][groupName] = nil
			allianceInvites[groupName] = nil
		end
		
		createGroupLog(group_, client.name.." ("..client.account.name..") has deleted "..groupName, true)
		
		outputDebugString("Deleting group where groupName = "..groupName)
		db:exec("DELETE FROM `groups_` WHERE `groupName` = ?", groupName)
		db:exec("DELETE FROM `groups_members` WHERE `groupName` = ?", groupName)
		db:exec("DELETE FROM `groups_ranks` WHERE `groupName` = ?", groupName)
		db:exec("DELETE FROM `groups_invites` WHERE `groupName` = ?", groupName)
		db:exec("DELETE FROM `groups_blacklist` WHERE `groupName` = ?", groupName)
		db:exec("DELETE FROM `groups_whitelist` WHERE `groupName` = ?", groupName)
		db:exec("DELETE FROM `groups_logs` WHERE `groupName` = ? AND `important` <> 1", groupName)
		
		-- Remove the invite from the table
		for acc, row in pairs(playerInvites) do
			for i, v in pairs(row) do
				if (v[1] == groupName) then
					table.remove(playerInvites[acc], i)
				end
			end
		end
		
		for _, account in pairs(groupMembers[groupName]) do
			local plr = Account(account).player
			if (plr and isElement(plr) and plr.type == "player" and getPlayerGroup(plr)) then
				plr:removeData("group")
				group[plr] = nil
				playerGroupCache[plr.account.name] = nil
				exports.UCDdx:new(plr, client.name.." has decided to delete the group", 255, 0, 0)
				triggerEvent("UCDgroups.viewUI", plr, true)
			end
		end
		
		-- Clear from the table to free memory
		groupMembers[groupName] = nil
		groupTable[groupName] = nil
		groupRanks[groupName] = nil
		
		-- Let the client know he did it
		exports.UCDdx:new(client, "You have deleted the group "..groupName, 255, 0, 0)
	end
end
addEvent("UCDgroups.deleteGroup", true)
addEventHandler("UCDgroups.deleteGroup", root, deleteGroup)

function joinGroup(group_)
	--if (not client) then client = source end
	if (source and group_) then
		if (groupTable[group_]) then
			if (not exports.UCDaccounts:isPlayerLoggedIn(source) or getPlayerGroup(source)) then
				return
			end
			local account = source.account.name
			local rank = getGroupFirstRank(group_)
			local d, t = exports.UCDutil:getTimeStamp()
			
			db:exec("INSERT INTO `groups_members` SET `groupName`=?, `account`=?, `rank`=?, `lastOnline`=?, `timeOnline`=?", group_, account, rank, getRealTime().yearday, getPlayerOnlineTime(plr))
			
			--groupTable[group_].memberCount = groupTable[group_].memberCount + 1
			--db:exec("UPDATE `groups_` SET `memberCount`=? WHERE `groupName`=?", tonumber(groupTable[group_].memberCount), group_)
			
			createGroupLog(group_, source.name.." ("..source.account.name..") has joined "..group_)
			
			table.insert(groupMembers[group_], account)
			source:setData("group", group_)
			group[source] = group_
			playerGroupCache[account] = {group_, account, rank, d, getRealTime().yearday, 0, 0}
			exports.UCDdx:new(source, "You have joined "..group_, 0, 255, 0)
			messageGroup(group_, source.name.." has joined the group", "info")
			triggerEvent("UCDgroups.viewUI", source, true)
		else
			exports.UCDdx:new(source, "You can't join this group because it doesn't exist", 255, 255, 0)
		end
	end
end
addEvent("UCDgroups.joinGroup", true)
addEventHandler("UCDgroups.joinGroup", root, joinGroup)

function sendInvite(plr)
	if (client) then
		if (not plr or not isElement(plr) or plr.type ~= "player") then
			return
		end
		if (getPlayerGroup(plr)) then
			return
		end
		local group_ = getPlayerGroup(client)
		if (group_) then
			if (canPlayerDoActionInGroup(client, "invite")) then
				if (groupTable[group_].lockInvites == 1) then
					exports.UCDdx:new(client, "The group is currently locked - no invites may be sent", 255, 0, 0)
					return
				end
				-- send invite, tell plr, tell group, add to queue, put in sql
				--playerInvites[plr.account.name] = {group_, client.name}
				if (not playerInvites[plr.account.name]) then
					playerInvites[plr.account.name] = {}
				end
				local result
				-- SQL will do less looping but it is inherently slower
				if (blacklistCache[group_]) then
					result = blacklistCache[group_]
				else
					result = db:query("SELECT `serialAccount` FROM `groups_blacklist` WHERE `groupName` = ?", group_):poll(-1)
				end
				if (result and #result > 0) then
					for _, ent in ipairs(result) do
						if (ent.serialAccount == plr.account.name) then
							exports.UCDdx:new(client, "You cannot invite this player as their account is blacklisted", 255, 255, 0)
							return
						end
						if (ent.serialAccount == plr.serial) then
							exports.UCDdx:new(client, "You cannot invite this player as their serial is blacklisted", 255, 255, 0)
							return
						end
					end
				end
				for index, row in pairs(playerInvites[plr.account.name]) do
					for _, data in pairs(row) do
						if (data == group_) then
							exports.UCDdx:new(client, "This player has already been invited to this group", 255, 255, 0)
							return
						end
					end
				end
				table.insert(playerInvites[plr.account.name], {group_, client.name})
				db:exec("INSERT INTO `groups_invites` SET `account`=?, `groupName`=?, `by`=?", plr.account.name, group_, client.name)
				createGroupLog(group_, client.name.." ("..client.account.name..") has invited "..plr.name.." ("..plr.account.name..") to the group")
				messageGroup(group_, client.name.." has invited "..plr.name.." to the group", "info")
				exports.UCDdx:new(plr, "You have been invited to "..group_.." by "..client.name..". Press F6 -> 'Group Invites' to view your invites", 0, 255, 0)
			else
				exports.UCDdx:new(client, "You don't have permission to do this action (invite)", 200, 0, 0)
			end
		end
	end
end
addEvent("UCDgroups.sendInvite", true)
addEventHandler("UCDgroups.sendInvite", root, sendInvite)

function handleInvite(groupName, state)
	if (client and groupName and state) then
		-- Delete the current invite (this loop works flawlessly)
		for index, row in pairs(playerInvites[client.account.name]) do
			for _, data in pairs(row) do
				if (data == groupName) then
					table.remove(playerInvites[client.account.name], index)
				end
			end
		end
		db:exec("DELETE FROM `groups_invites` WHERE `groupName` = ? AND `account` =? ", groupName, client.account.name)
		if (state == "accept") then
			if (groupTable[groupName].lockInvites == 1) then
				exports.UCDdx:new(client, "Unable to accept the invite - this group is locked", 255, 0, 0)
				triggerEvent("UCDgroups.requestInviteList", client)
				return
			end
			local result
			if (blacklistCache[groupName]) then
				result = blacklistCache[groupName]
			else
				result = db:query("SELECT `serialAccount` FROM `groups_blacklist` WHERE `groupName`=?", groupName):poll(-1)
			end
			if (result and #result > 0) then
				for _, ent in ipairs(result) do
					if (ent.serialAccount == client.serial) then
						exports.UCDdx:new(client, "You cannot join this group as your serial is blacklisted", 255, 0, 0)
						triggerEvent("UCDgroups.requestInviteList", client)
						return
					end
					if (ent.serialAccount == client.account.name) then
						exports.UCDdx:new(client, "You cannot join this group as your account is blacklisted", 255, 0, 0)
						triggerEvent("UCDgroups.requestInviteList", client)
						return
					end
				end
			end
			-- Make the player join the group
			-- messageGroup(groupName, client.name.." has joined the group", "info") -- Already handled in joinGroup function
			triggerEvent("UCDgroups.joinGroup", client, groupName)
		elseif (state == "deny") then
			messageGroup(groupName, client.name.." has declined the invitation to join the group", "info")
			exports.UCDdx:new(client, "You have declined the invitation to join "..groupName, 255, 255, 0)
		end
		
		triggerEvent("UCDgroups.requestInviteList", client)
	end
end
addEvent("UCDgroups.handleInvite", true)
addEventHandler("UCDgroups.handleInvite", root, handleInvite)

function requestInvites()
	if (source) then
		if (exports.UCDaccounts:isPlayerLoggedIn(source)) then
			local invites = playerInvites[source.account.name]
			triggerLatentClientEvent(source, "UCDgroups.inviteList", source, invites or {})
		end
	end
end
addEvent("UCDgroups.requestInviteList", true)
addEventHandler("UCDgroups.requestInviteList", root, requestInvites)

function promoteMember(accName, newRank, reason)
	if (client and accName and reason) then
		local group_ = getPlayerGroup(client)
		local acc = Account(accName)
		local clientRank = getPlayerGroupRank(client)
		local plrRank = playerGroupCache[accName][3]
		--local newRank = getNextRank(group_, plrRank)
		if (reason:gsub(" ", "") == "") then reason = "No Reason" end
		
		if (groupEditingRanks[group_]) then
			exports.UCDdx:new(client, "Ranks are currently being edited - you cannot warn, promote, demote or kick right now", 255, 0, 0)
			return
		end
		
		if (plrRank == getGroupLastRank(group_)) then return end
		if (group_ and acc) then
			if (canPlayerDoActionInGroup(client, "promote")) then
				if (isRankHigherThan(group_, clientRank, plrRank) == true) then
					if (newRank == clientRank and not canPlayerDoActionInGroup(client, "promoteUntilOwnRank")) then
						return
					end
					if (isRankHigherThan(group_, clientRank, newRank) == false) then return end
					playerGroupCache[accName][3] = newRank
					db:exec("UPDATE `groups_members` SET `rank`=? WHERE `account`=?", newRank, accName)
					triggerEvent("UCDgroups.viewUI", client, true)
					triggerEvent("UCDgroups.requestMemberList", client)
					
					createGroupLog(group_, client.name.." ("..client.account.name..") has promoted "..exports.UCDaccounts:GAD(accName, "lastUsedName").." ("..accName..") to "..newRank.." ("..reason..")")
					
					if (acc.player) then
						messageGroup(group_, client.name.." is promoting "..acc.player.name.." to "..newRank.." ("..reason..")", "info")
						triggerEvent("UCDgroups.viewUI", acc.player, true) -- Update the player's GUI
					else
						messageGroup(group_, client.name.." is promoting "..accName.." to "..newRank.." ("..reason..")", "info")
					end
					
					triggerClientEvent(client, "UCDgroups.promoteDemoteWindow", client)
				else
					exports.UCDdx:new(client, "You cannot promote players with same or higher rank", 200, 0, 0)
				end
			end
		else
			exports.UCDdx:new(client, "This player cannot be promoted", 200, 0, 0)
		end
	end
end
addEvent("UCDgroups.promoteMember", true)
addEventHandler("UCDgroups.promoteMember", root, promoteMember)

function demoteMember(accName, newRank, reason)
	if (client and accName and newRank and reason) then
		local group_ = getPlayerGroup(client)
		local acc = Account(accName)
		
		local clientRank = getPlayerGroupRank(client)
		local plrRank = playerGroupCache[accName][3]
		--local newRank = getPreviousRank(group_, plrRank)
		if (reason:gsub(" ", "") == "") then reason = "No Reason" end
		
		if (groupEditingRanks[group_]) then
			exports.UCDdx:new(client, "Ranks are currently being edited - you cannot warn, promote, demote or kick right now", 255, 0, 0)
			return
		end
		
		if (canPlayerDoActionInGroup(client, "demote")) then
			if (isRankHigherThan(group_, clientRank, plrRank)) then
				if (plrRank == clientRank and not canPlayerDoActionInGroup(client, "demoteWithSameRank")) then
					exports.UCDdx:new(client, "You are not allowed to demote players with the same rank as you", 255, 0, 0)
					return
				end
				if (isRankHigherThan(group_, clientRank, newRank) == false) then return end
				if (plrRank == getGroupFirstRank(group_)) then
					exports.UCDdx:new(client, "You cannot demote this player as they have the lowest rank already", 255, 0, 0)
					return
				end
				playerGroupCache[accName][3] = newRank
				db:exec("UPDATE `groups_members` SET `rank`=? WHERE `account`=?", newRank, accName)
				triggerEvent("UCDgroups.viewUI", client, true)
				triggerEvent("UCDgroups.requestMemberList", client)
				
				createGroupLog(group_, client.name.." ("..client.account.name..") has demoted "..exports.UCDaccounts:GAD(accName, "lastUsedName").." ("..accName..") to "..newRank.." ("..reason..")")
				triggerClientEvent(client, "UCDgroups.promoteDemoteWindow", client)
				
				if (acc.player) then
					messageGroup(group_, client.name.." is demoting "..acc.player.name.." to "..newRank.." ("..reason..")", "info")
					triggerEvent("UCDgroups.viewUI", acc.player, true)
				else
					messageGroup(group_, client.name.." is demoting "..accName.." to "..newRank.." ("..reason..")", "info")
				end
			else
				exports.UCDdx:new(client, "You can't demote players with a higher rank than you", 255, 0, 0)
			end
		end
	end
end
addEvent("UCDgroups.demoteMember", true)
addEventHandler("UCDgroups.demoteMember", root, demoteMember)

function kickMember(accName, reason)
	if (client and accName and reason) then
		local group_ = getPlayerGroup(client)
		local acc = Account(accName)
		local clientRank = getPlayerGroupRank(client)
		local plrRank = playerGroupCache[accName][3]
		if (reason:gsub(" ", "") == "") then reason = "No Reason" end
		
		if (groupEditingRanks[group_]) then
			exports.UCDdx:new(client, "Ranks are currently being edited - you cannot warn, promote, demote or kick right now", 255, 0, 0)
			return
		end
		
		if (canPlayerDoActionInGroup(client, "kick")) then
			if (isRankHigherThan(group_, clientRank, plrRank)) then
				if (plrRank == clientRank and not canPlayerDoActionInGroup(client, "demotePlayersWithSameRank")) then
					exports.UCDdx:new(client, "You are not allowed to kick players with the same rank as you", 255, 0, 0)
					return
				end
				
				for k, v in pairs(groupMembers[group_]) do
					if v == accName then
						table.remove(groupMembers[group_], k)
						--groupMembers[group_][k] = nil
						break
					end	
				end
				
				playerGroupCache[accName] = nil
				--groupTable[group_].memberCount = groupTable[group_].memberCount - 1
				--db:exec("UPDATE `groups_` SET `memberCount`=? WHERE `groupName`=?", tonumber(groupTable[group_].memberCount), group_)
				db:exec("DELETE FROM `groups_members` WHERE `account`=?", accName)
				
				createGroupLog(group_, client.name.." ("..client.account.name..") has kicked "..exports.UCDaccounts:GAD(accName, "lastUsedName").." ("..accName..") ("..reason..")")
				
				if (acc.player) then
					acc.player:removeData("group")
					local r, g, b = getGroupChatColour(group_)
					exports.UCDdx:new(acc.player, "You have been kicked from "..group_.." by "..client.name.." ("..reason..")", r, g, b)
					group[acc.player] = nil
					messageGroup(group_, client.name.." has kicked "..acc.player.name.." ("..reason..")", "info")
					triggerEvent("UCDgroups.viewUI", acc.player, true)
				else
					messageGroup(group_, client.name.." has kicked "..accName.." ("..reason..")", "info")
				end
				triggerEvent("UCDgroups.viewUI", client, true)
				triggerEvent("UCDgroups.requestMemberList", client)
				--]]
			else
				exports.UCDdx:new(client, "You can't kick players with a higher rank than you", 255, 0, 0)
			end
		end
	end
end
addEvent("UCDgroups.kickMember", true)
addEventHandler("UCDgroups.kickMember", root, kickMember)

function warnMember(accName, level, reason)
	if (client and accName and level and reason) then
		local group_ = getPlayerGroup(client)
		
		local clientRank = getPlayerGroupRank(client)
		local plrRank = playerGroupCache[accName][3]
		
		if (groupEditingRanks[group_]) then
			exports.UCDdx:new(client, "Ranks are currently being edited - you cannot warn, promote, demote or kick right now", 255, 0, 0)
			return
		end
		
		if (group_) then
			if (canPlayerDoActionInGroup(client, "warn") and isRankHigherThan(group_, clientRank, plrRank)) then
				if (level == playerGroupCache[accName][7]) then return end
				local change = level - playerGroupCache[accName][7]
				if (change > 0) then
					change = "+"..change.."%"
				else
					change = change.."%"
				end
				if (Account(accName).player) then
					messageGroup(group_, client.name.." has warned "..Account(accName).player.name.." ("..change..") ("..reason..")", "info")
				else
					messageGroup(group_, client.name.." has warned "..accName.." ("..change..") ("..reason..")", "info")
				end
				db:exec("UPDATE `groups_members` SET `warningLevel`=? WHERE `account`=?", level, accName)
				playerGroupCache[accName][7] = level
				createGroupLog(group_, client.name.." ("..client.account.name..") has warned "..exports.UCDaccounts:GAD(accName, "lastUsedName").." ("..accName..") ("..change..") ["..level.."] ("..reason..")")
				
				triggerEvent("UCDgroups.viewUI", client, true)
				triggerEvent("UCDgroups.requestMemberList", client)
			end
		end
	end
end
addEvent("UCDgroups.warnMember", true)
addEventHandler("UCDgroups.warnMember", root, warnMember)

function changeGroupBalance(type_, balanceChange)
	if (client) then
		if (not balanceChange or tonumber(balanceChange) == nil) then
			exports.UCDdx:new(client, "Something went wrong!", 255, 255, 0)
			return
		end
		local group_ = getPlayerGroup(client)
		if (group and canPlayerDoActionInGroup(client, type_)) then
			local currentBalance = groupTable[group_].balance
			if (type_ == "deposit") then
				if (client.money < balanceChange) then
					exports.UCDdx:new(client, "You can't deposit this much because you don't have it", 255, 0, 0)
					return
				end
				if (balanceChange <= 0) then
					exports.UCDdx:new(client, "You must enter a positive number", 255, 255, 0)
					return
				end
				groupTable[group_].balance = groupTable[group_].balance + balanceChange
				client.money = client.money - balanceChange
				db:exec("UPDATE `groups_` SET `balance`=? WHERE `groupName`=?", tonumber(groupTable[group_].balance), group_)
				messageGroup(group_, client.name.." has deposited $"..exports.UCDutil:tocomma(balanceChange).." into the group bank", "info")
				createGroupLog(group_, client.name.." ("..client.account.name..") has deposited $"..exports.UCDutil:tocomma(balanceChange).." into the group bank")
				triggerLatentClientEvent(client, "UCDgroups.balanceWindow", client, "update", groupTable[group_].balance)
			elseif (type_ == "withdraw") then
				if ((currentBalance - balanceChange) < 0) then
					exports.UCDdx:new(client, "The group doesn't have this much", 255, 255, 0)
					return
				end
				if (balanceChange <= 0) then
					exports.UCDdx:new(client, "You must enter a positive number", 255, 255, 0)
					return
				end
				groupTable[group_].balance = groupTable[group_].balance - balanceChange
				client.money = client.money + balanceChange
				db:exec("UPDATE `groups_` SET `balance`=? WHERE `groupName`=?", tonumber(groupTable[group_].balance), group_)
				messageGroup(group_, client.name.." has withdrawn $"..exports.UCDutil:tocomma(balanceChange).." from the group bank", "info")
				createGroupLog(group_, client.name.." ("..client.account.name..") has withdrawn $"..exports.UCDutil:tocomma(balanceChange).." from the group bank")
				triggerLatentClientEvent(client, "UCDgroups.balanceWindow", client, "update", groupTable[group_].balance)
			end
		end
	end
end
addEvent("UCDgroups.changeBalance", true)
addEventHandler("UCDgroups.changeBalance", root, changeGroupBalance)

function requestBalance()
	if (client or source) then
		local group_ = getPlayerGroup(source)
		if (group_) then
			triggerClientEvent(source, "UCDgroups.balanceWindow", source, "toggle", tonumber(groupTable[group_].balance))
		end
	end
end
addEvent("UCDgroups.requestBalance", true)
addEventHandler("UCDgroups.requestBalance", root, requestBalance)

function updateGroupInfo(newInfo)
	if (client) then
		local groupName = getPlayerGroup(client)
		if (groupName) then
			groupTable[groupName].info = newInfo
			db:exec("UPDATE `groups_` SET `info`=? WHERE `groupName`=?", newInfo, groupName)
			messageGroup(groupName, client.name.." has updated the group information", "info")
			createGroupLog(group_, client.name.." ("..client.account.name..") has updated the group information")
			for _, plr in pairs(getGroupOnlineMembers(groupName)) do
				triggerEvent("UCDgroups.viewUI", plr, true)
			end
		end
	end
end
addEvent("UCDgroups.updateInfo", true)
addEventHandler("UCDgroups.updateInfo", root, updateGroupInfo)

function requestMemberList()
	if (source) then
		local group_ = getPlayerGroup(source)
		if (group_) then
			local members = getAdvancedGroupMembers(group_)
			triggerLatentClientEvent(source, "UCDgroups.memberList", source, members)
		end
	end
end
addEvent("UCDgroups.requestMemberList", true)
addEventHandler("UCDgroups.requestMemberList", root, requestMemberList)

function requestGroupList()
	if (client) then
		local temp = {}
		for groupName, data in pairs(groupTable) do
			if (getGroupMemberCount(groupName) and getGroupMemberCount(groupName) >= 1) then
				temp[groupName] = {members = getGroupMemberCount(groupName), slots = data.slots or 50}
			end
		end
		if (temp) then
			triggerClientEvent(client, "UCDgroups.groupList", client, temp)
		end
	end
end
addEvent("UCDgroups.requestGroupList", true)
addEventHandler("UCDgroups.requestGroupList", root, requestGroupList)

function requestGroupHistory()
	if (client) then
		local group_ = getPlayerGroup(client)
		if (group_) then
			if (canPlayerDoActionInGroup(client, "history")) then
				local history, rows = db:query("SELECT `log` AS `log_` FROM `groups_logs` WHERE `groupName`=? ORDER BY `log` DESC LIMIT 100", group_):poll(-1)
				local total = db:query("SELECT Count(*) AS `count_` FROM `groups_logs` WHERE `groupName`=?", group_):poll(-1)[1].count_
				triggerLatentClientEvent(client, "UCDgroups.history", client, history or {}, total or 0, rows or 0)
			else
				exports.UCDdx:new(client, "You are not allowed to view the group history", 255, 0, 0)
			end
		end
	end
end
addEvent("UCDgroups.requestGroupHistory", true)
addEventHandler("UCDgroups.requestGroupHistory", root, requestGroupHistory)

function requestGroupRanks()
	if (source) then
		local group_ = getPlayerGroup(source)
		if (group_) then
			triggerLatentClientEvent(source, "UCDgroups.groupRanks", source, groupRanks[group_])
		end
	end
end
addEvent("UCDgroups.requestGroupRanks", true)
addEventHandler("UCDgroups.requestGroupRanks", root, requestGroupRanks)

function requestGroupSettings()
	if (source) then
		local group_ = getPlayerGroup(source)
		if (group_) then
			local temp = {
				["groupColour"] = fromJSON(groupTable[group_].colour) or settings.default_colour,
				["chatColour"] = fromJSON(groupTable[group_].chatColour) or settings.default_chat_colour,
				["gmotd"] = groupTable[group_].gmotd or "",
				["enableGSC"] = groupTable[group_].enableGSC or 1,
				["lockInvites"] = groupTable[group_].lockInvites or 0,
			}
			triggerLatentClientEvent(source, "UCDgroups.settings", source, temp)
		end
	end
end
addEvent("UCDgroups.requestGroupSettings", true)
addEventHandler("UCDgroups.requestGroupSettings", root, requestGroupSettings)

function requestBlacklist()
	if (source) then
		local group_ = getPlayerGroup(source)
		if (group_) then
			local blacklist
			if (blacklistCache[group_]) then
				blacklist = blacklistCache[group_]
			else
				blacklist = db:query("SELECT * FROM `groups_blacklist` WHERE `groupName`=?", group_):poll(-1)
				if (blacklist and #blacklist > 0) then
					blacklistCache[group_] = blacklist
				end
			end
			triggerLatentClientEvent(source, "UCDgroups.blacklist", source, blacklist or {})
		end
	end
end
addEvent("UCDgroups.requestBlacklist", true)
addEventHandler("UCDgroups.requestBlacklist", root, requestBlacklist)

function addBlacklistEntry(serialAccount, reason)
	if (client and serialAccount and reason and db) then
		local group_ = getPlayerGroup(client)
		if (group_) then
			if (canPlayerDoActionInGroup(client, "editBlacklist")) then
				if (blacklistCache[group_]) then
					local result = blacklistCache[group_]
					for i = 1, #result do
						if (result[i].serialAccount == serialAccount) then
							exports.UCDdx:new(client, "This serial or account is already blacklisted", 255, 0, 0)
							return
						end
					end
				else
					local result = db:query("SELECT `uniqueID` FROM `groups_blacklist` WHERE `serialAccount`=? AND `groupName`=?", serialAccount, group_):poll(-1)
					if (result and #result > 0) then
						exports.UCDdx:new(client, "This serial or account is already blacklisted", 255, 0, 0)
						return
					end
				end
				if (not Account(serialAccount) and serialAccount:len() ~= 32) then
					exports.UCDdx:new(client, "This specified account does not exist", 255, 0, 0)
					return
				end
				-- Should be good to go
				--db:exec("INSERT INTO `groups_blacklist` SET `groupName`=?, `serialAccount`=?, `by`=?, `reason`=?", group_, serialAccount, client.account.name, reason)
				local d, t = exports.UCDutil:getTimeStamp()
				db:exec("INSERT INTO `groups_blacklist` (`groupName`, `serialAccount`, `by`, `reason`, `datum`) VALUES (?, ?, ?, ?, NOW())", group_, serialAccount, client.account.name, reason) -- CONCAT(CURDATE(), ' ', CURTIME())
				if (not blacklistCache[group_]) then
					blacklistCache[group_] = {}
				end 
				table.insert(blacklistCache[group_], {["groupName"] = group_, ["serialAccount"] = serialAccount, ["by"] = client.account.name, ["reason"] = reason, ["datum"] = tostring(d.." "..t)})
				if (serialAccount:len() ~= 32) then
					exports.UCDdx:new(client, "You have added a blacklisting on account "..serialAccount, 255, 0, 0)
					createGroupLog(group_, client.name.." ("..client.account.name..") has added a blacklisting on account "..serialAccount)
				else
					exports.UCDdx:new(client, "You have added a blacklisting on serial "..serialAccount, 255, 0, 0)
					createGroupLog(group_, client.name.." ("..client.account.name..") has added a blacklisting on serial "..serialAccount)
				end
				triggerEvent("UCDgroups.requestBlacklist", client)
			else
				exports.UCDdx:new(client, "You are not allowed to edit the group's blacklist", 255, 0, 0)
			end
		end
	end
end
addEvent("UCDgroups.addBlacklistEntry", true)
addEventHandler("UCDgroups.addBlacklistEntry", root, addBlacklistEntry)

function removeBlacklistEntry(serialAccount)
	if (client and serialAccount and db) then
		local group_ = getPlayerGroup(client)
		if (group_) then
			if (canPlayerDoActionInGroup(client, "editBlacklist")) then
				local result = db:query("SELECT * FROM `groups_blacklist` WHERE `serialAccount`=? AND `groupName`=?", serialAccount, group_):poll(-1)
				if (not result or result == nil or #result >= 1) then
					local type1
					if (serialAccount:len() == 32) then -- serial
						type1 = "serial"
					else
						type1 = "account"
					end
					db:exec("DELETE FROM `groups_blacklist` WHERE `serialAccount`=? AND `groupName`=?", serialAccount, group_)
					if (blacklistCache[group_]) then
						for i = 1, #blacklistCache[group_] do
							if (blacklistCache[group_][i].serialAccount == serialAccount) then
								table.remove(blacklistCache[group_], i)
								break
							end
						end
					end
					exports.UCDdx:new(client, "You have removed the blacklisting on "..serialAccount, 255, 0, 0)
					createGroupLog(group_, client.name.." ("..client.account.name..") has removed the blacklisting on "..serialAccount)
					triggerEvent("UCDgroups.requestBlacklist", client)
				else
					if (serialAccount:len() == 32) then
						exports.UCDdx:new(client, "This serial is not blacklisted", 255, 0, 0)
					else
						exports.UCDdx:new(client, "This account is not blacklisted", 255, 0, 0)
					end
					triggerEvent("UCDgroups.requestBlacklist", client)
				end
			else
				exports.UCDdx:new(client, "You are not allowed to edit the group's blacklist", 255, 0, 0)
			end
		end
	end
end
addEvent("UCDgroups.removeBlacklistEntry", true)
addEventHandler("UCDgroups.removeBlacklistEntry", root, removeBlacklistEntry)

function groupChat(plr, _, ...)
	if (not exports.UCDchecking:canPlayerDoAction(plr, "Chat")) then return end
	if (exports.UCDaccounts:isPlayerLoggedIn(plr) and getPlayerGroup(plr)) then
		local msg = table.concat({...}, " ")
		messageGroup(getPlayerGroup(plr), "("..tostring(getPlayerGroup(plr))..") "..plr.name.." #FFFFFF"..msg, "chat")
		for _, plr2 in ipairs(Element.getAllByType("player")) do
			if (getPlayerGroup(plr2) == getPlayerGroup(plr)) then
				exports.UCDchat:insert(plr2, "group", plr, msg)
			end
		end
	end
end
addCommandHandler("gc", groupChat, false, false)
addCommandHandler("groupchat", groupChat, false, false)

function groupStaffChat(plr, _, ...)
	if (not exports.UCDchecking:canPlayerDoAction(plr, "Chat")) then return end
	if (exports.UCDaccounts:isPlayerLoggedIn(plr) and getPlayerGroup(plr) and canPlayerDoActionInGroup(plr, "gsc")) then
		local r, g, b = getGroupChatColour(getPlayerGroup(plr))
		if (groupTable[getPlayerGroup(plr)].enableGSC == 0) then
			exports.UCDdx:new(plr, "Group staff chat has been disabled", r, g, b)
			return
		end
		local msg = table.concat({...}, " ")
		for _, ent in ipairs(groupMembers[getPlayerGroup(plr)]) do
			local plr_ = Account(ent).player
			if (plr_ and isElement(plr_) and canPlayerDoActionInGroup(plr_, "gsc")) then
				outputChatBox("(GSC) "..plr.name.." #FFFFFF"..msg, plr_, r, g, b, true)
			end
		end
	end
end
addCommandHandler("gsc", groupStaffChat, false, false)
addCommandHandler("groupstaffchat", groupStaffChat, false, false)
addCommandHandler("gschat", groupStaffChat, false, false)
addCommandHandler("gstaff", groupStaffChat, false, false)

function handleLogin(plr)
	local account = plr.account.name
	if (not playerGroupCache[account]) then
		playerGroupCache[account] = {}
		db:query(handleLogin2, {plr, account}, "SELECT `groupName`, `rank`, `joined`, `timeOnline`, `warningLevel` FROM `groups_members` WHERE `account`=? LIMIT 1", account)
	else
		handleLogin2(nil, plr, account)
	end
	onlineTime[plr] = getRealTime().timestamp
end
addEventHandler("onPlayerLogin", root, function () handleLogin(source) end)

-- We do this so the we don't always query the SQL database upon login to get group data
function handleLogin2(qh, plr, account)
	if (qh) then
		local result = qh:poll(-1)
		if (result and #result == 1) then
			playerGroupCache[account] = {result[1].groupName, account, result[1].rank, result[1].joined, getRealTime().yearday, result[1].timeOnline, result[1].warningLevel} -- If a player is kicked while he is offline, we will need to delete the cache
		end
	end
	if (not playerGroupCache[account] or not playerGroupCache[account][1]) then return end
	playerGroupCache[account][5] = getRealTime().yearday
	local group_ = playerGroupCache[account][1]
	local r, g, b = getGroupChatColour(group_)
	local gmotd = (groupTable[group_] and groupTable[group_].gmotd) or ""
	
	plr:setData("group", group_)
	group[plr] = group_
	
	if (gmotd and gmotd ~= "" and gmotd:gsub(" ", "") ~= "" and gmotd:len() > 1) then
		local LUN = exports.UCDaccounts:GAD(groupTable[group_].gmotd_setter, "lastUsedName") or groupTable[group_].gmotd_setter
		outputChatBox("GMOTD "..LUN.." #FFFFFF"..gmotd, plr, r, g, b, true)
	end
end

addEventHandler("onPlayerQuit", root, 
	function ()
		onlineTime[source] = nil
		group[source] = nil
		
		local account = source.account.name
		if (account and exports.UCDaccounts:isPlayerLoggedIn(source) and getPlayerGroup(source)) then
			db:exec("UPDATE `groups_members` SET `timeOnline`=?, `lastOnline`=? WHERE `account`=?", getPlayerOnlineTime(source), getRealTime().yearday, account)
			playerGroupCache[account][6] = getPlayerOnlineTime(source)
			onlineTime[source] = nil
			group[source] = nil
		end
	end
)

addEventHandler("onResourceStop", resourceRoot,
	function () 
		for _, plr in pairs(Element.getAllByType("player")) do
			if (getPlayerGroup(plr)) then
				plr:removeData("group")
				db:exec("UPDATE `groups_members` SET `timeOnline`=?, `lastOnline`=? WHERE `account`=?", getPlayerOnlineTime(plr), getRealTime().yearday, plr.account.name)
			end
		end
	end
)

function toggleGUI(update)

	local groupName = getPlayerGroup(source) or ""
	local groupInfo = getGroupInfo(groupName) or ""
	local rank = getPlayerGroupRank(source)
	local permissions = getRankPermissions(groupName, rank)
	local ranks = {}
	local memberCount
	local groupSlots = 50
	local created
	
	if (groupName == "" or not groupName) then
		created = "N/A"
		memberCount = "N"
		groupSlots = "A"
	else
		memberCount = #groupMembers[groupName] or 0
		groupSlots = 50
		created = groupTable[groupName].created or "N/A"
	end
	
	triggerLatentClientEvent(source, "UCDgroups.toggleGUI", 15000, false, source, update, groupName, groupInfo, permissions, rank, ranks, memberCount, groupSlots, created)
end
addEvent("UCDgroups.viewUI", true)
addEventHandler("UCDgroups.viewUI", root, toggleGUI)

function updateGroupSettings(newSettings)
	if (client and newSettings) then
		local group_ = getPlayerGroup(client)
		if (group_) then
			local rank = getPlayerGroupRank(client)
			local c = fromJSON(groupTable[group_].colour)
			local chat = fromJSON(groupTable[group_].chatColour)
			
			if (newSettings.chatColour[1] ~= chat[1] or newSettings.chatColour[2] ~= chat[2] or newSettings.chatColour[3] ~= chat[3]) then
				if (canPlayerDoActionInGroup(client, "chatColour")) then
					groupTable[group_].chatColour = toJSON(newSettings.chatColour)
					db:exec("UPDATE `groups_` SET `chatColour`=? WHERE `groupName`=?", toJSON(newSettings.chatColour), group_)
					messageGroup(group_, client.name.." has updated the group chat colour", "info")
					createGroupLog(group_, client.name.." ("..client.account.name..") has updated the group chat colour ("..newSettings.chatColour[1]..", "..newSettings.chatColour[2]..", "..newSettings.chatColour[3]..")")
				else
					exports.UCDdx:new(client, "You are not allowed to edit the group chat colour", 255, 0, 0)
				end
			end
			
			if (newSettings.groupColour[1] ~= c[1] or newSettings.groupColour[2] ~= c[2] or newSettings.groupColour[3] ~= c[3]) then
				if (canPlayerDoActionInGroup(client, "groupColour")) then
					groupTable[group_].colour = toJSON(newSettings.groupColour)
					db:exec("UPDATE `groups_` SET `colour`=? WHERE `groupName`=?", toJSON(newSettings.groupColour), group_)
					messageGroup(group_, client.name.." has updated the group colour", "info")
					createGroupLog(group_, client.name.." ("..client.account.name..") has updated the group colour ("..newSettings.groupColour[1]..", "..newSettings.groupColour[2]..", "..newSettings.groupColour[3]..")")
					-- need an event here for things like turf etc
				else
					exports.UCDdx:new(client, "You are not allowed to edit the group colour", 255, 0, 0)
				end
			end
			
			if (newSettings.lockInvites ~= groupTable[group_].lockInvites) then
				if (getGroupLastRank(group_) == rank) then
					groupTable[group_].lockInvites = newSettings.lockInvites
					db:exec("UPDATE `groups_` SET `lockInvites`=? WHERE `groupName`=?", newSettings.lockInvites, group_)
					if (groupTable[group_].lockInvites == 1) then
						messageGroup(group_, client.name.." has locked group invites", "info")
						createGroupLog(group_, client.name.." ("..client.account.name..") has locked group invites")
					else
						messageGroup(group_, client.name.." has unlocked group invites", "info")
						createGroupLog(group_, client.name.." ("..client.account.name..") has unlocked group invites")
					end
				else
					exports.UCDdx:new(client, "You are not allowed to lock/unlock group invites", 255, 0, 0)
				end
			end
			
			if (newSettings.enableGSC ~= groupTable[group_].enableGSC) then
				if (getGroupLastRank(group_) == rank) then
					local r, g, b = getGroupChatColour(group_)
					groupTable[group_].enableGSC = newSettings.enableGSC
					db:exec("UPDATE `groups_` SET `enableGSC`=? WHERE `groupName`=?", newSettings.enableGSC, group_)
					if (groupTable[group_].enableGSC == 1) then
						createGroupLog(group_, client.name.." ("..client.account.name..") has enabled group staff chat")
					else
						createGroupLog(group_, client.name.." ("..client.account.name..") has disabled group staff chat")
					end
					for _, acc in ipairs(groupMembers[group_]) do
						if (Account(acc).player) then
							if (canPlayerDoActionInGroup(Account(acc).player, "gsc")) then
								if (groupTable[group_].enableGSC == 1) then
									exports.UCDdx:new(Account(acc).player, client.name.." has enabled group staff chat /gsc", r, g, b)
								else
									exports.UCDdx:new(Account(acc).player, client.name.." has disabled group staff chat /gsc", r, g, b)
								end
							end
						end
					end
				else
					exports.UCDdx:new(client, "You are not allowed to toggle group staff chat", 255, 0, 0)
				end
			end
			
			if (newSettings.gmotd ~= groupTable[group_].gmotd) then
				if (canPlayerDoActionInGroup(client, "gmotd")) then
					groupTable[group_].gmotd = newSettings.gmotd
					db:exec("UPDATE `groups_` SET `gmotd`=? WHERE `groupName`=?", newSettings.gmotd, group_)
					groupTable[group_].gmotd_setter = client.account.name
					db:exec("UPDATE `groups_` SET `gmotd_setter`=? WHERE `groupName`=?", client.account.name, group_)
					messageGroup(group_, client.name.." has changed the group MOTD", "info")
					createGroupLog(group_, client.name.." ("..client.account.name..") has changed the group MOTD")
				else
					exports.UCDdx:new(client, "You are not allowed to set the GMOTD", 255, 0, 0)
				end
			end
			
			triggerEvent("UCDgroups.requestGroupSettings", client)
		end
	end
end
addEvent("UCDgroups.updateSettings", true)
addEventHandler("UCDgroups.updateSettings", root, updateGroupSettings)

function deleteRank(rankName)
	if (client and rankName) then
		local group_ = getPlayerGroup(client)
		if (group_) then
			local rank = getPlayerGroupRank(client)
			if (getGroupLastRank(group_) == rank) then
				if (not groupRanks[group_][rankName]) then
					exports.UCDdx:new(client, "This rank does not exist", 255, 255, 0)
					return
				end
				local prevRank = getPreviousRank(group_, rankName)
				local rankIndex = getRankIndex(group_, rankName)
				if (rankIndex == 0 or rankIndex == -1) then
					exports.UCDdx:new(client, "This rank cannot be removed", 255, 255, 0)
					return
				end
				if (not prevRank) then
					exports.UCDdx:new(client, "You can't delete this rank because there is no rank before it", 255, 255, 0)
					return
				end
				groupEditingRanks[group_] = true
				db:exec("DELETE FROM `groups_ranks` WHERE `groupName`=? AND `rankName`=?", group_, rankName)
				db:exec("UPDATE `groups_ranks` SET `rankIndex` = `rankIndex` - 1 WHERE `rankIndex` > ? AND `groupName`=?", rankIndex, group_)
				db:exec("UPDATE `groups_members` SET `rank`=? WHERE `rank`=? AND `groupName`=?", prevRank, rankName, group_)
				groupRanks[group_][rankName] = nil
				for _, ent in pairs(playerGroupCache) do
					if (ent[1] == group_) then
						if (ent[3] == rankName) then
							ent[3] = prevRank
						end
					end
				end
				for _, ent in pairs(groupRanks[group_]) do
					if (ent[2] > rankIndex) then
						ent[2] = ent[2] - 1
					end
				end
				groupEditingRanks[group_] = nil
				triggerEvent("UCDgroups.requestGroupRanks", client)
				exports.UCDdx:new(client, "Rank "..rankName.." has been deleted", 0, 255, 0)
				createGroupLog(group_, client.name.." ("..client.account.name..") has deleted rank "..rankName)
			end
		end
	end
end
addEvent("UCDgroups.deleteRank", true)
addEventHandler("UCDgroups.deleteRank", root, deleteRank)

function addRank(rankName, prevRank, data)
	if (client and rankName and prevRank and data) then
		local group_ = getPlayerGroup(client)
		if (group_) then
			local rank = getPlayerGroupRank(client)
			if (getGroupLastRank(group_) == rank) then
				if (rankName == "Kick this player") then return end
				if (groupRanks[group_] and groupRanks[group_][rankName]) then
					exports.UCDdx:new(client, "A rank with this name already exists", 255, 255, 0)
					return
				end
				groupEditingRanks[group_] = true
				local rankIndex = getRankIndex(group_, prevRank)
				db:exec("UPDATE `groups_ranks` SET `rankIndex` = `rankIndex` + 1 WHERE `rankIndex` > ? AND `groupName` = ?", rankIndex, group_)
				db:exec("INSERT INTO `groups_ranks` (`groupName`, `rankName`, `permissions`, `rankIndex`) VALUES (?, ?, ?, ?)", group_, rankName, toJSON(data), rankIndex + 1)
				for _, ent in pairs(groupRanks[group_]) do
					if (ent[2] > rankIndex) then
						ent[2] = ent[2] + 1
					end
				end
				groupRanks[group_][rankName] = {data, rankIndex + 1}
				groupEditingRanks[group_] = nil
				triggerEvent("UCDgroups.requestGroupRanks", client)
				exports.UCDdx:new(client, "Rank "..rankName.." has been added", 0, 255, 0)
				createGroupLog(group_, client.name.." ("..client.account.name..") has added rank "..rankName)
			end
		end
	end
end
addEvent("UCDgroups.addRank", true)
addEventHandler("UCDgroups.addRank", root, addRank)

function editRank(rankName, newName, data)
	if (client and rankName and newName and data) then
		local group_ = getPlayerGroup(client)
		if (group_ and getPlayerGroupRank(client) == getGroupLastRank(group_)) then
			if (newName ~= rankName) then
				if (groupRanks[group_][newName]) then
					exports.UCDdx:new(client, "That rank name is already in use", 255, 0, 0)
					return
				end
			end
			if (getGroupLastRank(group_) == rankName) then
				if (data[25] ~= true) then
					outputDebugString("Correct permissions not given for last rank in group "..group_.."  with rank "..rankName)
					return
				end
			end
			if (newName ~= rankName) then
				local rankIndex = getRankIndex(group_, rankName)
				groupEditingRanks[group_] = true
				db:exec("UPDATE `groups_ranks` SET `rankName`=? WHERE `rankName`=? AND `groupName`=?", newName, rankName, group_)
				db:exec("UPDATE `groups_members` SET `rank`=? WHERE `rank`=? AND `groupName`=?", newName, rankName, group_)
				local r = groupRanks[group_][rankName]
				groupRanks[group_][newName] = r
				groupRanks[group_][rankName] = nil
				for acc, _data in pairs(playerGroupCache) do
					if (_data[1] == group_) then
						if (_data[3] == rankName) then
							_data[3] = newName
						end
					end
				end
				if (data and type(data) == "table" and rankIndex ~= -1) then
					db:exec("UPDATE `groups_ranks` SET `permissions`=? WHERE `rankName`=? AND `groupName`=?", toJSON(data), newName, group_)
					groupRanks[group_][newName][1] = data
				end
				groupEditingRanks[group_] = nil
				createGroupLog(group_, client.name.." ("..client.account.name..") has edited rank "..rankName.." --> "..newName)
			else
				groupEditingRanks[group_] = true
				db:exec("UPDATE `groups_ranks` SET `permissions`=? WHERE `rankName`=? AND `groupName`=?", toJSON(data), rankName, group_)
				groupRanks[group_][rankName][1] = data
				groupEditingRanks[group_] = nil
				createGroupLog(group_, client.name.." ("..client.account.name..") has edited rank "..rankName)
			end
			triggerEvent("UCDgroups.requestGroupRanks", client)
			exports.UCDdx:new(client, "Rank "..rankName.." has been updated", 0, 255, 0)
		end
	end
end
addEvent("UCDgroups.editRank", true)
addEventHandler("UCDgroups.editRank", root, editRank)

function requestGroupsForPD(demote, account)
	if (client and account) then
		local group_ = getPlayerGroup(client)
		if (group_) then
			if (groupEditingRanks[group_]) then
				exports.UCDdx:new(client, "Ranks are currently being edited - you cannot warn, promote, demote or kick right now", 255, 0, 0)
				return
			end
			local rank = playerGroupCache[tostring(account)][3]
			if (demote == true) then
				if (not canPlayerDoActionInGroup(client, "demote")) then
					exports.UCDdx:new(client, "You are not allowed to demote members", 255, 0, 0)
					return
				end
				if (rank == getGroupFirstRank(group_)) then return end
				if (isRankHigherThan(group_, rank, getPlayerGroupRank(client)) and getPlayerGroupRank(client) ~= getGroupLastRank(group_)) then
					return
				end
				if (isRankHigherThan(group_, rank, getPlayerGroupRank(client)) == "equal" and not canPlayerDoActionInGroup(client, "demoteWithSameRank")) then
					exports.UCDdx:new(client, "You are not allowed to demote members with the same rank as you", 255, 0, 0)
					return
				end
				
				local temp = {}
				local iter = 0
				if (getGroupLastRank(group_) ~= rank) then
					for i, v in pairs(groupRanks[group_]) do
						if (v[2] < getRankIndex(group_, rank) and v[2] ~= -1) then
							temp[v[2]] = i
						end
					end
				else
					for i, v in pairs(groupRanks[group_]) do
						if (v[2] > -1) then
							temp[v[2]] = i
						end
					end
				end			
				triggerClientEvent(client, "UCDgroups.promoteDemoteWindow", client, temp or {}, nil, nil, nil, account)
			else
				local clientRank = getPlayerGroupRank(client)
				local clientRankIndex = getRankIndex(group_, clientRank)
				local accountRankIndex = getRankIndex(group_, rank)
				if (rank == getGroupLastRank(group_)) then return end		
				if (accountRankIndex > clientRankIndex and clientRankIndex ~= -1) then return end
				
				local temp = {}
				for i = accountRankIndex, getRankIndex(group_, getPreviousRank(group_, getGroupLastRank(group_))) do
					for k, v in pairs(groupRanks[group_]) do
						-- 
						if (clientRankIndex == -1 or clientRankIndex >= i) then
							if (not canPlayerDoActionInGroup(client, "promoteUntilOwnRank") and clientRankIndex ~= -1) then
								outputDebugString("clientRankIndex >= "..i.." | and cannot promoteUntilOwnRank")
								break
							end
							-- If their rank is equal to or smaller than the current rank, insert into the table
							if (accountRankIndex < i) then
								if (i == v[2]) then
									temp[i] = k
								end
							end
						end
						--[[
						if (i >= clientRankIndex and clientRankIndex ~= -1) then
							if (i == clientRankIndex) then
								if (canPlayerDoActionInGroup(client, "promoteUntilOwnRank")) then
									temp[i] = getGroupRankFromIndex(group_, i)
									outputDebugString("Is allowed to do this for rankIndex = "..i)
								else
									outputDebugString("Should not be allowed to do this for rankIndex = "..i)
								end
							end
							break
						else
							temp[i] = getRankFromIndex(group_, i)
						end
						--]]
					end
				end
				--[[local iter = getRankIndex(group_, rank)
				local r = getRankIndex(group_, rank)
				while r < getRankIndex(group_, getPreviousRank(group_, getGroupLastRank(group_))) do
					for k, v in pairs(groupRanks[group_]) do
						--if (v[2] == iter) then
							temp[iter] = k
							iter = iter + 1
						--end
					end
				end
				]]
				-- Only allow promotions to founder is the specified player is a founder
				if (clientRankIndex == -1) then
					temp[-1] = getGroupLastRank(group_)
				end
				
				--for k, v in pairs(temp) do
				--	outputDebugString(tostring(k).." | "..tostring(v))
				--end
				
				triggerClientEvent(client, "UCDgroups.promoteDemoteWindow", client, temp or {}, nil, nil, nil, account)
			end
		end
	end
end
addEvent("UCDgroups.requestGroupsForPD", true)
addEventHandler("UCDgroups.requestGroupsForPD", root, requestGroupsForPD)

-- Alliances
function createAlliance(name)
	if (client and name) then
		local groupName = getPlayerGroup(client)
		if (not groupName) then
			exports.UCDdx:new(client, "You cannot create an alliance because you are not in a group", 255, 0, 0)
			return false
		end
		if (not canPlayerDoActionInGroup(client, "alliance")) then
			exports.UCDdx:new(client, "You do not have permission to manage alliances in your group", 255, 0, 0)
			return false
		end
		for _, g in pairs(allianceMembers) do
			if (g[groupName]) then
				exports.UCDdx:new(client, "This group is already in an alliance", 255, 0, 0)
				return false
			end
		end
		if (allianceTable[name]) then
			exports.UCDdx:new(client, "An alliance with this name already exists", 255, 0, 0)
			return false
		end
		for g in pairs(allianceTable) do
			if (g:lower() == name:lower()) then
				exports.UCDdx:new("An alliance with this name, in different case, already exists", 255, 0, 0)
				return false
			end
		end
		for type_, row in pairs(forbidden) do
			for _, chars in pairs(row) do
				if type_ == "whole" then
					if (name == chars) then
						exports.UCDdx:new(client, "The specified alliance name is prohibited. If you believe this is a mistake, please notify an administrator.", 255, 0, 0)
						return false
					end
				else
					if (name:lower():find(chars)) then
						exports.UCDdx:new(client, "The specified alliance name contains forbidden phrases or characters. If you believe this is a mistake, please notify an administrator.", 255, 0, 0)
						return false
					end
				end
			end
		end
		
		local d, t = exports.UCDutil:getTimeStamp()
		
		db:exec("INSERT INTO `groups_alliances_` (`alliance`, `info`, `colour`, `balance`, `created`) VALUES (?, ?, ?, ?, ?)", name, "Enter alliance information here!", "[ [ 255, 255, 255 ] ]", 0, d.." "..t)
		db:exec("INSERT INTO `groups_alliances_members` (`alliance`, `groupName`, `rank`) VALUES (?, ?, ?)", name, groupName, "Leader")
		
		allianceMembers[name] = {}
		allianceMembers[name][groupName] = "Leader"
		allianceTable[name] = {"Enter alliance information here!", "[ [ 255, 255, 255 ] ]", 0, d.." "..t} -- [1] = info, [2] = colour, [3] = balance, [4] = created
		g_alliance[groupName] = name
		
		createAllianceLog(name, groupName, client.name.." ("..client.account.name..") created "..name, true)
		exports.UCDdx:new(client, "You have successfully created alliance "..name, 0, 255, 0)
		
		triggerEvent("UCDgroups.alliance.viewUI", client, true)
	end
end
addEvent("UCDgroups.createAlliance", true)
addEventHandler("UCDgroups.createAlliance", root, createAlliance)

function deleteAlliance()
	if (client) then
		local groupName = getPlayerGroup(client)
		if (not groupName) then
			exports.UCDdx:new(client, "You are not in a group", 255, 0, 0)
			return false
		end
		local alliance = getGroupAlliance(groupName)
		if (not alliance) then
			exports.UCDdx:new(client, "Your group is not in an alliance", 255, 0, 0)
			return false
		end
		if (not canPlayerDoActionInGroup(client, "alliance")) then
			exports.UCDdx:new(client, "You do not have permission to manage alliances in your group", 255, 0, 0)
			return false
		end
		if (allianceMembers[alliance][groupName] ~= "Leader") then
			exports.UCDdx:new(client, "You do not have permission to delete the alliance", 255, 0, 0)
			return false
		end
		
		createAllianceLog(alliance, groupName, client.name.." ("..client.account.name..") has deleted "..alliance, true)
		
		db:exec("DELETE FROM `groups_alliances_` WHERE `alliance` = ?", alliance)
		db:exec("DELETE FROM `groups_alliances_members` WHERE `alliance` = ?", alliance)
		db:exec("DELETE FROM `groups_alliances_invites` WHERE `alliance` = ?", alliance)
		db:exec("DELETE FROM `groups_alliances_logs` WHERE `alliance` = ? AND `important` <> 1", alliance)
		
		for _, g in ipairs(getAllianceGroups(alliance)) do
			g_alliance[g] = nil
			messageGroup(g, client.name.." ("..client.account.name..") has deleted "..alliance, "info")
			for i, plr in ipairs(getGroupOnlineMembers(g)) do
				triggerEvent("UCDgroups.alliance.viewUI", plr, true)
			end
		end
		
		allianceMembers[alliance] = nil
		allianceTable[alliance] = nil
		
		exports.UCDdx:new(client, "You have deleted the alliance "..alliance, 255, 0, 0)
	end
end
addEvent("UCDgroups.deleteAlliance", true)
addEventHandler("UCDgroups.deleteAlliance", root, deleteAlliance)

function joinAlliance(alliance)
	if (source and source.type == "player" and alliance) then
		local groupName = getPlayerGroup(source)
		if (not groupName) then
			return
		end
		if (getGroupAlliance(groupName)) then
			return
		end
		if (not canPlayerDoActionInGroup(source, "alliance")) then
			exports.UCDdx:new(source, "You do not have permission to manage alliances in your group", 255, 0, 0)
			return
		end
		
		db:exec("INSERT INTO `groups_alliances_members` (`alliance`, `groupName`, `rank`) VALUES (?, ?, ?)", alliance, groupName, "Member")
		allianceMembers[alliance][groupName] = "Member"
		g_alliance[groupName] = alliance
		
		messageGroup(groupName, source.name.." ("..source.account.name..") joined the alliance "..alliance, "info")
		createAllianceLog(alliance, groupName, source.name.." ("..source.account.name..") has accepted the invitation to join the alliance")
		
		triggerEvent("UCDgroups.alliance.viewUI", source, true)
	end
end
addEvent("UCDgroups.joinAlliance", true)
addEventHandler("UCDgroups.joinAlliance", root, joinAlliance)

function leaveAlliance()
	if (client) then
		local groupName = getPlayerGroup(client)
		if (not groupName) then
			exports.UCDdx:new(client, "You are not in a group", 255, 0, 0)
			return false
		end
		local alliance = getGroupAlliance(groupName)
		if (not alliance) then
			exports.UCDdx:new(client, "Your group is not in an alliance", 255, 0, 0)
			return false
		end
		if (not canPlayerDoActionInGroup(client, "alliance")) then
			exports.UCDdx:new(client, "You do not have permission to manage alliances in your group", 255, 0, 0)
			return false
		end
		if (allianceMembers[alliance][groupName] == "Leader") then
			local leaderCount = 0
			for g, rank in pairs(allianceMembers[alliance]) do
				if (rank == "Leader" and g ~= groupName) then
					leaderCount = leaderCount + 1
				end
			end
			if (leaderCount == 0) then
				exports.UCDdx:new(client, "You cannot leave this alliance as your group is the only one with the Leader rank", 255, 0, 0)
				return false
			end
		end
		
		createAllianceLog(alliance, groupName, client.name.." ("..client.account.name..") left the alliance")
		
		db:exec("DELETE FROM `groups_alliances_members` WHERE `groupName` = ? AND `alliance` = ?", groupName, alliance)
		allianceMembers[alliance][groupName] = nil
		g_alliance[groupName] = nil
		
		messageGroup(groupName, client.name.." ("..client.account.name..") left the alliance "..alliance, "info")
		
		for i, plr in ipairs(getGroupOnlineMembers(groupName)) do
			triggerEvent("UCDgroups.alliance.viewUI", plr, true)
		end
		
		exports.UCDdx:new(client, "You have left the alliance "..alliance, 255, 0, 0)
	end
end
addEvent("UCDgroups.leaveAlliance", true)
addEventHandler("UCDgroups.leaveAlliance", root, leaveAlliance)

function promoteGroup(groupName)
	if (client) then
		local clientGroup = getPlayerGroup(client)
		if (not clientGroup) then
			return false
		end
		local alliance = getGroupAlliance(clientGroup)
		if (not alliance) then
			return false
		end
		if (not getGroupAlliance(groupName) or getGroupAlliance(groupName) ~= alliance) then
			return false
		end
		if (not canPlayerDoActionInGroup(client, "alliance")) then
			exports.UCDdx:new(client, "You do not have permission to manage alliances in your group", 255, 0, 0)
			return false
		end
		local clientGroupRank = allianceMembers[alliance][clientGroup]
		if (clientGroupRank ~= "Leader") then
			exports.UCDdx:new(client, "Your group does not have permission to do this action", 255, 0, 0)
			return false
		end
		local groupRank = allianceMembers[alliance][groupName]
		if (groupRank == "Leader") then
			exports.UCDdx:new(client, "You cannot promote this group further", 255, 0, 0)
			return false
		end
		
		allianceMembers[alliance][groupName] = "Leader"
		db:exec("UPDATE `groups_alliances_members` SET `rank` = ? WHERE `groupName` = ? AND `alliance` = ?", "Leader", groupName, alliance)
		
		createAllianceLog(alliance, clientGroup, client.name.." ("..client.account.name..") has promoted "..groupName.." to Leader")
		
		triggerEvent("UCDgroups.alliance.requestMemberList", client)
		
		for _, plr in ipairs(getGroupOnlineMembers(groupName)) do
			triggerEvent("UCDgroups.alliance.viewUI", plr, true)
		end
	end
end
addEvent("UCDgroups.promoteGroup", true)
addEventHandler("UCDgroups.promoteGroup", root, promoteGroup)

function demoteGroup(groupName)
	if (client) then
		local clientGroup = getPlayerGroup(client)
		if (not clientGroup) then
			return false
		end
		local alliance = getGroupAlliance(clientGroup)
		if (not alliance) then
			return false
		end
		if (not getGroupAlliance(groupName) or getGroupAlliance(groupName) ~= alliance) then
			return false
		end
		if (not canPlayerDoActionInGroup(client, "alliance")) then
			exports.UCDdx:new(client, "You do not have permission to manage alliances in your group", 255, 0, 0)
			return false
		end
		local clientGroupRank = allianceMembers[alliance][clientGroup]
		if (clientGroupRank ~= "Leader") then
			exports.UCDdx:new(client, "Your group does not have permission to do this action", 255, 0, 0)
			return false
		end
		local groupRank = allianceMembers[alliance][groupName]
		if (groupRank == "Member") then
			exports.UCDdx:new(client, "You cannot demote this group further", 255, 0, 0)
			return false
		end
		
		allianceMembers[alliance][groupName] = "Member"
		db:exec("UPDATE `groups_alliances_members` SET `rank` = ? WHERE `groupName` = ? AND `alliance` = ?", "Member", groupName, alliance)
		
		createAllianceLog(alliance, clientGroup, client.name.." ("..client.account.name..") has demoted "..groupName.." to Member")
		
		triggerEvent("UCDgroups.alliance.requestMemberList", client)
		
		for _, plr in ipairs(getGroupOnlineMembers(groupName)) do
			triggerEvent("UCDgroups.alliance.viewUI", plr, true)
		end
	end
end
addEvent("UCDgroups.demoteGroup", true)
addEventHandler("UCDgroups.demoteGroup", root, demoteGroup)

function kickGroup(groupName)
	if (client) then
		local clientGroup = getPlayerGroup(client)
		if (not clientGroup) then
			return false
		end
		local alliance = getGroupAlliance(clientGroup)
		if (not alliance) then
			return false
		end
		if (not getGroupAlliance(groupName) or getGroupAlliance(groupName) ~= alliance) then
			return false
		end
		if (not canPlayerDoActionInGroup(client, "alliance")) then
			exports.UCDdx:new(client, "You do not have permission to manage alliances in your group", 255, 0, 0)
			return false
		end
		local clientGroupRank = allianceMembers[alliance][clientGroup]
		if (clientGroupRank ~= "Leader") then
			exports.UCDdx:new(client, "Your group does not have permission to do this action", 255, 0, 0)
			return false
		end
		
		createAllianceLog(alliance, clientGroup, client.name.." ("..client.account.name..") has kicked "..groupName)
		
		allianceMembers[alliance][groupName] = nil
		g_alliance[groupName] = nil
		db:exec("DELETE FROM `groups_alliances_members` WHERE `groupName` = ? AND `alliance` = ?", groupName, alliance)
		
		triggerEvent("UCDgroups.alliance.requestMemberList", client)
		
		for _, plr in ipairs(getGroupOnlineMembers(groupName)) do
			triggerEvent("UCDgroups.alliance.viewUI", plr, true)
		end
	end
end
addEvent("UCDgroups.kickGroup", true)
addEventHandler("UCDgroups.kickGroup", root, kickGroup)

function requestAllianceMemberList()
	if (source) then
		local groupName = getPlayerGroup(source)
		local alliance = getGroupAlliance(groupName)
		
		local list = {}
		for g, data in pairs(allianceMembers[alliance]) do
			table.insert(list, {groupName = g, memberCount = getGroupMemberCount(g), slots = 50, rank = data, colour = {getGroupColour(g)}})
		end
		
		triggerLatentClientEvent(source, "UCDgroups.alliance.memberList", source, list)
	end
end
addEvent("UCDgroups.alliance.requestMemberList", true)
addEventHandler("UCDgroups.alliance.requestMemberList", root, requestAllianceMemberList)

function updateAllianceInfo(newInfo)
	if (client) then
		local groupName = getPlayerGroup(client)
		if (groupName) then
			local alliance = getGroupAlliance(groupName)
			if (not alliance) then
				return false
			end
			
			allianceTable[alliance][1] = newInfo
			db:exec("UPDATE `groups_alliances_` SET `info` = ? WHERE `alliance` = ?", newInfo, alliance)
			createAllianceLog(groupName, client.name.." ("..client.account.name..") has updated the alliance information")
			
			for g in pairs(allianceMembers[alliance]) do
				for _, plr in pairs(getGroupOnlineMembers(g)) do
					triggerEvent("UCDgroups.alliance.viewUI", plr, true)
				end
			end
		end
	end
end
addEvent("UCDgroups.alliance.updateInfo", true)
addEventHandler("UCDgroups.alliance.updateInfo", root, updateAllianceInfo)

function requestAllianceHistory()
	if (client) then
		local groupName = getPlayerGroup(client)
		if (groupName) then
			local alliance = getGroupAlliance(groupName)
			if (alliance) then
				local history, rows = db:query("SELECT `groupName`, `log` AS `log_` FROM `groups_alliances_logs` WHERE `alliance` = ? ORDER BY `logID` DESC LIMIT 100", alliance):poll(-1)
				local total = db:query("SELECT COUNT(*) AS `count_` FROM `groups_alliances_logs` WHERE `alliance` = ?", alliance):poll(-1)[1].count_
				triggerLatentClientEvent(client, "UCDgroups.alliance.history", client, history or {}, total or 0, rows or 0, alliance)
			end
		end
	end
end
addEvent("UCDgroups.requestAllianceHistory", true)
addEventHandler("UCDgroups.requestAllianceHistory", root, requestAllianceHistory)

function toggleAllianceGUI(update)
	local groupName = getPlayerGroup(source)
	if (not groupName) then
		return false
	end
	
	local alliance, info, created
	local alliancePerms = {}
	alliance = getGroupAlliance(groupName) or false
	
	if (alliance ~= false and allianceTable[alliance]) then
		created = allianceTable[alliance][4]
		info = allianceTable[alliance][1]
		
		if (allianceMembers[alliance][groupName] == "Leader") then
			alliancePerms = {[3] = true, [6] = true}
		else
			alliancePerms = {[3] = false, [6] = false}
		end
	else
		info = ""
		created = "N/A"
	end
	
	triggerLatentClientEvent(source, "UCDgroups.alliance.toggleGUI", 15000, false, source, update, alliance, info, alliancePerms, created)
end
addEvent("UCDgroups.alliance.viewUI", true)
addEventHandler("UCDgroups.alliance.viewUI", root, toggleAllianceGUI)

function changeAllianceBalance(type_, balanceChange)
	if (client) then
		if (not balanceChange or tonumber(balanceChange) == nil) then
			exports.UCDdx:new(client, "Something went wrong!", 255, 255, 0)
			return
		end
		local group_ = getPlayerGroup(client)
		if (group_) then
			local alliance = getGroupAlliance(group_)
			if (not alliance) then
				return false
			end
			
			local currentBalance = allianceTable[alliance][3]
			if (type_ == "deposit") then
				if (client.money < balanceChange) then
					exports.UCDdx:new(client, "You can't deposit this much because you don't have it", 255, 0, 0)
					return
				end
				if (balanceChange <= 0) then
					exports.UCDdx:new(client, "You must enter a positive number", 255, 255, 0)
					return
				end
				allianceTable[alliance][3] = allianceTable[alliance][3] + balanceChange
				client.money = client.money - balanceChange
				db:exec("UPDATE `groups_alliances_` SET `balance` = ? WHERE `alliance` = ?", tonumber(allianceTable[alliance][3]), alliance)
				createAllianceLog(alliance, group_, client.name.." ("..client.account.name..") has deposited $"..exports.UCDutil:tocomma(balanceChange).." into the alliance bank")
				triggerLatentClientEvent(client, "UCDgroups.alliance.balanceWindow", client, "update", allianceTable[alliance][3])
			elseif (type_ == "withdraw") then
				if ((currentBalance - balanceChange) < 0) then
					exports.UCDdx:new(client, "The alliance doesn't have this much", 255, 255, 0)
					return
				end
				if (balanceChange <= 0) then
					exports.UCDdx:new(client, "You must enter a positive number", 255, 255, 0)
					return
				end
				allianceTable[alliance][3] = allianceTable[alliance][3] - balanceChange
				client.money = client.money + balanceChange
				db:exec("UPDATE `groups_alliances_` SET `balance` = ? WHERE `alliance` = ?", tonumber(allianceTable[alliance][3]), alliance)
				createAllianceLog(alliance, group_, client.name.." ("..client.account.name..") has withdrawn $"..exports.UCDutil:tocomma(balanceChange).." from the alliance bank")
				triggerLatentClientEvent(client, "UCDgroups.alliance.balanceWindow", client, "update", allianceTable[alliance][3])
			end
		end
	end
end
addEvent("UCDgroups.alliance.changeBalance", true)
addEventHandler("UCDgroups.alliance.changeBalance", root, changeAllianceBalance)

function requestAllianceBalance()
	if (client or source) then
		local group_ = getPlayerGroup(source)
		if (group_) then
			local alliance = getGroupAlliance(group_)
			if (not alliance) then
				return false
			end
			triggerClientEvent(source, "UCDgroups.alliance.balanceWindow", source, "toggle", tonumber(allianceTable[alliance][3]))
		end
	end
end
addEvent("UCDgroups.requestAllianceBalance", true)
addEventHandler("UCDgroups.requestAllianceBalance", root, requestAllianceBalance)

-- Used to request the alliance invite list
function getGroupsForAlliance()
	--[[
	if (client) then
		local groupName = getPlayerGroup(client)
		if (not groupName) then
			return false
		end
		local alliance = getGroupAlliance(groupName)
		if (not alliance) then
			return false
		end
		if (allianceMembers[alliance][groupName] ~= "Leader") then
			return false
		end
		
		if (canPlayerDoActionInGroup(client, "alliance")) then
	--]]
			local temp = {}
			for group_, _ in pairs(groupTable) do
				if (not getGroupAlliance(group_)) then
					local r, g, b = getGroupColour(group_)
					table.insert(temp, {group_ = group_, r = r, g = g, b = b})
				end
			end
			--triggerLatentClientEvent(client, "UCDgroups.alliance.viewInviteGroups", client, temp)
			return temp
	--[[
		end
	end
	--]]
end

function requestGroupsForAllianceInviteList()
	if (client) then
		local groupName = getPlayerGroup(client)
		if (not groupName) then
			return false
		end
		local alliance = getGroupAlliance(groupName)
		if (not alliance) then
			return false
		end
		if (allianceMembers[alliance][groupName] ~= "Leader") then
			return false
		end
		
		if (canPlayerDoActionInGroup(client, "alliance")) then
			local t = getGroupsForAlliance()
			triggerLatentClientEvent(client, "UCDgroups.alliance.viewInviteGroups", client, t)
		end
	end
end
addEvent("UCDgroups.alliance.requestGroupsForInvite", true)
addEventHandler("UCDgroups.alliance.requestGroupsForInvite", root, requestGroupsForAllianceInviteList)

function requestAllianceList()
	if (client) then
		local temp = {}
		for alliance, data in pairs(allianceTable) do
			table.insert(temp, alliance)
		end
		triggerLatentClientEvent(client, "UCDgroups.viewAllianceList", client, temp)
	end
end
addEvent("UCDgroups.requestAllianceList", true)
addEventHandler("UCDgroups.requestAllianceList", root, requestAllianceList)

function requestAllianceInvites()
	if (source and source.type == "player") then
		local groupName = getPlayerGroup(source)
		if (not groupName) then
			return false
		end
		--local alliance = getGroupAlliance(groupName)
		--if (alliance) then
		--	return false
		--end
		if (not canPlayerDoActionInGroup(source, "alliance")) then
			return false
		end
		
		local invites = allianceInvites[groupName]
		if (not invites) then
			invites = {}
		end
		
		triggerClientEvent(source, "UCDgroups.viewAllianceInvites", source, invites)
	end
end
addEvent("UCDgroups.requestAllianceInvites", true)
addEventHandler("UCDgroups.requestAllianceInvites", root, requestAllianceInvites)

function inviteGroup(group_)
	if (client) then
		local groupName = getPlayerGroup(client)
		if (not groupName) then
			return false
		end
		local alliance = getGroupAlliance(groupName)
		if (not alliance) then
			return false
		end
		if (allianceMembers[alliance][groupName] ~= "Leader") then
			return false
		end
		if (not canPlayerDoActionInGroup(client, "alliance")) then
			return false
		end
		if (not allianceInvites[group_]) then
			allianceInvites[group_] = {}
		end
		for index, row in pairs(allianceInvites[group_]) do
			for _, data in pairs(row) do
				if (data == groupName) then
					exports.UCDdx:new(client, "This group has already been invited to the alliance", 255, 0, 0)
					return
				end
			end
		end
		table.insert(allianceInvites[group_], {alliance, groupName, client.name})
		exports.UCDdx:new(client, "You have invited "..tostring(group_).." to "..alliance, 255, 0, 0)
		db:exec("INSERT INTO `groups_alliances_invites` (`groupName`, `alliance`, `groupBy`, `playerBy`) VALUES (?, ?, ?, ?)", group_, alliance, groupName, client.name)
		createAllianceLog(alliance, groupName, client.name.." ("..client.account.name..") has invited the group "..group_.." to the alliance")
		triggerEvent("UCDgroups.alliance.viewUI", client, true)
	end
end
addEvent("UCDgroups.inviteGroup", true)
addEventHandler("UCDgroups.inviteGroup", root, inviteGroup)

function handleAllianceInvite(alliance_, state)
	if (client and alliance_ and state) then
		local groupName = getPlayerGroup(client)
		if (not groupName) then
			return false
		end
		if (not canPlayerDoActionInGroup(client, "alliance")) then
			exports.UCDdx:new(client, "You do not have permission to manage alliances in your group", 255, 0, 0)
			return false
		end
		
		for index, row in pairs(allianceInvites[groupName]) do
			if (row[1] == alliance_) then
				table.remove(allianceInvites[groupName], index)
			end
		end
		db:exec("DELETE FROM `groups_alliances_invites` WHERE `groupName` = ? AND `alliance` = ?", groupName, alliance_)
		
		if (state == "accept") then
			if (getGroupAlliance(groupName)) then
				exports.UCDdx:new(client, "Your group can't join this alliance because you are already in one", 255, 0, 0)
				triggerEvent("UCDgroups.requestAllianceInvites", client)
				return false
			end
			createGroupLog(groupName, client.name.." ("..client.account.name..") has accepted the invite to join alliance "..alliance_)
			triggerEvent("UCDgroups.joinAlliance", client, alliance_)
		elseif (state == "deny") then
			createGroupLog(groupName, client.name.." ("..client.account.name..") has declined the invite to join alliance "..alliance_)
			exports.UCDdx:new(client, "You have declined the invitation to join alliance "..groupName, 255, 255, 0)
		end
		
		triggerEvent("UCDgroups.requestAllianceInvites", client)
	end
end
addEvent("UCDgroups.alliance.handleInvite", true)
addEventHandler("UCDgroups.alliance.handleInvite", root, handleAllianceInvite)

function allianceChat(plr, _, ...)
	if (not exports.UCDchecking:canPlayerDoAction(plr, "Chat")) then return end
	local msg = table.concat({...}, " ")
	if (msg:gsub(" ", "") == "") then
		exports.UCDdx:new(plr, "Enter a message!", 255, 0, 0)
	end
	if (exports.UCDaccounts:isPlayerLoggedIn(plr) and getPlayerGroup(plr)) then
		local alliance = g_alliance[getPlayerGroup(plr)]
		if (not alliance) then
			exports.UCDdx:new(plr, "Your group is not in an alliance", 255, 0, 0)
			return
		end
		for groupName in pairs(allianceMembers[alliance]) do
			--messageGroup(groupName, "("..tostring(g_alliance[getPlayerGroup(plr)])..") "..plr.name.." #FFFFFF"..msg, "chat")
			for _, plr2 in ipairs(getGroupOnlineMembers(groupName)) do
				outputChatBox("("..tostring(alliance)..") "..plr.name.." #FFFFFF"..msg, plr2, 50, 100, 0, true)
				exports.UCDchat:insert(plr2, "alliance", plr, msg)
			end
		end
	end
end
addCommandHandler("ac", allianceChat, false, false)
addCommandHandler("alliancec", allianceChat, false, false)
addCommandHandler("achat", allianceChat, false, false)
addCommandHandler("alliancechat", allianceChat, false, false)
