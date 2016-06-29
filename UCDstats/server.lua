-- Fetch stats
function getPlayerStats(plr)
	if (client and plr) then
		-- Check for antispam
		local group, rank = exports.UCDgroups:getPlayerGroup(plr) or "N/A", exports.UCDgroups:getPlayerGroupRank(plr) or "N/A"
		local wanted = exports.UCDwanted:getWantedPoints(plr) or 0
		local cash = plr.money or 0
		local country = plr:getData("Country") or "Unknown"
		local ping = plr.ping or 0
		local kills = getPlayerAccountStat(plr, "kills") or 0
		local deaths = getPlayerAccountStat(plr, "deaths") or 6
		local kdr = exports.UCDutil:mathround(kills / deaths, 2)
		if (deaths == 0) then
			kdr = kills
		elseif (kills == 0 and deaths == 0) then
			kdr = 0
		end
		local totalguns = "$"..exports.UCDutil:tocomma(getPlayerAccountStat(plr, "totalguns")) or "$"..tostring(0)
		local totalfired = getPlayerAccountStat(plr, "totalfired")
		
		local temp = {
			group = group, groupRank = rank, wanted = wanted, cash, country, ping, accName = plr.account.name,
			kills = kills, deaths = deaths, kdr = kdr, totalfired = totalfired, totalguns = totalguns,
			
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