local GUI_antispam = {}

local vehicles = 
{
	["large"] = {592, 577, 553, 519},
	["small"] = {511, 512, 593, 513},
}

local pilot = 
{
    gridlist = {},
    window = {},
    button = {},
	column = {},
}

function GUI_open(marker)
	pilot.window[1] = guiCreateWindow(795, 464, 269, 357, "", false)
	guiWindowSetSizable(pilot.window[1], false)

	pilot.button[1] = guiCreateButton(10, 299, 118, 47, "Spawn vehicle", false, pilot.window[1])
	guiSetProperty(pilot.button[1], "NormalTextColour", "FFAAAAAA")
	pilot.button[2] = guiCreateButton(138, 299, 118, 47, "Exit", false, pilot.window[1])
	guiSetProperty(pilot.button[2], "NormalTextColour", "FFAAAAAA")
	pilot.gridlist[1] = guiCreateGridList(10, 28, 246, 261, false, pilot.window[1])
	pilot.column[1] = guiGridListAddColumn(pilot.gridlist[1], "Vehicle", 0.9)
	
	for markerType, vehicleIDs in pairs(vehicles) do
		-- If the markerType of the ped's marker is either small or large (so we don't create small in large vice versa)
		if (getElementData(marker, "pilot.markerType") == markerType) then
			for _, vehicleID in pairs(vehicleIDs) do
				local row = guiGridListAddRow(pilot.gridlist[1])
				guiGridListSetItemText(pilot.gridlist[1], row, pilot.column[1], getVehicleNameFromID(vehicleID), false, false)
				guiGridListSetItemData(pilot.gridlist[1], row, pilot.column[1], vehicleID)
			end
		end
	end
	
	showCursor(not isCursorShowing())
end

function GUI_close()
	if (isElement(pilot.window[1])) and (isCursorShowing()) then
		destroyElement(pilot.window[1])
		showCursor(false)
	end
end

function GUI_input(button)
	if (button == "left") then
		if (GUI_antispam[localPlayer]) then
			outputDebugString("stop spamming nigger")
			return false
		end
		if (source == pilot.button[2]) then
			GUI_close()
		elseif (source == pilot.button[1]) then
			local row = guiGridListGetSelectedItem(pilot.gridlist[1])
			if row ~= nil and row ~= false and row ~= -1 then
				local id = guiGridListGetItemData(pilot.gridlist[1], row, pilot.column[1])
				outputDebugString("Spawning vehicleID "..id)
				
				
			end
		else
			return false
		end
		return true
	end
end
addEventHandler("onClientGUIClick", guiRoot, GUI_input)
