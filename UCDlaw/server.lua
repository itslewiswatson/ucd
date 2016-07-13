local hits = {} -- Table of nightstick hits on certain criminals
local hitTimers = {} -- Table of timers for nightstick hits on certain criminals and when the hits are to be removed
local arrests = {} -- Table of players arrested by a certain cop, all of whom are pending jail

-- Handle giving nightstick
function onPlayerGetJob(jobName)
	if (source.team.name == "Law") then
		if (jobName == "Traffic Officer") then
			-- Camera
			if (source:getWeapon(9) ~= 43 or (source:getWeapon(9) == 43 and source:getTotalAmmo(9) < 9000)) then
				giveWeapon(source, 43, 9000)
			end
		end
		if (source:getWeapon(1) ~= 3 or (source:getWeapon(1) == 3 and source:getTotalAmmo(1) < 1)) then
			giveWeapon(source, 3, 1)
		end
		return
	end
	if (source:getWeapon(1) == 3) then
		takeWeapon(source, 3)
	end
	if (source:getWeapon(9) == 43) then
		takeWeapon(source, 9)
	end
end
addEvent("onPlayerGetJob")
addEventHandler("onPlayerGetJob", root, onPlayerGetJob)

function getPlayerArrests(plr)
	if (arrests[plr]) then
		return arrests[plr]
	end
	return {}
end

function releasePlayerOn()
	if (#getPlayerArrests(source) == 0) then
		return
	end
	for _, plr in ipairs(getPlayerArrests(source)) do
		releasePlayer(plr)
	end
end
addEvent("onPlayerGetJob")
addEventHandler("onPlayerGetJob", root, releasePlayerOn)
addEventHandler("onPlayerQuit", root, releasePlayerOn)
addEventHandler("onPlayerWasted", root, releasePlayerOn)

function isAbleToArrest(cop, plr)
	if (exports.UCDwanted:getWantedPoints(plr) > 0 and cop.team.name == "Law" and not isPlayerArrested(plr)) then
		return true
	end
	return false
end

function calculatePayment(wp)
	return math.random((wp * 150) - 50, (wp * 150) + 200)
end

function takeHit(cop, plr)
	if (not hits[plr] or not hits[plr][cop] or hits[plr][cop] == 0) then
		hitTimers[cop][source]:destroy()
		hitTimers[cop][source] = nil
		return
	end
	hits[plr][cop] = hits[plr][cop] - 1
	
	triggerClientEvent(plr, "UCDlaw.displayHits", plr, cop, hits[plr][cop], 2)
	triggerClientEvent(cop, "UCDlaw.displayHits", cop, plr, hits[plr][cop], 2)
end

function onHit(attacker, weapon, _, loss)
	if (attacker and attacker.type == "player" and weapon == 3) then
		--if (exports.UCDwanted:getWantedPoints(source) > 1 and attacker.team.name == "Law" and not isPlayerArrested(source)) then
		if (isAbleToArrest(attacker, source)) then
			
			if (exports.UCDbankrob:isPlayerInBank(source) or exports.UCDbankrob:isPlayerInBank(attacker)) then
				return false
			end
		
			-- If they haven't been hit yet
			if (not hits[source]) then
				hits[source] = {}
			end
			-- If they haven't been hit by this person yet
			if (not hits[source][attacker]) then
				hits[source][attacker] = 0
			end
			
			if (not hitTimers[attacker]) then
				hitTimers[attacker] = {}
			end
			if (not hitTimers[attacker][source]) then
				hitTimers[attacker][source] = Timer(takeHit, 5000, 1, attacker, source)
			end
			
			-- Add another hit
			hits[source][attacker] = hits[source][attacker] + 1
			
			if (source.armor > 0) then
				if (source.armor - loss < 0) then
					source.health = source.health + math.abs(source.armor - loss)
					source.armor = source.armor + loss
				else
					source.armor = source.armor + loss
				end
			else
				source.health = source.health + loss
			end
			
			triggerClientEvent(source, "UCDlaw.displayHits", source, attacker, hits[source][attacker], 2)
			triggerClientEvent(attacker, "UCDlaw.displayHits", attacker, source, hits[source][attacker], 2)
			
			-- If they have two hits, we have an arrest
			if (hits[source][attacker] == 2) then
				arrestPlayer(source, attacker)
				triggerClientEvent(attacker, "UCDlaw.displayHits", attacker, source, "remove")
				return
			end
		end
	end
end
addEventHandler("onPlayerDamage", root, onHit)

function carArrest(vehicle, _, plr)
	if (plr and plr.type == "player") then
		if (isAbleToArrest(source, plr)) then
			arrestPlayer(plr, source)
		end
	end
end
addEventHandler("onPlayerVehicleEnter", root, carArrest)

function releasePlayer(plr, hide)
	plr:removeData("arrested")
	setPedAnimation(plr)
	showCursor(plr, false)
	toggleAllControls(plr, true, true, false)
	
	for c, a in pairs(arrests) do
		for k, v in ipairs(a) do
			if (plr == v) then
				table.remove(arrests[c], k)
				break
			end
		end
	end
	
	setControlState(plr, "sprint", false)
	setControlState(plr, "walk", false)
	setControlState(plr, "forwards", false)
	
	triggerClientEvent(plr, "UCDlaw.displayArrested", plr, "remove")
	if (hide == true) then
		return true
	end
	exports.UCDdx:new(plr, "You have been released", 30, 144, 255)
	return true
end

function arrestPlayer(plr, cop)
	if (not arrests[cop]) then
		arrests[cop] = {}
	end
	table.insert(arrests[cop], plr)
	triggerEvent("onPlayerArrested", plr, cop)
	return true
end

function onPlayerArrested(cop)
	triggerClientEvent(cop, "UCDlaw.createPDMarkers", cop)
	
	if (hitTimers[cop][source] and isTimer(hitTimers[cop][source])) then
		hitTimers[cop][source]:destroy()
		hitTimers[cop][source] = nil
	end
	hits[source] = {}
	
	source:setData("arrested", true)
	if (cop.vehicle) then
		if (cop.vehicle:getOccupants()[1]) then
			cop.vehicle:getOccupants()[1]:removeFromVehicle(cop.vehicle)
			exports.UCDdx:new(cop.vehicle:getOccupants()[1], "You have been ejected as the driver has been arrested", 255, 0, 0)
		end
		source:warpIntoVehicle(cop.vehicle, 1)
	end
	
	exports.UCDdx:new(cop, "You have arrested "..source.name..", escort them to the nearest PD", 30, 144, 255)
	toggleAllControls(source, false, true, false)
	setCameraTarget(source, source)
	triggerClientEvent(source, "UCDlaw.displayArrested", source, cop)
	showCursor(source, true, true)
	followArrestor(source, cop)
end
addEvent("onPlayerArrested")
addEventHandler("onPlayerArrested", root, onPlayerArrested)

function onFinishEscorting()
	if (client) then
		if (not getPlayerArrests(client) or #getPlayerArrests(client) == 0) then
			return false
		end
		for _, plr in ipairs(getPlayerArrests(client)) do
			arrest(plr, client)
		end
		triggerClientEvent(client, "UCDlaw.destroyPDMarkers", client)
	end
end
addEvent("UCDlaw.onFinishEscorting", true)
addEventHandler("UCDlaw.onFinishEscorting", root, onFinishEscorting)

function arrest(plr, cop, killArrest)
	local wp = exports.UCDwanted:getWantedPoints(plr)
	local payment = calculatePayment(wp)
	local duration = wp * plr.wantedLevel
	duration = duration - math.floor(duration / 4)
	
	cop.money = cop.money + payment
	exports.UCDdx:new(cop, "You "..tostring(killArrest and "kill " or "").."arrested "..tostring(plr.name).." for "..tostring(exports.UCDutil:tocomma(duration)).." seconds and earned $"..tostring(exports.UCDutil:tocomma(payment)).." and "..tostring(wp).." AP", 30, 144, 255)
	
	exports.UCDjail:jailPlayer(plr, duration, false)
	exports.UCDwanted:setWantedPoints(plr, 0)
	releasePlayer(plr, true)
	
	-- plr stats
	exports.UCDstats:setPlayerAccountStat(plr, "timesArrested", exports.UCDstats:getPlayerAccountStat(plr, "timesArrested") + 1)
	-- cop stats
	exports.UCDstats:setPlayerAccountStat(cop, "AP", exports.UCDstats:getPlayerAccountStat(cop, "AP") + wp)
	exports.UCDstats:setPlayerAccountStat(cop, "arrests", exports.UCDstats:getPlayerAccountStat(cop, "arrests") + 1)
	if (killArrest) then
		exports.UCDstats:setPlayerAccountStat(cop, "killArrests", exports.UCDstats:getPlayerAccountStat(cop, "killArrests") + 1)
	end	
end

function isPlayerArrested(plr)
	for cop, a in pairs(arrests) do
		for _, v in ipairs(a) do
			if (plr == v) then
				return true, cop
			end
		end
	end
	return false
end

function releaseCommand(cop, _, name)
	if (cop.team.name ~= "Law") then
		return false
	end
	if (not getPlayerArrests(cop) or #getPlayerArrests(cop) == 0) then
		exports.UCDdx:new(cop, "You don't have anyone in your custody at this moment", 255, 0, 0)
		return false
	end
	
	local releasedAll
	if (name == "*") then
		for _, p in ipairs(arrests[cop]) do
			releasePlayer(p)
		end
		exports.UCDdx:new(cop, "You have released all criminals in your custody", 30, 144, 255)
		releasedAll = true
	end
	
	if (not releasedAll) then
		local plr = exports.UCDutil:getPlayerFromPartialName(name)
		for i, p in ipairs(arrests[cop]) do
			if (p == plr) then
				exports.UCDdx:new(cop, "You have released "..plr.name, 30, 144, 255)
				releasePlayer(plr)
				break
			end
		end
	end
	
	outputDebugString("release -> "..tostring(#getPlayerArrests(cop)))
	if (not getPlayerArrests(cop) or #getPlayerArrests(cop) == 0) then
		triggerClientEvent(cop, "UCDlaw.destroyPDMarkers", cop)
	end
	
	return true
end
addCommandHandler("release", releaseCommand)

addEventHandler("onResourceStop", resourceRoot,
	function ()
		for _, plr in ipairs(Element.getAllByType("player")) do
			if (isPlayerArrested(plr)) then
				releasePlayer(plr)
			end
		end
	end
)

function forceArrest()
	local arrested, cop = isPlayerArrested(source)
	if (arrested) then
		arrest(source, cop)
	end
end
addEventHandler("onPlayerQuit", root, forceArrest, true, "high")

