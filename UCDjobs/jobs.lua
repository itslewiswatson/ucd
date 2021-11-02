local jobs = exports.UCDjobsTable:getJobTable()
local blips = {}
local markers = {}
local GUI = {}
local originalSkin = {}
local frozen
local disabledControls = {"forwards", "backwards", "jump", "sprint", "left", "right"}

function onClientResourceStart()
	local sX, sY = guiGetScreenSize()
	-- GUI
	GUI.window = GuiWindow(781, 377, 337, 418, "UCD | Jobs - ", false)
	GUI.window.visible = false
	GUI.window.sizable = false
	GUI.window.alpha = 255
	guiSetPosition(GUI.window, 0, (sY - 377) / 2, false)
	GUI.label = GuiLabel(8, 30, 319, 198, "", false, GUI.window)
	
	--[[
	GUI.gridlist = GuiGridList(11, 238, 316, 120, false, GUI.window)
	guiGridListAddColumn(GUI.gridlist, "Skin Name", 0.7)
	guiGridListAddColumn(GUI.gridlist, "Skin ID", 0.2)
	--]]
	
	GUI.take = GuiButton(11, 368, 141, 36, "Take Job", false, GUI.window)
	GUI.close = GuiButton(186, 368, 141, 36, "Close", false, GUI.window)
	
	-- F5 GUI
	--F5.window = GuiWindow()
	
	-- Event handlers
	addEventHandler("onClientGUIClick", GUI.take, takeJob, false)
	addEventHandler("onClientGUIClick", GUI.close, toggleJobGUI, false)
	
	-- Create markers
	for jobName, info in pairs(jobs) do
		if (info.markers) then
			markers[jobName] = {}
			blips[jobName] = {}
			for i, v in ipairs(info.markers) do
				markers[jobName][i] = Marker(v.x, v.y, v.z - 1, "cylinder", 2, info.colour.r, info.colour.g, info.colour.b, 120)
				markers[jobName][i]:setData("job", jobName)
				markers[jobName][i].interior = v.interior
				markers[jobName][i].dimension = v.dimension
				markers[jobName][i]:setData("displayText", jobName.." Job")
				
				if (v.interior == 0 and info.blipID) then
					blips[jobName][i] = Blip.createAttachedTo(markers[jobName][i], info.blipID, nil, nil, nil, nil, nil, 5, 255)
				end
				
				addEventHandler("onClientMarkerHit", markers[jobName][i], onJobMarkerHit)
				addEventHandler("onClientMarkerLeave", markers[jobName][i], onJobMarkerLeave)
			end
		end
	end
end
addEventHandler("onClientResourceStart", resourceRoot, onClientResourceStart)

function createGridList()
	GUI.gridlist = GuiGridList(11, 238, 316, 120, false, GUI.window)
	guiGridListAddColumn(GUI.gridlist, "Skin Name", 0.7)
	guiGridListAddColumn(GUI.gridlist, "Skin ID", 0.2)
	guiGridListSetSortingEnabled(GUI.gridlist, false)
	addEventHandler("onClientGUIClick", GUI.gridlist, previewSkin)
end

function onJobMarkerHit(plr, matchingDimension)
	if (plr and isElement(plr) and plr.type == "player" and plr == localPlayer and not plr.vehicle and matchingDimension) then
		local jobName = source:getData("job")
		if (markers[jobName] and blips[jobName]) then
			if (plr.position.z - 1.5 < source.position.z and plr.position.z + 1.5 > source.position.z) then
				--toggleJobGUI(jobName)
				--for _, ctrl in ipairs(disabledControls) do
				--	setControlState(ctrl, false)
				--end
				bindZ(jobName)
			end
		end
	end
end

function onJobMarkerLeave(plr, matchingDimension)
	if (plr and isElement(plr) and plr.type == "player" and plr == localPlayer and not plr.vehicle) then
		local jobName = source:getData("job")
		--if (jobName) then
		--if (markers[jobName]) then
			exports.UCDdx:del("jobgui")
			unbindZ()
		--end
		--end
	end
end

function bindZ(jobName)
	bindKey("z", "down", toggleJobGUI, jobName)
	exports.UCDdx:add("jobgui", "Press Z: Job GUI", 255, 215, 0)
end
function unbindZ()
	unbindKey("z", "down", toggleJobGUI)
	exports.UCDdx:del("jobgui")
end

function toggleJobGUI(_, _, jobName)
	unbindZ()
	GUI.window.visible = not GUI.window.visible
	if (GUI.window.visible) then
		if (jobName) then
			-- Set text accordingly
			if (#jobs[jobName].skins >= 1) then
				createGridList()
			else
				if (GUI.gridlist) then
					GUI.gridlist:destroy()
					GUI.gridlist = nil
				end
			end
			GUI.label.text = tostring(jobs[jobName].desc)
			GUI.window.text = "UCD | Jobs - "..jobName
			-- Add gridlist items for skins
			for _, v in ipairs(jobs[jobName].skins) do
				local row = guiGridListAddRow(GUI.gridlist)
				guiGridListSetItemText(GUI.gridlist, row, 1, v[2], false, false)
				guiGridListSetItemText(GUI.gridlist, row, 2, v[1], false, false)
			end
		end
		showCursor(true)
		--localPlayer.frozen = true
		--frozen = true
		originalSkin[localPlayer] = localPlayer.model
	else
		if (GUI.gridlist) then
			guiGridListClear(GUI.gridlist)
		end
		GUI.label.text = ""
		GUI.window.text = "UCD | Jobs - "
		showCursor(false)
		if (localPlayer.model ~= originalSkin[localPlayer] and originalSkin[localPlayer] ~= nil) then
			localPlayer.model = originalSkin[localPlayer]
			originalSkin[localPlayer] = nil
		end
		--if (localPlayer.frozen and frozen == true) then
		--	localPlayer.frozen = false
		--	frozen = false
		--end
	end
end

function previewSkin()
	local row = guiGridListGetSelectedItem(GUI.gridlist)
	if (row and row ~= -1) then
		local skinID = tonumber(guiGridListGetItemText(GUI.gridlist, row, 2))
		localPlayer.model = skinID
	else
		localPlayer.model = originalSkin[localPlayer]
	end
end	

function takeJob()
	local jobName, skin
	if (GUI.window.visible) then
		jobName = gettok(GUI.window.text, 2, "-"):sub(2)
		if (jobs[jobName]) then
			local skinID
			if (GUI.gridlist and isElement(GUI.gridlist)) then
				local row = guiGridListGetSelectedItem(GUI.gridlist)
				if (not row or row == -1) then
					exports.UCDdx:new("You need to select a skin for this job", 255, 0, 0)
					return
				end
				skinID = tonumber(guiGridListGetItemText(GUI.gridlist, row, 2))
			end
			-- Take the job
			triggerServerEvent("UCDjobs.takeJob", localPlayer, jobName, skinID, originalSkin[localPlayer])
			toggleJobGUI()
		else
			exports.UCDdx:new("Something went wrong when trying to take this job", 255, 0, 0)
		end
	end
end
