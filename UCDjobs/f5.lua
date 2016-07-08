local F5 = {label = {}}
local jobs = exports.UCDjobsTable:getJobTable()
local sX, sY = guiGetScreenSize()

F5.window = GuiWindow(sX - 301, (sY / 2) - (388 / 2), 301, 388, "UCD | Jobs", false)
F5.window.sizable = false
F5.window.visible = false
F5.window.alpha = 1

-- Memo
F5.memo = GuiMemo(9, 116, 282, 219, "", false, F5.window)
F5.memo.readOnly = true

-- Close button
F5.button = GuiButton(82, 345, 134, 32, "Close", false, F5.window)

-- Rank labels
F5.label["curr"] = GuiLabel(9, 23, 282, 25, "Current Rank: ", false, F5.window)
--guiSetFont(F5.label["curr"], "clear-normal")
guiLabelSetHorizontalAlign(F5.label["curr"], "center", false)
guiLabelSetVerticalAlign(F5.label["curr"], "center")

F5.label["next"] = GuiLabel(9, 48, 282, 25, "Next Rank: ", false, F5.window)
--guiSetFont(F5.label["next"], "clear-normal")
guiLabelSetHorizontalAlign(F5.label["next"], "center", false)
guiLabelSetVerticalAlign(F5.label["next"], "center")

-- Progress bar and label
F5.progressbar = GuiProgressBar(9, 83, 282, 23, false, F5.window)
guiProgressBarSetProgress(F5.progressbar, 100)
F5.label["prog"] = GuiLabel(9, 83, 282, 23, "130/240", false, F5.window)
guiLabelSetHorizontalAlign(F5.label["prog"], "center", true)
guiLabelSetVerticalAlign(F5.label["prog"], "center")
guiLabelSetColor(F5.label["prog"], 0, 0, 0)

function togglePanel(data)
	if (not exports.UCDaccounts:isPlayerLoggedIn(localPlayer)) then return end
	if (data and type(data) == "table") then
		local ranks = exports.UCDjobsTable:getJobRanks(data.jobName)
		local progress = exports.UCDutil:mathround(data.progress, 2)
		local currRankName = ranks[data.currRank].name
		local nextRankName = ranks[data.nextRank].name
		local nextRankProg = ranks[data.nextRank].req
		local baseRankProg = ranks[data.currRank].req
		local memoProg = (progress / nextRankProg) * 100
		local measurement = jobs[data.jobName].measurement
		
		F5.window.visible = true
		showCursor(true)
		F5.window.text = "UCD | Jobs - "..tostring(data.jobName)
		F5.label["curr"].text = "Current Rank: L"..tostring(data.currRank).." "..tostring(currRankName).." with "..tostring(exports.UCDutil:tocomma(progress)).." "..tostring(measurement)
		F5.label["next"].text = "Next Rank: L"..tostring(data.nextRank).." "..tostring(nextRankName).." with "..tostring(exports.UCDutil:tocomma(nextRankProg)).." "..tostring(measurement)
		F5.label["prog"].text = tostring(progress).."/"..tostring(nextRankProg)
		guiProgressBarSetProgress(F5.progressbar, memoProg)
		
		local rankInfo = ""
		for i = 0, #ranks do
			rankInfo = rankInfo.."L"..tostring(i).." "..tostring(ranks[i].name)..": "..tostring(ranks[i].req).." "..tostring(measurement).." \n"
		end
		
		local txt = jobs[data.jobName].desc
		txt = txt:gsub("\n\n", "\n")
		txt = txt:gsub("\n", "")
		F5.memo.text = txt
		F5.memo.text = F5.memo.text.."\n"
		F5.memo.text = F5.memo.text..rankInfo
	else
		if (F5.window.visible) then
			F5.window.visible = false
			showCursor(false)
		else
			local jobName = localPlayer:getData("Occupation") or ""
			if (not jobs[jobName] or not jobs[jobName].f5) then
				return
			end
			triggerServerEvent("UCDjobs.F5.requestData", resourceRoot)
			
		end
	end
end
addCommandHandler("jobs", togglePanel)
bindKey("F5", "up", "jobs")
addEvent("UCDjobs.F5.togglePanel", true)
addEventHandler("UCDjobs.F5.togglePanel", root, togglePanel)
addEventHandler("onClientGUIClick", F5.button, togglePanel, false)
