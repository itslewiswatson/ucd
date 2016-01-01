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

	db:exec("INSERT INTO `accounts` SET `account`=?, `pw`=?, `ip`=?, `serial`=?, `email`=?", usr, passwd, plr.name, plr.ip, plr.serial, email)

	-- Get their account id so we don't have autoincrement failures
	--local accountID = db:query("SELECT LAST_INSERT_ID() AS `id`"):poll(-1)[1].id

	db:exec("INSERT INTO `accountData` SET `account`=?, `x`=?, `y`=?, `z`=?, `rot`=?, `dim`=?, `interior`=?, `playtime`=?, `team`=?, `money`=?, `model`=?, `walkstyle`=?, `wanted`=?, `health`=?, `armour`=?, `occupation`=?, `class`=?, `nametag`=?, `lastUsedName`=?",
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
		toJSON({Team.getFromName("Unemployed"):getColor()}),
		plr.name
	)
	accountData[usr] = {x = 2001, y = -788, z = 134, rot = 0, dim = 0, interior = 0, playtime = 1, team = "Unemployed", money = 500, model = 61, walkstyle = 0, wanted = 0, health = 200, armour = 0, occupation = "Unemployed", class = "Homeless", nametag = toJSON({Team.getFromName("Unemployed"):getColor()}), lastUsedName = plr.name}
	--cacheAccount(usr) -- Minimize SQL usage so we just create the table here
	passwd = nil -- Clear their password out of memory
	db:exec("INSERT INTO `playerWeapons` SET `account`=?, `weaponString`=?", usr, toJSON({})) -- Empty JSON string
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
