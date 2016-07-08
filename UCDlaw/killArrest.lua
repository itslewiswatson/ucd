-- Kill arrest
addEventHandler("onPlayerWasted", root,
	function (_, killer)
		if (source.wantedLevel > 0 and exports.UCDwanted:getWantedPoints(source) > 0) then
			if (killer and killer ~= source and killer.type == "player") then
				if (killer.team.name == "Law") then
					if (source.inWater or source.wantedLevel >= 3) then
						arrest(source, killer, true) -- Kill arrest
					elseif (source.wantedLevel < 3) then
						exports.UCDdx:new(killer, "You can only kill arrest players with 3+ stars or players in water", 255, 0, 0)
					end
				end
			end
		end
	end
)
