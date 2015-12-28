jobUI = {
    gridlist = {},
    window = {},
    button = {},
	column = {},
}  

validSkinID = {
	{ "Male Pilot", 61 },
	{ "Female Pilot", 20 }, -- make one
}

jobUI.window[1] = guiCreateWindow( 537, 144, 309, 460, "Pilot Job", false )
guiWindowSetSizable( jobUI.window[1], false )
guiSetVisible( jobUI.window[1], false )

jobUI.button[1] = guiCreateButton( 19, 392, 126, 56, "Take Job", false, jobUI.window[1] )
jobUI.button[2] = guiCreateButton( 168, 392, 126, 56, "Close", false, jobUI.window[1] )
jobUI.gridlist[1] = guiCreateGridList( 17, 264, 277, 118, false, jobUI.window[1] )
jobUI.column[1] = guiGridListAddColumn( jobUI.gridlist[1], "Skin", 0.7 )
jobUI.column[2] = guiGridListAddColumn( jobUI.gridlist[1], "ID", 0.2 )

function fillGridList()
	guiGridListClear( jobUI.gridlist[1] )
	for i, v in pairs ( validSkinID ) do
		local row = guiGridListAddRow( jobUI.gridlist[1] )
		if row ~= nil and row ~= false and row ~= -1 then
			guiGridListSetItemText( jobUI.gridlist[1], row, jobUI.column[1], v[1], false, false ) 
			guiGridListSetItemText( jobUI.gridlist[1], row, jobUI.column[2], tostring( v[2] ), false, false )
			
			guiGridListSetItemData( jobUI.gridlist[1], row, jobUI.column[1], v[2] )
			guiGridListSetItemData( jobUI.gridlist[1], row, jobUI.column[2], v[2] )
		end
	end
end

function showUI()
	guiSetVisible( jobUI.window[1], true )
	showCursor( true )
	fillGridList()
end

function manageButtons()
	if ( source == jobUI.button[1] ) then
		local row = guiGridListGetSelectedItem( jobUI.gridlist[1] )
		if row ~= nil and row ~= false and row ~= -1 then
			local skinID = guiGridListGetItemData( jobUI.gridlist[1], row, jobUI.column[1] )
			if ( skinID ) then
				triggerServerEvent( "rekt", localPlayer, skinID )
				--setElementModel( localPlayer, skinID )
				guiSetVisible( jobUI.window[1], false )
				showCursor( false )
			end
		else
			exports.dx:new( "You must select a skin", 255, 0, 0 )
		end
	elseif ( source == jobUI.button[2] ) then
		guiSetVisible( jobUI.window[1], false )
		showCursor( false )
	end
end
addEventHandler( "onClientGUIClick", guiRoot, manageButtons )

--------------------------

jobMarkers = {
	{ 1325.7433, 1617.3845, 9.8 }, -- LV
	{ -1242.964, 20.1757, 13.15 }, -- SF
	{ 1448.7687, -2287.3276, 12.45 }, -- LS
}

function open()
	if ( isPedInVehicle( localPlayer ) ) then return end
	if ( isPedOnGround( localPlayer ) ~= true ) then return end
	showUI()
end

for k, v in pairs ( jobMarkers ) do
	markers = createMarker( v[1], v[2], v[3], "cylinder", 2, 255, 255, 0, 125 )
	addEventHandler( "onClientMarkerHit", markers, open )
	createBlipAttachedTo( markers, 56, 2, 0, 0, 0, 0, 0, 300 )
end