function SAMarkerHit()
	if isPedInVehicle( localPlayer ) then return end
	if not isPedOnGround( localPlayer ) then return end
	showCursor( true )
	guiSetVisible( spawnWindow, true )
	SAgridlist()
end


function LAMarkerHit()
	if isPedInVehicle( localPlayer ) then return end
	if not isPedOnGround( localPlayer ) then return end
	showCursor( true )
	guiSetVisible( spawnWindow, true )
	LAgridlist()
end

-----------------------

smallAircraftMarkerTable = {
	{ 1984.7, -2315, 12.5, 90 }, -- LS
	{ -1246.2402, -96.1916, 13, 135 }, -- SF
	{ -1203.1144, -139.7044, 13, 135 }, -- SF
	{ 398.5202, 2504.7639, 15.4, 90 }, -- Abandoned
	{ 1609.2321, 1630.1877, 9.8, 180 }, -- LV
	{ 1677.542, 1630.18, 9.8, 180 }, -- LV
}

largeAircraftMarkerTable = {
	{  2112.5559, -2440.1431, 12.5, 180 }, -- LS
	{ -1337.278, -222.3104, 13, 315 }, -- SF
	{ -1657.6539, -165.1116, 13, 135 }, -- SF runway
}

for i, v in pairs ( smallAircraftMarkerTable ) do
	smallAircraftMarkers = createMarker( v[1], v[2], v[3], "cylinder", 2, 255, 255, 0 , 125 )
	addEventHandler( "onClientMarkerHit", smallAircraftMarkers, SAMarkerHit )
	SAspawnRotation = v[4]
end

for i, v in pairs ( largeAircraftMarkerTable ) do
	largeAircraftMarkers = createMarker( v[1], v[2], v[3], "cylinder", 2, 255, 255, 0, 125 )
	addEventHandler( "onClientMarkerHit", largeAircraftMarkers, LAMarkerHit )
	LAspawnRotation = v[4]
end

smallAircraftID = { 
	{ "Beagle", 511 }, 
	{ "Cropduster", 512 }, 
	{ "Dodo", 593 }, 
	{ "Rustler", 476 }, 
	{ "Stuntplane", 513 }, 
	{ "Shamal", 519 },
}

largeAircraftID = {
	{ "AT-400", 577 },
	{ "Andromada", 592 },
	{ "Nevada", 553 },
}

spawnWindow = guiCreateWindow( 553, 179, 278, 336, "", false )
guiWindowSetSizable( spawnWindow, false )
guiSetVisible( spawnWindow, false )

spawnBtn = guiCreateButton( 19, 287, 108, 39, "Spawn", false, spawnWindow )
closeBtn = guiCreateButton( 150, 287, 108, 39, "Close", false, spawnWindow )
spawnGridlist = guiCreateGridList( 19, 31, 239, 246, false, spawnWindow )
spawnColumn = guiGridListAddColumn( spawnGridlist, "Aircraft", 0.9 )    

function SAgridlist()
	guiSetText( spawnWindow, "Small Aircraft Spawn" )
	guiGridListClear( spawnGridlist )
	for i, v in pairs ( smallAircraftID ) do
		local row = guiGridListAddRow( spawnGridlist )
		if row ~= nil and row ~= false and row ~= -1 then
			guiGridListSetItemText( spawnGridlist, row, spawnColumn, v[1], false, false )
			guiGridListSetItemData( spawnGridlist, row, spawnColumn, v[2] )
		end
	end
end

function LAgridlist()
	guiSetText( spawnWindow, "Large Aircraft Spawn" )
	guiGridListClear( spawnGridlist )
	for i, v in pairs ( largeAircraftID ) do
		local row = guiGridListAddRow( spawnGridlist )
		if row ~= nil and row ~= false and row ~= -1 then
			guiGridListSetItemText( spawnGridlist, row, spawnColumn, v[1], false, false )
			guiGridListSetItemData( spawnGridlist, row, spawnColumn, v[2] )
		end
	end
end

addEventHandler( "onClientGUIClick", guiRoot,
	function ()
		if ( source == spawnBtn ) then
			local row = guiGridListGetSelectedItem( spawnGridlist )
			if row ~= nil and row ~= false and row ~= -1 then
				local vehID = guiGridListGetItemData( spawnGridlist, row, spawnColumn )
				if ( guiGetText( spawnWindow ) == "Small Aircraft Spawn" ) then
					triggerServerEvent( "spawnAircraft", localPlayer, vehID, SAspawnRotation )
					guiSetVisible( spawnWindow, false )
					showCursor( false )
				elseif ( guiGetText( spawnWindow ) == "Large Aircraft Spawn" ) then
					triggerServerEvent( "spawnAircraft", localPlayer, vehID, LAspawnRotation )
					guiSetVisible( spawnWindow, false )
					showCursor( false )
				else
					exports.dx:new( "Something went wrong!", 255, 255, 0 )
				end
			else
				exports.dx:new( "You did not select a vehicle from the list", 255, 255, 0 )
			end
		elseif ( source == closeBtn ) then
			guiSetVisible( spawnWindow, false )
			showCursor( false )
		end
	end
)
