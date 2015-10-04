addEvent( "spawnAircraft", true )
addEventHandler( "spawnAircraft", root,
	function ( vehID, LAspawnRotation, SAspawnRotation )
		if ( LAspawnRotation ) then
			local pX, pY, pZ = getElementPosition( client )
			local vehicle = createVehicle( vehID, pX, pY, pZ + 1, 0, 0, LAspawnRotation )
			warpPedIntoVehicle( client, vehicle )
		end
		if ( SAspawnRotation ) then
			local pX, pY, pZ = getElementPosition( client )
			local vehicle = createVehicle( vehID, pX, pY, pZ + 1, 0, 0, SAspawnRotation )
			warpPedIntoVehicle( client, vehicle )
		end
	end
)
	