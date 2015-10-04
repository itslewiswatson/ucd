addEvent( "ss", true )
addEventHandler( "ss", resourceRoot,
	function ( pixels )
		if image then
			destroyElement( image )
		end
		image = dxCreateTexture( pixels )
		destroyTimer = setTimer( function () image = nil end, 15000, 1 )
	end
)

addEventHandler( "onClientRender", root,
	function ()
		local sX, sY = guiGetScreenSize()
		local nX, nY = 1366, 768
		if image then
			if ( isTimer( destroyTimer ) ) then
				rem, execsRem, totalExec = getTimerDetails( destroyTimer )
				dxDrawImage( ( 200 / nX ) * sX, ( 30 / nY ) * sY, ( 1024 / nX ) * sX, ( 700 / nY ) * sY, image )
				dxDrawText( "Time remaining: "..exports.UCDmisc:mathround( rem / 1000, 2 ), 1028, 689, 1174, 729, tocolor( 255, 255, 255, 255 ), 1.5, "default", "center", "top", false, false, true )
			end
		end
	end
)

