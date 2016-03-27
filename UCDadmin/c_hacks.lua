function disableAdministratorDamage(attacker, weapon, bodypart, loss)
	if (source.team) then
		if (attacker and attacker.type == "ped") then return end
		if (source.team.name == "Admins" and source.model == 217 or source.model == 211) then
			cancelEvent()
		end
	end
end
addEventHandler("onClientPlayerDamage", root, disableAdministratorDamage, true, "high")
