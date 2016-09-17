function requestPlayerData(plr)
	local ip = plr.ip or "N/A"
	local serial = plr.serial or "N/A"
	if (isPlayerAdmin(plr)) then
		if (isPlayerOwner(plr) and not isPlayerOwner(client)) then ip = "Hidden" serial = "Hidden" end
	end
	local version = plr.version or "N/A"
	local bank = exports.UCDaccounts:GAD(plr, "bankbalance")
	local email = exports.UCDaccounts:getAccountEmail(plr.account.name) or "N/A" -- lol
	local money = plr:getMoney()
	local weapon = tostring(getWeaponNameFromID(getPedWeapon(plr)).." ["..getPedTotalAmmo(plr).."]")
	
	local data = {["ip"] = ip, ["serial"] = serial, ["version"] = version, ["email"] = email or "N/A", ["bank"] = bank, ["money"] = money, ["weapon"] = weapon}
	triggerLatentClientEvent(client, "UCDadmin.requestPlayerData:callback", client, data)
end
addEvent("UCDadmin.requestPlayerData", true)
addEventHandler("UCDadmin.requestPlayerData", root, requestPlayerData)

function fetchResources()
	local resources = {}
	for i, res in ipairs(getResources()) do
		resources[i] = {res.name, res.state}
	end
	--triggerClientEvent(client, "UCDadmin.updateResources", client, resources or {})
end
--addEvent("UCDadmin.getResources", true)
--addEventHandler("UCDadmin.getResources", root, fetchResources)
