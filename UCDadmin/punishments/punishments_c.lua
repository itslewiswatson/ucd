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
	local customReason
	if (reason == "Custom Reason") then
		reason = punish.edit["reason"].text
		customReason = true
	elseif (reason == "Select rule") then
		exports.UCDdx:new("Please select a reason", 255, 0, 0)
		return false
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
			if (not duration) then
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
