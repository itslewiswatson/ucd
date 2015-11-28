-- `groups`
-- [groupID] = {"name", "info", leaderID, count, "created", "balance", "colour"}
-- [int] = {varchar, text, leaderID, smallint, timestamp, bigint, varchar [json], }

-- We have groups_members query to basically queue the loading in of these to avoid lag

-- Move this to a dedicated exports file
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


local settings =
{
	max_members = 50,
	max_invites = 10, -- Maxmimum number of pending invites
	max_totalslots = 50, -- Pending invites and current members
	max_inactive = 14, -- 14 days
	
	default_infoText = "Enter information about your group here!",
	default_colour = {255, 255, 255},
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
		groupTable[row.groupID] = {}
		for column, data in pairs(row) do
			if (column ~= "groupID") then
				groupTable[row.groupID][column] = data
			end
		end
	end
	if (result and #result > 1) then
		db:query(cacheGroupMembers, {}, "SELECT `groupID`, `accountID` FROM `groups_members`")
	end
end

function cacheGroupMembers(qh)
	local result = qh:poll(0)
	for _, row in pairs(result) do
		if (groupTable[row.groupID]) then
			if (not groupMembers[row.groupID]) then
				groupMembers[row.groupID] = {}
			end
			table.insert(groupMembers[row.groupID], row.accountID)
			local member = exports.UCDaccounts:getPlayerFromAccountID(row.accountID)
			if (member) then
				db:exec("UPDATE `groups_members` SET `name`=? WHERE `accountID`=?", member.name, row.accountID)
			end
 		end
	end
	-- Resource should be fully loaded by now, let's load things for existing players
	for _, plr in pairs(Element.getAllByType("player")) do
		if (exports.UCDaccounts:isPlayerLoggedIn(plr)) then
			handleLogin(plr)
		end
	end
end

function getGroupData(groupID, column)
	return groupTable[groupID][column]
end

function createGroup(name)
	-- Need to perform preliminary checks [check if group name already exists, etc]
	if (#name < 2 or #name > 16) then
		-- Message
		return false
	end
	
	if not client or client == nil then client = getPlayerFromName("Noki") end -- For runcode purposes right now
	
	local clientID = exports.UCDaccounts:getPlayerAccountID(client) -- Get the client's id
	db:exec("INSERT INTO `groups_` SET `name`=?, `leaderID`=?, `colour`=?, `info`=?", name, clientID, toJSON(settings.default_colour), settings.default_infoText) -- Perform the inital group creation
	
	local groupID
	--local groupID = db:query("SELECT Max(`groupID`) AS `groupID` FROM `groups_`"):poll(-1)[1].groupID -- Get the group's id
	if (#groupTable == nil or #groupTable == 0) then
		groupID = 1
	else
		groupID = math.max(unpack(groupTable)) -- Gets the maximum number from the table, even if pairs break at all [less sql = better :)]
	end
	db:exec("INSERT INTO `groups_members` SET `groupID`=?, `accountID`=?, `name`=?, `rank`=?, `lastOnline`=?, `timeOnline`=?", groupID, clientID, client.name, 0, 0, 0) -- Make the client's membership official and grant founder status
	
	-- Perform a proper caching of the group
	db:query(cacheGroupTable, {}, "SELECT * FROM `groups_` WHERE `groupID`=?", groupID)
	
	groupMembers[groupID] = {}
	table.insert(groupMembers[groupID], clientID)
	
	client:setData("group", name)
	group[client] = name
	playerGroupCache[accountID] = {groupID, accountID, accountName, 0, nil, nil, 0} -- Should I even bother?
	
	return true
end

function handleLogin(plr)
	if (not plr) then plr = source end
	local accountID = exports.UCDaccounts:getPlayerAccountID(plr)
	if (not playerGroupCache[plr]) then
		playerGroupCache[plr] = {}
		db:query(handleLogin2, {plr, plr.account.name, accountID}, "SELECT `groupID`, `rank`, `joined`, `timeOnline` FROM `groups_members` WHERE `accountID`=?", accountID)
	else
		handleLogin2(nil, plr, plr.account.name, accountID)
	end
end
addEventHandler("onPlayerLogin", root, handleLogin)

-- We do this so the we don't always query the SQL database upon login to get group data
function handleLogin2(qh, plr, accountName, accountID)
	if (qh) then
		local result = qh:poll(-1)[1]
		if (result and #result == 1) then
			playerGroupCache[accountID] = {result.groupID, accountID, accountName, result.rank, result.joined, result.lastOnline, result.timeOnline} -- If a player is kicked while he is offline, we will need to delete the cache
		end
	end
	if (not playerGroupCache[accountID]) then return end
	local group_ = getGroupNameFromID(playerGroupCache[accountID][1])
	plr:setData("group", group_)
	group[plr] = group_
	onlineTime[plr] = getRealTime().timestamp
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
