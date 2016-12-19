Mail = {}
Mail.open = false

addCommandHandler("mo", function () outputDebugString(tostring(Mail.open)) end)

function Mail.create()
	phone.mail = {button = {}, checkbox = {}, label = {}, memo = {}}	

		-- Main view
		phone.mail.gridlist = guiCreateGridList(19, 124, 272, 291, false, phone.image["phone_window"])
		guiGridListAddColumn(phone.mail.gridlist, "Player", 0.3)
		guiGridListAddColumn(phone.mail.gridlist, "Message", 0.6)
        
        phone.mail.label["instruct"] = GuiLabel(19, 89, 274, 17, "Double click on a message to view", false, phone.image["phone_window"])
        guiLabelSetHorizontalAlign(phone.mail.label["instruct"], "center", false)
		
		phone.mail.button["new"] = GuiButton(29, 483, 77, 36, "New Mail", false, phone.image["phone_window"])
		phone.mail.button["delete"] = GuiButton(118, 483, 77, 36, "Delete Selected", false, phone.image["phone_window"])
        phone.mail.button["settings"] = GuiButton(206, 483, 77, 36, "Mail Settings", false, phone.image["phone_window"])     
		
		-- Filters
		
		-- Search
		phone.mail.edit = GuiEdit(79, 423, 211, 25, "", false, phone.image["phone_window"])
        phone.mail.label["search"] = GuiLabel(19, 423, 60, 21, "Search:", false, phone.image["phone_window"])
        guiLabelSetHorizontalAlign(phone.mail.label["search"], "center", false)
        guiLabelSetVerticalAlign(phone.mail.label["search"], "center")
		
		-- Types
		phone.mail.checkbox["filter_unread"] = GuiCheckBox(59, 458, 15, 15, "", false, false, phone.image["phone_window"])
        phone.mail.label["filter_unread"] = GuiLabel(74, 458, 78, 15, "Unread Only", false, phone.image["phone_window"])
        guiLabelSetHorizontalAlign(phone.mail.label["filter_unread"], "center", false)
		
		phone.mail.checkbox["filter_"] = GuiCheckBox(162, 458, 15, 15, "", false, false, phone.image["phone_window"])
		phone.mail.label["filter_"] = GuiLabel(177, 458, 84, 15, "Unread Only", false, phone.image["phone_window"])
        guiLabelSetHorizontalAlign(phone.mail.label["filter_"], "center", false)
		
		-- 
		---
		----
		phone.mail.scrollpane = GuiScrollPane(16, 110, 278, 177, false, phone.image["phone_window"])
		phone.mail.label["conversing_with"] = GuiLabel(16, 89, 278, 16, "Conversation with lastUsedName (accountName)", false, phone.image["phone_window"])
		guiLabelSetHorizontalAlign(phone.mail.label["conversing_with"], "center", false)
		
		phone.mail.memo["msg"] = GuiMemo(16, 287, 278, 55, "w * n\nw = width = 15px\nn = number of lines\ncharacters in 1 line = ~33 (new line at 30?)", false, phone.image["phone_window"])
		phone.mail.button["msg_delete"] = GuiButton(16, 352, 132, 36, "Delete Selected (55)", false, phone.image["phone_window"])
		phone.mail.button["msg_send"] = GuiButton(162, 352, 132, 36, "Send", false, phone.image["phone_window"])
		
		
	Mail.views = {
		main = {
			phone.mail.gridlist, phone.mail.label["instruct"], phone.mail.button["new"], phone.mail.button["delete"], phone.mail.button["settings"],
			phone.mail.edit, phone.mail.label["search"], phone.mail.checkbox["filter_unread"], phone.mail.label["filter_unread"],
			phone.mail.checkbox["filter_"], phone.mail.label["filter_"]
		},
		conversation = {
			phone.mail.scrollpane, phone.mail.label["conversing_with"], phone.mail.memo["msg"], phone.mail.button["msg_delete"], phone.mail.button["msg_send"], 
		},
	}
	
	Mail.all = {
		phone.mail.label["search"], phone.mail.edit, phone.mail.label["filter_unread"], phone.mail.gridlist, phone.mail.label["instruct"],
		phone.mail.button["new"], phone.mail.button["delete"], phone.mail.button["settings"], phone.mail.checkbox["filter_unread"],
		phone.mail.checkbox["filter_"], phone.mail.label["filter_"], phone.mail.scrollpane, phone.mail.label["conversing_with"],
		phone.mail.memo["msg"], phone.mail.button["msg_delete"], phone.mail.button["msg_send"],
	}
	
	for _, gui in pairs(Mail.all) do
		gui.visible = false
	end
end
Mail.create()

function Mail.toggle()
	-- o = opened
	local o = 0
	for _, gui in pairs(Mail.views.main) do
		if (gui.visible) then
			o = o + 1
		end
	end
	if (o == 0) then
		Mail.switchView("main")
		return
	end
	Mail.GUI(false)
end

function Mail.GUI(state)
	for _, gui in pairs(Mail.all) do
		gui.visible = state
	end
	Mail.open = state
end

function Mail.switchView(view)
	if (not Mail.views[view]) then
		outputDebugString("view "..tostring(view).. " doesnt exist")
		return
	end
	Mail.open = true -- Force it to be true here
	for v, t in pairs(Mail.views) do
		for _, gui in pairs(t) do
			if (v == view) then
				gui.visible = true
			else
				gui.visible = false
			end
		end
	end
end
addCommandHandler("switchv", function (_, view) Mail.switchView(view) end)

function Mail.onDoubleClickMessageList()
	
end

function Mail.openThread()
	
end

-- PROTOTYPE - DO NOT TOUCH
--[[

phone.mail = {
    checkbox = {},
    scrollpane = {},
    label = {},
    edit = {},
    button = {},
    window = {},
    gridlist = {},
    memo = {}
}
addEventHandler("onClientResourceStart", resourceRoot,
    function()
        phone.mail.window[1] = guiCreateWindow(535, 411, 311, 599, "", false)
        guiWindowSetSizable(phone.mail.window[1], false)
        guiSetAlpha(phone.mail.window[1], 0.90)

        phone.mail.gridlist[1] = guiCreateGridList(19, 124, 274, 291, false, phone.mail.window[1])
        guiGridListAddColumn(phone.mail.gridlist[1], "From", 0.3)
        guiGridListAddColumn(phone.mail.gridlist[1], "Message", 0.3)
        guiGridListAddColumn(phone.mail.gridlist[1], "Date", 0.3)
        phone.mail.button[1] = guiCreateButton(29, 483, 77, 36, "New Mail", false, phone.mail.window[1])
        guiSetProperty(phone.mail.button[1], "NormalTextColour", "FFAAAAAA")
        phone.mail.label[1] = GuiLabel(19, 89, 274, 17, "Double click on a message to view", false, phone.mail.window[1])
        guiLabelSetHorizontalAlign(phone.mail.label[1], "center", false)
        phone.mail.button[2] = guiCreateButton(206, 483, 77, 36, "Mail Settings", false, phone.mail.window[1])
        guiSetProperty(phone.mail.button[2], "NormalTextColour", "FFAAAAAA")
        phone.mail.button[3] = guiCreateButton(118, 483, 77, 36, "Delete Selected", false, phone.mail.window[1])
        guiSetProperty(phone.mail.button[3], "NormalTextColour", "FFAAAAAA")
        phone.mail.checkbox[1] = guiCreateCheckBox(59, 458, 15, 15, "", false, false, phone.mail.window[1])
        phone.mail.edit[1] = guiCreateEdit(79, 423, 214, 25, "", false, phone.mail.window[1])
        phone.mail.label[2] = GuiLabel(19, 423, 60, 21, "Search:", false, phone.mail.window[1])
        guiLabelSetHorizontalAlign(phone.mail.label[2], "center", false)
        guiLabelSetVerticalAlign(phone.mail.label[2], "center")
        phone.mail.label[3] = GuiLabel(74, 458, 78, 15, "Unread Only", false, phone.mail.window[1])
        guiLabelSetHorizontalAlign(phone.mail.label[3], "center", false)
        phone.mail.checkbox[2] = guiCreateCheckBox(162, 458, 15, 15, "", false, false, phone.mail.window[1])
        phone.mail.label[4] = GuiLabel(177, 458, 84, 15, "Unread Only", false, phone.mail.window[1])
        guiLabelSetHorizontalAlign(phone.mail.label[4], "center", false)


        phone.mail.window[2] = guiCreateWindow(1199, 459, 311, 599, "", false)
        guiWindowSetSizable(phone.mail.window[2], false)
        guiSetAlpha(phone.mail.window[2], 0.90)

        phone.mail.memo[1] = guiCreateMemo(16, 109, 278, 168, "[2016-12-12 @ 1:43pm]\n Risk > Me: ddddddddddddd\n\n[2016-12-12 @ 1:43pm]\nMe > Risk: ahahahah no\n\n[2016-12-12 @ 1:43pm]\nMe > Risk: hi\n", false, phone.mail.window[2])
        phone.mail.label[5] = GuiLabel(16, 89, 278, 16, "Conversation with [CSG]Risk (Risk)", false, phone.mail.window[2])
        guiLabelSetHorizontalAlign(phone.mail.label[5], "center", false)
        phone.mail.memo[2] = guiCreateMemo(16, 287, 278, 55, "", false, phone.mail.window[2])
        phone.mail.button[4] = guiCreateButton(16, 352, 132, 36, "Clear", false, phone.mail.window[2])
        guiSetProperty(phone.mail.button[4], "NormalTextColour", "FFAAAAAA")
        phone.mail.button[5] = guiCreateButton(162, 352, 132, 36, "Send", false, phone.mail.window[2])
        guiSetProperty(phone.mail.button[5], "NormalTextColour", "FFAAAAAA")


        phone.mail.window[3] = guiCreateWindow(878, 459, 311, 599, "", false)
        guiWindowSetSizable(phone.mail.window[3], false)
        guiSetAlpha(phone.mail.window[3], 0.90)

        phone.mail.label[6] = GuiLabel(16, 89, 278, 16, "Conversation with [CSG]Risk (Risk)", false, phone.mail.window[3])
        guiLabelSetHorizontalAlign(phone.mail.label[6], "center", false)
        phone.mail.memo[3] = guiCreateMemo(16, 287, 278, 55, "w * n\nw = width = 15px\nn = number of lines\ncharacters in 1 line = ~33 (new line at 30?)", false, phone.mail.window[3])
        phone.mail.button[6] = guiCreateButton(16, 352, 132, 36, "Delete Selected (55)", false, phone.mail.window[3])
        guiSetProperty(phone.mail.button[6], "NormalTextColour", "FFAAAAAA")
        phone.mail.button[7] = guiCreateButton(162, 352, 132, 36, "Send", false, phone.mail.window[3])
        guiSetProperty(phone.mail.button[7], "NormalTextColour", "FFAAAAAA")
        phone.mail.scrollpane[1] = guiCreateScrollPane(16, 110, 278, 177, false, phone.mail.window[3])

        phone.mail.checkbox[3] = guiCreateCheckBox(0, 0, 15, 15, "", false, false, phone.mail.scrollpane[1])
        phone.mail.label[7] = GuiLabel(25, 0, 233, 45, "[2016-12-12 @ 1:43pm]\nRisk > Me: ddddddddddddd\n123456789012345678901234567890123", false, phone.mail.scrollpane[1])
        guiLabelSetHorizontalAlign(phone.mail.label[7], "left", true)
        phone.mail.label[8] = GuiLabel(25, 55, 240, 45, "[2016-12-12 @ 1:43pm]\nRisk > Me: ddddddddddddd\n1234567890123456789012345678901234", false, phone.mail.scrollpane[1])
        guiLabelSetHorizontalAlign(phone.mail.label[8], "left", true)
        phone.mail.label[9] = GuiLabel(25, 110, 240, 45, "[2016-12-12 @ 1:43pm]\nRisk > Me: ddddddddddddd\n1234567890123456789012345678901234", false, phone.mail.scrollpane[1])
        guiLabelSetHorizontalAlign(phone.mail.label[9], "left", true)    
    end
)

]]
