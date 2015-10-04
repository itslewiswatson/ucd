function centerWindow( center_window )
    local screenW, screenH = guiGetScreenSize()
    local windowW, windowH = guiGetSize( center_window, false )
    local x, y = ( screenW - windowW ) /2, ( screenH - windowH ) / 2
    guiSetPosition( center_window, x, y, false )
end

local resourceWindow = guiCreateWindow( 352, 112, 562, 488, "Resource Manager GUI", false )
local resourceGrid = guiCreateGridList( 198, 41, 338, 412, false, resourceWindow )
local resourceStart = guiCreateButton( 20, 41, 146, 47, "Start", false, resourceWindow )
local resourceRestart = guiCreateButton( 20, 111, 146, 47, "Restart", false, resourceWindow )
local resourceStop = guiCreateButton( 20, 188, 146, 47, "Stop", false, resourceWindow )
local resourceMove = guiCreateButton( 20, 258, 146, 47, "Move", false, resourceWindow )
local resourceClose = guiCreateButton( 20, 406, 146, 47, "Close GUI", false, resourceWindow )
local resourceRefresh = guiCreateButton( 20, 331, 146, 47, "Refresh", false, resourceWindow )
guiWindowSetMovable( resourceWindow, true )
guiWindowSetSizable( resourceWindow, false )
guiSetVisible( resourceWindow, false)
centerWindow( resourceWindow )
guiGridListAddColumn( resourceGrid, "Resource:", 0.9 )

-- Get the selected resource
function getSelectedResourceName ()
	local resourceName = guiGridListGetItemText( resourceGrid, guiGridListGetSelectedItem( resourceGrid ), 1 )
	local row, column = guiGridListGetSelectedItem( resourceGrid )
	if ( resourceName ) and ( tostring( row ) ~= "-1" ) then
		return resourceName, row
	end
end

-- Event handler for buttons
addEventHandler( "onClientGUIClick", root,
	function ()
		local resource, rowid = getSelectedResourceName()
		if ( source == resourceClose ) then
			guiSetVisible( resourceWindow, false )
			showCursor( false )
			closeConfirmMoveGUI()
		elseif ( source == resourceStart ) and ( resource ) then
			triggerServerEvent( "onUpdateResourceState", localPlayer, "start", resource, rowid )
		elseif ( source == resourceRestart ) and ( resource ) then
			triggerServerEvent("onUpdateResourceState", localPlayer, "restart", resource, rowid )
		elseif ( source == resourceStop ) and ( resource ) then
			triggerServerEvent("onUpdateResourceState", localPlayer, "stop", resource, rowid )
		elseif ( source == resourceMove ) and ( resource ) then
			openConfirmMove( resource )
		elseif ( source == resourceRefresh ) then
			triggerServerEvent( "refresh", localPlayer )
		end
	end
)

local confirmMoveGUI = {}
local confirmMoveResource

function openConfirmMove(resource)
	guiSetEnabled(resourceGrid, false)
	if (isElement(confirmMoveGUI.window)) then
		destroyElement(confirmMoveGUI.window)
	end
	confirmMoveGUI.window = guiCreateWindow(0, 0, 400, 205,"Move "..resource, false, false)
	confirmMoveGUI.label = guiCreateLabel(10,10,390,100, "Are you sure that you want to move '"..resource.."'? \n If so, enter the new path.", false, confirmMoveGUI.window)
	guiLabelSetVerticalAlign(confirmMoveGUI.label,"center")
	guiLabelSetHorizontalAlign(confirmMoveGUI.label,"center")
	confirmMoveGUI.edit = guiCreateEdit(0,110,400,50, "",false,confirmMoveGUI.window)
	confirmMoveGUI.cancel = guiCreateButton(25,165,150,40, "Cancel",false,confirmMoveGUI.window)
	confirmMoveGUI.confirm = guiCreateButton(225,165,150,40, "Confirm",false,confirmMoveGUI.window)
	exports.misc:centerWindow( confirmMoveGUI.window )
	confirmMoveResource = resource
	
	addEventHandler( "onClientGUIClick", confirmMoveGUI.cancel, closeConfirmMoveGUI, false )
	addEventHandler( "onClientGUIClick", confirmMoveGUI.confirm, confirmMove, false )
end

function confirmMove()
	local newDir = guiGetText( confirmMoveGUI.edit )
	triggerServerEvent( "onMoveResource", localPlayer, confirmMoveResource, newDir )
	closeConfirmMoveGUI()
end

function closeConfirmMoveGUI()
	if ( isElement( confirmMoveGUI.window ) ) then
		destroyElement( confirmMoveGUI.window )
	end
	confirmMoveResource = nil
	guiSetEnabled( resourceGrid, true )
end

-- Put the resources in the grid
addEvent( "onOpenResourcesWindow", true )
addEventHandler( "onOpenResourcesWindow", root,
	function ( theTable )
		if ( not guiGetVisible( resourceWindow ) ) then
			guiGridListClear( resourceGrid )
			for i=1, #theTable do
				local row = guiGridListAddRow( resourceGrid )
				if ( theTable[i][2] == "running" ) or ( theTable[i][2] == "starting" ) then
					guiGridListSetItemText( resourceGrid, row, 1, theTable[i][1], false, false )
					guiGridListSetItemColor( resourceGrid, row, 1, 0, 225, 0 )
				else
					guiGridListSetItemText( resourceGrid, row, 1, theTable[i][1], false, false )
					guiGridListSetItemColor( resourceGrid, row, 1, 225, 0, 0 )
				end
			end
			guiSetVisible( resourceWindow, true )
			showCursor( true )
		else
			guiSetVisible( resourceWindow, false )
			showCursor( false )
			closeConfirmMoveGUI()
		end
	end
)

-- Update row color
addEvent( "setResourceColor", true )
addEventHandler( "setResourceColor", root,
	function ( row, R, G, B )
		guiGridListSetItemColor( resourceGrid, row, 1, R, G, B )
	end
)
