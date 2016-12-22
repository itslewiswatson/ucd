local customTimeOnes = {punish.edit["min"], punish.edit["hour"], punish.edit["day"], punish.radiobutton[1], punish.radiobutton[2], punish.radiobutton[3]}

function processPunish()
	local duration, timeMultiplier
	if (guiCheckBoxGetSelected(punish.checkbox["custom_duration"])) then
		if (guiRadioButtonGetSelected(punish.radiobutton[1])) then
			duration = punish.edit["min"].text
			timeMultiplier = 60
		elseif (guiRadioButtonGetSelected(punish.radiobutton[2])) then
			duration = punish.edit["hour"].text
			timeMultiplier = 3600
		elseif (guiRadioButtonGetSelected(punish.radiobutton[3])) then
			duration = punish.edit["day"].text
			timeMultiplier = (3600 * 24)
		else
			exports.UCDdx:new("Please select a time duration", 255, 0, 0)
			return false
		end
	end
	if (duration ~= nil and duration ~= "-1") then
		if (not tonumber(duration)) then
			exports.UCDdx:new("Enter a valid duration", 255, 0, 0)
			return false
		end
		duration = math.floor(duration * timeMultiplier)
	end
	
	local reason = guiComboBoxGetItemText(punish.combobox["rules"], guiComboBoxGetSelected(punish.combobox["rules"]))
	local customReason, removing
	if (reason == "Custom Reason") then
		reason = punish.edit["reason"].text
		customReason = true
	elseif (reason == "Select rule") then
		exports.UCDdx:new("Please select a reason", 255, 0, 0)
		return false
	elseif (reason == "Removing Punishment") then
		customReason = false
		removing = true
	end
	if (customReason) then
		if (reason:gsub(" ", "") == "") then
			exports.UCDdx:new("Please enter a reason", 255, 0, 0)
			return false
		end
		if (not duration) then
			exports.UCDdx:new("Please select a custom duration", 255, 0, 0)
			return false
		end
	else
		local ruleNo = reason:sub(2, 2):match("%d")
		if (reason:sub(1, 1) ~= "#" and not ruleNo) then
			-- They selected a reason which warrants a custom duration as it's not automatic
			if (not duration and not removing) then
				exports.UCDdx:new("Please enter a duration", 255, 0, 0)
				return false
			end
		end
	end
	
	local val
	if (punish.edit["custom"].enabled) then
		val = punish.edit["custom"].text
	else
		val = _plr
	end
	
	local action = guiComboBoxGetItemText(punish.combobox["punishtype"], guiComboBoxGetSelected(punish.combobox["punishtype"])):lower()
	if (action == "select punish type") then
		exports.UCDdx:new("Please select a punishment type", 255, 0, 0)
		return false
	end
	
	if (not _permissions[action]) then
		if (action == "ban") then
			exports.UCDdx:new(source, "Only L3+ admins may issue bans", 255, 0, 0)
		else
			exports.UCDdx:new(source, "Nice try. I wonder how you're here...", 255, 0, 0)
		end
		return
	end
	
	if (tonumber(duration) == -1 and action ~= "ban") then
		exports.UCDdx:new("Only bans can be permanent (-1 duration)", 255, 0, 0)
		return
	end
	
	togglePunishWindow() -- Have to hide it because timestamp shit and spam
	triggerServerEvent("UCDadmin.punish", resourceRoot, val, tonumber(duration), action, localPlayer, {reason, customReason})
end
addEventHandler("onClientGUIClick", punish.button["punish"], processPunish, false)

function customTimeShit()
	for _, gui in ipairs(customTimeOnes) do
		gui.enabled = not gui.enabled
	end
end
customTimeShit() -- Do this once to disable them
addEventHandler("onClientGUIClick", punish.checkbox["custom_duration"], customTimeShit, false)

function viewPunish.autoSize()
	for _, gui in pairs(viewPunish.grid) do
		for i = 1, gui.columnCount do
			gui:autoSizeColumn(i)
			gui:setColumnWidth(i, guiGridListGetColumnWidth(gui, i, true) + 0.006, true)
			-- yeah auto size function doesn't work well, idk why doesn't it show last letter
			-- i wonder why dont they make guiGridListGetColumnWidth in OOP
		end
	end
end

function viewPunish.edit()
	if (not _permissions["manage punish"]) then
		exports.UCDdx:new("Only L3+ admins may manage punishments", 255, 0, 0)
		return
	end
	local i = viewPunish.tabpanel.selectedTab == viewPunish.tab[1] and 1 or 2
	local row = viewPunish.grid[i]:getSelectedItem()
	if (not row or row == -1) then return end
	local key, log = viewPunish.grid[i]:getItemText(row, 1), viewPunish.grid[i]:getItemText(row, 2)
	triggerServerEvent("UCDadmin.punishments.onEditPunishment", localPlayer, key, log)
	viewPunish.editButton.enabled = false
	Timer(guiSetEnabled, 2500, 1, viewPunish.editButton, true)
	local sX, sY = guiGetScreenSize()
	local cX, cY = getCursorPosition()
	local x, y = cX * sX, cY * sY
	setCursorPosition(x + 0.1, y) -- because of MTA
end
addEventHandler("onClientGUIClick", viewPunish.editButton, viewPunish.edit, false)

function viewPunish.close()
	viewPunish.window.visible = false
end
addEvent("UCDadmin.punishments.closeGUI", true)
addEventHandler("UCDadmin.punishments.closeGUI", localPlayer, viewPunish.close)
addEventHandler("onClientGUIClick", viewPunish.closeButton, viewPunish.close, false)

function viewPunish.insertPunishments(data)
	for _, gui in ipairs(viewPunish.grid) do gui:clear() end
	if (data.serial) then
		for _, v in ipairs(data.serial) do
			local row = viewPunish.grid[1]:addRow()
			viewPunish.grid[1]:setItemText(row, 1, v[1], false, false)
			viewPunish.grid[1]:setItemText(row, 2, v[2], false, false)
			local r, g, b = 0, 255, 0
			if (v[3] == 0) then
				r, g, b = 255, 0, 0
			end
			viewPunish.grid[1]:setItemColor(row, 1, r, g, b)
			viewPunish.grid[1]:setItemColor(row, 2, r, g, b)
		end
	end
	if (data.account) then
		for _, v in ipairs(data.account) do
			local row = viewPunish.grid[2]:addRow()
			viewPunish.grid[2]:setItemText(row, 1, v[1], false, false)
			viewPunish.grid[2]:setItemText(row, 2, v[2], false, false)
			local r, g, b = 0, 255, 0
			if (v[3] == 0) then
				r, g, b = 255, 0, 0
			end
			viewPunish.grid[2]:setItemColor(row, 1, r, g, b)
			viewPunish.grid[2]:setItemColor(row, 2, r, g, b)
		end
	end
	viewPunish.autoSize()
end
addEvent("UCDadmin.punishments.onReceivePunishments", true)
addEventHandler("UCDadmin.punishments.onReceivePunishments", localPlayer, viewPunish.insertPunishments)