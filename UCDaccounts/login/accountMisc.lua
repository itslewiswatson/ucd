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

	db:exec("INSERT INTO `accounts` (`account`, `pw`, `ip`, `serial`, `email`) VALUES (?, ?, ?, ?, ?) ", usr, passwd, plr.ip, plr.serial, email)
	db:exec("INSERT INTO `accountData` SET `account`=?, `x`=?, `y`=?, `z`=?, `rot`=?, `dim`=?, `interior`=?, `playtime`=?, `team`=?, `money`=?, `model`=?, `walkstyle`=?, `wp`=?, `health`=?, `armour`=?, `occupation`=?, `nametag`=?, `lastUsedName`=?, `ownedWeapons`=?",
		usr,
		2001,
		-788,
		134,
		0,
		0,
		0,
		1,
		"Citizens",
		500,
		61,
		0,
		0,
		200,
		0,
		"",
		toJSON({Team.getFromName("Citizens"):getColor()}),
		plr.name,
		toJSON({})
	)
	db:exec("INSERT INTO `sms_friends` SET `account`=?, `friends`=?", usr, toJSON({}))
	db:exec("INSERT INTO `playerStats` SET `account`=?", usr)
	
	accountData[usr] = {x = 2001, y = -788, z = 134, rot = 0, dim = 0, interior = 0, playtime = 1, team = "Citizens", money = 500, model = 61, walkstyle = 0, wp = 0, health = 200, armour = 0, occupation = "", nametag = toJSON({Team.getFromName("Citizens"):getColor()}), lastUsedName = plr.name}
	db:exec("INSERT INTO `playerWeapons` SET `account`=?, `weaponString`=?", usr, toJSON({})) -- Empty JSON string
	return true
end

function deleteAccount(accName)
	if (not accName or type(accName) ~= "string") then return false end
	
	local acc = Account(accName)
	
	-- If the account has someone on it
	if (acc.player) then
		acc.player:kick(getThisResource().name, "Your account has been deleted")
	end
	
	-- Delete from all SQL tables
	db:exec("DELETE FROM `accounts` WHERE `account`=?", accName)
	db:exec("DELETE FROM `accountData` WHERE `account`=?", accName)
	db:exec("DELETE FROM `sms_friends` WHERE `account`=?", accName)
	db:exec("DELETE FROM `playerStats` WHERE `account`=?", accName)
	acc:remove()

	return true
end
