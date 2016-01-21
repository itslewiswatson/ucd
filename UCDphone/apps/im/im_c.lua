IM = {}

function IM.create()
	phone.im = {button = {}, edit = {}, gridlist = {}}
	--[[
	
	phone.im.image = GuiStaticImage(1618, 529, 274, 458, ":UCDphone/images/camera.png", false)
	phone.im.image.visible = false
	
	phone.im.button["mute"] = GuiButton(0, 435, 68, 23, "Mute", false, phone.im.image)
	phone.im.button["add_friend"] = GuiButton(68, 435, 68, 23, "Add friend", false, phone.im.image)
	phone.im.button["remove_friend"] = GuiButton(136, 435, 138, 23, "Remove friend", false, phone.im.image)
	
	phone.im.gridlist["players"] = GuiGridList(0, 303, 138, 132, false, phone.im.image)
	guiGridListAddColumn(phone.im.gridlist["players"], "Players", 0.9)
	
	phone.im.gridlist["friends"] = GuiGridList(136, 303, 138, 132, false, phone.im.image)
	guiGridListAddColumn(phone.im.gridlist["friends"], "Friends", 0.9)
	
	phone.im.edit["msg"] = GuiEdit(0, 242, 274, 27, "", false, phone.im.image)
	phone.im.edit["search_players"] = GuiEdit(0, 276, 138, 27, "", false, phone.im.image)
	phone.im.edit["search_friends"] = GuiEdit(138, 276, 138, 27, "", false, phone.im.image)
	
	phone.im.memo = GuiMemo(0, 23, 274, 213, "", false, phone.im.image)
	--]]
	

	phone.im.memo = GuiMemo(18, 94, 274, 213, "", false, phone.image["phone_window"])

	phone.im.edit["msg"] = GuiEdit(18, 347, 137, 27, "", false, phone.image["phone_window"])
	phone.im.edit["search_players"] = GuiEdit(18, 313, 273, 29, "", false, phone.image["phone_window"])
	phone.im.edit["search_friends"] = GuiEdit(155, 347, 137, 27, "", false, phone.image["phone_window"])

	phone.im.gridlist["players"] = guiCreateGridList(18, 374, 138, 132, false, phone.image["phone_window"])
	guiGridListAddColumn(phone.im.gridlist["players"], "Players", 0.9)
	phone.im.gridlist["friends"] = guiCreateGridList(154, 374, 138, 132, false, phone.image["phone_window"])
	guiGridListAddColumn(phone.im.gridlist["friends"], "Friends", 0.9)

	phone.im.button["mute"] = GuiButton(18, 506, 68, 23, "Mute", false, phone.image["phone_window"])
	phone.im.button["add_friend"] = GuiButton(86, 506, 68, 23, "Add friend", false, phone.image["phone_window"])
	phone.im.button["remove_friend"]= GuiButton(154, 506, 138, 23, "Remove friend", false, phone.image["phone_window"])
	
	IM.all = {
		phone.im.button["mute"], phone.im.button["add_friend"], phone.im.button["remove_friend"], phone.im.gridlist["players"], phone.im.gridlist["friends"], phone.im.edit["msg"],
		phone.im.edit["search_players"], phone.im.edit["search_friends"], phone.im.memo
	}
	for _, gui in pairs(IM.all) do
		gui.visible = false
	end
end
IM.create()

function IM.toggle()
	for _, gui in pairs(IM.all) do
		gui.visible = not gui.visible
	end
end

