local chatbox = {tab = {}, grid = {}}
chatbox.window = GuiWindow(0, 0, 600, 400, "UCD | Chatbox", false)
chatbox.window.sizable = false
chatbox.window.visible = false
exports.UCDutil:centerWindow(chatbox.window)
chatbox.tabPanel = GuiTabPanel(0, 20, 600, 335, false, chatbox.window)
local tabs = {"Support", "Main", "Team", "Local", "Group", "Alliance"}
for _, tab in ipairs(tabs) do
	local chatType = tab:lower()
	chatbox.tab[chatType] = GuiTab(tab, chatbox.tabPanel)
	chatbox.grid[chatType] = GuiGridList(5, 5, 572.5, 302.5, false, chatbox.tab[chatType])
	chatbox.grid[chatType]:addColumn("Name", 0.25)
	chatbox.grid[chatType]:addColumn("Message", 0.71)
end
chatbox.edit = GuiEdit(0, 360, 600, 200, "", false, chatbox.window)
chatbox.edit.maxLength = 128

addEvent("UCDchat.chatbox.insert", true)
addEventHandler("UCDchat.chatbox.insert", root,
	function (chatType, msg)
		local row = chatbox.grid[chatType]:insertRowAfter(-1)
		chatbox.grid[chatType]:setItemText(row, 1, source.name, false, false)
		chatbox.grid[chatType]:setItemText(row, 2, msg, false, false)
	end
)

addEventHandler("onClientGUIAccepted", chatbox.edit,
	function ()
		if (chatbox.edit.text:gsub(" ", "") ~= "") then
			local chatType
			for tabType, tab in pairs(chatbox.tab) do
				if (chatbox.tabPanel.selectedTab == tab) then
					chatType = tabType
				end
			end
			triggerServerEvent("UCDchat.chatbox.send", localPlayer, chatType, chatbox.edit.text)
			chatbox.edit.text = ""
		end
	end, false
)

bindKey("j", "down",
	function ()
		chatbox.window.visible = not chatbox.window.visible
		showCursor(chatbox.window.visible)
		guiSetInputMode(chatbox.window.visible and "no_binds_when_editing" or "allow_binds")
	end
)