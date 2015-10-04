function setWaterColour( cmd, r, g, b )
	if not ( r ) then outputChatBox( "You must enter 3 numbers between 0 and 255" ) return end
	setWaterColor( tonumber( r ), tonumber( g ), tonumber( b ) )
	outputChatBox( "You changed the water colour to: "..r..", "..g..", "..b.."" )
end
addCommandHandler( "water", setWaterColour )

function setWeatherToNumber( cmd, id )
	if not id then outputChatBox( "You must enter a number" ) return end
	setWeather( tonumber( id ) )
	outputChatBox( "Weather changed to: "..id.."" )
end
addCommandHandler( "weather", setWeatherToNumber )

function setClientTime( cmd, newTime )
    newTime = tonumber( newTime )
    if not newTime then outputChatBox( "Enter a number between 0 and 23" ) return end
    if ( newTime > 23 ) or ( newTime < 0 ) then
        outputChatBox( "You must enter a number between 0 and 23." )
        return
    end
    setTime( tonumber( newTime ), 0 )
end
addCommandHandler( "settime", setClientTime )

function movePlayerHead()
	for k, players in ipairs ( getElementsByType( "player" ) ) do
		local w, h = guiGetScreenSize()
		local lookatX, lookatY, lookatZ = getWorldFromScreenPosition( w/2, h/2, 10 )
		setPedLookAt( players, lookatX, lookatY, lookatZ )
	end
end
addEventHandler( "onClientRender", root, movePlayerHead )

-----------------------------------------

local fire = {
	{ 2647.1387, -2073.24, 48.2891, 10 },
	{ 2658.652, -2073.24, 48.289, 10 },
	{ 2671.5938, -2073.24, 48.2891, 10 }
}

function burn()
	for i, v in ipairs( fire ) do
	createFire( v[1], v[2], v[3], v[4] )
	end
end
--setTimer( burn, 1000, 0 )