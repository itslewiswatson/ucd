function getAllLoggedInPlayers()
	local loggedIn = {}
	for _, plr in pairs(Element.getAllByType("player")) do
		if (not plr.account:isGuest()) then
			table.insert(loggedIn, plr)
		end
	end
	return loggedIn
end

function getPlayerAccountID(plr)
	if (not plr) then return nil end
	if (plr:getType() ~= "player") then return false end
	
	local plrAccount = plr:getAccount()
	if (plrAccount:isGuest()) then return false end
	
	return plr:getData("accountID") or db:query("SELECT `id` FROM `accounts` WHERE `accName`=? LIMIT 1", plrAccount:getName()):poll(-1)[1].id
end

function isPlayerLoggedIn(plr)
	if (not plr) then return nil end
	if (getElementType(plr) ~= "player") then return false end
	
	local acc = getPlayerAccount(plr)
	if (not isGuestAccount(acc)) then
		return true
	else 
		return false
	end
end

function getPlayerFromID(id)
	if (not id) then return nil end
	for _, plr in pairs(Element.getAllByType("player")) do
		if (isPlayerLoggedIn(plr)) then
			if (getPlayerAccountID(v) == id) then
				return plr
			end
		end
	end
	return false
end

function getPlayerAccountName(plr)
	local plrAccount = plr:getAccount()
	if (not plrAccount) or (plrAccount:isGuest()) then
		return false
	end
	return plrAccount:getName()
end

function getAccountNameFromID(id)
	if not id then return nil end
	local accountName = accountData[id].accName
	
	-- Not in the table, select it from the database
	if (not accountName) or (accountName == nil) then
		local accountName = db:query("SELECT `accName` FROM `accounts` WHERE `id`=? LIMIT 1", id):poll(-1)[1].accName
		if (not accountName) or (accountName == nil) then
			-- We possible have the option to cache it here if need be
			return false
		end
		return accountName
	end
	
	return accountName
end

function getIDFromAccountName(accountName)
	
end

function registerAccount(plr, usr, passwd, email)
	if (not plr) or (not usr) or (not passwd) or (not email) then return nil end
	if (plr:getType() ~= "player") then return false end
	
	-- MTA's db already hashed their user passwords differently to how we do
	local mtaAccount = addAccount(usr, passwd)
	if (not mtaAccount) then
		outputDebugString("Player "..plr:getName().." failed to register correctly!")
		return false
	end
	
	-- Hash the user's passwd
	local salt = bcrypt_salt(6)
	passwd = bcrypt_digest(passwd, salt)
	
	db:exec("INSERT INTO `accounts` SET `accName`=?, `pw`=?, `lastUsedName`=?, `ip`=?, `serial`=?, `email`=?", usr, passwd, plr:getName(), plr:getIP(), plr:getSerial(), email)
	db:exec("INSERT INTO `accountData` SET `accName`=?, `x`=?, `y`=?, `z`=?, `rot`=?, `dim`=?, `interior`=?, `playtime`=?, `team`=?, `money`=?, `model`=?, `walkstyle`=?, `wanted`=?, `health`=?, `armour`=?, `occupation`=?, `class`=?, `nametag`=?",
		usr,
		2001,
		-788,
		134,
		0,
		0,
		0,
		1,
		"Unemployed",
		500,
		61,
		0,
		0,
		200,
		0,
		"Unemployed",
		"Homeless",
		toJSON({Team.getFromName("Unemployed"):getColor()})
	)
	
	-- Clear their password out of memory
	passwd = nil
	
	-- We need to cache their account
	local result = db:query("SELECT LAST_INSERT_ID() AS `id`"):poll(-1)[1].id
	cacheAccount(tonumber(result))
	
	return true
end

function deleteAccount(accountName)
	if (not accountName) then return nil end
	local delAccount = Account(accountName)
	local plr = delAccount:getPlayer()
	
	-- If the player has someone on it
	if (plr) then
		kickPlayer(plr, getResourceName(getThisResource()), "Your account has been deleted")
	end
	
	db:exec("DELETE FROM `accounts` WHERE `accName`=?", accountName)
	db:exec("DELETE FROM `accountData` WHERE `accName`=?", accountName)
	delAccount:remove()
	return true
end

-- This function is used solely for a player to change his password
-- DO NOT use this to change the the password of any account
function changeAccountPassword(accountName, oldPassword, newPassword)
	if (not accountName) or (not oldPassword) or (not newPassword) then return nil end
	
	-- Might want to add a newConfirmationPassword as well
	local accountName = tostring(accountName)
	local oldPassword = tostring(oldPassword)
	local newPassword = tostring(newPassword)

	local physicalAccount = getAccount(accountName)
	if (not physicalAccount) then return false end

	-- Fix this shit code
	local accountDetailQuery = exports.UCDsql:query("SELECT * FROM `accounts` WHERE `accName`=? LIMIT 1", accountName)
	if (accountDetailQuery) and (#accountDetailQuery == 1) then
		if (oldPassword == accountDetailQuery[1].pw) then
			db:exec("UPDATE `accounts` SET `pw`=? WHERE `accName`=?", tostring(newPassword), accountName)
			local passChange = setAccountPassword(physicalAccount, tostring(newPassword))
			if not passChange then return false end
		else
			return false
		end
	else
		return false
	end
	return true
end

-- This is the one we use manually. This also allows us to change the pw when the player is not online.
function changePassword(accountID, pass)
	if (not accountID) or (not pass) then return nil end
	local pass = tostring(pass)
	db:exec("UPDATE `accounts` SET `pw`=? WHERE `id`=?", pass, accountID)
	Account(getAccountNameFromID(accountID)):setPassword(pass)
	return true
end
