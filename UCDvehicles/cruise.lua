lastState = false

function cruiseOff()
	if isCruise then
		removeEventHandler( "onClientRender", root, cruiseOn )
		theCruiseTimer = nil
		setControlState ( "accelerate", false )
		setControlState ( "brake_reverse", false )
		isCruise = false
		exports.dx:new( "You are no longer cruising", 60, 200, 70 )
	end
end

function toggleControl()
	lastState = not lastState
	setControlState ( "accelerate", lastState )	
end

function cruiseOn()
	local player = getLocalPlayer()
	theCar1 = getPedOccupiedVehicle( player )
	if ( theCar1 ) then
		--if ( getVehicleEngineState( theCar1 ) == false ) then exports.dx:new( "You can't cruise while your engine is turned off", 60, 200, 70 ) return end
		local x1, y1, z1 = getElementVelocity( theCar1 )
		local speed1 = ( ( x1^2 + y1^2 + z1^2 ) ^0.5 ) * 161
		if ( speed1 < speed ) then
			if not lastState then
				toggleControl()
			end
		elseif ( speed1 > speed ) then
			if lastState then
				toggleControl()
			end
		end
	else
		cruiseOff()
	end
end

function cruiseControl()
	if cruiseState then
		local theCar = getPedOccupiedVehicle( getLocalPlayer( ) )
		if theCar and isElement( theCar ) and not isCruise then
			--if ( getVehicleEngineState( theCar ) == false ) then exports.dx:new( "You can't cruise while your engine is turned off", 60, 200, 70 ) return end
			local x, y, z = getElementVelocity( theCar )
			speed = ( ( x^2 + y^2 + z^ 2 )^0.5 ) * 161
			isCruise = true
			addEventHandler( "onClientRender", root, cruiseOn )
			exports.dx:new( "You are now cruising", 60, 200, 70 )
		else
			cruiseOff()
		end
	end
end
bindKey( "c", "down", cruiseControl )

addEventHandler( "onClientVehicleEnter", getRootElement(), 
	function( player, seat )
		if player == getLocalPlayer() and seat == 0 then
			cruiseState = 1
		end
	end
)

addEventHandler( "onClientVehicleExit", getRootElement(), 
	function ( player )
		if player == getLocalPlayer() then
		cruiseState = nil
		if cruiseHandler then removeEventHandler( "onClientRender", getRootElement(), cruiseControlTarget )	cruiseHandler = nil end
		cruiseOff()
		end
	end
)

addEventHandler( "onClientPlayerWasted", getRootElement(), 
	function()
		if source == getLocalPlayer() then
			cruiseState = nil
			if cruiseHandler then removeEventHandler( "onClientRender", getRootElement(), cruiseControlTarget )	cruiseHandler = nil end
			cruiseOff()
		end
	end
)

function cruiseControlTarget()
	if isCruise then
		cruiseOff()
		if cruiseHandler then removeEventHandler( "onClientRender", getRootElement(), cruiseControlTarget )	cruiseHandler = nil end
	end
end
bindKey( "brake_reverse", "down", cruiseControlTarget )