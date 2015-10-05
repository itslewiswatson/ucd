function fixAdminVeh( client )
	local theVehicle = getPedOccupiedVehicle( client )
	if not theVehicle then return end
	if ( getTeamName( getPlayerTeam( client ) ) ~= "Admins" ) then return end
	
	local vehicleHealth = getElementHealth( theVehicle ) / 10
	if ( vehicleHealth ~= 100 ) then
		fixVehicle( theVehicle )
		exports.UCDdx:new( client, "Your "..getVehicleName( theVehicle ).." has been fixed", 255, 255, 0 )
	else
		exports.UCDdx:new( client, "Your "..getVehicleName( theVehicle ).." is at full health", 255, 255, 0 )
	end
end
addCommandHandler("fix", fixAdminVeh)

addEvent( "staff.invis", true)
addEventHandler( "staff.invis", root,
	function ()
		setElementAlpha( client, 0 )
	end
)

addEvent( "staff.visible", true)
addEventHandler( "staff.visible", root,
	function ()
		setElementAlpha( client, 255 )
	end
)
