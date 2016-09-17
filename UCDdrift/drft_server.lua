function setPlayerBestDrift(score)
	if (client and score) then
		exports.UCDaccounts:SAD(client.account.name, "crimXP", exports.UCDaccounts:GAD(client.account.name, "crimXP") + 20)
		exports.UCDstats:setPlayerAccountStat(client, "bestDrift", score)
		client.money = client.money + 2500
		exports.UCDdx:new(client, "You have been rewarded $"..tostring(exports.UCDutil:tocomma(2500)).." and 20 crim XP for beating your previous best drift score", 0, 255, 0)
	end
end
addEvent("UCDdrift.setPlayerBestDrift", true)
addEventHandler("UCDdrift.setPlayerBestDrift", root, setPlayerBestDrift)

function addPlayerTotalDrift(score)
	if (client and score) then
		exports.UCDstats:setPlayerAccountStat(client, "totalDrift", exports.UCDstats:getPlayerAccountStat(client, "totalDrift") + score)
	end
end
addEvent("UCDdrift.addPlayerTotalDrift", true)
addEventHandler("UCDdrift.addPlayerTotalDrift", root, addPlayerTotalDrift)

addEvent("driftClienteListo", true)
addEventHandler("driftClienteListo", root,
	function ()
		triggerClientEvent(client, "UCDdrift.syncRecord", client, exports.UCDstats:getPlayerAccountStat(client, "bestDrift"))
	end
)

local wantedSpam = {}

function onPlayerFinishDrift()
	local msg
	local wanted = 5
	if (exports.UCDwanted:getWantedPoints(client) == 0) then
		msg = "You have been declared as a reckless driver by law enforcement"
	end
	if (wantedSpam[client] and getTickCount() - wantedSpam[client] < 10000) then
		return
	elseif (wantedSpam[client] and getTickCount() - wantedSpam[client] > 10000) then
		msg = "For further driving offences, you have been marked as a threat to other drivers"
	end
	exports.UCDwanted:addWantedPoints(client, wanted)
	exports.UCDdx:new(client, msg, 255, 255, 0)
	wantedSpam[client] = getTickCount()
end
addEvent("UCDdrift.onPlayerFinishDrift", true)
addEventHandler("UCDdrift.onPlayerFinishDrift", root, onPlayerFinishDrift)

addEventHandler("onPlayerQuit", root, 
	function ()
		wantedSpam[source] = nil
	end
)

function loadDrift()
	Timer(
		function (plr)
			triggerClientEvent(plr, "UCDdrift.syncRecord", plr, exports.UCDstats:getPlayerAccountStat(plr, "bestDrift") or 0)
		end, 1000, 1, source
	)
end
addEventHandler("onPlayerLogin", root, loadDrift)
