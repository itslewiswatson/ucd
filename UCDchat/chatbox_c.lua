local window = GuiWindow(0, 0, 600, 400, "UCD | Chatbox", false)
window.sizable = false
window.movable = false
window.visible = false
exports.UCDutil:centerWindow(window)
local tabPanel = GuiTabPanel(0, 20, 600, 335, false, window)
local _tabs = {"Support", "Main", "Team", "Local", "Group", "Alliance"}
local tabs = {}
local lists = {}
for _, tab in ipairs(_tabs) do
	tabs[tab:lower()] = GuiTab(tab, tabPanel)
	lists[tab:lower()] = GuiGridList(5, 5, 572.5, 302.5, false, tabs[tab:lower()])
	lists[tab:lower()]:addColumn("Name", 0.25)
	lists[tab:lower()]:addColumn("Message", 0.71)
end
local talk = GuiEdit(0, 360, 600, 200, "", false, window)
talk.maxLength = 128

addEvent("listInsert", true)
addEventHandler("listInsert", resourceRoot,
	function (type, sender, msg)
		local row = lists[type]:insertRowAfter(-1)
		lists[type]:setItemText(row, 1, sender.name, false, false)
		lists[type]:setItemText(row, 2, msg, false, false)
	end
)

addEventHandler("onClientGUIAccepted", root,
	function ()
		if (source == talk) then
			if (talk.text:gsub(" ", "") ~= "") then
				local type
				for type2, tab in pairs(tabs) do
					if (tabPanel.selectedTab == tab) then
						type = type2
					end
				end
				triggerServerEvent("doChat", resourceRoot, type, talk.text)
				talk.text = ""
			end
		end
	end
)

bindKey("j", "down",
	function ()
		window.visible = not window.visible
		showCursor(window.visible)
		guiSetInputMode(window.visible and "no_binds_when_editing" or "allow_binds")
	end
)