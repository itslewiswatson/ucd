function listHacks()
	if ( getTeamName( getPlayerTeam( localPlayer ) ) ~= "Admins" ) then return end
	outputChatBox( "Hack commands:" )
	outputChatBox( "   dmgproof - makes your current occupied vehicle damage proof" )
	outputChatBox( "   invis - makes your player model invisible" )
	outputChatBox( "   fix - repairs your current occupied vehicle" )
end
addCommandHandler( "hacks", listHacks )

function disableAdministratorDamage( attacker, weapon, bodypart, loss )
	if ( getPlayerTeam( source ) ) then
		if ( attacker ) and ( getElementType( attacker ) == "ped" ) then return end
		if ( getTeamName( getPlayerTeam( source ) ) == "Admins" ) and ( getElementModel( source ) == 217 or 211 ) then
			cancelEvent()
		end
	end
end
addEventHandler( "onClientPlayerDamage", root, disableAdministratorDamage )

addCommandHandler( "dmgproof",
	function ()
		local theVehicle = getPedOccupiedVehicle( localPlayer )
		if ( not theVehicle ) then return end
		if ( getTeamName( getPlayerTeam( localPlayer ) ) ~= "Admins" ) then return end
		if ( isVehicleDamageProof( theVehicle ) ~= true ) then
			setVehicleDamageProof( theVehicle, true ) 
			exports.dx:new( "Disabled damage for your "..getVehicleName( theVehicle ).."", 255, 255, 0 )
		else
			exports.dx:new( "Your "..getVehicleName( theVehicle ).." is already damage proof!", 255, 255, 0 )
			exports.dx:new( "Re-enter if you want it to not be damage proof", 255, 255, 0 )
		end
	end
)

addCommandHandler( "invis",
	function ()
		if ( getTeamName( getPlayerTeam( localPlayer ) ) ~= "Admins" ) then return end
		if ( getElementAlpha( localPlayer ) == 0 ) then
			triggerServerEvent( "staff.visible", localPlayer )
		else
			triggerServerEvent( "staff.invis", localPlayer )
			exports.UCDdx:new( "You are now invisible", 0, 255, 0 )
		end
	end
)

addEventHandler( "onClientVehicleExit", root,
	function ( thePlayer, seat )
		local thePlayer = localPlayer
		if ( getTeamName( getPlayerTeam( thePlayer ) ) ~= "Admins" ) then return end
		if ( seat ~= 0 ) then return end
		if ( isVehicleDamageProof( source ) ) then
			setVehicleDamageProof( source, false )
			exports.UCDdx:new( "Your "..getVehicleName( source ).." is no longer damage proof", 255, 255, 0 )
		end
	end
)

addCommandHandler( "flip",
	function ()
		if ( getTeamName( getPlayerTeam( localPlayer ) ) ~= "Admins" ) then return end	
		local vehicle = getPedOccupiedVehicle( localPlayer )
		if vehicle then
			local rX, rY, rZ = getElementRotation( vehicle )
			setElementRotation( vehicle, 0, 0, ( rX > 90 and rX < 270 ) and ( rZ + 180 ) or rZ )
		end
	end
)
