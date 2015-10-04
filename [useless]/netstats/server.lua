addEvent( "getIP", true )
addEventHandler( "getIP", root,
	function ( playerIP )
		local playerIP = getPlayerIP( client )
		local playerIP = tostring( playerIP )
		triggerClientEvent( source, "ipAddress", source, playerIP )
	end
)

