function setPlayerWalkingStyle(plr, id)
	if (not plr) then return nil end
	if (plr.type ~= "player" or tonumber(id) == nil) then return false end
	plr:setWalkingStyle(id)
	exports.UCDaccounts:SAD(plr, "walkstyle", id)
	
	return true
end
