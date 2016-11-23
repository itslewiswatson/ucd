-------------------------------------------------------------------
--// PROJECT: Union of Clarity and Diversity
--// RESOURCE: UCDhousing
--// DEVELOPER(S): Lewis Watson (Noki)
--// DATE: 09/12/2015
--// PURPOSE: Player interaction with the housing system.
--// FILE: \client.lua [client]
-------------------------------------------------------------------

confirmation = {window={}, label={}, button={}}
--UCDhousing = {button = {}, window = {}, edit = {}, label = {}}

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
	--[27] = {1, 243.71, 304.96, 999.14},
	[27] = {5, 140.32, 1365.91, 1083.86},
	[28] = {6, 234.13, 1063.72, 1084.2},
	[29] = {9, 83.04, 1322.28, 1083.85},
	[30] = {10, 23.92, 1340.16, 1084.37},
	[31] = {15, 377.15, 1417.3, 1081.32},
	[32] = {1, 2523.3279, -1679.1038, 1015.4986},
}

function leaveHouse(theElement)
	if (theElement ~= localPlayer) or (localPlayer:isInVehicle()) then return false end
	local houseID = localPlayer:getDimension()
	--removeHouseNotification()
	triggerServerEvent("UCDhousing.leaveHouse", localPlayer, houseID)
end

function handleleavingCOLs()
	for i=1,#leavingCOLs do
		local x, y, z = leavingCOLs[i][2], leavingCOLs[i][3], leavingCOLs[i][4]
		local interior = leavingCOLs[i][1]
		colCircle = createColTube(x, y, z -0.5, 1.3, 2.5)
		colCircle:setInterior(interior)
		addEventHandler("onClientColShapeHit", colCircle, leaveHouse)
	end
end
addEventHandler("onClientResourceStart", resourceRoot, handleleavingCOLs)

function zToHouse(_, _, plr, thePickup)
	if (not UCDhousing) then
		outputDebugString(tostring(plr).." | "..tostring(thePickup:getData("houseID")))
		triggerEvent("UCDhousing.fetchHouse.client", plr, thePickup:getData("houseID"))
	end
end
function addHouseNotification(plr, thePickup)
	exports.UCDdx:add("houseinfo", "Press Z: House Info", 255, 255, 0)
	bindKey("z", "down", zToHouse, plr, thePickup)
	if (plr:getData("Occupation") == "Criminal" or plr:getData("Occupation") == "Gangster") then
		exports.UCDdx:add("houserob", "Press N: House Rob", 255, 0, 0)
		bindKey("n", "down", nToRob, plr, thePickup)
	end
end
function removeHouseNotification()
	exports.UCDdx:del("houseinfo")
	exports.UCDdx:del("houserob")
	unbindKey("z", "down", zToHouse)
	unbindKey("n", "down", nToRob)
end

local function onHitHouseMarker(thePickup, matchingDimension)
	if (thePickup and isElement(thePickup)) then
		if (source ~= localPlayer or not matchingDimension or localPlayer.vehicle or getPickupType(thePickup) ~= 3) then
			return false
		end
		if (thePickup.model ~= 1272 and thePickup.model ~= 1273 or not thePickup:getData("houseID")) then
			return
		end
		
		-- Instead of creating the GUI, we send the houseID to the server to fetch info for the GUI
		local houseID = thePickup:getData("houseID")
		
		addHouseNotification(source, thePickup)
		outputDebugString("houseID = "..houseID)
	end
end
addEventHandler("onClientPlayerPickupHit", root, onHitHouseMarker)

local function onLeaveHouseMarker(thePickup, matchingDimension)
	if (source ~= localPlayer or not matchingDimension or localPlayer.vehicle or getPickupType(thePickup) ~= 3) then
		return false
	end
	if (thePickup.model ~= 1272 and thePickup.model ~= 1273 or not thePickup:getData("houseID")) then
		return
	end
	triggerEvent("UCDhousing.closeGUI", source)
	removeHouseNotification()
end
addEventHandler("onClientPlayerPickupLeave", root, onLeaveHouseMarker)

-- We create the GUI each time as the player will not always be using accounts
function fetchHouseGUI(houseID)
	if (localPlayer ~= source or UCDhousing ~= nil) then return false end
	-- Trigger a server event and transfer everything over
	triggerServerEvent("UCDhousing.fetchHouse.server", localPlayer, houseID)	
end
addEvent("UCDhousing.fetchHouse.client", true)
addEventHandler("UCDhousing.fetchHouse.client", root, fetchHouseGUI)

function createGUI(houseTable)
	if (UCDhousing) then return end
	--outputDebugString(tostring(houseTable))
	-- Assign table values to a variable name
	local houseID = houseTable[1]
	local owner = houseTable[2]
	local houseName = houseTable[3]
	local initialPrice = houseTable[4]
	local currentPrice = houseTable[5]
	local boughtForPrice = houseTable[6]
	local interiorID = houseTable[7]
	local open = houseTable[8]
	local sale = houseTable[9]
	
	local localPlayerAccountName = localPlayer:getData("accountName")
	
	if (owner == nil) then 
		exports.UCDdx:new("Whoops! We couldn't load the house data for some reason. Reconnect to fix this.", 255, 0, 0)
		exports.UCDdx:new("Error: table not synced - houseID: "..tostring(houseID), 255, 0, 0) 
		return 
	end
	
	outputDebugString("Creating GUI for houseID: "..houseID)
	outputDebugString("Owner ["..houseID.."]: "..owner)
	
	-- This is where things get messy. Though this is the best way of phasing out syncing the whole housing table.
	-- Set the GUI's properties (so we don't have to use element data)
	UCDhousing = {button = {}, window = {}, edit = {}, label = {}, houseID = houseTable[1], houseData = {}}
	for i = 1, #houseTable do
		UCDhousing.houseData[i] = houseTable[i]
	end
	
	-- Create the actual GUI
	UCDhousing.window[1] = GuiWindow(457, 195, 471, 336, "UCD | Housing [ID: "..houseID.."]", false)
	UCDhousing.window[1].sizable = false
	UCDhousing.window[1].alpha = 1
	exports.UCDutil:centerWindow(UCDhousing.window[1])
	
	UCDhousing.label[1] = GuiLabel(10, 23, 88, 20, "House name:", false, UCDhousing.window[1])
	UCDhousing.label[2] = GuiLabel(10, 43, 88, 20, "Owner:", false, UCDhousing.window[1])
	UCDhousing.label[3] = GuiLabel(10, 63, 88, 20, "Initial price:", false, UCDhousing.window[1])
	UCDhousing.label[4] = GuiLabel(10, 83, 88, 20, "Bought for:", false, UCDhousing.window[1])
	UCDhousing.label[5] = GuiLabel(10, 103, 88, 20, "Price:", false, UCDhousing.window[1])
	UCDhousing.label[6] = GuiLabel(10, 123, 88, 20, "Interior:", false, UCDhousing.window[1])
	UCDhousing.label[7] = GuiLabel(10, 143, 88, 20, "Open:", false, UCDhousing.window[1])
	UCDhousing.label[8] = GuiLabel(10, 163, 88, 20, "On sale:", false, UCDhousing.window[1])
	
	-- These are dynamic
	UCDhousing.label[9] = GuiLabel(108, 23, 115, 20, houseName, false, UCDhousing.window[1])
	UCDhousing.label[10] = GuiLabel(108, 43, 115, 20, tostring(owner), false, UCDhousing.window[1])
	UCDhousing.label[11] = GuiLabel(108, 63, 115, 20, "$"..exports.UCDutil:tocomma(initialPrice), false, UCDhousing.window[1])
	UCDhousing.label[12] = GuiLabel(108, 83, 115, 20, "$"..exports.UCDutil:tocomma(boughtForPrice), false, UCDhousing.window[1])
	UCDhousing.label[13] = GuiLabel(108, 103, 115, 20, "$"..exports.UCDutil:tocomma(currentPrice), false, UCDhousing.window[1])
	UCDhousing.label[14] = GuiLabel(108, 123, 115, 20, interiorID, false, UCDhousing.window[1])
	UCDhousing.label[15] = GuiLabel(108, 143, 115, 20, "nil", false, UCDhousing.window[1])
	UCDhousing.label[16] = GuiLabel(108, 163, 115, 20, "nil", false, UCDhousing.window[1])
	UCDhousing.label[17] = GuiLabel(0, 179, 471, 19, "__________________________________________________________________________________________", false, UCDhousing.window[1])
	guiLabelSetHorizontalAlign(UCDhousing.label[17], "center", false)
	UCDhousing.label[18] = GuiLabel(238, 23, 15, 160, "|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|", false, UCDhousing.window[1])

	local housingLabels1 = {UCDhousing.label[1], UCDhousing.label[2], UCDhousing.label[3], UCDhousing.label[4], UCDhousing.label[5], UCDhousing.label[6], UCDhousing.label[7], UCDhousing.label[8]}
	local housingLabels2 = {UCDhousing.label[9], UCDhousing.label[10], UCDhousing.label[11], UCDhousing.label[12], UCDhousing.label[13], UCDhousing.label[14], UCDhousing.label[15], UCDhousing.label[16], UCDhousing.label[17], UCDhousing.label[18]}
	
	for _, v in pairs(housingLabels1) do
		v:setFont("clear-normal")
		v:setHorizontalAlign("right", false)
		v:setVerticalAlign("center")
	end
	for _, v in pairs(housingLabels2) do
		v:setVerticalAlign("center") 
	end
	
	UCDhousing.button[1] = GuiButton(278, 33, 161, 60, "Purchase house", false, UCDhousing.window[1])
	UCDhousing.button[2] = GuiButton(278, 113, 161, 60, "Enter this house", false, UCDhousing.window[1])
	UCDhousing.edit[1]	 = GuiEdit(20, 212, 270, 44, "", false, UCDhousing.window[1])
	UCDhousing.button[3] = GuiButton(319, 212, 120, 44, "Set price", false, UCDhousing.window[1])
	UCDhousing.button[4] = GuiButton(20, 273, 94, 46, "Toggle sale", false, UCDhousing.window[1])
	UCDhousing.button[5] = GuiButton(129, 273, 94, 46, "Toggle open house", false, UCDhousing.window[1])
	UCDhousing.button[6] = GuiButton(235, 273, 94, 46, "Sell house to bank", false, UCDhousing.window[1])
	UCDhousing.button[7] = GuiButton(345, 273, 94, 46, "Close", false, UCDhousing.window[1])
	
	-- Check if the house is open, and set the text accordingly
	if (open == 1) then
		UCDhousing.label[15]:setText("Yes")
		UCDhousing.button[2]:setEnabled(true)
	else
		UCDhousing.label[15]:setText("No")
		UCDhousing.button[2]:setEnabled(false)
	end
	
	-- Check if the house is for sale, and set the text accordingly
	if (sale == 1) then
		UCDhousing.label[16]:setText("Yes")
		UCDhousing.button[1]:setEnabled(true)
	else
		UCDhousing.label[16]:setText("No")
		UCDhousing.button[1]:setEnabled(false)
	end
	
	-- If we have an owner
	if (localPlayerAccountName ~= "UCDhousing") then
		if (localPlayerAccountName == owner) then
			-- The owner must be able to enter his house, regardless of whether it's open or not
			UCDhousing.button[1]:setEnabled(false)
			UCDhousing.button[2]:setEnabled(true)
			UCDhousing.button[3]:setEnabled(true)
			UCDhousing.button[4]:setEnabled(true)
			UCDhousing.button[5]:setEnabled(true)
			if (not Resource.getFromName("UCDmarket") or Resource.getFromName("UCDmarket"):getState() ~= "running" or not root:getData("housing.rate")) then
				UCDhousing.button[6]:setEnabled(false)
			else
				UCDhousing.button[6]:setEnabled(true)
			end
		else
			UCDhousing.button[3]:setEnabled(false)
			UCDhousing.button[4]:setEnabled(false)
			UCDhousing.button[5]:setEnabled(false)
			UCDhousing.button[6]:setEnabled(false)
		end
	end
	
	-- We have to set this here so we don't have people trying to crash the database and fuck it up
	-- May have to add extra security measures and do double checks :/
	-- 14 because we have to account for commas and billions
	UCDhousing.edit[1]:setMaxLength(14)
	
	-- We have to disable this button regardless of whether the hit element was the owner or not
	--if (Resource("UCDmarket") and Resource("UCDmarket"):getState() ~= "running") then
	--	UCDhousing.button[6]:setEnabled(false)
	--end
	
	showCursor(true)
	addEventHandler("onClientGUIClick", UCDhousing.window[1], handleGUIInput)
end
addEvent("UCDhousing.createGUI", true)
addEventHandler("UCDhousing.createGUI", root, createGUI)

function closeGUI()
	if (source ~= localPlayer or not UCDhousing or not isElement(UCDhousing.window[1])) then return end
	if (isElement(UCDhousing.window[1])) then
		-- We destroy the confirmation window if it's active
		if (isElement(confirmation.window[1])) then
			confirmation.window[1]:destroy()
		end
		UCDhousing.window[1]:destroy()
	end
	if (isCursorShowing()) then
		showCursor(false)
	end
	removeHouseNotification()
	UCDhousing = nil
end
addEvent("UCDhousing.closeGUI", true)
addEventHandler("UCDhousing.closeGUI", root, closeGUI)

-- Add anti-spam here
--hasClicked = false
function handleGUIInput()
	-- So we can add a universal antispam/anticlick for the whole housing UI [we can have one statement instead of lots of nested ones within in check for source]
	if (not isElement(UCDhousing.window[1]) or source:getParent() ~= UCDhousing.window[1]) then return end
	--outputDebugString(UCDhousing.houseID[1])
	
	--if hasClicked == true then
	--	return
	--end
	
	-- Close
	if (source == UCDhousing.button[7]) then
		triggerEvent("UCDhousing.closeGUI", localPlayer)
	-- Enter house
	elseif (source == UCDhousing.button[2]) then
		if (UCDhousing.button[2]:getEnabled()) then
			local houseID = UCDhousing.houseID
			--local interiorID = getHouseData(houseID, "interiorID")
			outputDebugString("Entering house... ID = "..houseID)
			--triggerServerEvent("UCDhousing.enterHouse", localPlayer, houseID, interiorID)
			triggerServerEvent("UCDhousing.enterHouse", localPlayer, houseID)
			removeHouseNotification()
			triggerEvent("UCDhousing.closeGUI", localPlayer)
		end
	-- Purchase house
	elseif (source == UCDhousing.button[1]) then
		local houseID = UCDhousing.houseID
		--local housePrice = getHouseData(houseID, "currentPrice")
		local housePrice = UCDhousing.houseData[5]
		if (localPlayer:getMoney() >= housePrice) then
			-- Maybe we could make an export from this
			--createConfirmationWindow(houseID, "Are you sure you want to buy house\n "..getHouseData(houseID, "houseName").." [ID: "..houseID.."]\n for $"..exports.UCDutil:tocomma(housePrice).."?", purchaseHouse)
			createConfirmationWindow(houseID, "Are you sure you want to buy house\n "..UCDhousing.houseData[5].." [ID: "..houseID.."]\n for $"..exports.UCDutil:tocomma(housePrice).."?", purchaseHouse)
		else
			exports.UCDdx:new("You don't have enough money to buy this house!", 255, 0, 0)
		end
	-- Set house price
	elseif (source == UCDhousing.button[3]) then
		if (UCDhousing.button[3]:getEnabled()) then
			local houseID = UCDhousing.houseID
			local price = UCDhousing.edit[1]:getText()
			setHousePrice(houseID, price)
		end
	-- Toggle sale
	elseif (source == UCDhousing.button[4]) then
		if (UCDhousing.button[4]:getEnabled()) then
			local houseID = UCDhousing.houseID
			--local state = getHouseData(houseID, "sale")
			local state = UCDhousing.houseData[9]
			if (state == 1) then state = false else state = true end
			toggleSale(houseID, state)
		end
	-- Toggle open
	elseif (source == UCDhousing.button[5]) then
		if (UCDhousing.button[5]:getEnabled()) then
			local houseID = UCDhousing.houseID
			--local state = getHouseData(houseID, "open")
			local state = UCDhousing.houseData[8]
			if (state == 1) then state = false else state = true end
			toggleOpen(houseID, state)
		end
	-- Sell house to bank
	elseif (source == UCDhousing.button[6]) then
		if (UCDhousing.button[6]:getEnabled()) then
			--if (not Resource.getFromName("UCDmarket"))
			local houseID = UCDhousing.houseID
			--local price = getHouseData(houseID, "boughtForPrice")
			local price = UCDhousing.houseData[6]
			local rate = root:getData("housing.rate")
			createConfirmationWindow(houseID, "Current rate is "..tostring(rate).."% \nDo you want to sell your house for \n"..tostring(rate).."% of what it is worth [$"..exports.UCDutil:tocomma(tostring(math.floor(price * (rate / 100)))).."]?", sellHouseToBank)
			--sellHouseToBank(houseID)
		end
	end
	
	--hasClicked = true
	--setTimer(function () hasClicked = false end, 2000, 1)
end
--addEventHandler("onClientGUIClick", guiRoot, handleGUIInput)

function onClientGUIChanged()
	if (source:getParent() ~= UCDhousing.window[1]) then return end
	if (source == UCDhousing.edit[1]) then
		local text = UCDhousing.edit[1]:getText()
		--if (not text:find("%d")) then
		--	outputDebugString("strange char found")
		--end
		text = text:gsub(",", "")
		
		if (tonumber(text)) then
			UCDhousing.edit[1]:setText(exports.UCDutil:tocomma(tonumber(text)))
			--if (guiEditGetCaretIndex(UCDhousing.edit[1]) == string.len(UCDhousing.edit[1]:getText())) then
			outputDebugString(tostring(getKeyState("backspace")))
			if (not getKeyState("backspace")) then
				guiEditSetCaretIndex(UCDhousing.edit[1], string.len(UCDhousing.edit[1]:getText()))
			end
		end
	end
end
addEventHandler("onClientGUIChanged", guiRoot, onClientGUIChanged)

function toggleOpen(houseID, state)
	if (not houseID) then return false end
	--if (localPlayer:getData("accountName") ~= getHouseData(houseID, "owner")) then return false end
	if (localPlayer:getData("accountName") ~= UCDhousing.houseData[2]) then return false end
	
	UCDhousing.button[5]:setEnabled(false)
	triggerServerEvent("UCDhousing.toggleOpen", localPlayer, houseID, state)
end

function toggleSale(houseID, state)
	if (not houseID) then return false end
	--if (localPlayer:getData("accountName") ~= getHouseData(houseID, "owner")) then return false end
	if (localPlayer:getData("accountName") ~= UCDhousing.houseData[2]) then return false end
	
	UCDhousing.button[4]:setEnabled(false)
	triggerServerEvent("UCDhousing.toggleSale", localPlayer, houseID, state)
end

-- This is used for setting the price
function setHousePrice(houseID, price)
	--if (localPlayer:getData("accountName") ~= getHouseData(houseID, "owner")) then return false end -- The GUI should be disabled if you are not the owner, but a double check can't hurt for now
	if (localPlayer:getData("accountName") ~= UCDhousing.houseData[2]) then return false end -- The GUI should be disabled if you are not the owner, but a double check can't hurt for now
	local price = price:gsub(",", "")
	-- These checks are shit and should be refined
	if (price == "") or (not price) then
		exports.UCDdx:new("Do you really want to sell your house for nothing? I don't think so :)", 255, 0, 0)
		return false	
	end
	if (tonumber(price) == nil) then
		exports.UCDdx:new("Your new house price must be a number between 1 and 99,999,999!", 255, 0, 0)
		return false
	end
	-- The first check should have covered this, but we might as well leave it in here as I'm not sure if '-1' will constitute as a negative num
	if (string.find(tostring(price), "-")) then
		exports.UCDdx:new("Your new house price must be a number between 1 and 99,999,999!", 255, 0, 0)
		return false
	end

	-- Let's add an anti spam here because people will try to flood the database as a troll (hahaha so fucking funny you stupid fucks)
	UCDhousing.button[3]:setEnabled(false)
	triggerServerEvent("UCDhousing.setHousePrice", localPlayer, houseID, price)
end

function purchaseHouse(houseID, plr)
	-- The plr has already been established as the owner
	if (plr ~= localPlayer) then return false end
	-- A double check because the player can change their money while they have the GUI open
	--if (plr.money < getHouseData(houseID, "currentPrice")) then
	if (plr:getMoney() < UCDhousing.houseData[5]) then
		exports.UCDdx:new("You don't have enough money to buy this house!", 255, 0, 0)
		return false
	end
	
	UCDhousing.button[1]:setEnabled(false)
	triggerServerEvent("UCDhousing.purchaseHouse", localPlayer, houseID)
end

function sellHouseToBank(houseID, plr)
	if (plr ~= localPlayer) then return false end
	--if (localPlayer:getData("accountName") ~= getHouseData(houseID, "owner")) then return false end
	if (localPlayer:getData("accountName") ~= UCDhousing.houseData[2]) then return false end
	
	UCDhousing.button[6]:setEnabled(false)
	triggerServerEvent("UCDhousing.sellHouseToBank", localPlayer, houseID)
end

-- If we were to put this in an export
	-- name = sourceResource:getName()
	-- call[name]:func()
function createConfirmationWindow(houseID, text, func, arg1, arg2, arg3)
	if (isElement(confirmation.window[1])) then return false end
	confirmation = {window={}, label={}, button={}}
	
	confirmation.window[1] = GuiWindow(819, 425, 282, 132, "UCD | Housing - Confirmation", false)
	guiWindowSetSizable(confirmation.window[1], false)

	confirmation.label[1] = GuiLabel(10, 26, 262, 44, tostring(text), false, confirmation.window[1])
	guiLabelSetHorizontalAlign(confirmation.label[1], "center", false)
	confirmation.button[1] = GuiButton(47, 85, 76, 36, "Yes", false, confirmation.window[1])
	confirmation.button[2] = GuiButton(164, 85, 76, 36, "No", false, confirmation.window[1])
	
	-- The purchase house bit underneath is not part of this general function.
	function confirmationWindowClick()
		if (source == confirmation.button[1]) then
			if (isElement(confirmation.window[1])) then
				removeEventHandler("onClientGUIClick", confirmation.window[1], confirmationWindowClick)
				confirmation.window[1]:destroy()
			end
			
			-- Let's account for multiple functions and any additional arguments they may encounter
			if (arg1 and not arg2) then
				func(houseID, localPlayer, arg1)
			elseif (arg1 and arg2 and not arg3) then
				func(houseID, localPlayer, arg1, arg2)
			elseif (arg1 and arg2 and arg3) then
				func(houseID, localPlayer, arg1, arg2, arg3)
			else
				func(houseID, localPlayer)
			end
			
			return true
		elseif (source == confirmation.button[2]) then
			if (isElement(confirmation.window[1])) then
				removeEventHandler("onClientGUIClick", confirmation.window[1], confirmationWindowClick)
				confirmation.window[1]:destroy()
			end
			return false
		end
	end
	addEventHandler("onClientGUIClick", confirmation.window[1], confirmationWindowClick)
end

addEventHandler("onClientResourceStop", resourceRoot, function () removeHouseNotification() end)
