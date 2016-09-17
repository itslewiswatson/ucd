local spam = {}
local police = Team.getFromName("Law")
local admins = Team.getFromName("Admins")

function crime(attacker, killer, _, loss)
    local criminal
	if (not exports.UCDmafiaWars:isElementInLV(source)) then
		if (isElement(attacker)) then
			if (attacker.type == "player") then
				if (attacker.team ~= police and source.team == police) then
					criminal = attacker
				end
			elseif (attacker.type == "vehicle") then
				if (attacker.occupant and attacker.occupant.team ~= police and source.team == police) then
					criminal = attacker.occupant
				end    
			end
		elseif (isElement(killer)) then
			if (killer.type == "player") then
				if killer.team ~= police and source.team == police then
					criminal = killer
				end
			elseif (killer.type == "vehicle") then
				if (killer.occupant and killer.occupant.team ~= police and source.team == police) then
					criminal = killer.occupant
				end
			end
		end
		if (criminal and criminal.team ~= admins) then
			if (eventName == "onPlayerWasted") then
				exports.UCDwanted:addWantedPoints(criminal, 30)
			else
				if (not spam[criminal] or spam[criminal] and getTickCount() - spam[criminal] > 5000) then
					loss = (loss < 5 and 5) or math.ceil(loss / 3)
					exports.UCDwanted:addWantedPoints(criminal, loss)
					spam[criminal] = getTickCount()
				end
			end
		end
	end
end
addEventHandler("onPlayerDamage", root, crime)
addEventHandler("onPlayerWasted", root, crime)
