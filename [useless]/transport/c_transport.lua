local tansports = {}
local resX, resY = guiGetScreenSize()

addEventHandler( "onClientResourceStart", resourceRoot,
	function ()
		win = guiCreateWindow( 383, 229, 516, 440, "Rapid Transportation System", false )
		guiWindowSetSizable( win, false )
		guiSetAlpha( win, 0.91 )
		guiSetVisible( win, false )
	
		lab1 = guiCreateLabel( 18, 28, 249, 20, "Select a location to be transported to:", false, win )
		guiSetFont( lab1, "clear-normal" )
		
		lab2 = guiCreateLabel( 23, 392, 279, 31, "The cost of travel is dependent on how far you are away from your desired location.", false, win )
		guiLabelSetHorizontalAlign( lab2, "left", true )
	
		butTravel = guiCreateButton( 305, 392, 88, 36, "Travel", false, win )
		guiSetProperty( butTravel, "NormalTextColour", "FFAAFFAA" )
		addEventHandler( "onClientGUIClick", butTravel, travelToDest, false )
	
		butClose = guiCreateButton( 408, 392, 88, 36, "Close", false, win )
		guiSetProperty( butClose, "NormalTextColour", "FFFFAAAA" )
		addEventHandler( "onClientGUIClick", butClose, closeGUI, false )
	end
)

addEvent( "transport.gui", true )
addEventHandler( "transport.gui", root,
	function (locs)
		showCursor( true )
		guiSetVisible( win, true )
	
		grid = guiCreateGridList( 18, 58, 478, 324, false, win )
		guiGridListAddColumn( grid, "Location", 0.65 )
		guiGridListAddColumn( grid, "Cost of Travel", 0.25 )
	
		local money = getPlayerMoney()
	
		for i, loc in ipairs(locs) do
			local row = guiGridListAddRow(grid)
			guiGridListSetItemText( grid, row, 1, loc[1], false, false )
			guiGridListSetItemText( grid, row, 2, "$"..loc[2], false, false )
			if ( loc[2] > money ) then
				guiGridListSetItemColor( grid, row, 2, 255, 0, 0 )
			end
		end
	end
)

function closeGUI()
	showCursor( false )
	destroyElement( grid )
	guiSetVisible( win, false )
end

function travelToDest()
	local destName = guiGridListGetItemText( grid, guiGridListGetSelectedItem( grid ), 1 )
	if ( not destName ) then return end
	triggerServerEvent( "transport.travel", root, destName )
	closeGUI()
end