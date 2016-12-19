Housing = {}
Housing.cache = {}
Housing.blips = {}
Housing.open = false

function Housing.create()
	phone.housing = {label = {}}
	
	phone.housing.gridlist = guiCreateGridList(27, 96, 254, 207, false, phone.image["phone_window"])
	phone.housing.gridlist:addColumn("House ID", 0.2)
	phone.housing.gridlist:addColumn("House", 0.5)
	phone.housing.gridlist:addColumn("Location", 0.2)
	guiGridListSetSortingEnabled(phone.housing.gridlist, false)
	
	phone.housing.button = GuiButton(39, 484, 232, 37, "Toggle Marking", false, phone.image["phone_window"])
	
	phone.housing.label["OwnedHouses"] = GuiLabel(27, 303, 254, 15, "Owned Houses: ", false, phone.image["phone_window"])
	phone.housing.label["HouseName"] = GuiLabel(27, 322, 254, 23, "House Name: ", false, phone.image["phone_window"])
	phone.housing.label["InteriorID"] = GuiLabel(27, 345, 254, 23, "Interior ID:", false, phone.image["phone_window"])
	phone.housing.label["InitialPrice"] = GuiLabel(27, 368, 254, 23, "Initial Price:", false, phone.image["phone_window"])
	phone.housing.label["BoughtFor"] = GuiLabel(27, 391, 254, 23, "Bought For:", false, phone.image["phone_window"])
	phone.housing.label["CurrentPrice"] = GuiLabel(27, 414, 254, 23, "Current Price:", false, phone.image["phone_window"])
	phone.housing.label["Sale"] = GuiLabel(27, 437, 254, 23, "Sale:", false, phone.image["phone_window"])
	phone.housing.label["Open"] = GuiLabel(27, 460, 254, 23, "Open:", false, phone.image["phone_window"])
	
	guiLabelSetHorizontalAlign(phone.housing.label["OwnedHouses"], "center", false)
	guiSetFont(phone.housing.label["OwnedHouses"], "default-bold-small")
	
	Housing.all = {
		phone.housing.gridlist, phone.housing.label["HouseName"], phone.housing.label["InteriorID"], phone.housing.label["InitialPrice"],
		phone.housing.label["BoughtFor"], phone.housing.label["CurrentPrice"], phone.housing.label["Sale"], phone.housing.label["Open"],
		phone.housing.label["OwnedHouses"], phone.housing.button
	}
	for _, gui in pairs(Housing.all) do
		gui.visible = false
	end
end
Housing.create()

function Housing.toggle()
	for _, gui in pairs(Housing.all) do
		gui.visible = not gui.visible
		Housing.open = gui.visible
	end
end

function Housing.populate(cache)
	phone.housing.gridlist:clear()
	--Housing.destroyAllBlips()
	
	local checkBlips = {} -- Use this to retain blips, even when a house sells
	local houseCount = 0
	for houseID, data in pairs(cache) do
		checkBlips[houseID] = true
		
		local zone
		if (not exports.UCDutil or not exports.UCDutil:getCityZoneFromXYZ(data.Loc.x, data.Loc.y, data.Loc.z)) then
			zone = "SA"
		else
			zone = exports.UCDutil:getCityZoneFromXYZ(data.Loc.x, data.Loc.y, data.Loc.z)
		end
		
		local row = phone.housing.gridlist:addRow(houseID, data.HouseName, zone)
		guiGridListSetItemData(phone.housing.gridlist, row, 1, houseID)
		Housing.cache[houseID] = {
			HouseName = data.HouseName,
			InteriorID = data.InteriorID,
			InitialPrice = data.InitialPrice,
			BoughtFor = data.BoughtFor,
			CurrentPrice = data.CurrentPrice,
			Sale = data.Sale,
			Open = data.Open,
			x = data.Loc.x,
			y = data.Loc.y,
			z = data.Loc.z,
		}
		houseCount = houseCount + 1
	end	
	phone.housing.label["OwnedHouses"].text = "Owned Houses: "..tostring(houseCount or "0")
	
	for houseID in pairs(Housing.blips) do
		if (not checkBlips[houseID]) then
			Housing.blips[houseID]:destroy()
			Housing.blips[houseID] = nil
		end
	end
end
addEvent("UCDphone.housing.populate", true)
addEventHandler("UCDphone.housing.populate", root, Housing.populate)

function Housing.onHouseGridClick()
	local row = guiGridListGetSelectedItem(phone.housing.gridlist, 1)
	if (row and row ~= -1) then
		local houseID = guiGridListGetItemData(phone.housing.gridlist, row, 1)
		local houseData = Housing.cache[houseID]
		
		if (houseData.Sale == 1) then houseData.Sale = "Yes" else houseData.Sale = "No" end
		if (houseData.Open == 1) then houseData.Open = "Yes" else houseData.Open = "No" end
		
		phone.housing.label["HouseName"].text = "House Name: "..tostring(houseData.HouseName)
		phone.housing.label["InteriorID"].text = "Interior ID: "..tostring(houseData.InteriorID)
		phone.housing.label["InitialPrice"].text = "Initial Price: $"..tostring(exports.UCDutil:tocomma(houseData.InitialPrice))
		phone.housing.label["BoughtFor"].text = "Bought For: $"..tostring(exports.UCDutil:tocomma(houseData.BoughtFor))
		phone.housing.label["CurrentPrice"].text = "Current Price: $"..tostring(exports.UCDutil:tocomma(houseData.CurrentPrice))
		phone.housing.label["Sale"].text = "Sale: "..tostring(houseData.Sale)
		phone.housing.label["Open"].text = "Open: "..tostring(houseData.Open)
	else
		phone.housing.label["HouseName"].text = "House Name:"
		phone.housing.label["InteriorID"].text = "Interior ID:"
		phone.housing.label["InitialPrice"].text = "Initial Price:"
		phone.housing.label["BoughtFor"].text = "Bought For:"
		phone.housing.label["CurrentPrice"].text = "Current Price:"
		phone.housing.label["Sale"].text = "Sale:"
		phone.housing.label["Open"].text = "Open:"
	end
end
addEventHandler("onClientGUIClick", phone.housing.gridlist, Housing.onHouseGridClick)

function Housing.destroyAllBlips()
	for _, blip in pairs(Housing.blips) do
		blip:destroy()
	end
	Housing.blips = {}
end

function Housing.onToggleHouseBlip()
	local row = guiGridListGetSelectedItem(phone.housing.gridlist, 1)
	if (row and row ~= -1) then
		local houseID = guiGridListGetItemData(phone.housing.gridlist, row, 1)
		local houseData = Housing.cache[houseID]
		local housePos = Vector3(houseData.x, houseData.y, houseData.z)
		if (Housing.blips[houseID]) then
			Housing.blips[houseID]:destroy()
			Housing.blips[houseID] = nil
		else
			Housing.blips[houseID] = Blip(housePos, 31, nil, nil, nil, nil, nil, 0, 100000)
		end
	else
		exports.UCDdx:new("You must select a house from the grid list", 255, 0, 0)
	end
end
addEventHandler("onClientGUIClick", phone.housing.button, Housing.onToggleHouseBlip, false)
