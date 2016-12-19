-- Warp panel by HellStunter
local positions = {
	{1707.2239, 1607.8732, 10.0156, 270.94384765625, "Las Venturas Airport"},
	{2233.646, 2453.5923, 10.8245, 177.72918701172, "Las Venturas Police Department"},
	{214.1687, 1911.5682, 17.6406, 179.93859863281, "Area 51"},
	{-893.0352, 1998.78, 60.9141, 249.41040039063, "The Sherman Dam"},
	{-1468.334, 1490.0498, 8.2578, 269.69522094727, "San Fierro Da-Nang Boys Ship"},
	{-2655.8728, 1596.3607, 64.5165, 86.292449951172, "San Fierro Gant Bridge"},
	{-1615.0035, 667.2029, 7.1875, 268.8996887207, "San Fierro Police Department"},
	{-2897.3108, 457.6115, 4.9141, 268.99917602539, "San Fierro Docks"},
	{-2667.3772, 593.3926, 14.4531, 181.69494628906, "San Fierro Hospital"},
	{-1666.1599, -401.2081, 14.1484, 134.51873779297, "San Fierro Airport"},
	{-2238.6616, -1731.6495, 480.4632, 49.358123779297, "Mount Chillad"},
	{482.1791, -1853.8127, 3.7268, 359.69595336914, "Santa Maria Beach"},
	{1255.2522, -2030.9908, 59.5556, 84.657928466797, "San Andreas Presidental House"},
	{1962.8151, -2194.1438, 13.5469, 89.033111572266, "Los Santos Airport"},
	{1539.0527, -1674.7443, 13.5469, 89.033111572266, "Los Santos Police Department"},
	{1189.0702, -1324.7906, 13.5671, 269.82861328125, "All Saints Hospital"},
	{2011.6215, -1435.8839, 13.5547, 134.87286376953, "Jefferson Hospital"},
	{635.91784667969, -571.85083007813, 16.3359375, 269.90609741211, "Dillimore Police Department"},
	{2231.7734375, -28.512060165405, 26.3359375, 266.68014526367, "Palomino Creek"},
	{2523.5927734375, 2796.7934570313, 10.8203125, 179.57482910156, "K.A.C.C Military Fuels"},
	{318.58770751953, 2500.8020019531, 16.484375, 269.68524169922, "Verdant Meadows"},
	{-2259.8310546875, 2304.9401855469, 4.8202133178711, 354.60308837891, "Bayside Marina"}, 
}

local window = guiCreateWindow(574, 151, 434, 592, "UCD | Admin - Warp Points", false)
guiWindowSetSizable(window, false)
guiSetVisible(window, false)
exports.UCDutil:centerWindow(window)

local grid = guiCreateGridList(15, 29, 409, 473, false, window)
guiGridListAddColumn(grid, "Location name:", 0.9)

for i, v in pairs(positions) do
	local row = guiGridListAddRow(grid)
	guiGridListSetItemText(grid, row, 1, v[5], false, false)
	guiGridListSetItemData(grid, row, 1, i, false, false)
end

local warpButton = guiCreateButton(35, 512, 153, 62, "Warp", false, window)
local cancelButton = guiCreateButton(255, 512, 153, 62, "Close", false, window)
  
function toggleWPGUI()
  guiSetVisible(window, not guiGetVisible(window))
  showCursor(guiGetVisible(window))
 end
addEvent("UCDadmin.onToggleWPGUI", true)
addEventHandler("UCDadmin.onToggleWPGUI", resourceRoot, toggleWPGUI)

function onWPButtonClick()
    if (source == warpButton) then
		local i = guiGridListGetItemData(grid, guiGridListGetSelectedItem(grid))
		if (not i) then
			exports.UCDdx:new("Please choose a destination", 255, 0, 0)
			return
		end
	    local x, y, z, r = positions[i][1], positions[i][2], positions[i][3], positions[i][4]
		local element = localPlayer
		if (isPedInVehicle(element)) then
			element = getPedOccupiedVehicle(element)
			if (getVehicleController(element) ~= localPlayer) then
				exports.UCDdx:new("You must be the driver in order to warp this vehicle", 255, 0, 0)
				return
			end
		end
		setElementPosition(element, x, y, z)
		setElementRotation(element, 0, 0, r)
	    guiSetVisible(window, false)
		if (not adminPanel.window.visible) then
			showCursor(false)
		end
		exports.UCDdx:new("You have warped to "..tostring(guiGridListGetItemText(grid, guiGridListGetSelectedItem(grid))), 0, 255, 0)
	elseif (source == cancelButton) then
	    guiSetVisible(window, false)
		if (not adminPanel.window.visible) then
			showCursor(false)
		end
	end
end
addEventHandler("onClientGUIClick", warpButton, onWPButtonClick, false)
addEventHandler("onClientGUIClick", cancelButton, onWPButtonClick, false)