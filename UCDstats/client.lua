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
	"Delivered Arrests: ",
	"Kill Arrests: ",
	"Total Arrest Points: ",
	"▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬",
	"Times Arrested: ",
	"Lifetime Wanted Points: ",
	"Houses Robbed: ",
	"Attempted Bank Robbieries: ", -- 25
	"Successful Bank Robbieries: ", -- 26
	"Criminal Rank: ", -- 27
	"▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬",
	"Total Drift Points: ", -- 29
	"Best Drift: ", -- 30
	"▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬",
}
--[[
local nonJobs = {
	[""] = true,
	["Criminal"] = true,
	["Gangster"] = true,
	["Unoccupied"] = true,
}
--]]

local selections = 0
function resetSelections()
	selections = 0
end

GUIEditor = {scrollpane = {}, edit = {}, button = {}, label = {}, gridlist = {}}
GUIEditor.window = guiCreateWindow(719, 326, 468, 446, "UCD | Player Statistics", false)
GUIEditor.window.sizable = false
GUIEditor.window.visible = false
GUIEditor.window.alpha = 1
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

--function addJobRanks()	
	local jobRankTable = exports.UCDjobsTable:getJobsRanks()
	local i = #defaults + 1
	for job in pairs(jobRankTable) do
		GUIEditor.label[job] = GuiLabel(0, (i * 15) - 15, 262, 15, tostring(job).." Rank: ", false, GUIEditor.scrollpane[1])
		i = i + 1
	end
--end
--addEventHandler("onClientResourceStart", resourceRoot, addJobRanks)

addEventHandler("onClientPlayerLogin", localPlayer,
	function ()
		refreshGridlist()
	end
)

function refreshGridlist()
	GUIEditor.edit[1].text = ""
	GUIEditor.gridlist[1]:clear()
	for i, txt in ipairs(defaults) do
		GUIEditor.label[i].text = txt
	end
	for _, plr in ipairs(Element.getAllByType("player")) do
		--if (exports.UCDaccounts:isPlayerLoggedIn(plr)) then
			local row = guiGridListAddRow(GUIEditor.gridlist[1])
			local r, g, b
			if (plr.team) then
				r, g, b = plr.team:getColor()
			else
				r, g, b = 255, 255, 255
			end
			guiGridListSetItemText(GUIEditor.gridlist[1], row, 1, tostring(plr.name), false, false)
			guiGridListSetItemData(GUIEditor.gridlist[1], row, 1, plr)
			guiGridListSetItemColor(GUIEditor.gridlist[1], row, 1, r, g, b)
		--end
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
addCommandHandler("stats", toggleStatsWindow, false, false)
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
	
	GUIEditor.label[1].text = defaults[1]..tostring(source.name)
	GUIEditor.label[2].text = defaults[2]..tostring(data["accName"])
	GUIEditor.label[3].text = defaults[3]..tostring(source:getData("Occupation"))
	GUIEditor.label[4].text = defaults[4]..tostring(data["group"])
	GUIEditor.label[5].text = defaults[5]..tostring(data["groupRank"])
	GUIEditor.label[6].text = defaults[6]..tostring(pt)
	GUIEditor.label[7].text = defaults[7]..tostring(data["wl"]).." ("..tostring(data["wanted"])..")"
	GUIEditor.label[8].text = defaults[8].."$"..tostring(exports.UCDutil:tocomma(data["money"]))
	GUIEditor.label[9].text = defaults[9]..tostring(source:getData("Country"))
	GUIEditor.label[10].text = defaults[10]..tostring(source.ping)
	GUIEditor.label[12].text = defaults[12]..tostring(exports.UCDutil:tocomma(data["kills"]))
	GUIEditor.label[13].text = defaults[13]..tostring(exports.UCDutil:tocomma(data["deaths"]))
	GUIEditor.label[14].text = defaults[14]..tostring(exports.UCDutil:mathround(data["kdr"], 2))
	GUIEditor.label[15].text = defaults[15]..tostring(exports.UCDutil:tocomma(data["totalfired"]))
	GUIEditor.label[16].text = defaults[16]..tostring(data["totalguns"])
	GUIEditor.label[18].text = defaults[18]..tostring(data["arrests"])
	GUIEditor.label[19].text = defaults[19]..tostring(data["killArrests"])
	GUIEditor.label[20].text = defaults[20]..tostring(data["ap"])
	GUIEditor.label[22].text = defaults[22]..tostring(data["timesArrested"])
	GUIEditor.label[23].text = defaults[23]..tostring(data["lifetimeWanted"])
	GUIEditor.label[24].text = defaults[24]..tostring(data["housesRobbed"])
	GUIEditor.label[25].text = defaults[25]..tostring(data["attemptBR"])
	GUIEditor.label[26].text = defaults[26]..tostring(data["successBR"])
	GUIEditor.label[27].text = defaults[27]..tostring(data["crimRank"]).." ("..tostring(exports.UCDutil:tocomma(data["crimXP"])).." XP)"
	GUIEditor.label[29].text = defaults[29]..tostring(data["totalDrift"])
	GUIEditor.label[30].text = defaults[30]..tostring(data["bestDrift"])
	for job, rank in pairs(data["jobRanks"]) do
		if (GUIEditor.label[job]) then
			GUIEditor.label[job].text = tostring(tostring(job).." Rank: L"..tostring(rank or 0).." ("..tostring(jobRankTable[job][rank].name)..")")
		end
	end
end
addEvent("UCDstats.loadStats", true)
addEventHandler("UCDstats.loadStats", root, loadStats)

addEventHandler("onClientPlayerChangeNick", root,
	function (old, new)
		if (source ~= localPlayer) then
			for i = 0, guiGridListGetRowCount(GUIEditor.gridlist[1]) - 1 do
				if (guiGridListGetItemData(GUIEditor.gridlist[1], i, 1) == source) then
					guiGridListSetItemText(GUIEditor.gridlist[1], i, 1, tostring(new), false, false)
					return
				end
			end
		end
	end
)

addEventHandler("onClientPlayerJoin", root,
	function ()
		local row = guiGridListAddRow(GUIEditor.gridlist[1])
		local r, g, b = source:getNametagColor()
		guiGridListSetItemText(GUIEditor.gridlist[1], row, 1, tostring(source.name), false, false)
		guiGridListSetItemColor(GUIEditor.gridlist[1], row, 1, r, g, b)
		guiGridListSetItemData(GUIEditor.gridlist[1], row, 1, source)
	end
)

addEventHandler("onClientPlayerQuit", root,
	function ()
		for i = 0, guiGridListGetRowCount(GUIEditor.gridlist[1]) - 1 do
			if (guiGridListGetItemData(GUIEditor.gridlist[1], i, 1) == source) then
				guiGridListRemoveRow(GUIEditor.gridlist[1], i)
				return
			end
		end
	end
)
