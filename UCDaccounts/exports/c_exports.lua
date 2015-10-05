function isPlayerLoggedIn(plr)
	local plr = plr or localPlayer
	local loggedIn = plr:getData("isLoggedIn")
	if (not loggedIn) then
		return false
	end
	return true
end

