-- Fetch stats
function getPlayerStats(plr)
	if (client and plr) then
		if (not exports.UCDaccounts:isPlayerLoggedIn(plr)) then
			exports.UCDdx:new(client, "This player is not logged in - you can't view their stats", 255, 0, 0)
			return
		end
		-- Check for antispam
		local group, rank = exports.UCDgroups:getPlayerGroup(plr) or "N/A", exports.UCDgroups:getPlayerGroupRank(plr) or "N/A"
		local wanted = exports.UCDwanted:getWantedPoints(plr) or 0
		local cash = plr.money or 0
		local country = plr:getData("Country") or "Unknown"
		local ping = plr.ping or 0
		local wl = plr.wantedLevel or 0
		local kills = getPlayerAccountStat(plr, "kills") or 0
		local deaths = getPlayerAccountStat(plr, "deaths") or 6
		local kdr = kills / deaths
		if (deaths == 0) then
			kdr = kills
		elseif (kills == 0 and deaths == 0) then
			kdr = 0
		end
		local totalguns = "$"..exports.UCDutil:tocomma(getPlayerAccountStat(plr, "totalguns")) or "$"..tostring(0)
		local totalfired = getPlayerAccountStat(plr, "totalfired")
		local ap = getPlayerAccountStat(plr, "AP") or 0
		local arrests = getPlayerAccountStat(plr, "arrests") or 0
		local timesArrested = getPlayerAccountStat(plr, "timesArrested") or 0
		local lifetimeWanted = getPlayerAccountStat(plr, "lifetimeWanted") or 0
		local killArrests = getPlayerAccountStat(plr, "killArrests") or 0
		local housesRobbed = getPlayerAccountStat(plr, "housesRobbed") or 0
		local bestDrift = getPlayerAccountStat(plr, "bestDrift") or 0
		local totalDrift = getPlayerAccountStat(plr, "totalDrift") or 0
		local successBR = getPlayerAccountStat(plr, "successBR") or 0
		local attemptBR = getPlayerAccountStat(plr, "attemptBR") or 0
		
		local temp = {
			group = group, groupRank = rank, wanted = wanted, cash, country, ping, accName = plr.account.name,
			kills = kills, deaths = deaths, kdr = kdr, totalfired = totalfired, totalguns = totalguns, wl = wl,
			ap = ap, arrests = arrests,	timesArrested = timesArrested, lifetimeWanted = lifetimeWanted,
			killArrests = killArrests, housesRobbed = housesRobbed, bestDrift = bestDrift, totalDrift = totalDrift,
			attemptBR = attemptBR, successBR = successBR,
		}
		triggerLatentClientEvent(client, "UCDstats.loadStats", plr, temp or {})
	end
end
addEvent("UCDstats.getPlayerStats", true)
addEventHandler("UCDstats.getPlayerStats", root, getPlayerStats)

-- Set stats
addEventHandler("onPlayerWasted", root,
	function (_, killer)
		if (exports.UCDaccounts:isPlayerLoggedIn(source)) then
			
			setPlayerAccountStat(source, "deaths", getPlayerAccountStat(source, "deaths") + 1)
			
			if (killer) then
				if (killer.type == "vehicle" and killer.controller) then
					setPlayerAccountStat(killer.controller, "kills", getPlayerAccountStat(killer.controller, "kills") + 1)
					return
				end
				if (isElement(killer) and killer.type == "player") then
					if (killer == source) then
						return
					end
					setPlayerAccountStat(killer, "kills", getPlayerAccountStat(killer, "kills") + 1)
				end
			end
		end
	end
)

addEvent("UCDstats.addBulletCount", true)
addEventHandler("UCDstats.addBulletCount", root,
	function (count)
		setPlayerAccountStat(client, "totalfired", getPlayerAccountStat(client, "totalfired") + count)
	end
)