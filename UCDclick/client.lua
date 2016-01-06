nX, nY = guiGetScreenSize()
isCursor = false
selectedElement = nil

-- GUI
local UCDclick = {window = {}, button = {}}

UCDclick.window[1] = guiCreateWindow(722, 359, 457, 407, "UCD | Options", false)
UCDclick.window[1].sizeable = false
UCDclick.window[1].visible = false
-- 1st row
UCDclick.button[1] = guiCreateButton(10, 27, 139, 21, "", false, UCDclick.window[1])
UCDclick.button[3] = guiCreateButton(159, 27, 139, 21, "", false, UCDclick.window[1])
UCDclick.button[4] = guiCreateButton(308, 27, 139, 21, "", false, UCDclick.window[1])
-- 2nd row
UCDclick.button[5] = guiCreateButton(10, 58, 139, 21, "", false, UCDclick.window[1])
UCDclick.button[6] = guiCreateButton(159, 58, 139, 21, "", false, UCDclick.window[1])
UCDclick.button[7] = guiCreateButton(308, 58, 139, 21, "", false, UCDclick.window[1])
close_ = guiCreateButton(10, 371, 437, 26, "Close", false, UCDclick.window[1])


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

function playerClick(button, state, _, _, worldX, worldY, worldZ, element)
	if (button == "left" and state == "down") then
		if (element) then
			if (getElementType(element) == "player") then
				outputDebugString("Clicked on player")
			elseif (getElementType(element) == "vehicle") then
				if (element:getOccupant(0)) then
					outputDebugString("Clicked on player in vehicle")
				else
					outputDebugString("Clicked on vehicle")
				end
			end
			selectedElement = element
		end
	end
end

function renderCursorOptions()
	if (not isCursor) then return end
	local sX, sY, wX, wY, wZ = getCursorPosition()
	local oX, oY, oZ = getCameraMatrix()
	local hit, hitX, hitY, hitZ, hitElement = processLineOfSight(oX, oY, oZ, wX, wY, wZ)
	if (hit and hitElement and isElement(hitElement)) then
		if (hitElement.type == "player") then 
			drawText("Get options of "..hitElement.name)
			return
		elseif (hitElement.type == "vehicle") then
			if (hitElement:getOccupant(0)) then
				drawText("Get options of "..hitElement:getOccupant(0).name)
			else
				drawText("Get options of this "..hitElement.name)
			end
			return
		elseif (hitElement.type == "object") then
			drawText("No options currently available")
			return
		end
	end
	drawText("Click on a yourself, a player, an object or a vehicle for options")
end
addEventHandler("onClientRender", root, renderCursorOptions)

function drawText(text)
	dxDrawText(tostring(text), 0, 203, nX, nY / 4, tocolor(255, 255, 255, 255), 2, "default", "center", "center", false, false, false, false, false)
end
