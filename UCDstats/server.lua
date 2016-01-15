-- Fetch stats
function getPlayerStats(plr)
	if (client and plr) then
		-- Check for antispam
		local group, rank = exports.UCDgroups:getPlayerGroup(plr) or "N/A", exports.UCDgroups:getPlayerGroupRank(plr) or "N/A"
		local wanted = 0
		local cash = plr.money or 0
		local country = plr:getData("Country") or "Unknown"
		local ping = plr.ping or 0
		local temp = {
			group = group, groupRank = rank, wanted, cash, country, ping
		}
		triggerLatentClientEvent(client, "UCDstats.loadStats", plr, temp or {})
	end
end
addEvent("UCDstats.getPlayerStats", true)
addEventHandler("UCDstats.getPlayerStats", root, getPlayerStats)

-- Set stats
addEventHandler("onPlayerWasted", root,
	function (_, killer)
		if (killer.type == "vehicle" and killer.controller) then
		end
		if (isElement(killer) and killer.type == "player") then
			if (killer == source) then
				
				return
			end
		end
	end
)
