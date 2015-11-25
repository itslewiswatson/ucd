-- `groups`
-- [groupID] = {"name", "info", leaderID, count, "created", "balance", "colour"}
-- [int] = {varchar, text, leaderID, smallint, timestamp, bigint, varchar [json], }

-- We have groups_members query to basically queue the loading in of these to avoid lag

local settings =
{
	max_members = 50,
	max_invites = 10, -- Maxmimum number of pending invites
	max_totalslots = 50, -- Pending invites and current members
	max_inactive = 14, -- 14 days
}

db = exports.UCDsql:getConnection()

groupTable = {}
groupMembers = {} -- We can just get their player elements from their id since more caching was introduced

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
		db:query(cacheGroupMembers, {}, "SELECT groupID, accountID FROM `groups_members`")
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
end

function createGroup(name)
	-- Need to perform preliminary checks
	
	local clientID = getPlayerAccountID(client) -- Get the client's id
	db:exec("INSERT INTO `groups_` SET `name`=?, `leaderID`=?, `colour`=?", name, clientID, toJSON({255, 255, 255})) -- Make the inital group creation
	
	local groupID = db:query("SELECT Max(`id`) AS `id` FROM `accounts`"):poll(0)[1].id -- Get the group's id
	db:exec("INSERT INTO `groups_members` SET `groupID`=?, `accountID`=?, `name`=?, `rank`=?, `lastOnline`=?", groupID, clientID, client.name, 0, 0) -- Make the client's membership official and grant founder status
	
	-- Do a proper caching of the group
	db:query(cacheGroupTable, {}, "SELECT * FROM `groups_` WHERE `groupID`=?", groupID)
	
	groupMembers[groupID] = {}
	table.insert(groupMembers[groupID], clientID)
end
