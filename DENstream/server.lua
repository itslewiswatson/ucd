-- Tables
local streamsTable = {}
local streamSpeaker = {}

-- When a staff wants to open the stream
addCommandHandler( "stream",
    function ( thePlayer )
        if (exports.UCDadmin:isPlayerOwner(thePlayer)) then
            triggerClientEvent( thePlayer, "onClientOpenStreamWindow", thePlayer )
        end
    end
)

-- When a sounds start
addEvent( "onPlayerStartStreamSound", true )
addEventHandler( "onPlayerStartStreamSound", root,
    function ( theSound )
        local x, y, z = getElementPosition( client )
        local interior, dimension = getElementInterior( client ), getElementDimension( client )
        local theVehicle = getPedOccupiedVehicle ( client )
        streamsTable[ client ] = { theSound, x, y, z, interior, dimension, theVehicle }
        triggerClientEvent( root, "onClientPlayerStartStreamSound", client, streamsTable[ client ] )
        
        setElementPosition( client, x, y, z+1 )
        streamSpeaker[ client ] = createObject( 2229, x, y, z-1 )
        setElementRotation( streamSpeaker[ client ], 0, 0, getPedRotation( client ) )
        setElementInterior( streamSpeaker[ client ], interior )
        setElementDimension( streamSpeaker[ client ], dimension )
        if ( getPedOccupiedVehicle( client ) ) then
            attachElements( streamSpeaker[ client ], getPedOccupiedVehicle( client ), 0.3, -2.5, -0.5 )
        end
    end
)

-- When a sound stops
addEvent( "onPlayerStopStreamSound", true )
addEventHandler( "onPlayerStopStreamSound", root,
    function ()
        if ( streamSpeaker[ client ] ) then
            destroyElement( streamSpeaker[ client ] )
            streamSpeaker[ client ] = false
        end
        streamsTable[ client ] = false
        triggerClientEvent( root, "onClientPlayerStopStreamSound", client )
    end
)

-- when a player connects
addEvent( "onPlayerAskForStreams", true )
addEventHandler( "onPlayerAskForStreams", root,
    function ()
        -- if ( #streamsTable > 0 ) then
            triggerClientEvent( client, "onClientStartStreamsOnJoin", client, streamsTable )
        -- end
    end
)

-- When a player quits
addEventHandler( "onPlayerQuit", root,
    function ()
        if ( streamsTable[ source ] ) and ( streamSpeaker[ source ] ) then
            destroyElement( streamSpeaker[ source ] )
            streamsTable[ source ] = false
            streamSpeaker[ source ] = false
        end
    end
)

-- Stream to server
addCommandHandler( "sstream",
    function ( thePlayer, _, arg )
        if not ( arg ) or not ( exports.USGaccounts:getPlayerAccount( thePlayer ) == "union" ) then return end

        for i, k in ipairs ( getElementsByType( "player" ) ) do
            triggerClientEvent( k, "onClientOpenStream", k, arg )
        end
    end
)