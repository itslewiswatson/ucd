-- After we make a vehicle fuel system (or if we ever do), we need to add a line in here about vehicle fuel

addCommandHandler( "engine",
	function (plr)
		local veh = getPedOccupiedVehicle(plr)
		if (not isPedInVehicle(plr) or not veh or not isElement(veh)) then
			return false
		else
			if (getVehicleController(veh) == plr and getPedOccupiedVehicleSeat(plr) == 0) then
				setVehicleEngineState(veh, not getVehicleEngineState(veh))
			end
		end
	end
)
