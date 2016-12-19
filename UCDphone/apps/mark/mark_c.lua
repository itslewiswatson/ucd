Mark = {}
Mark.blips = {}
Mark.open = false

function Mark.create()
	phone.mark = {button = {}, edit = {}, gridlist = {}}
	
	phone.mark.edit["search_players"] = GuiEdit(18, 97, 274, 28, "", false, phone.image["phone_window"])
	phone.mark.gridlist["players"] = GuiGridList(20, 135, 271, 333, false, phone.image["phone_window"])
	guiGridListAddColumn(phone.mark.gridlist["players"], "Players", 0.9)
	phone.mark.button["toggle_mark"] = GuiButton(39, 476, 232, 37, "Toggle marking of specified player", false, phone.image["phone_window"])
	
	Mark.all = {
		phone.mark.edit["search_players"], phone.mark.gridlist["players"], phone.mark.button["toggle_mark"]
	}
	for _, gui in ipairs(Mark.all) do
		gui.visible = false
	end
end
Mark.create()

function Mark.toggle()
	for _, gui in ipairs(Mark.all) do
		gui.visible = not gui.visible
		Mark.open = gui.visible
	end
end

function Mark.onClickToggleMarking()
	local row = guiGridListGetSelectedItem(phone.mark.gridlist["players"])
	if (row and row ~= -1) then
		local name = guiGridListGetItemText(phone.mark.gridlist["players"], row, 1)
		if (name and Player(name)) then
			Mark.toggleBlip(Player(name))
		end
	end
end

function Mark.toggleBlip(ele)
	if (#Mark.blips >= 5) then
		exports.CSGdx:new("You can only have a maximum of 5 players blipped at a given time", 255, 0, 0)
		return
	end
	local blipID = 58
	if (Mark.blips[ele]) then
		exports.CSGdx:new("Marking removed on "..ele.name, 0, 255, 0)
		Mark.blips[ele]:destroy()
		Mark.blips[ele] = nil
		removeEventHandler("onClientPlayerQuit", ele, Mark.onQuit)
		return
	end
	exports.CSGdx:new(ele.name.." is now marked", 0, 255, 0)
	Mark.blips[ele] = Blip.createAttachedTo(ele, blipID)
	addEventHandler("onClientPlayerQuit", ele, Mark.onQuit)
end
addEventHandler("onClientGUIClick", phone.mark.button["toggle_mark"], Mark.onClickToggleMarking, false)

function Mark.onQuit()
	Mark.blips[source]:destroy()
	Mark.blips[source] = nil
end

function Mark.onSearchForPlayer()
	phone.mark.gridlist["players"]:clear()
	local text = phone.mark.edit["search_players"].text
	for _, plr in ipairs(Element.getAllByType("player")) do
		if (plr ~= localPlayer and plr.name:lower():find(text:lower())) then
			local row = guiGridListAddRow(phone.mark.gridlist["players"])
			guiGridListSetItemText(phone.mark.gridlist["players"], row, 1, plr.name, false, false)
		end
	end
end
addEventHandler("onClientGUIChanged", phone.mark.edit["search_players"], Mark.onSearchForPlayer, false)
