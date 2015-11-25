idToPlayer = {}
accountToID = {}

-- This doesn't need a table
function getAccountNameFromID(id)
	if (not id) then return nil end
	local accountName = accountData[id].accName

	-- Not in the table, select it from the database
	if (not accountName or accountName == nil) then
		local accountName = db:query("SELECT `accName` FROM `accounts` WHERE `id`=? LIMIT 1", id):poll(-1)[1].accName
		if (not accountName or accountName == nil) then
			-- We possible have the option to cache it here if need be
			return false
		end
		return accountName
	end
	return accountName
end

function getIDFromAccountName(accountName)
	if (not accountName) then return nil end
	if (type(accountName) ~= "string") then return false end
	
	-- Caching at its finest
	if (accountToID[accountName]) then
		return accountToID[accountName]
	end
	
	-- Not in the table
	for i=1, #accountData do
		if accountData[i].accName == accountName then
			accountToID[accountName] = i -- Cache it in the table
			return i
		end
	end
	return false
end

function getPlayerFromID(id)
	if (not id) then return nil end
	
	-- Select it fron the table if it's there
	if (idToPlayer[id]) then
		return idToPlayer[id]
	end
	
	-- Loop
	for _, plr in pairs(Element.getAllByType("player")) do
		if (isPlayerLoggedIn(plr)) then
			if (getPlayerAccountID(plr) == id) then
				idToPlayer[id] = plr
				return plr
			end
		end
	end
	return false
end

-- Remove them from the table to avoid element recyling and conflict
addEventHandler("onPlayerQuit", root, 
	function ()
		local id = exports.UCDaccounts:getPlayerAccountID(plr)
		if idToPlayer[id] then
			idToPlayer[id] = nil
		end
	end, false, "high"
)

addEventHandler("onResourceStart", resourceRoot,
	function ()
		for _, plr in pairs(Element.getAllByType("player")) do
			if (isPlayerLoggedIn(plr)) then
				-- Put them in there
				accountToID[plr.account.name] = getPlayerAccountID(plr)
				idToPlayer[getPlayerAccountID(plr)] = plr
			end
		end
	end
)
