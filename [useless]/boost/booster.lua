function getElementSpeed( element, unit )
	if ( unit == nil ) then unit = 0 end
	if ( isElement(element ) ) then
		local x,y,z = getElementVelocity( element )
		if ( unit == "mph" or unit == 1 or unit == "1" ) then
			return ( x ^ 2 + y ^ 2 + z ^ 2 ) ^ 0.5 * 100
		else
			return ( x ^ 2 + y ^ 2 + z ^ 2 ) ^ 0.5 * 1.61 * 100
		end
	else
		return false
	end
end

function setElementSpeed( element, unit, speed )
	if ( unit == nil ) then unit = 0 end
	if ( speed == nil ) then speed = 0 end
	speed = tonumber( speed )
	local acSpeed = getElementSpeed( element, unit )
	if ( acSpeed ~= false ) then
		local diff = speed / acSpeed
		local x,y,z = getElementVelocity( element )
		setElementVelocity( element, x * diff, y * diff, z * diff )
		return true
	end
	return false
end

addEventHandler( "onClientKey", root,
	function ( button, press )
		if ( getPlayerTeam( localPlayer ) == getTeamFromName( "Admins" ) ) then
			if (not localPlayer.vehicle or localPlayer.vehicle.controller ~= localPlayer) then return end
			theVehicle = getPedOccupiedVehicle( localPlayer )
			getspeed = getElementSpeed( theVehicle, 2 )
			if ( button == "mouse_wheel_up" ) and ( theVehicle ) and ( isPedInVehicle( localPlayer ) ) and not ( getspeed == 0 ) then
				setElementSpeed( theVehicle, 2, getspeed + 55)
			elseif ( button == "mouse_wheel_down" ) and ( theVehicle ) and ( isPedInVehicle( localPlayer ) ) and not (getspeed == 0) then
				setElementSpeed( theVehicle, 2, getspeed - 55 )
			end
		end
	end
)