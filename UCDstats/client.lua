local defaults = {
	"Name: ",
	"Account Name: ",
	"Job: ",
	"Group: ",
	"Group Rank: ",
	"Play Time: ",
	"Wanted Level: ",
	"Cash: ",
	"Country: ",
	"Ping: ",
	"▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬",
	"Kills: ",
	"Deaths: ",
	"KDR: ",
	"Total bullets fired: ",
	"Total spent on guns: ",
	"▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬",
}

local selections = 0
function resetSelections()
	selections = 0
end

GUIEditor = {scrollpane = {}, edit = {}, button = {}, label = {}, gridlist = {}}
GUIEditor.window = guiCreateWindow(719, 326, 468, 446, "UCD | Player Statistics", false)
GUIEditor.window.sizable = false
GUIEditor.window.visible = false
GUIEditor.edit[1] = GuiEdit(10, 26, 176, 34, "", false, GUIEditor.window)
GUIEditor.gridlist[1] = GuiGridList(10, 65, 176, 371, false, GUIEditor.window)
guiGridListAddColumn(GUIEditor.gridlist[1], "Player", 0.9)
guiGridListSetSortingEnabled(GUIEditor.gridlist[1], false)
GUIEditor.button[1] = GuiButton(196, 26, 128, 34, "Refresh", false, GUIEditor.window)
GUIEditor.button[2] = GuiButton(330, 26, 128, 34, "Close", false, GUIEditor.window)
GUIEditor.scrollpane[1] = guiCreateScrollPane(196, 67, 262, 369, false, GUIEditor.window)
for i = 1, #defaults do
	-- Lua iterating from 1 is sometimes great, sometimes fucking awful
	GUIEditor.label[i] = GuiLabel(0, (i * 15) - 15, 262, 15, defaults[i], false, GUIEditor.scrollpane[1])
end
exports.UCDutil:centerWindow(GUIEditor.window)

addEventHandler("onClientPlayerLogin", localPlayer,
	function ()
		refreshGridlist()
	end
)

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
	if (not exports.UCDaccounts:isPlayerLoggedIn(localPlayer)) then
		return
	end
	
	GUIEditor.window.visible = not GUIEditor.window.visible
	if (GUIEditor.window.visible) then
		showCursor(true)
		return
	end
	showCursor(false)
end
addCommandHandler("stats", toggleStatsWindow)
addEventHandler("onClientGUIClick", GUIEditor.button[2], toggleStatsWindow, false)

function selectPlayer()
	local row = guiGridListGetSelectedItem(GUIEditor.gridlist[1])
	if (row and row ~= -1) then
		if (selections >= 10) then
			exports.UCDdx:new("In order to reduce server load, you can only view 10 people's stats within 10 seconds", 255, 0, 0)
			return
		end
		selections = selections + 1
		local plr = guiGridListGetItemData(GUIEditor.gridlist[1], row, 1)
		if (not exports.UCDaccounts:isPlayerLoggedIn(plr)) then
			exports.UCDdx:new("This player is not logged in", 255, 0, 0)
			return
		end
		triggerServerEvent("UCDstats.getPlayerStats", localPlayer, guiGridListGetItemData(GUIEditor.gridlist[1], row, 1))
		Timer(resetSelections, 10000, 1)
	end
end
addEventHandler("onClientGUIClick", GUIEditor.gridlist[1], selectPlayer, false)

function search()
	local text = GUIEditor.edit[1].text
	if (text ~= "" and text ~= " " and text:gsub(" ", "") ~= "") then
		GUIEditor.gridlist[1]:clear()
		for _, plr in ipairs(Element.getAllByType("player")) do
			if (plr.name:lower():find(text:lower())) then
				local row = guiGridListAddRow(GUIEditor.gridlist[1])
				local r, g, b = plr.team:getColor()
				guiGridListSetItemText(GUIEditor.gridlist[1], row, 1, tostring(plr.name), false, false)
				guiGridListSetItemData(GUIEditor.gridlist[1], row, 1, plr)
				guiGridListSetItemColor(GUIEditor.gridlist[1], row, 1, r, g, b)
			end
		end
		return
	end
	refreshGridlist()
end
addEventHandler("onClientGUIChanged", GUIEditor.edit[1], search, false)

function loadStats(data)
	local t = split(tostring(source:getData("dxscoreboard_playtime")), ":")
	local h, m = t[1], t[2]
	local pt
	if (m == "00") then
		pt = tostring(h).."h"
	elseif (h == "00") then
		pt = tostring(m).."m"
	else
		pt = tostring(h).."h, "..tostring(m).."m"
	end
	
	GUIEditor.label[1].text = defaults[1]..source.name
	GUIEditor.label[2].text = defaults[2]..tostring(data["accName"])
	GUIEditor.label[3].text = defaults[3]..tostring(source:getData("Occupation"))
	GUIEditor.label[4].text = defaults[4]..tostring(data["group"])
	GUIEditor.label[5].text = defaults[5]..tostring(data["groupRank"])
	GUIEditor.label[6].text = defaults[6]..tostring(pt)
	GUIEditor.label[7].text = defaults[7]..tostring(source:getWantedLevel()).." ("..tostring(data["wanted"])..")"
	GUIEditor.label[8].text = defaults[8].."$"..tostring(exports.UCDutil:tocomma(source:getMoney()))
	GUIEditor.label[9].text = defaults[9]..tostring(source:getData("Country"))
	GUIEditor.label[10].text = defaults[10]..tostring(source.ping)
	GUIEditor.label[12].text = defaults[12]..tostring(exports.UCDutil:tocomma(data["kills"]))
	GUIEditor.label[13].text = defaults[13]..tostring(exports.UCDutil:tocomma(data["deaths"]))
	GUIEditor.label[14].text = defaults[14]..tostring(data["kdr"])
	GUIEditor.label[15].text = defaults[15]..tostring(exports.UCDutil:tocomma(data["totalfired"]))
	GUIEditor.label[16].text = defaults[16]..tostring(data["totalguns"])
end
addEvent("UCDstats.loadStats", true)
addEventHandler("UCDstats.loadStats", root, loadStats)
