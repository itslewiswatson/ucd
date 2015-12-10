-- `groups`
-- [groupName] = {"info", leaderID, count, "created", "balance", "colour"}
-- [string] = {text, leaderID, smallint, timestamp, bigint, varchar [json], }

-- We have groups_members query to basically queue the loading in of these to avoid lag

local settings = {
	max_members = 50,
	max_invites = 10, -- Maxmimum number of pending invites
	max_totalslots = 50, -- Pending invites and current members
	max_inactive = 14, -- 14 days
	
	default_info_text = "Enter information about your group here!",
	default_colour = {255, 255, 255},
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
playerGroupCache = {} -- Player group cache
onlineTime = {}

addEventHandler("onResourceStart", resourceRoot,
	function ()
		if (not db) then outputDebugString("["..Resource.getName(resourceRoot).."] Unable to establish connection with MySQL database.") return false end
		db:query(cacheGroupTable, {}, "SELECT * FROM `groups_`")
	end
)

function cacheGroupTable(qh)
	local result = qh:poll(0)
	for _, row in pairs(result) do
		groupTable[row.groupName] = {}
		for column, data in pairs(row) do
			if (column ~= "groupName") then
				groupTable[row.groupName][column] = data
			end
		end
	end
	if (result and #result >= 1) then
		db:query(cacheGroupMembers, {}, "SELECT `groupName`, `accountID` FROM `groups_members`")
	end
end

function cacheGroupMembers(qh)
	local result = qh:poll(0)
	for _, row in pairs(result) do
		if (groupTable[row.groupName]) then
			if (not groupMembers[row.groupName]) then
				groupMembers[row.groupName] = {}
			end
			table.insert(groupMembers[row.groupName], row.accountID)
			local member = exports.UCDaccounts:getPlayerFromID(row.accountID)
			if (member) then
				db:exec("UPDATE `groups_members` SET `name`=? WHERE `accountID`=?", member.name, row.accountID)
			end
 		end
	end
	for i in pairs(groupTable) do
		if (not groupMembers[i] or #groupMembers[i] == 0) then
			-- Remove group
		end
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
		if (group[client] or client:getData("group") ~= false) then
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
				if type_ == whole then
					if (name == chars) then
						exports.UCDdx:new(client, "The specified group name is prohibited. If you believe this is a mistake, please notify an administrator.", 255, 0, 0)
						return false
					end
				else
					--outputDebugString(chars)
					if (name:lower():find(chars)) then
						exports.UCDdx:new(client, "The specified group name contains forbidden phrases or characters. If you believe this is a mistake, please notify an administrator.", 255, 0, 0)
						return false
					end
				end
			end
		end
		
		if not client or client == nil then client = getPlayerFromName("Noki") end -- For runcode purposes right now
		
		local clientID = exports.UCDaccounts:getPlayerAccountID(client) -- Get the client's id
		db:exec("INSERT INTO `groups_` SET `groupName`=?, `leaderID`=?, `colour`=?, `info`=?", groupName, clientID, toJSON(settings.default_colour), settings.default_info_text) -- Perform the inital group creation	
		db:exec("INSERT INTO `groups_members` SET `groupName`=?, `accountID`=?, `name`=?, `rank`=?, `lastOnline`=?, `timeOnline`=?", groupName, clientID, client.name, 0, 0, 0) -- Make the client's membership official and grant founder status
		db:query(cacheGroupTable, {}, "SELECT * FROM `groups_` WHERE `groupName`=?", groupName)
		groupMembers[groupName] = {}
		table.insert(groupMembers[groupName], clientID)
		client:setData("group", groupName)
		group[client] = groupName
		playerGroupCache[clientID] = {groupName, clientID, accountName, 0, nil, nil, 0} -- Should I even bother?
		exports.UCDdx:new(client, "You have successfully created "..groupName, 0, 255, 0)
	end
end
addEvent("UCDgroups.createGroup", true)
addEventHandler("UCDgroups.createGroup", root, createGroup)

function deleteGroup()
	if (client) then
		if (not group[client]) then
			exports.UCDdx:new(client, "You are not in a group", 255, 0, 0)
			return
		end
		local groupName = playerGroupCache[exports.UCDaccounts:getPlayerAccountID(client)][1]
		outputDebugString("Deleting group where groupName = "..groupName)
		db:exec("DELETE FROM `groups_` WHERE `groupName`=?", groupName)
		db:exec("DELETE FROM `groups_members` WHERE `groupName`=?", groupName)
			
		-- Find a more efficient way to do this
		-- getMembersInGroup(groupID)
		for _, id in pairs(groupMembers[groupName]) do
			local plr = exports.UCDaccounts:getPlayerFromID(id)
			if (plr and isElement(plr) and group[plr]) then
				plr:setData("group", false)
				group[plr] = nil
				playerGroupCache[exports.UCDaccounts:getPlayerAccountID(plr)] = nil
				onlineTime[plr] = nil
				exports.UCDdx:new(plr, client.name.." has decided to delete the group", 255, 0, 0)
				triggerClientEvent(plr, "UCDgroups.updateGUI", plr)
			end
		end
		
		groupMembers[groupName] = nil
		groupTable[groupName] = nil
		
		exports.UCDdx:new(client, "You have deleted the group", 255, 0, 0)
	end
end
addEvent("UCDgroups.deleteGroup", true)
addEventHandler("UCDgroups.deleteGroup", root, deleteGroup)

function handleLogin(plr)
	local accountID = exports.UCDaccounts:getPlayerAccountID(plr)
	outputDebugString("handleLogin - accountID = "..tostring(accountID))
	if (not playerGroupCache[plr]) then
		playerGroupCache[plr] = {}
		db:query(handleLogin2, {plr, plr.account.name, accountID}, "SELECT `groupName`, `rank`, `joined`, `lastOnline`, `timeOnline` FROM `groups_members` WHERE `accountID`=? LIMIT 1", accountID)
	else
		handleLogin2(nil, plr, plr.account.name, accountID)
	end
end
addEventHandler("onPlayerLogin", root, function () handleLogin(source) end)

-- We do this so the we don't always query the SQL database upon login to get group data
function handleLogin2(qh, plr, accountName, accountID)
	if (qh) then
		outputDebugString("Called handleLogin2 with a query handler")
		local result = qh:poll(-1)
		if (result and #result == 1) then
			playerGroupCache[accountID] = {result[1].groupName, accountID, accountName, result[1].rank, result[1].joined, result[1].lastOnline, result[1].timeOnline} -- If a player is kicked while he is offline, we will need to delete the cache
		end
	end
	if (not playerGroupCache[accountID]) then return end
	local group_ = playerGroupCache[accountID][1]
	outputDebugString("handleLogin2: groupName = "..tostring(group_))
	plr:setData("group", group_)
	group[plr] = group_
	onlineTime[plr] = getRealTime().timestamp
	outputDebugString("Finished handleLogin2")
end

addEventHandler("onPlayerQuit", root, 
	function ()
		local accountID = exports.UCDaccounts:getPlayerAccountID(source)
		if (accountID and exports.UCDaccounts:isPlayerLoggedIn(source)) then
			local onlineTime = getPlayerOnlineTime(source)
			-- Put the online time in the databse
			db:exec("UPDATE `groups_members` SET `timeOnline`=? WHERE `accountID`=?", getPlayerOnlineTime(source), accountID)
			playerGroupCache[accountID][7] = onlineTime
			onlineTime[source] = nil
			group[source] = nil
		end
	end
)

addEventHandler("onResourceStop", resourceRoot,
	function () 
		for _, plr in pairs(Element.getAllByType("player")) do
			if plr:getData("group") ~= false then 
				plr:setData("group", false)
				db:exec("UPDATE `groups_members` SET `timeOnline`=? WHERE `accountID`=?", getPlayerOnlineTime(plr), exports.UCDaccounts:getPlayerAccountID(plr))
			end
		end
	end
)

function getGroupInfo(group)
	if not group or group == "" then return end
	if not groupTable[group].info then
		return false
	end
	return groupTable[group].info
end

function getGroupMemberCount(group)
	return #groupMembers[group] or false
end

function toggleGUI(plr, update)
	local plr = client or plr
	local groupName = group[plr] or ""
	local groupInfo = getGroupInfo(groupName) or ""
	local permissions = {}
	local rank = -1
	local ranks = {}
	
	triggerLatentClientEvent(plr, "UCDgroups.toggleGUI", 15000, false, plr, update, groupName, groupInfo, permissions, rank, ranks)
end
addEvent("UCDgroups.viewUI", true)
addEventHandler("UCDgroups.viewUI", root, toggleGUI)

