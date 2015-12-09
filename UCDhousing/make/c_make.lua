-------------------------------------------------------------------
--// PROJECT: Union of Clarity and Diversity
--// RESOURCE: UCDhousing
--// DEVELOPER(S): Lewis Watson (Noki)
--// DATE: 09/12/2015
--// PURPOSE: Interactive window for creating houses.
--// FILE: \make\c_make.lua [client]
-------------------------------------------------------------------

housingCreator = {
    window = {},
    edit = {},
    label = {},
	button = {}
}

function sendToSv()
	houseInfo = {}
	houseInfo["interiorID"] = guiGetText(housingCreator.edit[1])
	houseInfo["x"] = guiGetText(housingCreator.edit[2])
	houseInfo["y"] = guiGetText(housingCreator.edit[3])
	houseInfo["z"] = guiGetText(housingCreator.edit[4])
	houseInfo["name"] = guiGetText(housingCreator.edit[5])
	houseInfo["price"] = guiGetText(housingCreator.edit[6])
	
	triggerServerEvent("UCDhousing.makeHouse", resourceRoot, houseInfo)
	
	houseInfo = {}
end
function close()
	destroyElement(housingCreator.window[1])
	showCursor(false)
end

function openPanel()
	if (not localPlayer) then outputDebugString("nigger") return end
	if (not isPedOnGround(localPlayer)) then exports.UCDdx:new("You must be on the ground for this feature to work", 255, 0, 0) return end
	
	x, y, z = getElementPosition(localPlayer)
	
	housingCreator.window[1] = guiCreateWindow(457, 192, 468, 335, "UCD | Housing [Creation Panel]", false)
	guiWindowSetSizable(housingCreator.window[1], false)
	
	housingCreator.label[1] = guiCreateLabel(30, 47, 55, 17, "interiorID:", false, housingCreator.window[1])
	housingCreator.label[2] = guiCreateLabel(30, 78, 55, 17, "x:", false, housingCreator.window[1])
	housingCreator.label[3] = guiCreateLabel(30, 105, 55, 17, "y:", false, housingCreator.window[1])
	housingCreator.label[4] = guiCreateLabel(30, 136, 55, 17, "z:", false, housingCreator.window[1])
	housingCreator.label[5] = guiCreateLabel(30, 169, 55, 17, "Name:", false, housingCreator.window[1])
	housingCreator.label[6] = guiCreateLabel(30, 204, 55, 17, "Price: ", false, housingCreator.window[1])
	housingCreator.edit[1] = guiCreateEdit(149, 43, 262, 21, "", false, housingCreator.window[1])
	housingCreator.edit[2] = guiCreateEdit(149, 74, 262, 21, exports.UCDutil:mathround(x, 4), false, housingCreator.window[1])
	housingCreator.edit[3] = guiCreateEdit(149, 105, 262, 21, exports.UCDutil:mathround(y, 4), false, housingCreator.window[1])
	housingCreator.edit[4] = guiCreateEdit(149, 132, 262, 21, exports.UCDutil:mathround(z, 4), false, housingCreator.window[1])
	housingCreator.edit[5] = guiCreateEdit(149, 165, 262, 21, "", false, housingCreator.window[1])
	housingCreator.edit[6] = guiCreateEdit(149, 200, 262, 21, "", false, housingCreator.window[1])
	housingCreator.label[7] = guiCreateLabel(30, 259, 303, 49, "houseIDs will be automatically assigned.\nThe price you set will be the initial price, bought for price and the current market price\nThe owner will be UCDhousing..", false, housingCreator.window[1])
	housingCreator.button[1] = guiCreateButton(364, 259, 88, 59, "Submit", false, housingCreator.window[1])
	guiSetProperty(housingCreator.button[1], "NormalTextColour", "FFAAAAAA")
	housingCreator.button[2] = guiCreateButton(428, 43, 30, 183, "close", false, housingCreator.window[1])
	guiSetProperty(housingCreator.button[2], "NormalTextColour", "FFAAAAAA")    
	
	showCursor(true)
	
	addEventHandler("onClientGUIClick", housingCreator.button[1], sendToSv, false)
	addEventHandler("onClientGUIClick", housingCreator.button[2], close, false)
	guiSetInputMode("no_binds_when_editing")
end
addCommandHandler("chouse", openPanel)
