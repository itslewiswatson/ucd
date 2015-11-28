-- Event that plays the sound for nearby players
addEvent( "onClientPlayJihadSound", true )
addEventHandler( "onClientPlayJihadSound", root,
	function ( theTerrorist )
		local x, y, z = getElementPosition( theTerrorist )
		local sound = playSound3D( "akbar.mp3", x, y, z )
		setSoundVolume( sound, 1.0 )
		setSoundMaxDistance ( sound, 40 )
		attachElements( sound, theTerrorist )
	end
)