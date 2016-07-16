local MDT = {checkbox = {}, label = {}, button = {}}
local cursor = false
local blips = {}
local filters
local players
local players2 = {}
local refreshTimer
local refreshTimer2
local markAll = false

function createGUI()
	MDT.window = GuiWindow(691, 336, 555, 402, "UCD | Mobile Data Terminal (MDT)", false)
	MDT.window.visible = false
	MDT.window.sizable = false
	MDT.window.alpha = 1
	exports.UCDutil:centerWindow(MDT.window)

	MDT.gridlist = GuiGridList(9, 47, 536, 185, false, MDT.window)
	guiGridListAddColumn(MDT.gridlist, "Player", 0.2)
	guiGridListAddColumn(MDT.gridlist, "WP", 0.15)
	guiGridListAddColumn(MDT.gridlist, "Loc", 0.15)
	guiGridListAddColumn(MDT.gridlist, "Transport", 0.2)
	guiGridListAddColumn(MDT.gridlist, "Distance", 0.2)
	guiGridListSetSortingEnabled(MDT.gridlist, false)

	MDT.label[1] = GuiLabel(11, 24, 534, 18, "Click a player's name to toggle marking", false, MDT.window)
	guiLabelSetHorizontalAlign(MDT.label[1], "center", false)
	guiLabelSetVerticalAlign(MDT.label[1], "center")

	MDT.button[1] = GuiButton(10, 350, 174, 43, "Mark All", false, MDT.window)
	MDT.button[2] = GuiButton(190, 350, 174, 43, "Unmark All", false, MDT.window)
	MDT.button[3] = GuiButton(371, 350, 174, 43, "Close", false, MDT.window)

	MDT.label[2] = GuiLabel(17, 237, 157, 20, "Filters", false, MDT.window)
	guiSetFont(MDT.label[2], "clear-normal")

	MDT.checkbox[1] = GuiCheckBox(27, 260, 15, 15, "", false, false, MDT.window)
	MDT.label[3] = GuiLabel(52, 260, 81, 15, "Car", false, MDT.window)
	
	MDT.checkbox[2] = GuiCheckBox(27, 280, 15, 15, "", false, false, MDT.window)
	MDT.label[4] = GuiLabel(52, 280, 81, 15, "Bike", false, MDT.window)
	
	MDT.checkbox[3] = GuiCheckBox(27, 300, 15, 15, "", false, false, MDT.window)
	MDT.label[5] = GuiLabel(52, 300, 81, 15, "Plane", false, MDT.window)
	
	MDT.checkbox[4] = GuiCheckBox(27, 321, 15, 15, "", false, false, MDT.window)
	MDT.label[6] = GuiLabel(52, 321, 81, 15, "On foot", false, MDT.window)
	
	MDT.checkbox[5] = GuiCheckBox(143, 260, 15, 15, "", false, false, MDT.window)
	MDT.label[7] = GuiLabel(168, 260, 81, 15, "< 500m", false, MDT.window)
	
	MDT.checkbox[8] = GuiCheckBox(143, 321, 15, 15, "", false, false, MDT.window)
	MDT.label[8] = GuiLabel(168, 280, 81, 15, "< 1000m", false, MDT.window)
	
	MDT.checkbox[6] = GuiCheckBox(143, 280, 15, 15, "", false, false, MDT.window)
	MDT.label[9] = GuiLabel(168, 300, 81, 15, "< 2000m", false, MDT.window)
	
	MDT.checkbox[7] = GuiCheckBox(143, 300, 15, 15, "", false, false, MDT.window)
	MDT.label[10] = GuiLabel(168, 321, 81, 15, "< 3000m", false, MDT.window)
	
	MDT.checkbox[9] = GuiCheckBox(259, 260, 15, 15, "", false, false, MDT.window)
	MDT.label[11] = GuiLabel(284, 260, 81, 15, "> 1 star", false, MDT.window)
	
	MDT.checkbox[10] = GuiCheckBox(259, 280, 15, 15, "", false, false, MDT.window)
	MDT.label[12] = GuiLabel(284, 280, 81, 15, ">= 3 stars", false, MDT.window)
	
	MDT.checkbox[11] = GuiCheckBox(259, 300, 15, 15, "", false, false, MDT.window)
	MDT.label[13] = GuiLabel(284, 300, 81, 15, ">= 5 stars", false, MDT.window)
	
	MDT.checkbox[12] = GuiCheckBox(259, 321, 15, 15, "", false, false, MDT.window)
	MDT.label[14] = GuiLabel(284, 321, 81, 15, "6+ stars only", false, MDT.window)
	
	MDT.checkbox[13] = GuiCheckBox(375, 260, 15, 15, "", false, false, MDT.window)
	MDT.label[15] = GuiLabel(400, 260, 81, 15, "Los Santos", false, MDT.window)
	
	MDT.checkbox[14] = GuiCheckBox(375, 280, 15, 15, "", false, false, MDT.window)
	MDT.label[16] = GuiLabel(400, 280, 81, 15, "San Fierro", false, MDT.window)
	
	MDT.checkbox[15] = GuiCheckBox(375, 300, 15, 15, "", false, false, MDT.window)
	MDT.label[17] = GuiLabel(400, 300, 81, 15, "Las Venturas", false, MDT.window)
	
	MDT.checkbox[16] = GuiCheckBox(375, 321, 15, 15, "", false, false, MDT.window)
	MDT.label[18] = GuiLabel(400, 321, 81, 15, "Rural areas", false, MDT.window)
end
createGUI()

function toggleGUI(force)
	if (force ~= true) then
		if (localPlayer.team.name ~= "Law") then
			MDT.window.visible = false
			showCursor(false)
			cursor = false
			onUnmarkAll()
			return false
		end
	end
	MDT.window.visible = not MDT.window.visible
	cursor = not cursor
	showCursor(cursor)
end
addEventHandler("onClientGUIClick", MDT.button[3], toggleGUI, false)
addCommandHandler("policecomputer", toggleGUI)
addCommandHandler("mdt", toggleGUI)
bindKey("F5", "up", "mdt")
addEvent("onClientPlayerGetJob", true)
addEventHandler("onClientPlayerGetJob", root, 
	function () 
		if (source == localPlayer and source.team.name ~= "Law") then 
			toggleGUI(true) 
		end 
		if (source == localPlayer and source.team.name == "Law") then
			if (not refreshTimer2 or not isTimer(refreshTimer2)) then
				refreshTimer2 = Timer(createGridList, 5000, 0)
			end
		end
	end
)

addEventHandler("onClientResourceStart", resourceRoot, 
	function ()
		if (localPlayer.team.name == "Law") then
			refreshTimer2 = Timer(createGridList, 5000, 0)
		end
	end
)

function onEditFilter()
	filters = {["c"] = {}, ["v"] = {}}
	-- WL filter
	if (MDT.checkbox[12].selected) then -- 6 stars plus
		filters["w"] = 6
	elseif (MDT.checkbox[11].selected) then -- 5 stars
		filters["w"] = 5
	elseif (MDT.checkbox[10].selected) then -- 3 stars
		filters["w"] = 3
	elseif (MDT.checkbox[9].selected) then -- > 1 star
		filters["w"] = 2
	end
	-- Distance filter
	if (MDT.checkbox[7].selected) then
		filters["d"] = 3000
	elseif (MDT.checkbox[6].selected) then
		filters["d"] = 2000
	elseif (MDT.checkbox[8].selected) then
		filters["d"] = 1000
	elseif (MDT.checkbox[5].selected) then
		filters["d"] = 500
	end
	-- City filter
	if (MDT.checkbox[16].selected) then
		table.insert(filters["c"], "WS")
		table.insert(filters["c"], "TR")
		table.insert(filters["c"], "BC")
		table.insert(filters["c"], "SA")
		table.insert(filters["c"], "RC")
		table.insert(filters["c"], "FC")
	end
	if (MDT.checkbox[15].selected) then
		table.insert(filters["c"], "LV")
	end
	if (MDT.checkbox[14].selected) then
		table.insert(filters["c"], "SF")
	end
	if (MDT.checkbox[13].selected) then
		table.insert(filters["c"], "LS")
	end
	-- Vehicle filter
	if (MDT.checkbox[5].selected) then
		table.insert(filters["v"], "N/A")
	end
	if (MDT.checkbox[2].selected) then
		table.insert(filters["v"], "Bike")
	end
	if (MDT.checkbox[3].selected) then
		table.insert(filters["v"], "Air")
	end
	if (MDT.checkbox[1].selected) then
		table.insert(filters["v"], "Automobile")
	end
	applyFilters()
end
for i = 1, #MDT.checkbox do
	addEventHandler("onClientGUIClick", MDT.checkbox[i], onEditFilter, false)
end

function onMarkPlayer()
	local row = guiGridListGetSelectedItem(MDT.gridlist)
	if (row and row ~= -1) then
		local plr = guiGridListGetItemData(MDT.gridlist, row, 1)
		local isMarked = false
		for k, v in pairs(players2) do
			if (v == plr) then
				isMarked = k
				break
			end
		end
		if (isMarked) then
			table.remove(players2, k)
			refreshBlips()
			return
		end
		
		table.insert(players2, plr)
		refreshBlips()
	end
end
addEventHandler("onClientGUIClick", MDT.gridlist, onMarkPlayer)

function onMarkAll()
	onEditFilter()
	--applyFilters()
	--refreshBlips()
	if (not refreshTimer or not isTimer(refreshTimer)) then
		refreshTimer = Timer(applyFilters, 2000, 0)
	end
	markAll = true
	players2 = players
	refreshBlips()
end
addEventHandler("onClientGUIClick", MDT.button[1], onMarkAll, false)

function onUnmarkAll()
	for plr, blip in pairs(blips) do
		blip:destroy()
		blips[plr] = nil
	end
	if (refreshTimer or isTimer(refreshTimer)) then
		refreshTimer:destroy()
		refreshTimer = nil
	end
	markAll = false
	players2 = {}
end
addEventHandler("onClientGUIClick", MDT.button[2], onUnmarkAll, false)

function getAllWantedPlayers()
	local temp = {}
	for _, plr in ipairs(Element.getAllByType("player")) do
		if (plr:getData("w") and plr:getData("w") > 0) then
			table.insert(temp, plr)
		end
	end
	return temp
end

function applyFilters()
	local filterCount = 0
	
	if (filters["c"] and #filters["c"] > 0) then
		filterCount = filterCount + 1
	end
	if (filters["v"] and #filters["v"] > 0) then
		filterCount = filterCount + 1
	end
	if (filters["d"]) then
		filterCount = filterCount + 1
	end
	if (filters["w"]) then
		filterCount = filterCount + 1
	end
	--outputDebugString("filterCount > "..filterCount)
	
	players = {}
	
	for _, plr in ipairs(getAllWantedPlayers()) do
		local w, v, d, c
		if (filters["w"]) then
			if (plr:getData("w") >= filters["w"]) then
				w = true
			end
		else
			w = true
		end
		if (filters["v"]) then
			if (plr.vehicle) then
				local type1 = getVehicleType(plr.vehicle)
				local type2
				if (type1 == "Automobile" or type1 == "Monster Truck" or type1 == "Boat") then
					type2 = "Automobile"
				elseif (type1 == "Bike" or type1 == "BMX" or type1 == "Quad" or type1 == "") then
					type2 = "Bike"
				elseif (type1 == "Plane" or type1 == "Helicopter") then
					type2 = "Air"
				else
					type2 = "Automobile"
				end
				local vehtype = false
				for k, v in pairs(filters["v"]) do
					if (v == type2) then
						vehtype = true
						break
					end
				end
				if (vehtype) then
					v = true
				end
			else
				local notInCar = false
				for k, v in pairs(filters["v"]) do
					if (v == "N/A") then
						notInCar = true
						break
					end
				end
				if (notInCar) then
					v = true
				end
			end
			if (#filters["v"] == 0) then
				v = true
			end
		else
			v = true
		end
		if (filters["d"]) then
			local dist = math.floor(getDistanceBetweenPoints3D(localPlayer.position, plr.position))
			if (dist <= filters["d"]) then
				d = true
			end
		else
			d = true
		end
		if (filters["c"]) then
			local x, y, z = plr.position.x, plr.position.y, plr.position.z
			local zone = exports.UCDutil:getCityZoneFromXYZ(x, y, z)
			--outputDebugString(zone)
			local zonef = false
			for _, v in ipairs(filters["c"]) do
				if (v == zone) then
					zonef = true
					break
				end
			end
			if (zonef) then
				c = true
			end
			if (#filters["c"] == 0) then
				c = true
			end
		else
			c = true
		end
		if (w and v and c and d) then
			table.insert(players, plr)
		end
	end
	createGridList()
	refreshBlips()
end

function createGridList()
	MDT.gridlist:clear()
	if (players) then
		for _, plr in ipairs(players) do
			local row = guiGridListAddRow(MDT.gridlist)
			local x, y, z = plr.position.x, plr.position.y, plr.position.z
			local type2
			if (plr.vehicle) then
				local type1 = getVehicleType(plr.vehicle)
				if (type1 == "Automobile" or type1 == "Monster Truck" or type1 == "Boat") then
					type2 = "Automobile"
				elseif (type1 == "Bike" or type1 == "BMX" or type1 == "Quad" or type1 == "") then
					type2 = "Bike"
				elseif (type1 == "Plane" or type1 == "Helicopter") then
					type2 = "Air"
				else
					type2 = "Automobile"
				end
			else
				type2 = "On foot"
			end
			
			guiGridListSetItemText(MDT.gridlist, row, 1, tostring(plr.name), false, false)
			guiGridListSetItemText(MDT.gridlist, row, 2, tostring(plr:getData("w")), false, false)
			guiGridListSetItemText(MDT.gridlist, row, 3, tostring(exports.UCDutil:getCityZoneFromXYZ(x, y, z)), false, false)
			guiGridListSetItemText(MDT.gridlist, row, 4, tostring(type2), false, false)
			guiGridListSetItemText(MDT.gridlist, row, 5, tostring(math.floor(getDistanceBetweenPoints3D(localPlayer.position, x, y, z))), false, false)
			guiGridListSetItemData(MDT.gridlist, row, 1, plr)
		end
	else
		players = getAllWantedPlayers()
		createGridList()
	end
end
createGridList()

function onPlayerWPChange()
	applyFilters()
end
addEvent("UCDmdt.onPlayerWPChange", true)
addEventHandler("UCDmdt.onPlayerWPChange", root, onPlayerWPChange)

function refreshBlips()
	for _, plr in ipairs(Element.getAllByType("player")) do
		if (blips[plr]) then
			blips[plr]:destroy()
			blips[plr] = nil
		end
	end
	if (players2) then
		--if (markAll) then
			for _, plr in ipairs(players2) do
				blips[plr] = Blip.createAttachedTo(plr, 20)
			end
		--end
	else
		--players = getAllWantedPlayers()
		--refreshBlips()
	end
end

addEventHandler("onClientPlayerQuit", root, 
	function ()
		if (blips[source]) then
			blips[source]:destroy()
			blips[source] = nil
		end
		for i = 0, guiGridListGetRowCount(MDT.gridlist) - 1 do
			local plr = guiGridListGetItemData(MDT.gridlist, i, 1)
			if (plr == source) then
				guiGridListRemoveRow(i)
			end
		end
	end
)
