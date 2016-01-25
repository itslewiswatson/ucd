--[[
GUI = {}

GUI.window = guiCreateWindow(535, 202, 302, 392, "UCD | Trucker - Destinations", false)
GUI.window.sizable = false
GUI.window.visible = false
GUI.window.alpha = 1
exports.UCDutil:centerWindow(GUI.window)

GUI.gridlist = guiCreateGridList(9, 54, 284, 292, false, GUI.window)
guiGridListAddColumn(GUI.gridlist, "Destination", 0.6)
guiGridListAddColumn(GUI.gridlist, "Distance", 0.3)
GUI.button = guiCreateButton(159, 352, 134, 30, "Close", false, GUI.window)
GUI.label = guiCreateLabel(9, 28, 283, 16, "Double click a destination from the list", false, GUI.window)
guiLabelSetHorizontalAlign(GUI.label, "center", false)

function selectHaul()
	local row = guiGridListGetSelectedItem(GUI.gridlist)
	if (row and row ~= -1) then
		local dest = guiGridListGetItemData(GUI.gridlist, row, 1)
		if (dest == prev) then
			exports.UCDdx:new("You're already at that destination", 255, 0, 0)
			return	
		end
		calculateHaul(dest)
		toggleGUI()
	end
end
addEventHandler("onClientGUIDoubleClick", GUI.gridlist, selectHaul, false)

function toggleGUI()
	GUI.window.visible = not GUI.window.visible
	showCursor(GUI.window.visible)
end
addEventHandler("onClientGUIClick", GUI.button, toggleGUI, false)
--]]
