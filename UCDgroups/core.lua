-- `groups`
-- [groupName] = {"info", leaderID, count, "created", "colour"}
-- [string] = {text, leaderID, smallint, timestamp, bigint, varchar [json], }

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
		"ucd",
		"noki",
		"zorque",
		"cunt",
		"cunts",
		"fuckucd",
		"fuckserver",
		"cit",
		"ugc",
		"ngc",
		"nr7gaming",
		"a7a",
	},
	partial = {
		"zorque",
		"cunt",
		"ngc",
		"arran",
		"cit ",
		"admin",
		"staff",
		"is shit",
		"isshit",
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
}

defaultRanks = {
	-- [name] 	= {{permissions}, rankIndex},
	["Trial"] 	= {{}, 0},
	["Regular"] = {{[12] = true}, 1},
	["Trusted"] = {{[8] = true, [10] = true, [12] = true}, 2},
	["Deputy"] 	= {{[1] = true, [2] = true, [3] = true, [6] = true, [8] = true, [9] = true, [10] = true, [12] = true, [17] = true}, 3},
	["Leader"] 	= {{[1] = true, [2] = true, [3] = true, [4] = true, [6] = true, [8] = true, [9] = true, [10] = true, [12] = true, [15] = true, [17] = true}, 4},
	["Founder"] = {{}, -1},
}

db = exports.UCDsql:getConnection()

group = {}
groupTable = {}
groupMembers = {} -- We can just get their player elements from their id since more caching was introduced
groupRanks = {}

playerInvites = {} -- When a player gets invited ([accName] = group_)

playerGroupCache = {} -- Player group cache
onlineTime = {}

addEventHandler("onResourceStart", resourceRoot,
	function ()
		if (not db) then outputDebugString("["..Resource.getName(resourceRoot).."] Unable to establish connection with MySQL database.") return false end
		db:query(cacheGroupTable, {}, "SELECT * FROM `groups_`")
	end
)

function cacheGroupTable(qh)
	local result = qh:poll(-1)
	for _, row in pairs(result) do
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
	for _, row in pairs(result) do
		if (groupTable[row.groupName]) then
			if (not groupMembers[row.groupName]) then
				groupMembers[row.groupName] = {}
			end
			table.insert(groupMembers[row.groupName], row.account)
			local member = Account(row.account).player --exports.UCDaccounts:getPlayerFromID(row.account)
			if (member) then
				db:exec("UPDATE `groups_members` SET `name`=? WHERE `account`=?", member.name, row.account)
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
	for _, row in pairs(result) do
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
	for _, plr in pairs(Element.getAllByType("player")) do -- Maybe exports.UCDaccounts:getLoggedInPlayers()
		if (exports.UCDaccounts:isPlayerLoggedIn(plr)) then
			handleLogin(plr)
		end
	end
end

function createGroup(name)
	local groupName = name
	if (client and name) then
		if (getPlayerGroup(client)) then
			exports.UCDdx:new(client, "You cannot create a group because you are already in one. Leave your current group first.", 255, 0, 0)
			return false
		end
		for index, row in pairs(groupTable) do
			if row.name == name then
				exports.UCDdx:new("A group with this name already exists", 255, 0, 0)
				return false
			end
		end
		for type_, row in pairs(forbidden) do
			for _, chars in pairs(row) do
				if type_ == "whole" then
					if (name == chars) then
						exports.UCDdx:new(client, "The specified group name is prohibited. If you believe this is a mistake, please notify an administrator.", 255, 0, 0)
						return false
					end
				else
					if (name:lower():find(chars)) then
						exports.UCDdx:new(client, "The specified group name contains forbidden phrases or characters. If you believe this is a mistake, please notify an administrator.", 255, 0, 0)
						return false
					end
				end
			end
		end
		local playtime = math.floor(exports.UCDaccounts:GAD(client, "playtime") / (60 * 60)) or 0 -- Gets the playtime in hours
		if (playtime < 5) then
			exports.UCDdx:new(client, "You need at least 5 hours in-game to be able to create a group", 255, 255, 0)
		end
		
		--local clientID = exports.UCDaccounts:getPlayerAccountID(client) -- Get the client's id	
		local d, t = exports.UCDutil:getTimeStamp()
		
		db:exec("INSERT INTO `groups_` SET `groupName`=?, `leader`=?, `colour`=?, `info`=?, `created`=?", groupName, client.account.name, toJSON(settings.default_colour), settings.default_info_text, d) -- Perform the inital group creation	
		--db:exec("INSERT INTO `groups_members` SET `groupName`=?, `accountID`=?, `name`=?, `rank`=?, `lastOnline`=?, `timeOnline`=?", groupName, clientID, client.name, "Founder", getRealTime().yearday, 0) -- Make the client's membership official and grant founder status
		db:exec("INSERT INTO `groups_members` VALUES (?, ?, ?, ?, ?, ?, ?, ?)", client.account.name, groupName, client.name, "Founder", getRealTime().yearday, d, getPlayerOnlineTime(client), 0) -- Make the client's membership official and grant founder status
		setDefaultRanks(groupName)
		
		groupTable[groupName] = {
			["leader"] = client.account.name, 
			["info"] = settings.default_info_text, 
			["memberCount"] = 1, 
			["created"] = nil,
			["colour"] = toJSON(settings.default_colour),
			["balance"] = 0,
			["chatColour"] = toJSON(settings.default_chat_colour),
		}
		
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
			--local accountID = exports.UCDaccounts:getPlayerAccountID(client)
			if (not reason or reason == " " or reason == "") then
				reason = "No reason"
			end
			client:removeData("group")
			group[client] = nil
			--onlineTime[client] = nil
			playerGroupCache[account] = nil
			db:exec("DELETE FROM `groups_members` WHERE `account`=?", account)
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
		
		outputDebugString("Deleting group where groupName = "..groupName)
		db:exec("DELETE FROM `groups_` WHERE `groupName`=?", groupName)
		db:exec("DELETE FROM `groups_members` WHERE `groupName`=?", groupName)
		db:exec("DELETE FROM `groups_ranks` WHERE `groupName`=?", groupName)
		db:exec("DELETE FROM `groups_invites` WHERE `groupName`=?", groupName)
		
		-- Remove the invite from the table
		for acc, row in pairs(playerInvites) do
			for i, v in pairs(row) do
				if (v[1] == groupName) then
					table.remove(playerInvites[acc], i)
				end
			end
		end
		
		for _, account in pairs(groupMembers[groupName]) do
			--local plr = exports.UCDaccounts:getPlayerFromID(id)
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
				outputDebugString("You're in a group")
				return
			end
			--local accountID = exports.UCDaccounts:getPlayerAccountID(source)
			local account = source.account.name
			local rank = getGroupFirstRank(group_)
			local d, t = exports.UCDutil:getTimeStamp()
			
			--db:exec("INSERT INTO `groups_members` SET `groupName`=?, `account`=?, `name`=?, `rank`=?, `lastOnline`=?, `timeOnline`=?", group_, account, source.name, rank, getRealTime().yearday, onlineTime[plr])
			db:exec("INSERT INTO `groups_members` SET `groupName`=?, `account`=?, `name`=?, `rank`=?, `lastOnline`=?, `timeOnline`=?", group_, account, source.name, rank, getRealTime().yearday, getPlayerOnlineTime(plr))
			
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
				-- send invite, tell plr, tell group, add to queue, put in sql
				--playerInvites[plr.account.name] = {group_, client.name}
				if (not playerInvites[plr.account.name]) then
					playerInvites[plr.account.name] = {}
				end
				for index, row in pairs(playerInvites[plr.account.name]) do
					for _, data in pairs(row) do
						if (data == group_) then
							outputDebugString("already has invite")
							return
						end
					end
				end
				table.insert(playerInvites[plr.account.name], {group_, client.name})
				db:exec("INSERT INTO `groups_invites` SET `account`=?, `groupName`=?, `by`=?", plr.account.name, group_, client.name)
				
				messageGroup(group_, client.name.." has invited "..plr.name.." to the group", info)
				exports.UCDdx:new(plr, "You have been invited to "..group_.." by "..client.name..". Press F6 to view your invites", 0, 255, 0)
			else
				exports.UCDdx:new(client, "You can't do this ayy lmao", 200, 0, 0)
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
		db:exec("DELETE FROM `groups_invites` WHERE `groupName`=? AND `account`=?", groupName, client.account.name)
		
		if (state == "accept") then
			-- Make the player join the group
			messageGroup(groupName, client.name.." has accepted the invitation to join the group", "info")
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
			outputDebugString(tostring(groupTable[group_].balance))
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
			for _, plr in pairs(getGroupOnlineMembers(groupName)) do
				triggerEvent("UCDgroups.viewUI", plr, true)
			end
		end
	end
end
addEvent("UCDgroups.updateInfo", true)
addEventHandler("UCDgroups.updateInfo", root, updateGroupInfo)

function requestMemberList()
	if (client) then
		local group_ = getPlayerGroup(client)
		if (group_) then
			local members = getAdvancedGroupMembers(group_)
			triggerLatentClientEvent(client, "UCDgroups.memberList", client, members)
		end
	end
end
addEvent("UCDgroups.requestMemberList", true)
addEventHandler("UCDgroups.requestMemberList", root, requestMemberList)

function requestGroupList()
	if (client) then
		local temp = {}
		local i = 1
		for groupName, data in pairs(groupTable) do
			if (data.memberCount >= 1) then
				temp[i] = {name = groupName, members = data.memberCount, slots = data.slots or 20}
				i = i + 1
			end
		end
		if (temp) then
			triggerClientEvent(client, "UCDgroups.groupList", client, temp)
		end
	end
end
addEvent("UCDgroups.requestGroupList", true)
addEventHandler("UCDgroups.requestGroupList", root, requestGroupList)

function groupChat(plr, _, ...)
	if (exports.UCDaccounts:isPlayerLoggedIn(plr) and getPlayerGroup(plr)) then
		--local msg = table.concat({msg}, " ")
		local msg = table.concat({...}, " ")
		messageGroup(getPlayerGroup(plr), plr.name.." #FFFFFF"..msg, "chat")
	end
end
addCommandHandler("gc", groupChat, false, false)
addCommandHandler("groupchat", groupChat, false, false)

function handleLogin(plr)
	--local accountID = exports.UCDaccounts:getPlayerAccountID(plr)
	local account = plr.account.name
	outputDebugString("handleLogin - account = "..tostring(account))
	if (not playerGroupCache[account]) then
		playerGroupCache[account] = {}
		db:query(handleLogin2, {plr, account}, "SELECT `groupName`, `rank`, `joined`, `lastOnline`, `timeOnline`, `warningLevel` FROM `groups_members` WHERE `account`=? LIMIT 1", account)
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
			playerGroupCache[account] = {result[1].groupName, account, result[1].rank, result[1].joined, result[1].lastOnline, result[1].timeOnline, result[1].warningLevel} -- If a player is kicked while he is offline, we will need to delete the cache
		end
	end
	if (not playerGroupCache[account]) then return end
	local group_ = playerGroupCache[account][1]
	outputDebugString("handleLogin2: groupName = "..tostring(group_))
	plr:setData("group", group_)
	group[plr] = group_
end

addEventHandler("onPlayerQuit", root, 
	function ()
		--local accountID = exports.UCDaccounts:getPlayerAccountID(source)
		local account = source.account.name
		if (account and exports.UCDaccounts:isPlayerLoggedIn(source)) then
			-- Put the online time in the databse
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
				db:exec("UPDATE `groups_members` SET `timeOnline`=? WHERE `account`=?", getPlayerOnlineTime(plr), plr.account.name)
			end
		end
	end
)

function toggleGUI(update)
	--if (source.type == "player" and not plr) then plr = source end
	local groupName = getPlayerGroup(source) or ""
	local groupInfo = getGroupInfo(groupName) or ""
	local rank = getPlayerGroupRank(source)
	local permissions = getRankPermissions(groupName, rank)
	local ranks = {}
	
	triggerLatentClientEvent(source, "UCDgroups.toggleGUI", 15000, false, source, update, groupName, groupInfo, permissions, rank, ranks)
end
addEvent("UCDgroups.viewUI", true)
addEventHandler("UCDgroups.viewUI", root, toggleGUI)

