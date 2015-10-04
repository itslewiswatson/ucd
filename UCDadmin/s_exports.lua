db = exports.UCDsql:getConnection()

function getModeratorRank(plr)
	if not plr then return nil end
	local id = exports.UCDaccounts:getPlayerAccountID(plr)
	local adminRank = exports.UCDsql:query("SELECT `moderatorRank` FROM `admins` WHERE `id`=? LIMIT 1", id)
	if (#adminRank == 1) then
		return adminRank[1].moderatorRank
	else
		return false
	end
end

function getDeveloperRank(plr)
	if not plr then return nil end
	local id = exports.UCDaccounts:getPlayerAccountID(plr)
	local adminRank = exports.UCDsql:query("SELECT `developerRank` FROM `admins` WHERE `id`=? LIMIT 1", id)
	if (#adminRank == 1) then
		return adminRank[1].developerRank
	else
		return false
	end
end

-- make an admin table
function isPlayerOwner(plr)
	if not plr then return nil end
	local id = exports.UCDaccounts:getPlayerAccountID(plr)
	local adminRank = exports.UCDsql:query("SELECT `isOwner` FROM `admins` WHERE `id`=? LIMIT 1", id)
	if (#adminRank == 1) then
		if (adminRank[1].isOwner == 1) then
			return true
		elseif (adminRank[1].isOwner == 0) or (adminRank[1].isOwner == nil) then
			return false
		else
			return false
		end
	else
		return false
	end
	return true
end

function isPlayerDeveloper(plr)
	if not plr then return nil end
	if (getElementType(plr) ~= "player") then return nil end
	local id = exports.UCDaccounts:getPlayerAccountID(plr)
	local adminRank = exports.UCDsql:query("SELECT `developerRank` FROM `admins` WHERE `id`=? LIMIT 1", id)
	if (#adminRank == 1) then
		if (adminRank[1].developerRank > 0) then
			return true
		else
			return false
		end
	else
		return false
	end
end

function isPlayerModerator(plr)
	if not plr then return nil end
	if (getElementType(plr) ~= "player") then return nil end
	local id = exports.UCDaccounts:getPlayerAccountID(plr)
	local adminRank = exports.UCDsql:query("SELECT `moderatorRank` FROM `admins` WHERE `id`=?", id)
	if (#adminRank == 1) then
		if (adminRank[1].moderatorRank > 0) then
			return true
		else
			return false
		end
	else
		return false
	end
end

function setPlayerDeveloperRank(plr, rank)
	if not plr or not rank then return nil end
	if (getElementType(plr) ~= "player") then return false end
	if (tonumber(rank) == nil) then return false end
	if (rank > 4) then
		return false
	elseif (rank < 0) then
		return false
	end
	
	local id = exports.UCDaccounts:getPlayerAccountID(plr)
	local existingDev = exports.UCDsql:query("SELECT `developerRank` FROM `admins` WHERE `id`=? LIMIT 1", id)
	if (#existingDev == 1) then
		dbExec(db, "UPDATE `admins` SET `developerRank`=? WHERE `id`=?", rank, id)
	else
		dbExec(db, "INSERT INTO `admins` VALUES (?, ?, ?, ?)", id, 0, rank, 0)
	end
	return true
end

function setPlayerModeratorRank(plr, rank)
	if not plr or not rank then return nil end
	if (getElementType(plr) ~= "player") then return false end
	if (tonumber(rank) == nil) then return false end
	if (rank > 4) then
		return false
	elseif (rank < 0) then
		return false
	end
	
	local id = exports.UCDaccounts:getPlayerAccountID(plr)
	local existingMod = exports.UCDsql:query("SELECT `moderatorRank` FROM `admins` WHERE `id`=? LIMIT 1", id)
	if (#existingMod == 1) then
		dbExec(db, "UPDATE `admins` SET `moderatorRank`=? WHERE `id`=?", rank, id)
	else
		dbExec(db, "INSERT INTO `admins` VALUES (?, ?, ?, ?)", id, 0, rank, 0)
	end
	return true
end

function isAdminOnDuty(plr)
	if not plr then return nil end
	if (plr:getType() ~= "player") then return false end
	
	-- We also need to check if they are an admin in the database, as people can just join the admin team anyway
	if ((not isPlayerDeveloper(plr)) or (not isPlayerModerator(plr))) then
		return false
	end
	
	-- Check if they are on duty (all on duty admins should be in the "Admins" team)
	if (not exports.UCDteams:isPlayerInTeam(plr, "Admins")) then
		return false
	end
	-- All checks passed, return true
	return true
end
