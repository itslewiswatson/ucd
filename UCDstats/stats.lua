playerStats = {}
db = exports.UCDsql:getConnection()

addEventHandler("onPlayerLogin", resourceRoot,
	function ()
		db:query(cachePlayerStats, {source}, "SELECT * FROM `playerStats` WHERE `account`=?", source.account.name)
	end
)

function cachePlayerStats(qh, plr)
	local result = qh:poll(-1)
	playerStats[plr] = {}
	
	for _, row in pairs(result) do
		for column, value in pairs(row) do
			if (column ~= "id") then
				playerStats[plr][column] = value
 			end
		end
	end
end

function onQuit()
	if (playerStats[source]) then
		playerStats[source] = nil
	end
end
addEventHandler("onPlayerQuit", root, onQuit)

function getPlayerAccountStat(plr, stat)
	if (not plr or not stat) then return nil end
	if (not isElement(plr) or plr:getType() ~= "player" or type(stat) ~= "string") then return false end
	if (not playerStats[plr] or playerStats[plr] == nil or playerStats[plr][stat] == nil) then
		return nil
	end
	if (stat == "*") then
		return playerStats[plr]
	end
	return playerStats[plr][stat]
end

function setPlayerAccountStat(plr, stat, value)
	if (not plr or not stat or not value or not db) then return nil end
	if (not isElement(plr) or plr:getType() ~= "player" or type(stat) ~= "string") then return false end	
	if (not playerStats[plr] or playerStats[plr] == nil or playerStats[plr][stat] == nil) then
		return nil
	end
	playerStats[plr][stat] = value
	db:exec("UPDATE `playerStats` SET `??`=? WHERE `id`=?", stat, value, exports.UCDaccounts:getPlayerAccountID(plr))
	return true
end
