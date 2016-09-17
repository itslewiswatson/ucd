local nX, nY = guiGetScreenSize()
local isCursor = false
local selectedElement = nil

function createGUI()
	window = GuiWindow(532, 628, 308, 107, "UCD | Mechanic Authentication", false)
	window.sizable = false
	--window.visible = false
	window.alpha = 1
	window:setPosition(nX / 2 - (308 / 2), nY - 107 - 15, false)

	label = GuiLabel(10, 27, 288, 21, "...", false, window)
	guiLabelSetHorizontalAlign(label, "center", false)
	accept = GuiButton(10, 58, 138, 37, "Accept", false, window)
	decline = GuiButton(160, 58, 138, 37, "Decline", false, window)
	showCursor(true)
end

function destroyGUI()
	window:destroy()
	showCursor(false)
	_mechanic = nil
	_vehicle = nil
end

function addJobHelp()
	exports.UCDdx:add("mechanichelp", "Press X and click on a vehicle to repair it", 255, 215, 0)
end
function removeJobHelp()
	exports.UCDdx:del("mechanichelp")
end

addEvent("onClientPlayerGetJob", true)
addEventHandler("onClientPlayerGetJob", root,
	function (jobName)
		if (jobName == "Mechanic") then
			addJobHelp()
		else
			removeJobHelp()
		end
	end
)

addEventHandler("onClientResourceStart", resourceRoot,
	function ()
		if (localPlayer:getData("Occupation") == "Mechanic") then
			addJobHelp()
		else
			removeJobHelp()
		end
	end	
)

addEvent("onClientPlayerLogin", true)
addEventHandler("onClientPlayerLogin", localPlayer,
	function ()
		Timer(
			function ()
				if (localPlayer:getData("Occupation") == "Mechanic") then
					addJobHelp()
				else
					removeJobHelp()
				end
			end, 2500, 1
		)
	end
)

function _showCursor()
	--if (localPlayer.name ~= "[UCD]Noki") then
	--	return
	--end
	if (localPlayer.team.name ~= "Citizens" or localPlayer:getData("Occupation") ~= "Mechanic") then
		return
	end
	if (isCursor) then
		showCursor(false, true)
		isCursor = false
		removeEventHandler("onClientClick", root, vehicleClick)
	else
		showCursor(true, true)
		isCursor = true
		addEventHandler("onClientClick", root, vehicleClick)
	end
end
addCommandHandler("cursor", _showCursor)
bindKey("x", "down", "cursor")

function vehicleClick(button, state, _, _, worldX, worldY, worldZ, element)
	if (button == "left" and state == "down") then
		if (element) then
			if (element.type == "vehicle") then
				_showCursor()
				local dist = Vector3(element.position - localPlayer.position):getLength()
				if (dist > 5) then
					exports.UCDdx:new("This vehicle is too far away to be repaired - move closer", 255, 0, 0)
					return
				end
				local owner
				if (element:getData("owner")) then
					owner = Player(element:getData("owner"))
					if (not owner) then
						exports.UCDdx:new("This vehicle's owner is not online", 255, 0, 0)
						return
					end				
				end
				if (#element.occupants >= 1 or element.controller) then
					exports.UCDdx:new("The vehicle you want to repair must have no occupants", 255, 0, 0)
					return
				end
				-- Start repair
				triggerServerEvent("UCDmechanic.requestRepair", resourceRoot, element, owner)
			end
			selectedElement = element

		end
	end
end

function renderCursorOptions()
	if (not isCursor) then return end
	local sX, sY, wX, wY, wZ = getCursorPosition()
	local oX, oY, oZ = getCameraMatrix()
	if (sX and sY and wX and wY and wZ and oX and oY and oZ) then
		local hit, hitX, hitY, hitZ, hitElement = processLineOfSight(oX, oY, oZ, wX, wY, wZ)
		if (hit and hitElement and isElement(hitElement)) then
			if (hitElement.type == "vehicle") then
				--if (hitElement:getOccupant(0)) then
				--	drawText("Get options of "..hitElement:getOccupant(0).name.."'s vehicle")
				--else
					drawText("Repair this "..hitElement.name)
				--end
				return
			end
		end
		drawText("Click on a nearby vehicle to repair it")
	end
end
addEventHandler("onClientRender", root, renderCursorOptions)

function drawText(text)
	dxDrawText(tostring(text), 0, 203, nX, nY / 4, tocolor(255, 255, 255, 255), 2, "default", "center", "center", false, false, false, false, false)
end

function authenticateRepair(veh, plr)
	if (plr == localPlayer) then
		--return
	end
	if (not isElement(plr) or plr.type ~= "player") then
		return
	end
	if (not isElement(veh) or veh.type ~= "vehicle") then
		return
	end
	if (window and isElement(window)) then
		return
	end
	_mechanic = plr
	_vehicle = veh
	createGUI()
	label.text = tostring(plr.name).." wants to repair your "..tostring(veh.name)
	addEventHandler("onClientGUIClick", window, onGUIClick)
	declineTimer = Timer(declineRequest, 15000, 1)
end
addEvent("UCDmechanic.authenticateRepair", true)
addEventHandler("UCDmechanic.authenticateRepair", root, authenticateRepair)

function declineRequest()
	triggerServerEvent("UCDmechanic.onDeclineRequest", resourceRoot, _mechanic)
end

function acceptRequest()
	triggerServerEvent("UCDmechanic.onStartRepair", resourceRoot, _vehicle, _mechanic, localPlayer)
end

function onGUIClick(button, state)
	if (button == "left" and state == "up") then
		if (declineTimer and isTimer(declineTimer)) then
			declineTimer:destroy()
			declineTimer = nil
		end
		if (source == accept) then
			acceptRequest()
		elseif (source == decline) then
			declineRequest()
		end
		destroyGUI()
	end
end

