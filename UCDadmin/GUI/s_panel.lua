function requestPlayerData(plr)
	local ip = plr.ip or "N/A"
	local serial = plr.serial or "N/A"
	if (isPlayerOwner(plr) or getPlayerAdminRank(plr) >=5) then ip = "Hidden" serial = "Hidden" end
	local version = or "N/A"
	local bank = 500 -- Need bank thingo
	local email = exports.UCDsql:getConnection():query("SELECT `email` FROM `accounts` WHERE `id`=?", exports.UCDaccounts:getPlayerAccountID(plr)):poll(-1)[1].email or "N/A" -- lol
	
	local data = {["ip"] = ip, ["serial"] = serial, ["version"] = version, ["email"] = email, ["bank"] = bank}
	triggerLatentClientEvent(client, "UCDadmin.requestPlayerData:callback", client, data)
end
addEvent("UCDadmin.requestPlayerData", true)
addEventHandler("UCDadmin.requestPlayerData", root, requestPlayerData)
