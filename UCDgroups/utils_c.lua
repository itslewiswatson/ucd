function onClientGUIChanged()
	-- Banking edit
	if (source == banking.edit[1]) then
		local text = banking.edit[1].text
		text = text:gsub(",", "")
		if (tonumber(text)) then
			if (tonumber(text) > 99999999) then
				banking.edit[1].text = "99,999,999"
			end
			banking.edit[1]:setText(exports.UCDutil:tocomma(tonumber(text)))
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
