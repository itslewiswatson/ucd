
--[[function scanForTag( old, new )
	local disallowedTag = "nga"
	if type( string.find( string.lower( new ), disallowedTag, 1, true ) ) == "number" then
		if not ( hasObjectPermissionTo( source, "function.kickPlayer" ) ) then
			exports.dx:new( source, "You are not a staff, you cannot use the administrator tag.", 255, 0, 0 )
			setPlayerName( source, old )
			cancelEvent()
		end
	end
end
addEventHandler( "onPlayerChangeNick", root, scanForTag )]]

local adminSerials = {
	["7784D1745F2D9DD06DD223333311BEB4"] = true, -- Noki
	
}

