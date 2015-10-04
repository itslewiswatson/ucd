addEvent( "rekt", true )
addEventHandler( "rekt", root, 
	function ( skinID )
		setElementModel( client, skinID )
		setPlayerTeam( client, getTeamFromName( "Aviators" ) )
		setElementData( client, "Occupation", "Pilot" )
		setElementData( client, "Class", "Junior Pilot" )
		exports.dx:new( client, "You are now a pilot!", 255, 255, 0 )
	end
)
