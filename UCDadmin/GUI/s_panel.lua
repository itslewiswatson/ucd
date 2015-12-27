function requestPlayerData(plr)
	local ip = plr.ip or "N/A"
	local serial = plr.serial or "N/A"
	if (isPlayerAdmin(plr)) then
		if (isPlayerOwner(plr) or getPlayerAdminRank(plr) >= 5 and getPlayerAdminRank(client) ~= 5) then ip = "Hidden" serial = "Hidden" end
	end
	local version = plr.version or "N/A"
	local bank = 500 -- Need bank thingo
	local email = exports.UCDaccounts:getAccountEmail(plr.account.name) or "N/A" -- lol
	
	local data = {["ip"] = ip, ["serial"] = serial, ["version"] = version, ["email"] = email or "N/A", ["bank"] = bank}
	triggerLatentClientEvent(client, "UCDadmin.requestPlayerData:callback", client, data)
end
addEvent("UCDadmin.requestPlayerData", true)
addEventHandler("UCDadmin.requestPlayerData", root, requestPlayerData)