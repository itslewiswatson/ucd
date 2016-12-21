local F5 = {tab = {}, label = {}, memo = {}}

local info =
{
	["House Robbing"] = "To rob a house, enter the house marker and press 'N'. You will then enter the house. Once in, there are two markers that will appear somewhere in the house. Go find them and collect the loot there. Exit the house and make your way to a truck blip. Here you can sell your stolen goods for money.",
	["Turfing"] = "To capture turfs and participate in gang wars, you must go to Las Venturas. Here you can battle it out with other groups for control over various areas in LV called turfs. Las Venturas is a city not bound by law. The police rarely enter for fear of their own lives, so you're free to do as you please here. Las Venturas is also a KoS zone (kill on sight), meaning you can kill anyone. But be careful, you may also get hunted. It is recommended to use guns in Las Venturas as it's a very dangerous area.",
	["Briefcase"] = "To deliver the briefcase to Woozie within time to get a good reward based on the distance you have travelled. If 10 minutes pass and you haven't delivered it yet, Woozie will -unfotunately- leave you alone for SF.",
	["Bank Robbery"] = "The bank robbery is the activity that separates the boys from the men. Only the best criminals can possibly rob the bank. To rob the bank you will need lots of guns and a getaway. Travel to the LS bank marked by a $ (dollar sign) on your map to rob the bank. Bring a getaway vehicle and park it out the front of the bank. You will need this for later when you escape. Enter the bank and wait for the robbery to begin. Once in, capture all the checkpoint markers and hold them for 4 minutes. You will need to kill any police that get in your way. Work together on this. After you have successfully held the bank, exit and escape. You have to get far away from the bank to receive your reward.",
	["Drifting"] = "",
	["Street Racing"] = "",
}

-- Update timers for constant updates
local bcUpdate, bcTime, bcMsg

addEventHandler("onClientResourceStart", resourceRoot,
	function ()
		F5.window = GuiWindow(772, 390, 423, 322, "UCD | Criminal Panel", false)
		F5.window.visible = false
		F5.window.sizable = false
		F5.window.alpha = 1
		exports.UCDutil:centerWindow(F5.window)
		
		F5.progressbar = GuiProgressBar(97, 28, 315, 30, false, F5.window)
		F5.label["progress"] = GuiLabel(97, 28, 316, 30, "0/0", false, F5.window)
		guiLabelSetColor(F5.label["progress"], 1, 0, 0)
		guiLabelSetHorizontalAlign(F5.label["progress"], "center", false)
		guiLabelSetVerticalAlign(F5.label["progress"], "center")
		guiLabelSetColor(F5.label["progress"], 255, 255, 255)
		
		F5.button = GuiButton(330, 287, 82, 25, "Close", false, F5.window)
		F5.label["level"] = GuiLabel(9, 28, 78, 30, "Level", false, F5.window)
		guiLabelSetHorizontalAlign(F5.label["level"], "center", false)
		guiLabelSetVerticalAlign(F5.label["level"], "center")
		F5.label["lines"] = GuiLabel(9, 58, 402, 15, "_________________________________________________________________", false, F5.window)
		F5.tabpanel = GuiTabPanel(9, 83, 404, 195, false, F5.window)
		
		F5.tab["info"] = GuiTab("Info", F5.tabpanel)
		F5.memo["info"] = GuiMemo(10, 10, 384, 151, "As a criminal, it's basically your job to break the law. Whether it's robbing the bank, taking ove Las Venturas, engaging in firefights or street racing, you are meant to cause chaos. For every thing you do wrong (in the eyes of the law), you earn points. As you earn points, you progress through the levels. The higher your level, the more notorious you are. You earn money every time you rank up.\n\nThings to do:\n- Turfing with a gang\n- Delivering the briefcase\n- Robbing the bank\n- Killing police\n- Drifing\n- Street racing\n- Robbing houses", false, F5.tab["info"])
		F5.memo["info"].readOnly = true
		
		F5.tab["events"] = GuiTab("Events", F5.tabpanel)
		F5.label["br"] = GuiLabel(10, 10, 384, 23, "Bank Robbery: ", false, F5.tab["events"])
		guiSetFont(F5.label["br"], "clear-normal")
		guiLabelSetVerticalAlign(F5.label["br"], "center")
		F5.label["bc"] = GuiLabel(10, 43, 384, 23, "Briefcase: ", false, F5.tab["events"])
		guiSetFont(F5.label["bc"], "clear-normal")
		guiLabelSetVerticalAlign(F5.label["bc"], "center")
		F5.label["streetrace"] = GuiLabel(10, 76, 384, 23, "Street Race: <feature not completed>", false, F5.tab["events"])
		guiSetFont(F5.label["streetrace"], "clear-normal")
		guiLabelSetVerticalAlign(F5.label["streetrace"], "center")
		F5.label["drift"] = GuiLabel(10, 109, 384, 23, "Drift-Off: <feature not completed>", false, F5.tab["events"])
		guiSetFont(F5.label["drift"], "clear-normal")
		guiLabelSetVerticalAlign(F5.label["drift"], "center")
		
		F5.tab["activities"] = GuiTab("Activities", F5.tabpanel)
		F5.gridlist = GuiGridList(10, 11, 128, 150, false, F5.tab["activities"])
		guiGridListSetSortingEnabled(F5.gridlist, false)
		F5.gridlist:addColumn("Activity", 0.85)
		for activity in pairs(info) do
			local row = F5.gridlist:addRow()
			guiGridListSetItemText(F5.gridlist, row, 1, tostring(activity), false, false)
		end
		F5.memo["activityInfo"] = GuiMemo(148, 10, 246, 151, "", false, F5.tab["activities"])
		F5.memo["activityInfo"].readOnly = true
		
		addEventHandler("onClientGUIClick", F5.button, forceClose, false)
		addEventHandler("onClientGUIClick", F5.gridlist, onSelectActivity, false)
	end
)

function onSelectActivity()
	local row = guiGridListGetSelectedItem(F5.gridlist)
	if (row and row ~= -1) then
		local txt = guiGridListGetItemText(F5.gridlist, row, 1)
		F5.memo["activityInfo"].text = tostring(info[txt])
	else
		F5.memo["activityInfo"].text = ""
	end
end

function forceClose()
	F5.window.visible = false
	showCursor(false)
end
addEvent("onClientPlayerGetJob", true)
addEventHandler("onClientPlayerGetJob", root, function (job) if (job ~= "Criminal" or job ~= "Gangster") then forceClose() end end)

function toggleGUI(data)
	if (localPlayer.team and (localPlayer.team.name == "Criminals" or localPlayer.team.name == "Gangsters")) then
		if (data and type(data) == "table") then
			F5.window.visible = true
			showCursor(true)
			F5.label["progress"].text = tostring(data.xp).."/"..tostring(data.nextXP)
			F5.label["level"].text = "Level "..tostring(data.rank)
			local prog = math.floor((data.xp / data.nextXP) * 100)
			F5.progressbar.progress = prog
			
			if (tonumber(data.bank)) then
				if (data.bank > 60) then
					local mins = math.floor(data.bank / 60)
					F5.label["br"].text = "Bank Robbery: "..tostring(mins).." mins and "..tostring(math.floor(data.bank - (mins * 60))).." seconds"
				else
					F5.label["br"].text = "Bank Robbery: "..tostring(data.bank).." seconds"
				end
			else
				F5.label["br"].text = "Bank Robbery: "..tostring(data.bank)
			end
			
			if (data.bc) then
				F5.label["bc"].text = "Briefcase: "..tostring(data.bc)
				if (bcUpdate and isTimer(bcUpdate)) then
					bcUpdate:destroy()
					bcUpdate = nil
				end
				bcTime = data.bc
				bcMsg = data.bcMsg
				bcUpdate = Timer(bcDecrementTime, 1000, 0)
			end
		else
			if (F5.window.visible) then
				F5.window.visible = false
				showCursor(false)
			else
				triggerServerEvent("UCDcriminal.fetchData", resourceRoot)
			end
		end
	end
end
addCommandHandler("crimpanel", toggleGUI, false, false)
bindKey("F5", "up", "crimpanel")
addEvent("UCDcriminal.updateGUI", true)
addEventHandler("UCDcriminal.updateGUI", root, toggleGUI)

function bcDecrementTime()
	bcTime = bcTime - 1000 -- The timer is in ms, and formatMil requires ms
	if (bcTime <= 0) then
		F5.label["bc"].text = "Briefcase: Available to take"
		bcUpdate:destroy()
		bcUpdate = nil
		return
	end
	F5.label["bc"].text = "Briefcase: "..tostring(exports.UCDutil:formatMil(bcTime)).." "..tostring(bcMsg)
end
