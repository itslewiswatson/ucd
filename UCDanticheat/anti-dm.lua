
function onPlayerDamage(attacker, weapon, bodypart, loss)
	if (source.team and source.team.name == "Admins") then
		cancelEvent()
		return
	end
	
	if (exports.UCDsafeZones:isElementWithinSafeZone(source)) then
		if (source:getWantedLevel() ~= 0) then
			if (attacker ~= nil) then
				return
			end
		end
		cancelEvent()
		return
	end
	
	if (not exports.UCDmafiaWars:isElementInLV(source)) then
		if (attacker) then
			if (attacker.type == "vehicle") then
				if (not attacker.controller) then
					cancelEvent()
					return
				else
					if (attacker.controller.team.name == "Law" and source.team.name == "Criminals") then
						if (source:getWantedLevel() == 0) then
							cancelEvent()
							return
						end
					elseif (attacker.controller.team.name == "Law" and (source.team.name == "Citizens" or source.team.name == "Unoccupied" or source.team.name == "Law")) then
						cancelEvent()
						return
					elseif (attacker.controller.team.name == "Criminals" and (source.team.name == "Citizens" or source.team.name == "Unoccupied" or source.team.name == "Criminals")) then
						cancelEvent()
						return
					elseif (attacker.controller.team.name == "Unoccupied" or attacker.controller.team.name == "Citizens") then
						cancelEvent()
						return
					end
				end
			elseif (attacker.type == "player") then
				if (attacker == source) then
					return
				end
				if (attacker.team.name == "Law" and source.team.name == "Criminals") then
					if (source:getWantedLevel() == 0) then
						cancelEvent()
						return
					end
				elseif (attacker.team.name == "Law" and (source.team.name == "Citizens" or source.team.name == "Unoccupied" or source.team.name == "Law")) then
					cancelEvent()
					return
				elseif (attacker.team.name == "Criminals" and (source.team.name == "Citizens" or source.team.name == "Unoccupied" or source.team.name == "Criminals")) then
					cancelEvent()
					return
				elseif (attacker.team.name == "Unoccupied" or attacker.team.name == "Citizens") then
					cancelEvent()
					return
				end
			end
		end
	else
		-- They are in LV, but admins and safe zones have already been accounted for
		-- It's every man, woman and child for themselves in LV
	end
end
addEventHandler("onClientPlayerDamage", root, onPlayerDamage)

function onVehicleDamage(attacker, weapon, loss)
	
end
addEventHandler("onClientVehicleDamage", root, onVehicleDamage)
