function getAllLoggedInPlayers()
	outputDebugString(sourceResource.name.." is using getAllLoggedInPlayers")
	local loggedIn = {}
	for _, plr in ipairs(Element.getAllByType("player")) do
		if (not plr.account:isGuest()) then
			table.insert(loggedIn, plr)
		end
	end
	return loggedIn
end
function getLoggedInPlayers()
	local loggedIn = {}
	for _, plr in pairs(Element.getAllByType("player")) do
		if (not plr.account:isGuest()) then
			table.insert(loggedIn, plr)
		end
	end
	return loggedIn
end

function getPlayerAccountID(plr)
	if (not plr) then return end
	if (not isElement(plr) or plr.type ~= "player") then return false end
	if (plr.account.guest) then return false end
	--return plr:getData("accountID") or db:query("SELECT `id` FROM `accounts` WHERE `accName`=? LIMIT 1", plr.account.name):poll(-1)[1].id
	if (sourceResource) then
		outputDebugString(tostring(sourceResource.name).." called getPlayerAccountID...")
		return 1
	end
	outputDebugString("Called getPlayerAccountID...")
	return 1
end

function isPlayerLoggedIn(plr)
	if (not plr) then return end
	if (not isElement(plr) or plr.type ~= "player" or plr.account.guest or not plr.account) then return false end
	return true
end

function getPlayerAccountName(plr)
	if (not plr) then return end
	if (not isElement(plr) or plr.type ~= "player" or not plr.account or plr.account.guest) then return false end
	return plr.account.name
end

-- Need to unfuck this
emailCache = {}
function getAccountEmail(account)
	if (not account) then return end
	if (not Account(account) or account == "guest") then return false end
	if (not emailCache[account]) then
		local email = db:query("SELECT `email` FROM `accounts` WHERE `account`=? LIMIT 1", account):poll(-1)[1].email
		emailCache[account] = email
	end
	return emailCache[account]
end
