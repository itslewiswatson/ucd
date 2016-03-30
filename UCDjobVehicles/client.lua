local GUI = {}
local _data
local _marker
local spawnerData = {}

GUI.window = guiCreateWindow(819, 448, 259, 256, "UCD | Jobs - Vehicles", false)
GUI.window.sizeable = false
GUI.window.visible = false
GUI.window.alpha = 255
exports.UCDutil:centerWindow(GUI.window)
GUI.gridlist = guiCreateGridList(9, 26, 240, 182, false, GUI.window)
guiGridListSetSortingEnabled(GUI.gridlist, false)
guiGridListAddColumn(GUI.gridlist, "Vehicle", 0.9)
GUI.spawn = guiCreateButton(9, 214, 114, 31, "Spawn", false, GUI.window)
GUI.close = guiCreateButton(135, 214, 114, 31, "Close", false, GUI.window)

-- Create markers
function init()
	if (not jobVehicles or type(jobVehicles) ~= "table") then
		outputDebugString("No table to loop through")
		--init()
		return
	end
	for _, info in ipairs(jobVehicles) do
		local mkr = Marker(info.x, info.y, info.z - 1, "cylinder", 2, info.colour.r, info.colour.g, info.colour.b, 200)
		spawnerData[mkr] = {info.vt, info.rot, info.vehs}
		addEventHandler("onClientMarkerHit", mkr, markerHit)
		addEventHandler("onClientMarkerLeave", mkr, removeText)
	end
end
addEventHandler("onClientResourceStart", resourceRoot, init)

function markerHit(ele, matchingDimension)
	if (ele and ele.type == "player" and not ele.vehicle and matchingDimension and ele == localPlayer) then
		if (ele.position.z - 1.5 < source.position.z and ele.position.z + 1.5 > source.position.z) then
			if (spawnerData[source]) then
				_mkr = source
				bindKey("z", "down", onHitZ)
				exports.UCDdx:add("vehiclespawn", "Press Z: Spawn Vehicle", 255, 255, 0)
			end
		end
	end
end

function removeText()
	unbindKey("z", "down", onHitZ)
	exports.UCDdx:del("vehiclespawn")
end

function onHitZ()
	markerOpen(_mkr)
	_mkr = nil
	removeText()
end

function markerOpen(mkr)
	local job = localPlayer:getData("Occupation")
	local isAbleTo
	if (not job) then return end
	outputDebugString(tostring(#spawnerData[mkr][1]))
	if (#spawnerData[mkr][1] == 0) then
		isAbleTo = true
	else
		for i, v in ipairs(spawnerData[mkr][1] or {}) do
			if (job == v or localPlayer.team.name == v) then
				isAbleTo = true
				break
			end
		end
	end
	if (isAbleTo) then
		--triggerClientEvent(ele, "UCDjobVehicles.toggleSpawner", ele, spawnerData[source], source)
		triggerEvent("UCDjobVehicles.toggleSpawner", localPlayer, spawnerData[mkr], mkr)
	else
		exports.UCDdx:new("You are not allowed to use this spawner", 255, 255, 0)
	end
end

function onClickSpawn()
	local row = guiGridListGetSelectedItem(GUI.gridlist)
	if (row and row ~= -1) then
		local vehicleModel = getVehicleModelFromName(guiGridListGetItemText(GUI.gridlist, row, 1))
		local rot = _data[2]
		triggerServerEvent("UCDjobVehicles.createFromMarker", resourceRoot, vehicleModel, rot, {x = _marker.position.x, y = _marker.position.y, z = _marker.position.z}) -- Workaround until vectors can be passed as parameters
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
		GUI.window.text = "UCD | "..localPlayer:getData("Occupation").." - Vehicles"
		if (#spawnerData[_marker][1] == 0) then
			GUI.window.text = "UCD | Complimentary Vehicles"
		end
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
		_data = data
		_marker = marker
		toggleGUI()
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
