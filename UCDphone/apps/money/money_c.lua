Money = {}

function Money.create()
	phone.money = {button = {}, edit = {}, gridlist = {}}
		
	phone.money.edit["search_players"] = GuiEdit(18, 97, 273, 28, "", false, phone.image["phone_window"])
	phone.money.edit["amount"] = GuiEdit(25, 466, 131, 44, "", false, phone.image["phone_window"])
	phone.money.gridlist["players"] = GuiGridList(20, 139, 271, 317, false, phone.image["phone_window"])
	guiGridListAddColumn(phone.money.gridlist["players"], "Players", 0.9)
	phone.money.button["send_money"] = guiCreateButton(169, 466, 112, 44, "Send Money", false, phone.image["phone_window"])
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

