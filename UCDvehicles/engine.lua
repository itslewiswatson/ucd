-- After we make a vehicle fuel system (or if we ever do), we need to add a line in here about vehicle fuel

--[[
function toggleEngine( plr )
	local theVehicle = getPedOccupiedVehicle( plr )
	if ( theVehicle ) and ( isElement( theVehicle ) ) then
		if ( getVehicleController( theVehicle ) == plr ) then
			if ( getVehicleEngineState( theVehicle ) == true ) then
				setVehicleEngineState( theVehicle, false )
			else
				setVehicleEngineState( theVehicle, true )
			end
		else
			return false
		end
	else
		return false
	end
	return true
end
addCommandHandler( "engine", toggleEngine )
--]]

--[[
function toggleEngineState( veh, state )
	if not ( veh ) or not ( state ) then
		return nil
	end
	if ( getElementType( veh ) ~= "vehicle" ) then
		return false
	end
	if ( state ~= true ) or ( state ~= false ) then
		return false
	end
	
	local engineChange = setVehicleEngineState( veh, state )
	if not engineChange then
		return false
	end
	return true
end
--]]

addCommandHandler( "engine",
	function ( plr )
		local veh = getPedOccupiedVehicle( plr )
		if ( isPedInVehicle( plr ) ~= true ) and ( not veh ) and ( not isElement( veh ) ) then
			return false
		else
			if ( getVehicleController( veh ) ) then
				if ( getPedOccupiedVehicleSeat( plr ) ~= 0 ) then
					return false
				else
					if ( getVehicleEngineState( veh ) == true ) then
						engineStateChange = setVehicleEngineState( veh, false )
					else
						engineStateChange = setVehicleEngineState( veh, true )
					end
				end
			else
				return false
			end
		end
		if engineStateChange then
			return true
		else
			return false
		end
	end
)
