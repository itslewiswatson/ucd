isCursor = false
selectedElement = nil

-- GUI
local UCD = {window = {}, button = {}}
UCD.window[1] = guiCreateWindow(574, 226, 270, 281, "UCD | ", false)
guiWindowSetSizable(UCD.window[1], false)
guiSetVisible(UCD.window[1], false)
--[[
UCD.button[1] = guiCreateButton(23, 37, 220, 55, "Destroy vehicle", false, UCD.window[1])
guiSetProperty(UCD.button[1], "NormalTextColour", "FFAAAAAA")
UCD.button[2] = guiCreateButton(23, 110, 220, 55, "Warp into vehicle", false, UCD.window[1])
guiSetProperty(UCD.button[2], "NormalTextColour", "FFAAAAAA")
UCD.button[3] = guiCreateButton(23, 189, 220, 55, "Find vehicle owner //TBA", false, UCD.window[1])
guiSetProperty(UCD.button[3], "NormalTextColour", "FFAAAAAA")

addEventHandler("onClientGUIClick", guiRoot, destroyVehicle)
addEventHandler("onClientGUIClick", guiRoot, warpIntoVehicle)
addEventHandler("onClientGUIClick", guiRoot, findVehicleOwner)
]]

function playerClick(button, state, _, _, worldX, worldY, worldZ, element)
	if (button == "left") then
		if (state == "down") then
			if (element) then
				if (getElementType(element) == "player") then
					outputDebugString("Clicked on player")
				elseif (getElementType(element) == "vehicle") then
					outputDebugString("Clicked on vehicle")
				end
				selectedElement = element
			end
		end
	end
end

function _showCursor()
	if (isCursor) then
		showCursor(false, true)
		isCursor = false
		removeEventHandler("onClientClick", root, playerClick)
	else
		showCursor(true, true)
		isCursor = true
		addEventHandler("onClientClick", root, playerClick)
	end
end
addCommandHandler("cursor", _showCursor)
bindKey("x", "down", "cursor")

function renderCursorOptions()
	if (not isCursor) then return end
	local sX, sY, wX, wY, wZ = getCursorPosition()
	local oX, oY, oZ = getCameraMatrix()
	local hit, hitX, hitY, hitZ, hitElement = processLineOfSight(oX, oY, oZ, wX, wY, wZ)
	if (hit and hitElement and isElement(hitElement)) then
		if (getElementType(hitElement) == "player") then
			local plrName = getPlayerName(hitElement)
			dxDrawText("Get options of "..plrName, 527, 285, 839, 328, tocolor(255, 255, 255, 255), 1, "bankgothic", "center", "center")
			return
		elseif (getElementType(hitElement) == "vehicle") then
			local vehicleName = getVehicleName(hitElement)
			dxDrawText("Get options of "..vehicleName, 527, 285, 839, 328, tocolor(255, 255, 255, 255), 1, "bankgothic", "center", "center")
			return
		end
	end
	dxDrawText("Click on a vehicle for more options", 527, 285, 839, 328, tocolor(255, 255, 255, 255), 1, "bankgothic", "center", "center")
end
addEventHandler("onClientRender", root, renderCursorOptions)

function destroyVehicle()
	if (source == UCDdveh) then
		destroyElement()
	end
end
function warpIntoVehicle()
	
end
function findVehicleOwner()
	-- To be made
end

function createUI()

end