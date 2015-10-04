function spawnVehicleFromID( thePlayer, cmd, id )
	id = tonumber(id)
	if not ( id ) then outputChatBox( "Enter a valid vehicle number between 400 and 612!", thePlayer ) return end
	if ( id < 400) or ( id > 611 ) then outputChatBox( "Enter a valid vehicle number between 400 and 612!", thePlayer ) return end
	if ( id > 399) and ( id < 612 ) then
		x, y, z = getElementPosition( thePlayer )
		createdVehicle = createVehicle( id, x, y, z )
		warpPedIntoVehicle( thePlayer, createdVehicle, 0 )
	end
end
addCommandHandler( "veh", spawnVehicleFromID )
