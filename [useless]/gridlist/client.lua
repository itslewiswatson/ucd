local tTable = {
	{"NiP"},
	{"LDLC"},
	{"fnatic"},
}

window = guiCreateWindow( 540, 311, 473, 391, "", false )
guiWindowSetSizable( window, false )
guiSetVisible( window, false )
list = guiCreateGridList( 86, 42, 329, 334, false, window )
guiGridListAddColumn( list, "rekt", 0.9 )    
	
function updateGridList()
	for k, player in pairs( getElementsByType( "player" ) ) do
		local row = guiGridListAddRow( list )
		guiGridListSetItemText( list, row, 1, getPlayerName( player ), false, false )
		--guiGridListSetItemData( list, row, 1, v[1] )
	end
end

addCommandHandler( "rekt",
	function ()
		--exports.misc:guiBlendElement( window, 0.8 )
		guiSetVisible( window, true )
		updateGridList()
	end
)
