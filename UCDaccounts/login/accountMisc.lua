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
	
	local blankJSON = toJSON({})
	-- Password should now only be stored in SMF
	
	db:exec("INSERT INTO `accountData` (`account`, `lastUsedName`, `ownedWeapons`, `weaponString`, `sms_friends`) VALUES (?, ?, ?, ?, ?)",
		usr,
		plr.name,
		blankJSON,
		blankJSON,
		blankJSON
	)
	accountData[usr] = {x = 1519.616, y = -1675.9303, z = 13.5469, rot = 270, dim = 0, interior = 0, playtime = 1, team = "Citizens", money = 25000, model = 0, walkstyle = 0, wp = 0, health = 200, armour = 0, occupation = "", nametag = toJSON({Team.getFromName("Citizens"):getColor()}), lastUsedName = plr.name, ownedWeapons = toJSON({}), weaponString = toJSON({}), sms_friends = toJSON({}), aviator = 0, trucker = 0, crimXP = 0, bankbalance = 10000}
	db:exec("INSERT INTO `playerStats` SET `account`=?", usr)
	db:exec("INSERT INTO `accounts` (`account`, `ip`, `serial`, `email`) VALUES (?, ?, ?, ?) ", usr, plr.ip, plr.serial, email)

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
	--db:exec("DELETE FROM `sms_friends` WHERE `account`=?", accName)
	db:exec("DELETE FROM `playerStats` WHERE `account`=?", accName)
	--exports.UCDsql:getForumDatabase():exec("DELETE FROM `smf_members` WHERE `member_name` = ?", accName)
	acc:remove()

	return true
end
