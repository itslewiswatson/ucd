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
	-- for i=1, #accountData do -- This will break at bad pairs
	for i in pairs(accountData) do
		if accountData[i].accName == accountName then
			accountToID[accountName] = i -- Cache it in the table
			return i
		end
	end
	return false
end

function getPlayerFromID(accountID)
	if (not accountID) then return end
	
	-- Select it fron the table if it's there
	if (idToPlayer[accountID]) then
		return idToPlayer[accountID]
	end
	
	-- Loop
	for _, plr in pairs(Element.getAllByType("player")) do
		if (isPlayerLoggedIn(plr)) then
			if (getPlayerAccountID(plr) == accountID) then
				if (idToPlayer[accountID]) then
					idToPlayer[accountID] = nil
				end
				idToPlayer[accountID] = plr
				return plr
			end
		end
	end
	return false
end

-- Remove them from the table to avoid element recyling and conflict
addEventHandler("onPlayerQuit", root, 
	function ()
		local accountID = exports.UCDaccounts:getPlayerAccountID(source)
		idToPlayer[accountID] = nil
	end
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
