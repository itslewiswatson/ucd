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
	if (not plr) then return end
	if (not isElement(plr) or plr.type ~= "player") then return false end
	if (plr.account.guest) then return false end
	return plr:getData("accountID") or db:query("SELECT `id` FROM `accounts` WHERE `accName`=? LIMIT 1", plr.account.name):poll(-1)[1].id
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

function registerAccount(plr, usr, passwd, email)
	if (not plr or not usr or not passwd or not email) then return end
	if (not isElement(plr) or plr.type ~= "player") then return false end

	-- MTA's db already hashes their user passwords differently to how we do
	-- This account going first is important, otherwise we would have a fucking mess
	local mtaAccount = Account.add(usr, passwd)
	if (not mtaAccount) then
		outputDebugString("Player "..plr.name.." failed to register correctly!")
		return false
	end

	-- Hash the user's passwd [Make reconsiderations with forum account sync]
	local salt = bcrypt_salt(6)
	local passwd = bcrypt_digest(passwd, salt)

	db:exec("INSERT INTO `accounts` SET `accName`=?, `pw`=?, `lastUsedName`=?, `ip`=?, `serial`=?, `email`=?", usr, passwd, plr.name, plr.ip, plr.serial, email)

	-- Get their account id so we don't have autoincrement failures
	--local accountID = db:query("SELECT LAST_INSERT_ID() AS `id`"):poll(-1)[1].id

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
	passwd = nil -- Clear their password out of memory
	db:exec("INSERT INTO `playerWeapons` SET `weaponString`=?", toJSON({})) -- Empty JSON string
	
	if (not accountData or #accountData == 0) then
		cacheAccount(1) -- We need to cache their account
	else
		cacheAccount(math.max(unpack(accountData)) + 1)
	end
	-- THIS SHOULD BE THE MOST FOOL PROOF WAY TO DETECT IT
	
	-- Old way
	--cacheAccount(db:query("SELECT MAX(`id`) AS `id`"):poll(-1)[1].id) -- We need to cache their account

	return true
end

function deleteAccount(accountKey)
	if (not accountKey) then return nil end

	local type_

	if (type(accountKey) == "string") then
		acc = Account(accountName)
		type_ = "accName"
	elseif (tonumber(accountKey) ~= nil) then
		acc = Account(accountData[accountKey][accName])
		type_ = "id"
	else
		return false
	end

	-- If the account has someone on it
	if (plr) then
		kickPlayer(plr, getResourceName(getThisResource()), "Your account has been deleted")
	end

	-- Important we check for this first
	if type_ == "id" then
		db:exec("DELETE FROM `playerWeapons` WHERE `id`=?", accountKey)
	else
		local newAccountKey = db:query("SELECT `id` FROM `accounts` WHERE `accName`=?", accountKey):poll(-1)[1].id
		db:exec("DELETE FROM `playerWeapons` WHERE `id`=?", newAccountKey)

	end

	db:exec("DELETE FROM `accounts` WHERE `??`=?", type_, accountKey)
	db:exec("DELETE FROM `accountData` WHERE `??`=?", type_, accountKey)

	acc:remove()

	return true
end

-- This function is used solely for a player to change his password
-- DO NOT use this to change the the password of any account
-- DEPRACATED
--[[
function changeAccountPassword(accountName, oldPassword, newPassword)
	if (not accountName or not oldPassword or not newPassword) then return nil end

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
--]]

-- This is the one we use manually. This also allows us to change the pw when the player is not online.
-- DEPRACATED
--[[
function changePassword(accountID, pass)
	if (not accountID) or (not pass) then return nil end
	local pass = tostring(pass)
	db:exec("UPDATE `accounts` SET `pw`=? WHERE `id`=?", pass, accountID)
	Account(getAccountNameFromID(accountID)):setPassword(pass)
	return true
end
--]]
