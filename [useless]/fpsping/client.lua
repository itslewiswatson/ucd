addEventHandler( "onClientRender", root,
    function()
        dxDrawText( "Ping:", 1256, 6, 1281, 22, tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "top", false, false, true, true, false )
        dxDrawText( getPlayerPing( localPlayer ), 1287, 6, 1312, 22, tocolor( 255, 255, 255, 255 ), 1.00, "default-bold", "left", "top", false, true, true, true, false )

        dxDrawText( "FPS:", 1312, 6, 1337, 22, tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "top", false, true, true, true, false )
        dxDrawText( getElementData( localPlayer, "FPS" ), 1341, 6, 1366, 22, tocolor( 255, 255, 255, 255 ), 1.00, "default-bold", "left", "top", false, false, true, false, false )
    end
)

