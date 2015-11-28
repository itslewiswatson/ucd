-- Tables
local streamsTable = {}
local isStreaming = false
local music = false

-- GUI Code
local DENStreamWindow = guiCreateWindow( 618, 250, 319, 306, "MP3/Radio/YouTube Streamer", false )
guiWindowSetSizable( DENStreamWindow, false )
local DENStreamLabel = guiCreateLabel( 10, 23, 293, 16, "Enter a MP3/Radio/YouTube URL or select one:", false, DENStreamWindow )
guiSetFont( DENStreamLabel, "default-bold-small" )
local DENStreamEdit = guiCreateEdit( 9, 41, 300, 22, "", false, DENStreamWindow )
local DENStreamGrid = guiCreateGridList( 10, 67, 297, 201, false, DENStreamWindow )
guiGridListAddColumn( DENStreamGrid, "Station name:", 0.85 )
local DENStreamButton1 = guiCreateButton( 10, 272, 119, 25, "Start", false, DENStreamWindow )
local DENStreamButton2 = guiCreateButton( 134, 272, 119, 25, "Stop", false, DENStreamWindow )
local DENStreamButton3 = guiCreateButton( 256, 272, 52, 25, "Close", false, DENStreamWindow )

local screenW,screenH=guiGetScreenSize()
local windowW,windowH=guiGetSize( DENStreamWindow, false )
local x,y = (screenW-windowW)/2,(screenH-windowH)/2
guiSetPosition( DENStreamWindow, x, y, false )

guiWindowSetMovable ( DENStreamWindow, true )
guiWindowSetSizable ( DENStreamWindow, false )
guiSetVisible ( DENStreamWindow, false )

-- Default Stations
local radioStations = {
	[ "NEG Hitradio" ] = "http://negmta.net:8000/listen.pls",
	[ "Hitradio 181" ] = "http://www.181.fm/winamp.pls?station=181-power&style=mp3&description=Power%20181%20(Top%2040)&file=181-power.pls",
	[ "Hardstyle Nu" ] = "http://listen.hardstyle.nu/listen.pls",
	[ "Hardbase" ] = "http://listen.hardbase.fm/aacplus.pls",
	[ "Slam!FM" ] = "http://82.201.100.23/slamfm.m3u",
	[ "Dance FM" ] = "http://true.nl/streams/dancetunes.asx",
	[ "Best blues" ] = "http://64.62.252.130:9032/listen.pls",
	[ "Classic music" ] = "http://sc1.abacast.com:8220/listen.pls",
	[ "Country" ] = "http://shoutcast.internet-radio.org.uk:10656/listen.pls",
	[ "Electro, dance, house" ] = "http://stream.electroradio.ch:26630/listen.pls",
	[ "90s grunge rock" ] = "http://173.193.14.170:8006/listen.pls",
	[ "Rock, metal and alternative" ] = "http://screlay-dtc0l-1.shoutcast.com:8012/listen.pls",
	[ "60s 70s 80s 90s rock" ] = "http://cp.internet-radio.org.uk:15476/listen.pls",
	[ "Pop, dance, trance" ] = "http://cp.internet-radio.org.uk:15114/listen.pls",
	[ "Psychodelic, Progressive rock" ] = "http://krautrock.pop-stream.de:7592/listen.pls",
	[ "Hip hop, rap, rnb" ] = "http://mp3uplink.duplexfx.com:8054/listen.pls",
	[ "Filth FM" ] = "http://lemon.citrus3.com/castcontrol/playlist.php?id=51&type=pls",
	[ "Reggae and Dancehall music" ] = "http://www.raggakings.net/listen.wax",
	[ "Dirty South FM" ] = "http://www.dirtysouthradioonline.com/broadband-128.asx",
	[ "Smooth Beats" ] = "http://www.smoothbeats.com/hiphop.asx",
	[ "Smooth Jazz" ] = "http://www.1.fm/go/baysmoothjazz128k.asx",
	[ "Rock Web" ] = "http://100xr.redirectme.net/100xr.asx",
	[ "Dubstep" ] = "http://dubstep.fm/listen.pls",
}

-- Put them in the grid
for station, k in pairs( radioStations ) do
	local row = guiGridListAddRow( DENStreamGrid )
	guiGridListSetItemText( DENStreamGrid, row, 1, station, false, false )
end

-- Open the stream window
addEvent( "onClientOpenStreamWindow", true )
addEventHandler( "onClientOpenStreamWindow", root,
	function ()
		if ( guiGetVisible( DENStreamWindow ) ) then
			guiSetVisible( DENStreamWindow, false )
			showCursor( false )
		else
			guiSetVisible( DENStreamWindow, true )
			showCursor( true )
			guiSetInputMode( "no_binds_when_editing" )
		end
	end
)

-- Close button
addEventHandler( "onClientGUIClick", DENStreamButton3,
	function ()
		guiSetVisible( DENStreamWindow, false )
		showCursor( false )
	end, false
)

-- Get stream URL
function getStreamURL ()
	local stationURL = guiGridListGetItemText ( DENStreamGrid, guiGridListGetSelectedItem ( DENStreamGrid ), 1 )
	local row, column = guiGridListGetSelectedItem ( DENStreamGrid )
	if ( stationURL ) and ( tostring( row ) ~= "-1" ) then
		return radioStations[ stationURL ]
	else
		return guiGetText( DENStreamEdit )
	end
end

-- Start button
addEventHandler( "onClientGUIClick", DENStreamButton1,
	function ()
		if ( isStreaming ) then
			outputChatBox( "You are already streaming, stop the first stream first!", 225, 0, 0 )
		elseif ( getStreamURL () == "" ) or ( getStreamURL () == " " ) then
			eoutputChatBox( "Can't start stream, please enter a valid URL", 225, 0, 0 )
		else
			local testSound = playSound ( getStreamURL(), true )
			if ( isElement( testSound ) ) then
				stopSound( testSound )
				isStreaming = true
				triggerServerEvent( "onPlayerStartStreamSound", localPlayer, getStreamURL () )
			else
				outputChatBox( "Can't start stream, please enter a valid URL", 225, 0, 0 )
			end
		end
	end, false
)

-- Stop stream
addEventHandler( "onClientGUIClick", DENStreamButton2,
	function ()
		if ( isStreaming ) then
			triggerServerEvent( "onPlayerStopStreamSound", localPlayer )
			isStreaming = false
		else
			outputChatBox( "You aren't even streaming!", 225, 0, 0 )
		end
	end, false
)

-- Deselect gridlist
addEventHandler( "onClientGUIClick", DENStreamEdit,
	function ()
		guiGridListSetSelectedItem ( DENStreamGrid, 0, 0 )
	end, false
)

-- Start sounds comming in from streamers
addEvent( "onClientPlayerStartStreamSound", true )
addEventHandler( "onClientPlayerStartStreamSound", root,
	function ( soundTable, aPlayer )
		local theSound = playSound3D( soundTable[1], soundTable[2], soundTable[3], soundTable[4], true )
		setSoundVolume( theSound, 1.0 )
		setSoundMaxDistance( theSound, 150 )
		setElementInterior  ( theSound, soundTable[5] )
		setElementDimension ( theSound, soundTable[6] )
		
		if ( soundTable[7] ) and ( isElement( soundTable[7] ) ) then
			attachElements( theSound, soundTable[7] )
		end
		
		streamsTable[ source ] = { theSound, soundTable[1], soundTable[2], soundTable[3], soundTable[4], soundTable[5], soundTable[6], soundTable[7]  }
		guiSetEnabled( DENStreamButton1, true ) guiSetEnabled( DENStreamButton2, true )
		if ( aPlayer == localPlayer ) then
			if not ( theSound ) then
				outputChatBox( "Stream URL seems not to work properly!", 225, 0, 0 )
			end
			isStreaming = true 
		end
	end
)

-- Start streams on join
addEvent( "onClientStartStreamsOnJoin", true )
addEventHandler( "onClientStartStreamsOnJoin", root,
	function ( theTable )
		for thePlayer, soundTable in pairs ( theTable ) do
			if ( soundTable ) then
				local theSound = playSound3D( soundTable[1], soundTable[2], soundTable[3], soundTable[4], true )
				setSoundVolume( theSound, 1.0 )
				setSoundMaxDistance( theSound, 150 )
				setElementInterior  ( theSound, soundTable[5] )
				setElementDimension ( theSound, soundTable[6] )
				
				if ( soundTable[7] ) and ( isElement( soundTable[7] ) ) then
					attachElements( theSound, soundTable[7] )
				end
				
				streamsTable[ thePlayer ] = { theSound, soundTable[1], soundTable[2], soundTable[3], soundTable[4], soundTable[5], soundTable[6], soundTable[7]  }
			end
		end
	end
)

-- Stop stream
addEvent( "onClientPlayerStopStreamSound", true )
addEventHandler( "onClientPlayerStopStreamSound", root,
	function ()
		if ( streamsTable[ source ] ) then
			stopSound( streamsTable[ source ][1] )
			streamsTable[ source ] = false
		end
	end
)

-- When a player quits
addEventHandler( "onClientPlayerQuit", root,
	function ()
		if ( streamsTable[ source ] ) then
			local theTable = streamsTable[ source ]
			stopSound( theTable[1] )
			streamsTable[ source ] = false
		end
	end
)

-- onResourceStart
addEventHandler( "onClientResourceStart", resourceRoot,
	function ()
		triggerServerEvent( "onPlayerAskForStreams", localPlayer )
	end
)

-- Event to restore the buttons
addEvent( "onClientRestoreGUI", true )
addEventHandler( "onClientRestoreGUI", root,
	function ()
		guiSetEnabled( DENStreamButton1, true ) guiSetEnabled( DENStreamButton2, true )
	end
)

-- Server wide stream
addEvent( "onClientOpenStream", true )
addEventHandler( "onClientOpenStream", root,
	function ( arg )
		if ( arg == "stop" ) and ( music ) then
			stopSound( music )
			music = false
			return
		end

		music = playSound( arg )
		setSoundVolume( music, 1.0 )
	end
)