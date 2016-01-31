local markerInfo = {}
local sX, sY = guiGetScreenSize()
GUI = {
    gridlist = {},
    window = {},
    button = {}
}

GUI.window = GuiWindow(1085, 205, 281, 361, "UCD | Vehicle Shop - Low End", false)
GUI.window.sizable = false
GUI.window.visible = false
GUI.window.alpha = 1
GUI.gridlist = GuiGridList(9, 28, 262, 280, false, GUI.window)
guiGridListAddColumn(GUI.gridlist, "Vehicle", 0.6)
guiGridListAddColumn(GUI.gridlist, "Price", 0.3)
GUI.button["buy"] = GuiButton(10, 318, 80, 30, "Buy", false, GUI.window)
GUI.button["colour"] = GuiButton(101, 318, 80, 30, "Colour", false, GUI.window)
GUI.button["close"] = GuiButton(191, 318, 80, 30, "Close", false, GUI.window)

function onHitShopMarker(plr, matchingDimension)
	if (plr == localPlayer and not localPlayer.vehicle and matchingDimension and plr.interior == 0) then
		if (localPlayer.position.z < source.position.z + 1.5 and localPlayer.position.z > source.position.z - 1.5) then
			exports.UCDdx:add("Press Z: Buy Vehicle", 255, 255, 0)
			bindKey("z", "down", openGUI, source)
		end
	end
end

function onLeaveShopMarker(plr, matchingDimension)
	if (plr == localPlayer and not localPlayer.vehicle and matchingDimension and plr.interior == 0) then
		exports.UCDdx:del("Press Z: Buy Vehicle")
		unbindKey("z", "down", closeGUI)
		closeGUI()
	end
end

for i, info in ipairs(markers) do
	local m = Marker(info.x, info.y, info.z - 1, "cylinder", 2, 255, 255, 180, 170)
	
	-- Custom blips
	if (type(blips[info.t]) == "string") then
		local b = exports.UCDblips:createCustomBlip(info.x, info.y, 16, 16, blips[info.t], 300)
		exports.UCDblips:setCustomBlipStreamRadius(b, 50)
	else
		Blip.createAttachedTo(m, blips[info.t], 2, 0, 0, 0, 0, 0, 300)
	end	
	
	addEventHandler("onClientMarkerHit", m, onHitShopMarker)
	addEventHandler("onClientMarkerLeave", m, onLeaveShopMarker)
	markerInfo[m] = {info.t, i}
end

function openGUI(_, _, m)
	if (GUI.visible) then return end
	if (m and isElement(m)) then
		if (getDistanceBetweenPoints3D(localPlayer.position, m.position) > 1.5) then
			return
		end
		GUI.window.text = "UCD | Vehicle Shop - "..tostring(markerInfo[m][1])
		populateGridList(markerInfo[m][1])
	end
	GUI.window.visible = true
	GUI.window:setPosition(sX - 281, sY / 2 - (361 / 2), false)
	showCursor(true)
	exports.UCDdx:del("Press Z: Buy Vehicle")
	unbindKey("z", "down", closeGUI)
	_markerInfo = markerInfo[m]
end

function closeGUI()
	if (not GUI.window.visible) then return end
	GUI.gridlist:clear()
	GUI.window.visible = false
	showCursor(false)
	exports.UCDdx:del("Press Z: Buy Vehicle")
	unbindKey("z", "down", closeGUI)
	if (Camera.target ~= localPlayer) then
		Camera.target = localPlayer
	end
	_markerInfo = nil
	if (veh and isElement(veh)) then
		veh:destroy()	
	end
	veh = nil
end
addEventHandler("onClientGUIClick", GUI.button["close"], closeGUI, false)

function populateGridList(var)
	GUI.gridlist:clear()
	for k, v in ipairs(vehicles[var] or {}) do
		local name = getVehicleNameFromModel(v)
		local price = prices[name]
		local row = guiGridListAddRow(GUI.gridlist)
		guiGridListSetItemText(GUI.gridlist, row, 1, tostring(name), false, false)
		guiGridListSetItemText(GUI.gridlist, row, 2, tostring(exports.UCDutil:tocomma(price)), false, false)
		if (price ~= nil and price <= localPlayer:getMoney()) then
			guiGridListSetItemColor(GUI.gridlist, row, 1, 0, 255, 0)
			guiGridListSetItemColor(GUI.gridlist, row, 2, 0, 255, 0)
		else
			guiGridListSetItemColor(GUI.gridlist, row, 1, 255, 0, 0)
			guiGridListSetItemColor(GUI.gridlist, row, 2, 255, 0, 0)
		end
	end
end

function onClickVehicle()
	local row = guiGridListGetSelectedItem(GUI.gridlist)
	if (row and row ~= -1) then
		local id = getVehicleModelFromName(guiGridListGetItemText(GUI.gridlist, row, 1))
		if (id and _markerInfo) then
			if (veh and isElement(veh)) then
				veh:destroy()
				veh = nil
			end
			
			local i = _markerInfo[2]
			local p = markers[i].p
			veh = Vehicle(id, p)
			veh.rotation = Vector3(0, 0, markers[i].r)
			Camera.setMatrix(markers[i].c, p, 0, 180)
		end
	end
end
addEventHandler("onClientGUIClick", GUI.gridlist, onClickVehicle, false)

function onClickBuy()
	local row = guiGridListGetSelectedItem(GUI.gridlist)
	if (row and row ~= -1) then
		local id = getVehicleModelFromName(guiGridListGetItemText(GUI.gridlist, row, 1))
		if (id and veh and isElement(veh)) then
			triggerServerEvent("UCDvehicleShops.purchase", localPlayer, id, {veh:getColor()}, _markerInfo[2])
			closeGUI()
		end
	end
end
addEventHandler("onClientGUIClick", GUI.button["buy"], onClickBuy, false)

function onClickColour()
	if (veh and isElement(veh)) then
		GUI.window.visible = false
		colorPicker.openSelect()
		addEventHandler("onClientRender", root, updateColor)
	end
end
addEventHandler("onClientGUIClick", GUI.button["colour"], onClickColour, false)

function updateColor()
	if (not colorPicker.isSelectOpen) then return end
	local r, g, b = colorPicker.updateTempColors()
	if (veh and isElement(veh)) then
		local r1, g1, b1, r2, g2, b2 = getVehicleColor(veh, true)
		if (guiCheckBoxGetSelected(checkColor1)) then
			r1, g1, b1 = r, g, b
		end
		if (guiCheckBoxGetSelected(checkColor2)) then
			r2, g2, b2 = r, g, b
		end
		--if (guiCheckBoxGetSelected(checkColor3)) then
		--	setVehicleHeadLightColor(localPlayer.vehicle, r, g, b)
		--end
		setVehicleColor(veh, r1, g1, b1, r2, g2, b2)
		tempColors = {r1, g1, b1, r2, g2, b2}
	end
end
