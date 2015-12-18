db = exports.UCDsql:getConnection()

function getOnlineAdmins()
	local onlineAdmins = {}
	for _, plr in pairs(Element.getAllByType("player")) do
		if (adminTable[exports.UCDaccounts:getPlayerAccountID(plr)]) then
			table.insert(onlineAdmins, plr)
		end
	end
	return onlineAdmins
end

function getPlayerAdminRank(plr)
	if (not plr) then return end
	if (plr.type ~= "player") then return false end
	local id = exports.UCDaccounts:getPlayerAccountID(plr)
	if isPlayerOwner(plr) then return 5 end
	if (adminTable and adminTable[id]) then
		return adminTable[id].rank 
	end
	return false
end

-- make an admin table
function isPlayerOwner(plr)
	if not plr then return nil end
	if exports.UCDaccounts:getPlayerAccountID(plr) == 1 then return true else return false end
end

function isPlayerDeveloper(plr)
	if not plr then return nil end
	if (plr:getType() ~= "player") then return false end
	
	local id = exports.UCDaccounts:getPlayerAccountID(plr)
	if (not adminTable[id] or not adminTable[id].dev) then
		return false
	end
	return true
end

function isPlayerAdmin(plr)
	if not plr then return nil end
	if (plr.type ~= "player") then return false end
	
	local id = exports.UCDaccounts:getPlayerAccountID(plr)
	if (not adminTable[id]) then
		return false
	end
	return true
end

function setPlayerAdminRank(plr, rank)
	if (not plr or not rank) then return nil end
	if (plr:getType() ~= "player" or tonumber(rank) == nil or rank > 5 or rank < 1) then return false end
	
	local id = exports.UCDaccounts:getPlayerAccountID(plr)
	db:exec("UPDATE `admins` SET `rank`=? WHERE `id`=?", rank, id)
	if (not adminTable[id]) then
		db:query(createAdminTable, {}, "SELECT * FROM `admins`")
	else
		adminTable[id]["rank"] = rank
	end
	return true
end

function setPlayerDeveloper(plr, state)
	if (not plr or not state) then return nil end
	if (plr:getType() ~= "player" or not isPlayerAdmin(plr)) then return false end
	
	local id = exports.UCDaccounts:getPlayerAccountID(plr)
	if (not adminTable[id]) then
		return false
	end
	
	-- Arg checking
	if (state == true) then
		state = "true"
	elseif (state == false) then 
		state = "false"
	end
	if (state ~= "true" or state ~= "false") then return false end
	
	db:exec("UPDATE `admins` SET `dev`=? WHERE `id`=?", state, id)
	adminTable[id]["dev"] = state
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
