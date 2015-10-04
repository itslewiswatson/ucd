
GUIEditor = {
    window = {},
    edit = {},
    label = {},
	button = {}
}

function sendToSv()
	houseInfo = {}
	houseInfo["interiorID"] = guiGetText(GUIEditor.edit[1])
	houseInfo["x"] = guiGetText(GUIEditor.edit[2])
	houseInfo["y"] = guiGetText(GUIEditor.edit[3])
	houseInfo["z"] = guiGetText(GUIEditor.edit[4])
	houseInfo["name"] = guiGetText(GUIEditor.edit[5])
	houseInfo["price"] = guiGetText(GUIEditor.edit[6])
	
	triggerServerEvent("UCDhousing.makeHouse", resourceRoot)
end
function close()
	destroyElement(GUIEditor.window[1])
	showCursor(false)
end

function openPanel()
	if (not localPlayer) then outputDebugString("nigger") return end
	if (not isPedOnGround(localPlayer)) then exports.UCDdx:new("You must be on the ground for this feature to work", 255, 0, 0) return end
	
	x, y, z = getElementPosition(localPlayer)
	
	GUIEditor.window[1] = guiCreateWindow(457, 192, 468, 335, "UCDhousing | Creation Panel", false)
	guiWindowSetSizable(GUIEditor.window[1], false)
	
	GUIEditor.label[1] = guiCreateLabel(30, 47, 55, 17, "interiorID:", false, GUIEditor.window[1])
	GUIEditor.label[2] = guiCreateLabel(30, 78, 55, 17, "x:", false, GUIEditor.window[1])
	GUIEditor.label[3] = guiCreateLabel(30, 105, 55, 17, "y:", false, GUIEditor.window[1])
	GUIEditor.label[4] = guiCreateLabel(30, 136, 55, 17, "z:", false, GUIEditor.window[1])
	GUIEditor.label[5] = guiCreateLabel(30, 169, 55, 17, "Name:", false, GUIEditor.window[1])
	GUIEditor.label[6] = guiCreateLabel(30, 204, 55, 17, "Price: ", false, GUIEditor.window[1])
	GUIEditor.edit[1] = guiCreateEdit(149, 43, 262, 21, "", false, GUIEditor.window[1])
	GUIEditor.edit[2] = guiCreateEdit(149, 74, 262, 21, exports.UCDmisc:mathround(x, 4), false, GUIEditor.window[1])
	GUIEditor.edit[3] = guiCreateEdit(149, 105, 262, 21, exports.UCDmisc:mathround(y, 4), false, GUIEditor.window[1])
	GUIEditor.edit[4] = guiCreateEdit(149, 132, 262, 21, exports.UCDmisc:mathround(z, 4), false, GUIEditor.window[1])
	GUIEditor.edit[5] = guiCreateEdit(149, 165, 262, 21, "", false, GUIEditor.window[1])
	GUIEditor.edit[6] = guiCreateEdit(149, 200, 262, 21, "", false, GUIEditor.window[1])
	GUIEditor.label[7] = guiCreateLabel(30, 259, 303, 49, "houseIDs will be automatically assigned.\nThe price you set will be the initial price, bought for price and the current market price\nThe owner will be UCDhousing..", false, GUIEditor.window[1])
	GUIEditor.button[1] = guiCreateButton(364, 259, 88, 59, "Submit", false, GUIEditor.window[1])
	guiSetProperty(GUIEditor.button[1], "NormalTextColour", "FFAAAAAA")
	GUIEditor.button[2] = guiCreateButton(428, 43, 30, 183, "close", false, GUIEditor.window[1])
	guiSetProperty(GUIEditor.button[2], "NormalTextColour", "FFAAAAAA")    
	
	showCursor(true)
	
	addEventHandler("onClientGUIClick", GUIEditor.button[1], sendToSv)
	addEventHandler("onClientGUIClick", GUIEditor.button[2], close)
end
addCommandHandler("chouse", openPanel)


