-- Warp points by HellStunter
local positions = 
{
	["LV Airport"] = {1707.2239, 1607.8732, 10.0156},
	["Restricted Area"] = {214.1687, 1911.5682, 17.6406},
	["The Sherman Dam"] = {-893.0352, 1998.78, 60.9141},
	["SF Ship"] = {-1468.334, 1490.0498, 8.2578},
	["SF Gant Bridge"] = {-2655.8728, 1596.3607, 64.5165},
	["SF Police Department"] = {-1615.0035, 667.2029, 7.1875},
	["SF Docks"] = {-2897.3108, 457.6115, 4.9141},
	["SF Hospital"] = {-2667.3772, 593.3926, 14.4531},
	["SF Airport"] = {-1666.1599, -401.2081, 14.1484},
	["Mount Chillad"] = {-2238.6616, -1731.6495, 480.4632},
	["Santa Maria Beach"] = {482.1791, -1853.8127, 3.7268},
	["White House"] = {1255.2522, -2030.9908, 59.5556},
	["LS Airport"] = {1962.8151, -2194.1438, 13.5469},
	["LS Police Department"] = {1539.0527, -1674.7443, 13.5469},
	["LS All Saints Hospital"] = {1189.0702, -1324.7906, 13.5671},
	["LS Jefferson Hospital"] = {2011.6215, -1435.8839, 13.5547},
	["Dillimore"] = {648.8795, -561.3219, 16.2489},
	["Palomino Creek"] = {2349.6997, 81.1277, 26.4844},
	["LV Police Department"] = {2233.646, 2453.5923, 10.8245},
	["Spinybed"] = {2481.0706, 2751.9346, 10.8203},
	["Verdant Meadows"] = {399.7484, 2528.8411, 16.5755},
	["Bayside Marina"] = {-2269.199, 2347.9468, 4.8202}, 
}

local window = guiCreateWindow(574, 151, 434, 592, "UCD Admin | Warp", false)
guiWindowSetSizable(window, false)
local sw, sh = guiGetScreenSize()
guiSetPosition(window, (sw-434)/2, (sh-592)/2, false)

local grid = guiCreateGridList(15, 29, 409, 473, false, window)
guiGridListAddColumn(grid, "Location", 0.9)

for locName, locPos in pairs(positions) do
	local row = guiGridListAddRow(grid)
	guiGridListSetItemText(grid, row, 1, locName, false, false)
end

local button = guiCreateButton(35, 512, 153, 62, "Warp", false, window)
local Exit = guiCreateButton(255, 512, 153, 62, "Close", false, window)
guiSetVisible(window, false)	 
  
function showGUI()
  guiSetVisible(window, not guiGetVisible(window))
  showCursor(guiGetVisible(window))
 end
addEvent("showGUI", true)
addEventHandler("showGUI", getRootElement(), showGUI)

function onClick()
    if (source == button) then
		local locName = guiGridListGetItemText(grid, guiGridListGetSelectedItem(grid))
	    local x, y, z = positions[locName][1], positions[locName][2], positions[locName][3]
		local element = localPlayer
		if (isPedInVehicle(element)) then
			element = getPedOccupiedVehicle(element)
			if (getVehicleOccupant(element) ~= localPlayer) then
				exports.UCDdx:new("You must be the driver in order to warp your vehicle", 255, 0, 0)
				return
			end
		end
		setElementPosition(element, x, y, z)
	    guiSetVisible(window, false)
		showCursor(false)
	elseif (source == Exit) then
	    guiSetVisible(window, false)
		showCursor(false)
	end
end
addEventHandler("onClientGUIClick", root, onClick)