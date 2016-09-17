function onClientGUIChanged()
	-- Banking edit
	if (source == banking.edit[1]) then
		local text = banking.edit[1].text
		text = text:gsub(",", "")
		if (tonumber(text)) then
			banking.edit[1]:setText(exports.UCDutil:tocomma(tonumber(text)))
			if (tonumber(text) > localPlayer:getMoney()) then
				banking.edit[1].text = exports.UCDutil:tocomma(localPlayer:getMoney())
			end
			--if (guiEditGetCaretIndex(UCDhousing.edit[1]) == string.len(UCDhousing.edit[1]:getText())) then
			if (not getKeyState("backspace")) then
				guiEditSetCaretIndex(banking.edit[1], string.len(banking.edit[1].text))
			end
		end
	-- Group list search
	elseif (source == groupList.edit[1]) then
		local text = groupList.edit[1].text
		if (text == "" or text == " " or text:gsub(" ", "") == "") then
			guiGridListClear(groupList.gridlist[1])
			for name_, data_ in pairs(groupList_) do
				if (name_:lower():find(text:lower())) then
					local row = guiGridListAddRow(groupList.gridlist[1])
					guiGridListSetItemText(groupList.gridlist[1], row, 1, name_, false, false)
					guiGridListSetItemText(groupList.gridlist[1], row, 2, tostring(data_.members).."/"..tostring(data_.slots), false, false)
				end
			end
			return
		end
		guiGridListClear(groupList.gridlist[1])
		for name_, data_ in pairs(groupList_) do
			if (name_:lower():find(text:lower())) then
				local row = guiGridListAddRow(groupList.gridlist[1])
				guiGridListSetItemText(groupList.gridlist[1], row, 1, name_, false, false)
				guiGridListSetItemText(groupList.gridlist[1], row, 2, tostring(data_.members).."/"..tostring(data_.slots), false, false)
			end
		end
	-- Group log search
	elseif (source == historyGUI.edit[1]) then
		if (_hist) then
			local text = historyGUI.edit[1].text
			if (text == "" or text == " " or text:gsub(" ", "") == "") then
				historyGUI.gridlist[1]:clear()
				for _, data in pairs(_hist) do
					local row = guiGridListAddRow(historyGUI.gridlist[1])
					guiGridListSetItemText(historyGUI.gridlist[1], row, 1, tostring(data.log_), false, false)
					guiGridListSetItemColor(historyGUI.gridlist[1], row, 1, 0, 200, 200)
				end
				return
			end
			historyGUI.gridlist[1]:clear()
			for _, data in pairs(_hist) do
				if (data.log_:lower():find(text:lower())) then
					local row = guiGridListAddRow(historyGUI.gridlist[1])
					guiGridListSetItemText(historyGUI.gridlist[1], row, 1, tostring(data.log_), false, false)
					guiGridListSetItemColor(historyGUI.gridlist[1], row, 1, 0, 200, 200)
				end
			end
		end
	-- Alliance log search
	elseif (source == a_history.edit[1]) then
		if (a_hist) then
			local text = a_history.edit[1].text
			if (text == "" or text == " " or text:gsub(" ", "") == "") then
				a_history.gridlist[1]:clear()
				for _, data in pairs(a_hist) do
					local row = guiGridListAddRow(a_history.gridlist[1])
					guiGridListSetItemText(a_history.gridlist[1], row, 1, tostring(data.groupName), false, false)
					guiGridListSetItemColor(a_history.gridlist[1], row, 1, 0, 200, 200)
					guiGridListSetItemText(a_history.gridlist[1], row, 2, tostring(data.log_), false, false)
					guiGridListSetItemColor(a_history.gridlist[1], row, 2, 0, 200, 200)
				end
				return
			end
			a_history.gridlist[1]:clear()
			for _, data in pairs(a_hist) do
				if (data.log_:lower():find(text:lower())) then
					local row = guiGridListAddRow(a_history.gridlist[1])
					guiGridListSetItemText(a_history.gridlist[1], row, 1, tostring(data.groupName), false, false)
					guiGridListSetItemColor(a_history.gridlist[1], row, 1, 0, 200, 200)
					guiGridListSetItemText(a_history.gridlist[1], row, 2, tostring(data.log_), false, false)
					guiGridListSetItemColor(a_history.gridlist[1], row, 2, 0, 200, 200)
				end
			end
		end
	-- Alliance banking
	elseif (source == a_banking.edit[1]) then
		local text = a_banking.edit[1].text
		text = text:gsub(",", "")
		if (tonumber(text)) then
			a_banking.edit[1]:setText(exports.UCDutil:tocomma(tonumber(text)))
			if (tonumber(text) > localPlayer:getMoney()) then
				a_banking.edit[1].text = exports.UCDutil:tocomma(localPlayer:getMoney())
			end
			--if (guiEditGetCaretIndex(UCDhousing.edit[1]) == string.len(UCDhousing.edit[1]:getText())) then
			if (not getKeyState("backspace")) then
				guiEditSetCaretIndex(a_banking.edit[1], string.len(a_banking.edit[1].text))
			end
		end
	-- Alliance send invite
	elseif (source == a_send_invite.edit[1]) then
		if (_groups) then
			local text = source.text
			if (text == "" or text == " " or text:gsub(" ", "") == "") then
				a_send_invite.gridlist[1]:clear()
				for _, data in pairs(_groups) do
					local row = guiGridListAddRow(a_send_invite.gridlist[1])
					guiGridListSetItemText(a_send_invite.gridlist[1], row, 1, tostring(data.group_), false, false)
					guiGridListSetItemColor(a_send_invite.gridlist[1], row, 1, data.r, data.g, data.b)
				end
				return
			end
			a_send_invite.gridlist[1]:clear()
			for _, data in pairs(_groups) do
				if (data.group_:lower():find(text:lower())) then
					local row = guiGridListAddRow(a_send_invite.gridlist[1])
					guiGridListSetItemText(a_send_invite.gridlist[1], row, 1, tostring(data.group_), false, false)
					guiGridListSetItemColor(a_send_invite.gridlist[1], row, 1, data.r, data.g, data.b)
				end
			end
		end
	-- Alliance list
	elseif (source == a_list.edit[1]) then
		if (_alliances) then
			local text = source.text
			if (text == "" or text == " " or text:gsub(" ", "") == "") then
				a_list.gridlist[1]:clear()
				for _, data in pairs(_alliances) do
					local row = guiGridListAddRow(a_list.gridlist[1])
					guiGridListSetItemText(a_list.gridlist[1], row, 1, tostring(data), false, false)
				end
				return
			end
			a_list.gridlist[1]:clear()
			for _, data in pairs(_alliances) do
				if (data:lower():find(text:lower())) then
					local row = guiGridListAddRow(a_list.gridlist[1])
					guiGridListSetItemText(a_list.gridlist[1], row, 1, tostring(data), false, false)
				end
			end
		end
	end
end

function boolean(var)
	return (not (not var))
end

function updateEditForWarning()
	if (warningAdjust.window[1].visible) then
		if (tonumber(warningAdjust.edit[1].text) ~= nil) then
			if (tonumber(warningAdjust.edit[1].text) > 100) then
				warningAdjust.edit[1].text = "100"
				guiProgressBarSetProgress(warningAdjust.progressbar[1], 100)
			end
			if (tonumber(warningAdjust.edit[1].text) >= 0 and tonumber(warningAdjust.edit[1].text) <= 100) then
				guiProgressBarSetProgress(warningAdjust.progressbar[1], tonumber(warningAdjust.edit[1].text))
				if (original[1] >= tonumber(warningAdjust.edit[1].text)) then
					warningAdjust.label[2].text = tonumber(warningAdjust.edit[1].text).."% (-"..tostring(original[1] - tonumber(warningAdjust.edit[1].text))..")"
				else
					warningAdjust.label[2].text = tonumber(warningAdjust.edit[1].text).."% (+"..tostring(original[1] + tonumber(warningAdjust.edit[1].text))..")"
				end
			end
		end
	end
end

function blacklistTabSwitch(ele)
	if (ele == blacklistGUI.tab[1]) then
		guiGridListSetSelectedItem(blacklistGUI.gridlist[2], 0, 0)
	elseif (ele == blacklistGUI.tab[2]) then
		guiGridListSetSelectedItem(blacklistGUI.gridlist[1], 0, 0)
	end
end

function getOnlineTimeString(seconds)
	local str = ""
	local hours = math.floor(seconds / 60)
	local minutes = math.ceil(seconds - (hours * 60))
	if (hours > 0) then
		str = "("..hours.."h "..minutes.."m)"
	else
		str = "("..minutes.."m)"
	end
	return str
end

local blips = {}

function refreshBlips(dataName)
	if (eventName == "onClientElementDataChange" and dataName ~= "group") then return end
	for _, blip in ipairs(blips) do
		if (isElement(blip)) then
			destroyElement(blip)
		end
	end
	for _, plr in ipairs(getElementsByType("player")) do
		if (plr ~= localPlayer) then
			local locGroup = getElementData(localPlayer, "group")
			local plrGroup = getElementData(plr, "group")
			if (locGroup and locGroup == plrGroup) then
				table.insert(blips, createBlipAttachedTo(plr, 60))
			end
		end
	end
end
addEventHandler("onClientResourceStart", resourceRoot, refreshBlips)
addEventHandler("onClientPlayerJoin", root, refreshBlips)
addEventHandler("onClientElementDataChange", root, refreshBlips)
addEventHandler("onClientPlayerQuit", root, refreshBlips)