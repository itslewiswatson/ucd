local defaults = {
	"Name: ", "Job: ", "Group: ", "Group Rank: ", "Wanted Level: ", "Cash: ", "Country: ", "Ping: ", "_____________________________________",
	"", "", 
}

GUIEditor = {scrollpane = {}, edit = {}, button = {}, window = {}, label = {}, gridlist = {}}
GUIEditor.window[1] = guiCreateWindow(719, 326, 468, 446, "UCD | Player Statistics", false)
GUIEditor.window[1].sizable = false
GUIEditor.window[1].visible = false
GUIEditor.edit[1] = guiCreateEdit(10, 26, 176, 34, "", false, GUIEditor.window[1])
GUIEditor.gridlist[1] = guiCreateGridList(10, 65, 176, 371, false, GUIEditor.window[1])
guiGridListAddColumn(GUIEditor.gridlist[1], "Player", 0.9)
GUIEditor.button[1] = guiCreateButton(196, 26, 128, 34, "Refresh", false, GUIEditor.window[1])
GUIEditor.button[2] = guiCreateButton(330, 26, 128, 34, "Close", false, GUIEditor.window[1])
GUIEditor.scrollpane[1] = guiCreateScrollPane(196, 67, 262, 369, false, GUIEditor.window[1])
GUIEditor.label[1] = guiCreateLabel(0, 0, 262, 15, "Name: ", false, GUIEditor.scrollpane[1])
GUIEditor.label[2] = guiCreateLabel(0, 15, 262, 15, "Job: ", false, GUIEditor.scrollpane[1])
GUIEditor.label[3] = guiCreateLabel(0, 30, 262, 15, "Group: ", false, GUIEditor.scrollpane[1])
GUIEditor.label[4] = guiCreateLabel(0, 45, 262, 15, "Group Rank: ", false, GUIEditor.scrollpane[1])
GUIEditor.label[5] = guiCreateLabel(0, 60, 262, 15, "Wanted Level: ", false, GUIEditor.scrollpane[1])
GUIEditor.label[6] = guiCreateLabel(0, 75, 262, 15, "Cash: ", false, GUIEditor.scrollpane[1])
GUIEditor.label[7] = guiCreateLabel(0, 90, 262, 15, "Country: ", false, GUIEditor.scrollpane[1])
GUIEditor.label[8] = guiCreateLabel(0, 105, 262, 15, "Ping: ", false, GUIEditor.scrollpane[1])
GUIEditor.label[9] = guiCreateLabel(0, 120, 262, 15, "_____________________________________", false, GUIEditor.scrollpane[1])
GUIEditor.label[10] = guiCreateLabel(0, 135, 262, 15, "", false, GUIEditor.scrollpane[1])
GUIEditor.label[11] = guiCreateLabel(0, 135, 262, 15, "", false, GUIEditor.scrollpane[1])

function refreshGridlist()
	guiGridListClear(GUIEditor.gridlist[1])
	for i, txt in ipairs(defaults) do
		GUIEditor.label[i].text = txt
	end
	for _, plr in ipairs(Element.getAllByType("player")) do
		if (exports.UCDaccounts:isPlayerLoggedIn(plr)) then
			local row = guiGridListAddRow(GUIEditor.gridlist[1])
			local r, g, b = plr.team:getColor()
			guiGridListSetItemText(GUIEditor.gridlist[1], row, 1, tostring(plr.name), false, false)
			guiGridListSetItemData(GUIEditor.gridlist[1], row, 1, plr)
			guiGridListSetItemColor(GUIEditor.gridlist[1], row, 1, r, g, b)
		end
	end
end
refreshGridlist()
addEventHandler("onClientGUIClick", GUIEditor.button[1], refreshGridlist, false)

function toggleStatsWindow()
	GUIEditor.window[1].visible = not GUIEditor.window[1].visible
	if (GUIEditor.window[1].visible) then
		showCursor(true)
	else
		showCursor(false)
	end
end
addCommandHandler("stats", toggleStatsWindow)
addEventHandler("onClientGUIClick", GUIEditor.button[2], toggleStatsWindow, false)

function selectPlayer()
	local row = guiGridListGetSelectedItem(GUIEditor.gridlist[1])
	if (row and row ~= -1) then
		triggerServerEvent("UCDstats.getPlayerStats", localPlayer, guiGridListGetItemData(GUIEditor.gridlist[1], row, 1))
	end
end
addEventHandler("onClientGUIClick", GUIEditor.gridlist[1], selectPlayer, false)

function loadStats(data)
	GUIEditor.label[1].text = "Name: "..source.name
	GUIEditor.label[2].text = "Job: "..tostring(source:getData("Occupation"))
	GUIEditor.label[3].text = "Group: "..tostring(data["group"])
	GUIEditor.label[4].text = "Group Rank: "..tostring(data["groupRank"])
	GUIEditor.label[5].text = "Wanted Level: 0"
	GUIEditor.label[6].text = "Cash: $"..tostring(exports.UCDutil:tocomma(source:getMoney()))
	GUIEditor.label[7].text = "Country: "..tostring(source:getData("Country"))
	GUIEditor.label[8].text = "Ping: "..tostring(source.ping)
end
addEvent("UCDstats.loadStats", true)
addEventHandler("UCDstats.loadStats", root, loadStats)
