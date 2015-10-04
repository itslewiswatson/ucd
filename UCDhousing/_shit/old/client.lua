--[[
-- DEV NOTES
-- We can store each house's owner data, price etc as element data
	-- By storing it as ele. data, we can easily fetch it that way as opposed to querying each time someone opens the UI
	-- But we will have to update it every time someone buys a house, sets price etc
--]]

local sX, sY = guiGetScreenSize()
local nX, nY = 1366, 768
local leavingCOLs = {
	[1] = {3, 235.23, 1186.67, 1080.25},
	[2] = {2, 226.78, 1239.93, 1082.14},
	[3] = {1, 223.07, 1287.08, 1082.13},
	[4] = {15, 327.94, 1477.72, 1084.43},
	[5] = {2, 2468.84, -1698.36, 1013.5},
	[6] = {5, 226.29, 1114.27, 1080.99},
	[7] = {15, 387.22, 1471.73, 1080.18},
	[8] = {7, 225.66, 1021.44, 1084},
	[9] = {8, 2807.62, -1174.76, 1025.57},
	[10] = {10, 2270.41, -1210.53, 1047.56},
	[11] = {3, 2496.05, -1692.09, 1014.74},
	[12] = {10, 2259.38, -1135.9, 1050.63},
	[13] = {8, 2365.18, -1135.6, 1050.87},
	[14] = {5, 2233.64, -1115.27, 1050.88},
	[15] = {11, 2282.82, -1140.29, 1050.89},
	[16] = {6, 2196.85, -1204.45, 1049.02},
	[17] = {6, 2308.76, -1212.94, 1049.02},
	[18] = {1, 2218.4, -1076.36, 1050.48},
	[19] = {2, 2237.55, -1081.65, 1049.02},
	[20] = {9, 2317.77, -1026.77, 1050.21},
	[21] = {6, 2333, -1077.36, 1049.02},
	[22] = {5, 1260.64, -785.34, 1091.9},
	[23] = {1, 243.71, 305.01, 999.14},
	[24] = {2, 266.49, 304.99, 999.14},
	[25] = {12, 2324.31, -1149.55, 1050.71},
	[26] = {5, 318.57, 1114.47, 1083.88},
	[27] = {1, 243.71, 304.96, 999.14},
	[28] = {5, 140.32, 1365.91, 1083.86},
	[29] = {6, 234.13, 1063.72, 1084.2},
	[30] = {9, 83.04, 1322.28, 1083.85},
	[31] = {10, 23.92, 1340.16, 1084.37},
	[32] = {15, 377.15, 1417.3, 1081.32},
	[33] = {5, 1298.87, -797.01, 1084, 1015.4990},
}

function leaveHouse(theElement)
	if (theElement ~= localPlayer) then
		return false
	end
	if (isPedInVehicle(localPlayer)) then
		return false
	end
	local houseID = getElementDimension(localPlayer)
	triggerServerEvent("UCDhousing.leaveHouse", localPlayer, houseID)
end

function handleleavingCOLs()
	for i=1,#leavingCOLs do
		local x, y, z = leavingCOLs[i][2], leavingCOLs[i][3], leavingCOLs[i][4]
		local interior = leavingCOLs[i][1]
		colCircle = createColTube(x, y, z -0.5, 1.3, 2.5)
		setElementInterior(colCircle, interior)
		addEventHandler("onClientColShapeHit", colCircle, leaveHouse)
	end
end
addEventHandler("onClientResourceStart", resourceRoot, handleleavingCOLs)

function houseNotification()
	dxDrawText("Press 'Z' to open the housing GUI", (492 / nX) * sX, (658 / nY) * sY, (863 / nX) * sX, (688 / nY) * sY, tocolor(0, 0, 0, 255), 1.00, "pricedown", "left", "top", false, false, false, false, false)
	dxDrawText("Press 'Z' to open the housing GUI", (494 / nX) * sX, (658 / nY) * sY, (865 / nX) * sX, (688 / nY) * sY, tocolor(0, 0, 0, 255), 1.00, "pricedown", "left", "top", false, false, false, false, false)
	dxDrawText("Press 'Z' to open the housing GUI", (492 / nX) * sX, (660 / nY) * sY, (863 / nX) * sX, (690 / nY) * sY, tocolor(0, 0, 0, 255), 1.00, "pricedown", "left", "top", false, false, false, false, false)
	dxDrawText("Press 'Z' to open the housing GUI", (494 / nX) * sX, (660 / nY) * sY, (865 / nX) * sX, (690 / nY) * sY, tocolor(0, 0, 0, 255), 1.00, "pricedown", "left", "top", false, false, false, false, false)
	dxDrawText("Press 'Z' to open the housing GUI", (493 / nX) * sX, (659 / nY) * sY, (864 / nX) * sX, (689 / nY) * sY, tocolor(235, 105, 19, 255), 1.00, "pricedown", "left", "top", false, false, false, false, false)
end

function onHitHouseMarker(thePickup, matchingDimension)
	if (source ~= localPlayer) then
		return false
	end
	if (not matchingDimension) then
		return false
	end
	if (isPedInVehicle(localPlayer)) then
		return false
	end
	if (getPickupType(thePickup) ~= 3) then
		return false
	end
	if (getElementModel(thePickup) ~= 1272) and (getElementModel(thePickup) ~= 1273) then
		return
	end
	
	-- Instead of creating the GUI, we send the houseID to the server to fetch info for the GUI
	local houseID = getElementData(thePickup, "houseID")
	triggerServerEvent("getHouseDataTable", source, houseID)
	
	--addEventHandler("onClientRender", root, houseNotification)
	outputDebugString("houseID = "..houseID)
end
addEventHandler("onClientPlayerPickupHit", root, onHitHouseMarker)

function onLeaveHouseMarker(thePickup, matchingDimension)
	if (source ~= localPlayer) then
		return false
	end
	if (not matchingDimension) then
		return false
	end
	if (isPedInVehicle(localPlayer)) then
		return false
	end
	if (getPickupType(thePickup) ~= 3) then
		return false
	end
	if (getElementModel(thePickup) ~= 1272) and (getElementModel(thePickup) ~= 1273) then
		return
	end
	
	closeGUI()
	--removeEventHandler("onClientRender", root, houseNotification)
end
addEventHandler("onClientPlayerPickupLeave", root, onLeaveHouseMarker)

UCDhousing = {
    button = {},
    window = {},
    edit = {},
    label = {}
}

addEvent("UCDhousing.createGUI", true)
function createGUI(houseData)
	-- Assign table values to a variable name
	local houseID = houseData["houseID"]
	local owner = houseData["owner"]
	local streetName = houseData["streetName"]
	local initialPrice = houseData["initPrice"]
	local interiorID = houseData["interiorID"]
	local open = houseData["open"]
	local sale = houseData["sale"]
	
	-- Just for conventional purposes until I put it in the SQL database
	if (streetName == nil) then
		streetName = "swag street"
	end
	if (initialPrice == nil) then
		initialPrice = 444444
	end
	
	outputDebugString("Created GUI for houseID: "..houseID)
	
	-- Create the actual GUI
	UCDhousing.window[1] = guiCreateWindow(457, 195, 471, 336, "UCD | Housing [ID: "..houseID.."]", false)
	guiWindowSetSizable(UCDhousing.window[1], false)
	exports.UCDmisc:centerWindow(UCDhousing.window[1])
	setElementData(UCDhousing.window[1], "houseID", houseID)
	setElementData(UCDhousing.window[1], "interiorID", interiorID)

	UCDhousing.label[1] = guiCreateLabel(10, 23, 88, 20, "Street name:", false, UCDhousing.window[1])
	UCDhousing.label[2] = guiCreateLabel(10, 43, 88, 20, "Owner:", false, UCDhousing.window[1])
	UCDhousing.label[3] = guiCreateLabel(10, 63, 88, 20, "Initial price:", false, UCDhousing.window[1])
	UCDhousing.label[4] = guiCreateLabel(10, 83, 88, 20, "Bought for:", false, UCDhousing.window[1])
	UCDhousing.label[5] = guiCreateLabel(10, 103, 88, 20, "Price:", false, UCDhousing.window[1])
	UCDhousing.label[6] = guiCreateLabel(10, 123, 88, 20, "Interior:", false, UCDhousing.window[1])
	UCDhousing.label[7] = guiCreateLabel(10, 143, 88, 20, "Open:", false, UCDhousing.window[1])
	UCDhousing.label[8] = guiCreateLabel(10, 163, 88, 20, "On sale:", false, UCDhousing.window[1])
	
	-- These are dynamic
	UCDhousing.label[9] = guiCreateLabel(108, 23, 115, 20, streetName, false, UCDhousing.window[1])
	UCDhousing.label[10] = guiCreateLabel(108, 43, 115, 20, tostring(owner), false, UCDhousing.window[1])
	UCDhousing.label[11] = guiCreateLabel(108, 63, 115, 20, "$"..exports.UCDmisc:tocomma(initialPrice), false, UCDhousing.window[1])
	UCDhousing.label[12] = guiCreateLabel(108, 83, 115, 20, "$1", false, UCDhousing.window[1])
	UCDhousing.label[13] = guiCreateLabel(108, 103, 115, 20, "$99,999,999", false, UCDhousing.window[1])
	UCDhousing.label[14] = guiCreateLabel(108, 123, 115, 20, interiorID, false, UCDhousing.window[1])
	UCDhousing.label[15] = guiCreateLabel(108, 143, 115, 20, "isOpen", false, UCDhousing.window[1])
	UCDhousing.label[16] = guiCreateLabel(108, 163, 115, 20, "forSale", false, UCDhousing.window[1])
	UCDhousing.label[17] = guiCreateLabel(0, 179, 471, 19, "__________________________________________________________________________________________", false, UCDhousing.window[1])
	guiLabelSetHorizontalAlign(UCDhousing.label[17], "center", false)
	UCDhousing.label[18] = guiCreateLabel(238, 23, 15, 160, "|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|", false, UCDhousing.window[1])

	local housingLabels1 = {UCDhousing.label[1], UCDhousing.label[2], UCDhousing.label[3], UCDhousing.label[4], UCDhousing.label[5], UCDhousing.label[6], UCDhousing.label[7], UCDhousing.label[8]}
	local housingLabels2 = {UCDhousing.label[9], UCDhousing.label[10], UCDhousing.label[11], UCDhousing.label[12], UCDhousing.label[13], UCDhousing.label[14], UCDhousing.label[15], UCDhousing.label[16], UCDhousing.label[17], UCDhousing.label[18]}
	
	for _, v in pairs(housingLabels1) do
		guiSetFont(v, "clear-normal")
		guiLabelSetHorizontalAlign(v, "right", false)
		guiLabelSetVerticalAlign(v, "center")
	end
	for _, v in pairs(housingLabels2) do
		guiLabelSetVerticalAlign(v, "center") 
	end
	
	UCDhousing.button[1] = guiCreateButton(278, 33, 161, 60, "Purchase house", false, UCDhousing.window[1])
	guiSetProperty(UCDhousing.button[1], "NormalTextColour", "FFAAAAAA")
	UCDhousing.button[2] = guiCreateButton(278, 113, 161, 60, "Enter this house", false, UCDhousing.window[1])
	guiSetProperty(UCDhousing.button[2], "NormalTextColour", "FFAAAAAA")
	UCDhousing.edit[1] = guiCreateEdit(20, 212, 270, 44, "", false, UCDhousing.window[1])
	UCDhousing.button[3] = guiCreateButton(319, 212, 120, 44, "Set price", false, UCDhousing.window[1])
	guiSetProperty(UCDhousing.button[3], "NormalTextColour", "FFAAAAAA")
	UCDhousing.button[4] = guiCreateButton(20, 273, 94, 46, "Toggle sale", false, UCDhousing.window[1])
	guiSetProperty(UCDhousing.button[4], "NormalTextColour", "FFAAAAAA")
	UCDhousing.button[5] = guiCreateButton(129, 273, 94, 46, "Toggle open house", false, UCDhousing.window[1])
	guiSetProperty(UCDhousing.button[5], "NormalTextColour", "FFAAAAAA")
	UCDhousing.button[6] = guiCreateButton(235, 273, 94, 46, "Sell house to bank", false, UCDhousing.window[1])
	guiSetProperty(UCDhousing.button[6], "NormalTextColour", "FFAAAAAA")
	UCDhousing.button[7] = guiCreateButton(345, 273, 94, 46, "Close", false, UCDhousing.window[1])
	guiSetProperty(UCDhousing.button[7], "NormalTextColour", "FFAAAAAA")
	
	-- Check if the house is open, and set the text accordingly
	if (open == 1) then
		guiSetText(UCDhousing.label[15], "Yes")
		guiSetEnabled(UCDhousing.button[2], true)
	else
		guiSetText(UCDhousing.label[15], "No")
		guiSetEnabled(UCDhousing.button[2], false)
	end
	
	-- Check if the house is for sale, and set the text accordingly
	if (sale == 1) then
		guiSetText(UCDhousing.label[16], "Yes")
		guiSetEnabled(UCDhousing.button[1], true)
	else
		guiSetText(UCDhousing.label[16], "No")
		guiSetEnabled(UCDhousing.button[1], false)
	end
	
	showCursor(true)
end
addEventHandler("UCDhousing.createGUI", root, createGUI)

function closeGUI()
	if (isElement(UCDhousing.window[1])) then
		destroyElement(UCDhousing.window[1])
	end
	if (isCursorShowing()) then
		showCursor(false)
	end
end

function handleClicks()
	if (source == UCDhousing.button[7]) then
		closeGUI()
	elseif (source == UCDhousing.button[2]) then
		if (guiGetEnabled(UCDhousing.button[2])) then
			local houseID = getElementData(UCDhousing.window[1], "houseID")
			local interiorID = getElementData(UCDhousing.window[1], "interiorID")
			outputDebugString("Entering house... ID = "..houseID)
			triggerServerEvent("UCDhousing.enterHouse", localPlayer, houseID, interiorID)
		end
	end
end
addEventHandler("onClientGUIClick", guiRoot, handleClicks)

--- 
	--[[guiSetFont(UCDhousing.label[1], "clear-normal")
	guiLabelSetHorizontalAlign(UCDhousing.label[1], "right", false)
	guiLabelSetVerticalAlign(UCDhousing.label[1], "center")
	guiSetFont(UCDhousing.label[2], "clear-normal")
	guiLabelSetHorizontalAlign(UCDhousing.label[2], "right", false)
	guiLabelSetVerticalAlign(UCDhousing.label[2], "center")
	guiSetFont(UCDhousing.label[3], "clear-normal")
	guiLabelSetHorizontalAlign(UCDhousing.label[3], "right", false)
	guiLabelSetVerticalAlign(UCDhousing.label[3], "center")
	guiSetFont(UCDhousing.label[4], "clear-normal")
	guiLabelSetHorizontalAlign(UCDhousing.label[4], "right", false)
	guiLabelSetVerticalAlign(UCDhousing.label[4], "center")
	guiSetFont(UCDhousing.label[5], "clear-normal")
	guiLabelSetHorizontalAlign(UCDhousing.label[5], "right", false)
	guiLabelSetVerticalAlign(UCDhousing.label[5], "center")
	guiSetFont(UCDhousing.label[6], "clear-normal")
	guiLabelSetHorizontalAlign(UCDhousing.label[6], "right", false)
	guiLabelSetVerticalAlign(UCDhousing.label[6], "center")
	guiSetFont(UCDhousing.label[7], "clear-normal")
	guiLabelSetHorizontalAlign(UCDhousing.label[7], "right", false)
	guiLabelSetVerticalAlign(UCDhousing.label[7], "center")
	guiSetFont(UCDhousing.label[8], "clear-normal")
	guiLabelSetHorizontalAlign(UCDhousing.label[8], "right", false)
	guiLabelSetVerticalAlign(UCDhousing.label[8], "center")]]
	--
	--[[
	guiLabelSetVerticalAlign(UCDhousing.label[9], "center")
	guiLabelSetVerticalAlign(UCDhousing.label[10], "center")
	guiLabelSetVerticalAlign(UCDhousing.label[11], "center")
	guiLabelSetVerticalAlign(UCDhousing.label[12], "center")
	guiLabelSetVerticalAlign(UCDhousing.label[13], "center")
	guiLabelSetVerticalAlign(UCDhousing.label[14], "center")
	guiLabelSetVerticalAlign(UCDhousing.label[15], "center")
	guiLabelSetVerticalAlign(UCDhousing.label[16], "center")
	]]
	
--[[
function createGUI(thePickup)
	if (not thePickup) then
		outputDebugString("No element passed")
		return nil
	end
	if (getElementType(thePickup) ~= "pickup" ) then
		outputDebugString("thePickup not pickup")
		return false 
	end	
	outputDebugString("Created GUI for houseID: "..getElementData(thePickup, "houseID"))
	
	-- Declare variables here to use on the GUI
	local houseID = getElementData(thePickup, "houseID")
	local streetName = getElementData(thePickup, "streetName")
	local initialPrice = getElementData(thePickup, "initialPrice")
	local interiorID = getElementData(thePickup, "interiorID")
	local owner = getElementData(thePickup, "ownerName")
	local open = getElementData(thePickup, "open")
	local sale = getElementData(thePickup, "forSale")
	
	-- Create the actual GUI
	UCDhousing.window[1] = guiCreateWindow(457, 195, 471, 336, "UCD | Housing [ID: "..houseID.."]", false)
	guiWindowSetSizable(UCDhousing.window[1], false)
	setElementData(UCDhousing.window[1], "houseID", getElementData(thePickup, "houseID"))
	setElementData(UCDhousing.window[1], "interiorID", getElementData(thePickup, "interiorID"))

	UCDhousing.label[1] = guiCreateLabel(10, 23, 88, 20, "Street name:", false, UCDhousing.window[1])
	UCDhousing.label[2] = guiCreateLabel(10, 43, 88, 20, "Owner:", false, UCDhousing.window[1])
	UCDhousing.label[3] = guiCreateLabel(10, 63, 88, 20, "Initial price:", false, UCDhousing.window[1])
	UCDhousing.label[4] = guiCreateLabel(10, 83, 88, 20, "Bought for:", false, UCDhousing.window[1])
	UCDhousing.label[5] = guiCreateLabel(10, 103, 88, 20, "Price:", false, UCDhousing.window[1])
	UCDhousing.label[6] = guiCreateLabel(10, 123, 88, 20, "Interior:", false, UCDhousing.window[1])
	UCDhousing.label[7] = guiCreateLabel(10, 143, 88, 20, "Open:", false, UCDhousing.window[1])
	UCDhousing.label[8] = guiCreateLabel(10, 163, 88, 20, "On sale:", false, UCDhousing.window[1])
	
	-- These are dynamic
	UCDhousing.label[9] = guiCreateLabel(108, 23, 115, 20, streetName, false, UCDhousing.window[1])
	UCDhousing.label[10] = guiCreateLabel(108, 43, 115, 20, tostring(owner), false, UCDhousing.window[1])
	UCDhousing.label[11] = guiCreateLabel(108, 63, 115, 20, "$"..exports.UCDmisc:tocomma(initialPrice), false, UCDhousing.window[1])
	UCDhousing.label[12] = guiCreateLabel(108, 83, 115, 20, "$1", false, UCDhousing.window[1])
	UCDhousing.label[13] = guiCreateLabel(108, 103, 115, 20, "$99,999,999", false, UCDhousing.window[1])
	UCDhousing.label[14] = guiCreateLabel(108, 123, 115, 20, interiorID, false, UCDhousing.window[1])
	UCDhousing.label[15] = guiCreateLabel(108, 143, 115, 20, "isOpen", false, UCDhousing.window[1])
	UCDhousing.label[16] = guiCreateLabel(108, 163, 115, 20, "forSale", false, UCDhousing.window[1])
	UCDhousing.label[17] = guiCreateLabel(0, 179, 471, 19, "__________________________________________________________________________________________", false, UCDhousing.window[1])
	guiLabelSetHorizontalAlign(UCDhousing.label[17], "center", false)
	UCDhousing.label[18] = guiCreateLabel(238, 23, 15, 160, "|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|", false, UCDhousing.window[1])

	local housingLabels1 = {UCDhousing.label[1], UCDhousing.label[2], UCDhousing.label[3], UCDhousing.label[4], UCDhousing.label[5], UCDhousing.label[6], UCDhousing.label[7], UCDhousing.label[8]}
	local housingLabels2 = {UCDhousing.label[9], UCDhousing.label[10], UCDhousing.label[11], UCDhousing.label[12], UCDhousing.label[13], UCDhousing.label[14], UCDhousing.label[15], UCDhousing.label[16], UCDhousing.label[17], UCDhousing.label[18]}
	
	for _, v in pairs(housingLabels1) do
		guiSetFont(v, "clear-normal")
		guiLabelSetHorizontalAlign(v, "right", false)
		guiLabelSetVerticalAlign(v, "center")
	end
	for _, v in pairs(housingLabels2) do
		guiLabelSetVerticalAlign(v, "center") 
	end
	
	UCDhousing.button[1] = guiCreateButton(278, 33, 161, 60, "Purchase house", false, UCDhousing.window[1])
	guiSetProperty(UCDhousing.button[1], "NormalTextColour", "FFAAAAAA")
	UCDhousing.button[2] = guiCreateButton(278, 113, 161, 60, "Enter this house", false, UCDhousing.window[1])
	guiSetProperty(UCDhousing.button[2], "NormalTextColour", "FFAAAAAA")
	UCDhousing.edit[1] = guiCreateEdit(20, 212, 270, 44, "", false, UCDhousing.window[1])
	UCDhousing.button[3] = guiCreateButton(319, 212, 120, 44, "Set price", false, UCDhousing.window[1])
	guiSetProperty(UCDhousing.button[3], "NormalTextColour", "FFAAAAAA")
	UCDhousing.button[4] = guiCreateButton(20, 273, 94, 46, "Toggle sale", false, UCDhousing.window[1])
	guiSetProperty(UCDhousing.button[4], "NormalTextColour", "FFAAAAAA")
	UCDhousing.button[5] = guiCreateButton(129, 273, 94, 46, "Toggle open house", false, UCDhousing.window[1])
	guiSetProperty(UCDhousing.button[5], "NormalTextColour", "FFAAAAAA")
	UCDhousing.button[6] = guiCreateButton(235, 273, 94, 46, "Sell house to bank", false, UCDhousing.window[1])
	guiSetProperty(UCDhousing.button[6], "NormalTextColour", "FFAAAAAA")
	UCDhousing.button[7] = guiCreateButton(345, 273, 94, 46, "Close", false, UCDhousing.window[1])
	guiSetProperty(UCDhousing.button[7], "NormalTextColour", "FFAAAAAA")
	
	-- Check if the house is open, and set the text accordingly
	if (open == 1) then
		guiSetText(UCDhousing.label[15], "Yes")
		guiSetEnabled(UCDhousing.button[2], true)
	else
		guiSetText(UCDhousing.label[15], "No")
		guiSetEnabled(UCDhousing.button[2], false)
	end
	
	-- Check if the house is for sale, and set the text accordingly
	if (sale == 1) then
		guiSetText(UCDhousing.label[16], "Yes")
		guiSetEnabled(UCDhousing.button[1], true)
	else
		guiSetText(UCDhousing.label[16], "No")
		guiSetEnabled(UCDhousing.button[1], false)
	end
end
--]]