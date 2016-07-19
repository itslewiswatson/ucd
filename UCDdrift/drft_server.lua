function setPlayerBestDrift(score)
	if (client and score) then
		exports.UCDstats:setPlayerAccountStat(client, "bestDrift", score)
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

--[[
addEventHandler("onVehicleDamage", root, 
	function ()
		plr = source.controller
		if plr then
			triggerClientEvent(plr, "driftCarCrashed", plr, source)
		end
	end
)
--]]

function gcash(amount)
	client.money = client.money + amount
end
addEvent("updatecash", true )
addEventHandler("updatecash", root, gcash )


-- saving / Load


function loadDrift()
	if (not plr.account.guest) then
		triggerClientEvent(source, "UCDdrift.syncRecord", source, exports.UCDstats:getPlayerAccountStat(client, "bestDrift"))
	end
end
addEventHandler("onPlayerLogin", root, loadDrift)
