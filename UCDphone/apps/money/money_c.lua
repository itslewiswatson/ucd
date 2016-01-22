Money = {}

function Money.create()
	phone.money = {button = {}, edit = {}, gridlist = {}}
	
	phone.money.edit["search_players"] = GuiEdit(18, 97, 274, 28, "", false, phone.image["phone_window"])
	phone.money.edit["amount"] = GuiEdit(25, 466, 131, 44, "", false, phone.image["phone_window"])
	phone.money.gridlist["players"] = GuiGridList(18, 139, 274, 317, false, phone.image["phone_window"])
	guiGridListAddColumn(phone.money.gridlist["players"], "Players", 0.9)
	phone.money.button["send_money"] = guiCreateButton(169, 466, 112, 44, "Transfer", false, phone.image["phone_window"])
	phone.money.button["send_money"].alpha = 255
	
	Money.all = {
		phone.money.edit["search_players"], phone.money.edit["amount"], phone.money.gridlist["players"], phone.money.button["send_money"]
	}
	for _, gui in pairs(Money.all) do
		gui.visible = false
	end
end
Money.create()

function Money.toggle()
	for _, gui in pairs(Money.all) do
		gui.visible = not gui.visible
	end
end

function Money.onClickTransfer()
	local row = guiGridListGetSelectedItem(phone.money.gridlist["players"])
	if (row and row ~= -1) then
		local name = guiGridListGetItemText(phone.money.gridlist["players"], row, 1)
		if (name and Player(name)) then
			Money.sendMoney(Player(name))
		end
	end
end
addEventHandler("onClientGUIClick", phone.money.button["send_money"], Money.onClickTransfer, false)

function Money.sendMoney(ele)
	if (localPlayer:getMoney() <= 0) then
		return
	end
	local amount = phone.money.edit["amount"].text
	amount = amount:gsub(",", "")
	if (amount == "" or amount == " " or amount:gsub(" ", "") == "") then
		return
	end
	if (not tonumber(amount)) then
		exports.UCDdx:new("You must only enter numbers in the amount box", 255, 0, 0)
		return
	end
	amount = tonumber(amount)
	amount = math.floor(amount)
	if (amount > 90000000 or amount < 1) then
		exports.UCDdx:new("You must enter a number smaller than 90,000,000 and larger than 0", 255, 0, 0)
		return
	end
	if (amount > localPlayer:getMoney()) then
		exports.UCDdx:new("You don't have this much money on you", 255, 0, 0)
		return
	end
	triggerServerEvent("UCDphone.sendMoney", localPlayer, ele, amount)
	phone.money.edit["amount"].text = ""
end

function Money.onAmountEdit()
	local text = phone.money.edit["amount"].text
	text = text:gsub(",", "")
	if (not tonumber(text)) then
		return
	end
	phone.money.edit["amount"].text = exports.UCDutil:tocomma(text)
	if (tonumber(text) > localPlayer:getMoney()) then
		phone.money.edit["amount"].text = exports.UCDutil:tocomma(localPlayer:getMoney())
	end
	if (not getKeyState("backspace")) then
		guiEditSetCaretIndex(phone.money.edit["amount"], phone.money.edit["amount"].text:len())
	end
end
addEventHandler("onClientGUIChanged", phone.money.edit["amount"], Money.onAmountEdit, false)

function Money.onSearchForPlayer()
	guiGridListClear(phone.money.gridlist["players"])
	local text = phone.money.edit["search_players"].text
	for _, plr in ipairs(Element.getAllByType("player")) do
		if (plr ~= localPlayer and plr.name:lower():find(text:lower())) then
			local row = guiGridListAddRow(phone.money.gridlist["players"])
			guiGridListSetItemText(phone.money.gridlist["players"], row, 1, plr.name, false, false)
		end
	end
end
addEventHandler("onClientGUIChanged", phone.money.edit["search_players"], Money.onSearchForPlayer, false)
