IM = {}
IM.f2a = {}

function IM.create()
	phone.im = {button = {}, edit = {}, gridlist = {}}
	
	phone.im.memo = GuiMemo(18, 94, 274, 213, "", false, phone.image["phone_window"])
	phone.im.memo.readOnly = true

	phone.im.edit["msg"] = GuiEdit(18, 313, 273, 29, "", false, phone.image["phone_window"])
	phone.im.edit["search_players"] = GuiEdit(18, 347, 137, 27, "", false, phone.image["phone_window"])
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

function IM.onSearchForPlayer()
	guiGridListClear(phone.im.gridlist["players"])
	local text = phone.im.edit["search_players"].text
	for _, plr in ipairs(Element.getAllByType("player")) do
		if (plr ~= localPlayer and plr.name:lower():find(text:lower())) then
			local row = guiGridListAddRow(phone.im.gridlist["players"])
			guiGridListSetItemText(phone.im.gridlist["players"], row, 1, plr.name, false, false)
		end
	end
end
addEventHandler("onClientGUIChanged", phone.im.edit["search_players"], IM.onSearchForPlayer, false)

function IM.onAttemptSendMessage(button, state)
	local enter = {["enter"] = true, ["num_enter"] = true}
	if (enter[button] and state == false) then
		-- If they are in the correct edit box
		if (guiEditGetCaretIndex(phone.im.edit["msg"])) then
			local msg = phone.im.edit["msg"].text
			if (msg:len() == 0 or msg == "" or msg:gsub(" ", "") == "") then
				return
			end
			local row1 = guiGridListGetSelectedItem(phone.im.gridlist["players"])
			local row2 = guiGridListGetSelectedItem(phone.im.gridlist["friends"])
			if (row1 and row2 and row1 ~= -1 and row2 ~= -1) then
				exports.UCDdx:new("You must select either an online friend or a player to send a message to", 255, 0, 0)
				return
			end
			-- Player
			if (row1 and row1 ~= -1) then
				local txt = guiGridListGetItemText(phone.im.gridlist["players"], row1, 1)
				if (Player(txt)) then
					IM.onSendMessage(txt, msg)
				end
			-- Friend
			elseif (row2 and row2 ~= -1) then
				local txt = guiGridListGetItemText(phone.im.gridlist["friends"], row2, 1)
				-- If they are online
				if (Player(txt)) then
					IM.onSendMessage(txt, msg)
				else
					exports.UCDdx:new("You cannot IM this friend as they are offline", 255, 0, 0)
				end
			end
		end
	end
end
addEventHandler("onClientKey", root, IM.onAttemptSendMessage)

function IM.onSendMessage(plrName, message)
	phone.im.edit["msg"].text = ""
	triggerServerEvent("UCDchat.onSendIMFromPhone", localPlayer, plrName, message)
end

-- wasReceived = bool (true for received, false for sent)
function IM.appendMessage(wasReceived, plrName, message)
	local x
	if (wasReceived) then
		x = "from"
	else
		x = "to"
	end
	phone.im.memo.text = "[IM "..x.." "..plrName.."] "..message.."\n"..phone.im.memo.text
end
addEvent("UCDphone.appendMessage", true)
addEventHandler("UCDphone.appendMessage", root, IM.appendMessage)

function IM.onReceivedFriendsList(list)
	guiGridListClear(phone.im.gridlist["friends"])
	for _, info in pairs(list) do
		local row = guiGridListAddRow(phone.im.gridlist["friends"])
		IM.f2a[row] = info[3]
		guiGridListSetItemText(phone.im.gridlist["friends"], row, 1, tostring(info[1]), false, false)
		if (info[2]) then
			guiGridListSetItemColor(phone.im.gridlist["friends"], row, 1, 0, 255, 0)
			return
		end
		guiGridListSetItemColor(phone.im.gridlist["friends"], row, 1, 255, 0, 0)
	end
end
addEvent("UCDphone.sendFriends", true)
addEventHandler("UCDphone.sendFriends", root, IM.onReceivedFriendsList)

function IM.addFriend()
	local row = guiGridListGetSelectedItem(phone.im.gridlist["players"])
	if (row and row ~= -1) then
		local plrName = guiGridListGetItemText(phone.im.gridlist["players"], row, 1)
		triggerServerEvent("UCDphone.addFriend", localPlayer, plrName)
	end
end
addEventHandler("onClientGUIClick", phone.im.button["add_friend"], IM.addFriend, false)

function IM.removeFriend()
	local row = guiGridListGetSelectedItem(phone.im.gridlist["friends"])
	if (row and row ~= -1) then
		local accName = IM.f2a[row]
		triggerServerEvent("UCDphone.removeFriend", localPlayer, accName)
	end
end
addEventHandler("onClientGUIClick", phone.im.button["remove_friend"], IM.removeFriend, false)
