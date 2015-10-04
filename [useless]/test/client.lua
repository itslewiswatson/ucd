
warpLocations = {
	[1] = {0, 0, 1179.73, -1328.07, 14.18, "Los Santos Hospital"},
	[2] = {0, 0, 2041.48, -1425.96, 17.16, "Los Santos Jefferson Hospital"},
	[3] = {0, 0, -2641.06, 630.99, 14.45, "San Fierro Hospital"},
	[4] = {0, 0, 1615.27, 1821.87, 10.82, "Las Venturas Hospital"},
	[5] = {0, 0, 1958.46, -2188.22, 13.54, "Los Santos Airport"},
	[6] = {0, 0, -1472.21, -269.55, 14.14, "San Fierro Airport"},
	[7] = {0, 0, 1714.05, 1510.12, 10.79, "Las Venturas Airport"},
	[8] = {0, 0, 1529.64, -1630.67, 13.38, "Los Santos LSPD"},
	[9] = {0, 0, -1610.21, 717.19, 12.81, "San Fierro SFPD"},
	[10] = {0, 0, 2282.27, 2423.78, 10.82, "Las Venturas LVPD"},
	[12] = {0, 0, -2262.96, -1701.6, 479.91, "Mount Chilliad"},
	[13] = {0, 0, -1941.48, 2396.00, 49.49, "Drug store"},
	[14] = {0, 11, 349.07, -2812.09, 46.24, "Maze"},
	[15] = {0, 0, 2012.699, -3542.1001, 15.3, "Dice"},
	[16] = {0, 0, 1820.51, -3116.96, 1.21, "Admin Island"},
	[17] = {0, 0, 180.72, 1930.26, 17.96, "MF Base"},
	[18] = {0, 0, 1827.47, -1329.44, 13.46, "SWAT Base"},
	[19] = {0, 0, 2515.06, -2684.76, 13.6, "LS Docks"},
	[20] = {0, 0, 0, 0, 3, "GG"},
}

local window = guiCreateWindow(825, 302, 270, 381, "NGC ~ Warp Locations", false)
guiWindowSetSizable(window, false)
guiSetVisible(window, false)
local screenW,screenH = guiGetScreenSize()
local windowW,windowH = guiGetSize(window, false)
local x, y = (screenW - windowW) / 2, (screenH - windowH) / 2
guiSetPosition(window, x, y, false)
local warp = guiCreateButton(12, 323, 111, 40, "Warp", false, window)
local cancel = guiCreateButton(142, 323, 111, 40, "Cancel", false, window)
local warpsgrid = guiCreateGridList(12, 26, 243, 282, false, window)
local column1 = guiGridListAddColumn(warpsgrid, "#", 0.13)
local column2 = guiGridListAddColumn(warpsgrid, "Place:", 0.69)

for i, v in ipairs(warpLocations) do
	local warpName = v[6]
	local row = guiGridListAddRow(warpsgrid)
	guiGridListSetItemText(warpsgrid, row, column1, i, false, false)
	guiGridListSetItemText(warpsgrid, row, column2, warpName, false, false)
	outputDebugString(i)
end

function openUI()
	if (getTeamName(getPlayerTeam(localPlayer)) == "Admins")  then
		if (guiGetVisible(window)) then
			guiSetVisible(window, false)
			showCursor(false)
		else
			guiSetVisible(window, true)
			showCursor(true)
		end
	end
end
addCommandHandler("wp", openUI)

function closeUI()
	guiSetVisible(window, false)
	showCursor(false)
end
addEventHandler("onClientGUIClick", cancel, closeUI)

function warpToLoc()
	local warpID = guiGridListGetItemText(warpsgrid, guiGridListGetSelectedItem(warpsgrid), 1)
	local i, d, x, y, z, name = unpack(warpLocations[tonumber(warpID)])
	setElementPosition(localPlayer, x, y, z)
	exports.server:setClientPlayerInterior(localPlayer, i)
	exports.server:setClientPlayerDimension(thePlayer, d)
	guiSetVisible(window, false)
	showCursor(false)
end
addEventHandler("onClientGUIClick", warp, warpToLoc, false)




