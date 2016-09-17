local marker = {}
local sx, sy = guiGetScreenSize()

local bailPoints = {
	--{1369.2296, -937.5957, 34.1875},
	{256.9531, 69.5891, 1003.6406, 50000, 6},
}

--[[
	Populate gridlist with players that are wanted!
--]]

function processUI()
	bailWindow = guiCreateWindow(669, 310, 415, 477, "Bail System", false)
	guiWindowSetSizable(bailWindow, false)
	guiSetAlpha(bailWindow, 1.00)
	showCursor(false)
	guiSetVisible(bailWindow, false)
	
	bailInfoLabel = guiCreateLabel(10, 22, 401, 34, "Here you can bail your friend out, simply find his name here and you can\n see the cost down below and then press bail to bail her", false, bailWindow)
	bailGridlist = guiCreateGridList(9, 56, 347, 374, false, bailWindow)
	acceptButton = guiCreateButton(9, 434, 88, 33, "Bail", false, bailWindow)
	closeButton = guiCreateButton(258, 434, 88, 33, "Regret", false, bailWindow)
	priceLabel = guiCreateLabel(103, 440, 67, 17, "$2,500", false, bailWindow)

	playerColumn = guiGridListAddColumn(bailGridlist, "Player", 0.5)
	wantedColumn = guiGridListAddColumn(bailGridlist, "WL", 0.5)
	guiSetFont(acceptButton, "default-bold-small")
	guiSetFont(closeButton, "default-bold-small")
	guiLabelSetColor(priceLabel, 0, 225, 0)
	
	guiSetProperty(acceptButton, "NormalTextColour", "FFAAAAAA")
	guiSetProperty(closeButton, "NormalTextColour", "FFAAAAAA")
	
	addEventHandler("onClientGUIClick", closeButton, closeUI)
	addEventHandler("onClientGUIClick", acceptButton, attemptBail)
end
addEventHandler("onClientResourceStart", resourceRoot, processUI)

function closeUI()
	if (not guiGetVisible(bailWindow)) then return end
	guiSetVisible(bailWindow, false)
	showCursor(false)
end

function onStart()
	for ind, dat in pairs(bailPoints) do
		marker = createMarker(dat[1], dat[2], dat[3] - 1, "cylinder", 2, 0, 225, 0, 255)
		setElementInterior(marker, dat[5])
		setElementDimension(marker, dat[4])
		addEventHandler("onClientMarkerHit", marker, enteredMarker)
	end
end
addEventHandler("onClientResourceStart", resourceRoot, onStart)

function enteredMarker(player)
	if (player and isElement(player) and getElementType(player) == "player") then
		if (isPedInVehicle(player)) then return end
		if (player ~= localPlayer) then return end
		
		-- something i cant remember
		-- fuck i dont remember how to code lol
		guiSetVisible(bailWindow, true)
		showCursor(true)
		
		guiGridListClear(bailGridlist)
		guiSetText(priceLabel, "$"..0)
		for ind, plr in pairs(getElementsByType("player")) do
			triggerServerEvent("UCDbail.requestPeople", root)
		end
	end
end

function attemptBail()
	local a, b = guiGridListGetSelectedItem(bailGridlist)
	local player = guiGridListGetItemText(bailGridlist, a, b)
	outputChatBox("Success, "..player.." is in jail!", 255, 0, 0)
end

function outputWanted(wantedPeople)
	guiGridListClear(bailGridlist)
	for ind, dat in pairs(wantedPeople) do
		local row = guiGridListAddRow(bailGridlist)
		guiGridListSetItemText(bailGridlist, row, playerColumn, dat[1], false, false)
		guiGridListSetItemText(bailGridlist, row, wantedColumn, tostring(dat[2]), false, false)
	end
end
addEvent("UCDbail.outputWanted", true)
addEventHandler("UCDbail.outputWanted", root, outputWanted)