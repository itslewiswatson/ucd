local GUI = {}
local _data
local _marker

GUI.window = guiCreateWindow(819, 448, 259, 256, "UCD | Jobs - Vehicles", false)
GUI.window.sizeable = false
GUI.window.visible = false
GUI.gridlist = guiCreateGridList(9, 26, 240, 182, false, GUI.window)
guiGridListSetSortingEnabled(GUI.gridlist, false)
guiGridListAddColumn(GUI.gridlist, "Vehicle", 0.9)
GUI.spawn = guiCreateButton(9, 214, 114, 31, "Spawn", false, GUI.window)
GUI.close = guiCreateButton(135, 214, 114, 31, "Close", false, GUI.window)

function onClickSpawn()
	local row = guiGridListGetSelectedItem(GUI.gridlist)
	if (row and row ~= -1) then
		local vehicleModel = getVehicleModelFromName(guiGridListGetItemText(GUI.gridlist, row, 1))
		local rot = _data[2]
		triggerServerEvent("UCDjobVehicles.createFromMarker", localPlayer, vehicleModel, rot, _marker)
		toggleGUI()
	else
		exports.UCDdx:new("You need to select a vehicle from the list", 255, 0, 0)
	end
end
addEventHandler("onClientGUIClick", GUI.spawn, onClickSpawn, false)

function toggleGUI()
	GUI.window.visible = not GUI.window.visible
	if (GUI.window.visible) then
		showCursor(true, true)
		--localPlayer.frozen = true
		GUI.window.text = "UCD | "..source:getData("Occupation").." - Vehicles"
	else
		showCursor(false, false)
		--localPlayer.frozen = false
		GUI.window.text = "UCD | Jobs - Vehicles"
	end
end
addEventHandler("onClientGUIClick", GUI.close, toggleGUI, false)

function toggleSpawner(data, marker)
	if (source and source.type == "player" and source == localPlayer) then
		guiGridListClear(GUI.gridlist)
		toggleGUI()
		_data = data
		_marker = marker
		if (data and type(data) == "table") then
			for _, v in ipairs(data[3]) do
				local row = guiGridListAddRow(GUI.gridlist)
				guiGridListSetItemText(GUI.gridlist, row, 1, tostring(getVehicleNameFromModel(v)), false, false)
			end
		end
 	end
end
addEvent("UCDjobVehicles.toggleSpawner", true)
addEventHandler("UCDjobVehicles.toggleSpawner", root, toggleSpawner)
