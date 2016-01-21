function doCriminal(plr)
	if (not plr) then
		return
	end
	if (plr.vehicle) then
		exports.UCDdx:new(plr, "You can't become a criminal while in a vehicle", 255, 0, 0)
		return
	end
	if (exports.UCDteams:isPlayerInTeam(plr, "Criminals")) then
		return
	end
	if (exports.UCDmafiaWars:isElementInLV(plr) and exports.UCDteams:isPlayerInTeam(plr, "Gangsters")) then
		return
	end
	exports.UCDjobs:setPlayerJob(plr, "Criminal")
end
addCommandHandler("criminal", doCriminal, false, false)

function makeGangster()
	if (exports.UCDteams:isPlayerInTeam(source, "Criminals")) then
		exports.UCDjobs:setPlayerJob(source, "Gangster")
	end
end
addEvent("onPlayerEnterLV")
addEventHandler("onPlayerEnterLV", root, makeGangster)
addEvent("onPlayerTakeJob")
addEventHandler("onPlayerTakeJob", root, makeGangster)

function removeGangster()
	if (exports.UCDteams:isPlayerInTeam(source, "Gangsters")) then
		exports.UCDjobs:setPlayerJob(source, "Criminal")
	end
end
addEvent("onPlayerLeaveLV")
addEventHandler("onPlayerLeaveLV", root, removeGangster)
