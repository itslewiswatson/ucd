function centerWindow(center_window)
	outputDebugString("[UCDmisc] "..sourceResource.name.." is using the centerWindow export. Use UCDutil instead.")
    local screenW, screenH = guiGetScreenSize()
    local windowW, windowH = guiGetSize(center_window, false)
    local x, y = (screenW - windowW) /2, (screenH - windowH) / 2
    guiSetPosition(center_window, x, y, false)
end

function isPlayerLoggedIn(plr)
	outputDebugString("[UCDmisc] "..sourceResource.name.." is using the isPlayerLoggedIn [client] export. Use UCDaccounts instead.")
	local plr = plr or localPlayer
	local loggedIn = plr:getData("isLoggedIn")
	if (not loggedIn) then
		return false
	end
	return true
end