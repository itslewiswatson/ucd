mainGUI = {button = {}, window = {}, label = {}, edit = {}}
infoGUI = {button = {}, window = {}, memo = {}}
memberList = {gridlist = {}, window = {}, button = {}}
groupList = {window = {}, button = {}, gridlist = {}}
banking = {button = {}, window = {}, edit = {}, label = {}}
sendInviteGUI = {gridlist = {}, window = {}, button = {}}
plrInvites = {gridlist = {}, window = {}, button = {}}

_permissions = {
	[1] = "Ability to demote players",
	[2] = "Ability to promote players",
	[3] = "Abilty to kick players",
	[4] = "Able to promote players until their own rank",
	[5] = "Able to edit group info",
	[6] = "Able to invite players to group",
	[7] = "Able to delete the group",
	[8] = "Able to edit the group whitelist",
	[9] = "Able to edit the group blacklist",
	[10] = "Able to view the group history",
	[11] = "Able to demote players with same rank",
	[12] = "Able to deposit money in group bank",
	[13] = "Able to withdraw money from group bank",
	[14] = "Able to change the group color",
	[15] = "Able to join/create alliances",
	[16] = "Able to change the group chat color",
	[17] = "Able to warn group members",
}
forbiddenPermsForTrial = {[1] = true, [2] = true, [3] = true, [4] = true, [7] = true, [11] = true}

-- These are GUI buttons, don't confuse with the permissions
local notInGroup = {[1] = true, [2] = false, [3] = false, [4] = false, [5] = true, [6] = false, [7] = false, [8] = false, [9] = true, [10] = false, [11] = false, [12] = false, [13] = false, [14] = false, [15] = false, [16] = true}

function toggleGroupUI(updateOnly, groupName, groupInfo, permissions, rank, ranks)
	if (updateOnly ~= true) then
		if (not mainGUI.window[1].visible) then
			mainGUI.window[1].visible = true
			showCursor(true)
			guiSetInputEnabled(true)
			guiSetInputMode("no_binds_when_editing")
		else
			for _, gui in pairs(windows) do
				gui.visible = false
			end
			showCursor(false)
			guiSetInputEnabled(false)
		end
	end
	if (groupName ~= "") then
		mainGUI.window[1].text = "UCD | Groups - "..groupName
		mainGUI.edit[1].text = groupName
		mainGUI.edit[1].enabled = false
		
		mainGUI.button[1].enabled = false
		--mainGUI.button[2].enabled = not boolean(permissions[7]) -- This only appliers to founders, as they can't leave the group [count founders as well]
		mainGUI.button[2].enabled = true -- Founders should be able to leave the group, but as long as there is more than one of them
		mainGUI.button[3].enabled = boolean(permissions[7])
		mainGUI.button[4].enabled = true
		mainGUI.button[5].enabled = true -- Should always be true
		mainGUI.button[6].enabled = boolean(permissions[6])
		mainGUI.button[7].enabled = boolean(permissions[7]) -- Only founders can edit ranks
		mainGUI.button[8].enabled = boolean(permissions[10])
		mainGUI.button[9].enabled = true
		mainGUI.button[10].enabled = true
		mainGUI.button[11].enabled = boolean(permissions[9])
		mainGUI.button[12].enabled = boolean(permissions[8])
		mainGUI.button[13].enabled = boolean(permissions[12]) or boolean(permissions[13])
		mainGUI.button[14].enabled = boolean(permissions[16]) or boolean(permissions[14])
		mainGUI.button[15].enabled = boolean(permissions[15])
		mainGUI.button[16].enabled = true
		
		infoGUI.memo[1].text = groupInfo
		guiMemoSetReadOnly(infoGUI.memo[1], not boolean(permissions[5]))
		infoGUI.button[1].enabled = boolean(permissions[5])
		
		banking.button[1].enabled = boolean(permissions[12])
		banking.button[2].enabled = boolean(permissions[13])
	else
		-- If they get kicked, leave or delete the group, this should trigger
		mainGUI.window[1].text = "UCD | Groups"
		mainGUI.edit[1].text = ""
		mainGUI.edit[1].enabled = true
		for index, bool in ipairs(notInGroup) do
			mainGUI.button[index].enabled = bool
		end
		-- Have to destroy/hide all other GUIs if they are present (except group list)
		if (memberList.window[1] and isElement(memberList.window[1])) then
			memberList.window[1]:destroy()
		end
		if (infoGUI.window[1] and isElement(infoGUI.window[1])) then
			infoGUI.window[1].visible = false
		end
		if (banking.window[1] and isElement(banking.window[1])) then
			banking.window[1].visible = false
		end
	end
end
addEvent("UCDgroups.toggleGUI", true)
addEventHandler("UCDgroups.toggleGUI", root, toggleGroupUI)

function createGUI()
	mainGUI.window[1] = guiCreateWindow(756, 353, 450, 360, "UCD | Groups", false)
	mainGUI.window[1].visible = false
	guiWindowSetSizable(mainGUI.window[1], false)
	exports.UCDutil:centerWindow(mainGUI.window[1])
	mainGUI.edit[1] = guiCreateEdit(10, 31, 167, 30, "", false, mainGUI.window[1])
	guiEditSetMaxLength(mainGUI.edit[1], 20)
	mainGUI.button[1] = guiCreateButton(10, 76, 130, 36, "Create Group", false, mainGUI.window[1])
	mainGUI.button[2] = guiCreateButton(157, 76, 130, 36, "Leave Group", false, mainGUI.window[1])
	mainGUI.button[3] = guiCreateButton(307, 76, 130, 36, "Delete Group", false, mainGUI.window[1])
	mainGUI.button[4] = guiCreateButton(10, 122, 130, 36, "Group Members", false, mainGUI.window[1])
	mainGUI.button[5] = guiCreateButton(157, 122, 130, 36, "Group List", false, mainGUI.window[1])
	mainGUI.button[6] = guiCreateButton(307, 122, 130, 36, "Invite to Group", false, mainGUI.window[1])
	mainGUI.button[7] = guiCreateButton(10, 168, 130, 36, "Group Ranks", false, mainGUI.window[1])
	mainGUI.button[8] = guiCreateButton(157, 168, 130, 36, "Group History", false, mainGUI.window[1])
	mainGUI.button[9] = guiCreateButton(307, 168, 130, 36, "Group Invites", false, mainGUI.window[1])
	mainGUI.button[10] = guiCreateButton(10, 214, 130, 36, "Group Info", false, mainGUI.window[1])
	mainGUI.button[11] = guiCreateButton(10, 260, 130, 36, "Group Blacklist", false, mainGUI.window[1])
	mainGUI.button[12] = guiCreateButton(157, 260, 130, 36, "Group Whitelist", false, mainGUI.window[1])
	mainGUI.button[13] = guiCreateButton(157, 214, 130, 36, "Group Bank", false, mainGUI.window[1])
	mainGUI.button[14] = guiCreateButton(307, 214, 130, 36, "Group Settings", false, mainGUI.window[1])
	mainGUI.button[15] = guiCreateButton(307, 260, 130, 36, "Alliance", false, mainGUI.window[1])
	mainGUI.button[16] = guiCreateButton(10, 306, 430, 36, "Close", false, mainGUI.window[1])
	mainGUI.label[1] = guiCreateLabel(177, 31, 267, 15, "Founded: 25/12/2015 - 16:33", false, mainGUI.window[1])
	guiLabelSetHorizontalAlign(mainGUI.label[1], "center", false)
	guiLabelSetVerticalAlign(mainGUI.label[1], "center")
	mainGUI.label[2] = guiCreateLabel(177, 46, 267, 15, "Members: 100/150", false, mainGUI.window[1])
	guiLabelSetHorizontalAlign(mainGUI.label[2], "center", false)
	guiLabelSetVerticalAlign(mainGUI.label[2], "center")
	
	-- Group info
	infoGUI.window[1] = guiCreateWindow(690, 338, 571, 380, "UCD | Groups - Information", false)
	infoGUI.window[1].visible = false
	guiWindowSetSizable(infoGUI.window[1], false)
	infoGUI.memo[1] = guiCreateMemo(10, 23, 551, 316, "", false, infoGUI.window[1])
	infoGUI.button[1] = guiCreateButton(10, 349, 270, 21, "Save group information", false, infoGUI.window[1])
	infoGUI.button[2] = guiCreateButton(291, 349, 270, 21, "Close", false, infoGUI.window[1])   
	
	-- Group list
	groupList.window[1] = guiCreateWindow(825, 319, 298, 346, "UCD | Groups - List", false)
	guiWindowSetSizable(groupList.window[1], false)
	groupList.window[1].visible = false
	exports.UCDutil:centerWindow(groupList.window[1])
	groupList.button[1] = guiCreateButton(86, 307, 128, 29, "Close", false, groupList.window[1])
	groupList.gridlist[1] = guiCreateGridList(12, 26, 276, 276, false, groupList.window[1])
	guiGridListAddColumn(groupList.gridlist[1], "Group", 0.6)
	guiGridListAddColumn(groupList.gridlist[1], "Members", 0.3)
	
	-- Banking
	banking.window[1] = guiCreateWindow(805, 430, 316, 161, "UCD | Groups - Banking", false)
	guiWindowSetSizable(banking.window[1], false)
	banking.window[1].visible = false
	banking.button[1] = guiCreateButton(10, 106, 85, 43, "Deposit", false, banking.window[1])
	banking.label[1] = guiCreateLabel(10, 24, 293, 24, "Current balance: $999,999,999,999", false, banking.window[1])
	guiLabelSetHorizontalAlign(banking.label[1], "center", false)
	guiLabelSetVerticalAlign(banking.label[1], "center")
	banking.edit[1] = guiCreateEdit(10, 58, 293, 38, "", false, banking.window[1])
	banking.button[2] = guiCreateButton(116, 106, 85, 43, "Withdraw", false, banking.window[1])
	banking.button[3] = guiCreateButton(218, 106, 85, 43, "Close", false, banking.window[1])
	
	-- Invitations [outgoing]
	sendInviteGUI.window[1] = guiCreateWindow(837, 343, 235, 317, "UCD | Groups - Send Invitation", false)
	sendInviteGUI.window[1].visible = false
	sendInviteGUI.window[1].sizable = false
	sendInviteGUI.gridlist[1] = guiCreateGridList(9, 25, 216, 242, false, sendInviteGUI.window[1])
	guiGridListAddColumn(sendInviteGUI.gridlist[1], "Name", 0.9)
	sendInviteGUI.button[1] = guiCreateButton(9, 272, 103, 34, "Send Invite", false, sendInviteGUI.window[1])
	sendInviteGUI.button[2] = guiCreateButton(122, 272, 103, 34, "Close", false, sendInviteGUI.window[1])
	
	-- Invitations [incoming]
	plrInvites.window[1] = guiCreateWindow(777, 425, 360, 250, "UCD | Groups - Received Invitations", false)
	plrInvites.window[1].visible = false
	guiWindowSetSizable(plrInvites.window[1], false)
	plrInvites.gridlist[1] = guiCreateGridList(10, 26, 338, 169, false, plrInvites.window[1])
	guiGridListSetSortingEnabled(plrInvites.gridlist[1], false)
	guiGridListAddColumn(plrInvites.gridlist[1], "Group", 0.5)
	guiGridListAddColumn(plrInvites.gridlist[1], "Invited By", 0.4)
	plrInvites.button[1] = guiCreateButton(10, 203, 106, 35, "Accept", false, plrInvites.window[1])
	plrInvites.button[2] = guiCreateButton(128, 203, 106, 35, "Deny", false, plrInvites.window[1])
	plrInvites.button[3] = guiCreateButton(244, 203, 106, 35, "Close", false, plrInvites.window[1])
	
	-- All the group GUI windows
	windows = {mainGUI.window[1], infoGUI.window[1], memberList.window[1], groupList.window[1], banking.window[1], sendInviteGUI.window[1], plrInvites.window[1]}
	
	-- Event handlers
	addEventHandler("onClientGUIClick", mainGUI.button[1], createGroup, false)
	addEventHandler("onClientGUIClick", mainGUI.button[2], leaveGroup, false)
	addEventHandler("onClientGUIClick", mainGUI.button[3], deleteGroup, false)
	--addEventHandler("onClientGUIClick", mainGUI.button[4], function () triggerServerEvent("UCDgroups.requestMemberList", localPlayer) end, false)
	addEventHandler("onClientGUIClick", mainGUI.button[4], function () triggerEvent("UCDgroups.memberList", localPlayer) end, false)
	--addEventHandler("onClientGUIClick", mainGUI.button[5], function () triggerServerEvent("UCDgroups.requestGroupList", localPlayer) end, false)
	addEventHandler("onClientGUIClick", mainGUI.button[5], function () triggerEvent("UCDgroups.groupList", localPlayer) end, false)
	addEventHandler("onClientGUIClick", mainGUI.button[6], viewInviteTo, false)
	addEventHandler("onClientGUIClick", mainGUI.button[9], function () triggerEvent("UCDgroups.inviteList", localPlayer) end, false)
	addEventHandler("onClientGUIClick", mainGUI.button[10], viewGroupInfo, false)
	addEventHandler("onClientGUIClick", mainGUI.button[13], function () triggerServerEvent("UCDgroups.requestBalance", localPlayer) end, false)
	addEventHandler("onClientGUIClick", mainGUI.button[16], function () executeCommandHandler("groups") end, false) 
	addEventHandler("onClientGUIClick", infoGUI.button[1], saveGroupInfo, false)
	addEventHandler("onClientGUIClick", infoGUI.button[2], viewGroupInfo, false)
	addEventHandler("onClientGUIClick", groupList.button[1], function () triggerEvent("UCDgroups.groupList", localPlayer) end, false)
	addEventHandler("onClientGUIClick", banking.button[1], function () triggerEvent("UCDgroups.balanceWindow", localPlayer, "deposit") end, false)
	addEventHandler("onClientGUIClick", banking.button[2], function () triggerEvent("UCDgroups.balanceWindow", localPlayer, "withdraw") end, false)
	addEventHandler("onClientGUIClick", banking.button[3], function () triggerEvent("UCDgroups.balanceWindow", localPlayer, "toggle") end, false)
	addEventHandler("onClientGUIClick", sendInviteGUI.button[1], sendInvite, false)
	addEventHandler("onClientGUIClick", sendInviteGUI.button[2], viewInviteTo, false)
	addEventHandler("onClientGUIClick", plrInvites.button[1], handleInvite, false)
	addEventHandler("onClientGUIClick", plrInvites.button[2], handleInvite, false)
	addEventHandler("onClientGUIClick", plrInvites.button[3], function () triggerEvent("UCDgroups.inviteList", localPlayer) end, false)
end
addEventHandler("onClientResourceStart", resourceRoot, createGUI)

function bankingHandler(action, groupBalance)
	if (action == "toggle") then
		banking.window[1].visible = not banking.window[1].visible
		if (banking.window[1].visible) then
			guiBringToFront(banking.window[1])
			banking.label[1].text = "Current balance: $"..tostring(exports.UCDutil:tocomma(groupBalance))
		end
	elseif (action == "update") then
		banking.label[1].text = "Current balance: $"..tostring(exports.UCDutil:tocomma(groupBalance))
	else
		local groupBalance = gettok(banking.label[1].text, 2, "$"):gsub(",", "")
		local text
		text = banking.edit[1].text:gsub(",", "")		
		if (tonumber(text) == nil) then
			exports.UCDdx:new("You must enter a valid number to "..action, 255, 255, 0)
			return
		end
		if (tonumber(text) > source:getMoney() and action == "deposit") then
			exports.UCDdx:new("You don't have this much money to "..action, 255, 255, 0)
			return
		end
		if (tonumber(groupBalance) < tonumber(text) and action == "withdraw") then
			exports.UCDdx:new("You can't withdraw more than what is in the bank", 255, 255, 0)
			return
		end
		triggerServerEvent("UCDgroups.changeBalance", source, action, tonumber(text))
	end
end
addEvent("UCDgroups.balanceWindow", true)
addEventHandler("UCDgroups.balanceWindow", root, bankingHandler)

function onClientGUIChanged()
	if (source.parent ~= banking.window[1]) then return end
	if (source == banking.edit[1]) then
		local text = banking.edit[1].text
		text = text:gsub(",", "")
		if (tonumber(text)) then
			banking.edit[1]:setText(exports.UCDutil:tocomma(tonumber(text)))
			--if (guiEditGetCaretIndex(UCDhousing.edit[1]) == string.len(UCDhousing.edit[1]:getText())) then
			if (not getKeyState("backspace")) then
				guiEditSetCaretIndex(banking.edit[1], string.len(banking.edit[1].text))
			end
		end
	end
end
addEventHandler("onClientGUIChanged", guiRoot, onClientGUIChanged)

function boolean(var)
	return (not (not var))
end

function toggleGUI()
	if (mainGUI.window[1] and mainGUI.window[1].visible) then
		for _, gui in pairs(windows) do
			if (gui and isElement(gui)) then
				gui.visible = false
			end
		end
		if (memberList.window[1] and isElement(memberList.window[1])) then
			memberList.window[1]:destroy()
		end
		showCursor(false)
		guiSetInputEnabled(false)
	else
		triggerServerEvent("UCDgroups.viewUI", localPlayer)
	end
end
addCommandHandler("groups", toggleGUI)
bindKey("F6", "down", "groups")

function viewGroupInfo()
	infoGUI.window[1].visible = not infoGUI.window[1].visible
	if (infoGUI.window[1].visible) then
		guiBringToFront(infoGUI.window[1])
	end
end

function saveGroupInfo()
	if (infoGUI.window[1].visible) then
		if (infoGUI.memo[1].text:len() > 3000) then
			exports.UCDdx:new("The group information can't be more than 3000 characters.", 200, 0, 0)
			return
		end
		triggerServerEvent("UCDgroups.updateInfo", localPlayer, infoGUI.memo[1].text)
	end
end

function viewMemberList(members)
	if (memberList.window[1] and isElement(memberList.window[1])) then
		memberList.window[1]:destroy()
		if (not members) then
			return
		end
	else
		if (not members) then
			triggerServerEvent("UCDgroups.requestMemberList", source)
			return
		end
	end
	memberList.window[1] = guiCreateWindow(690, 369, 566, 330, "UCD | Groups - Members", false)
	guiWindowSetSizable(memberList.window[1], false)

	memberList.gridlist[1] = guiCreateGridList(9, 25, 547, 266, false, memberList.window[1])
	guiGridListAddColumn(memberList.gridlist[1], "Name", 0.3)
	guiGridListAddColumn(memberList.gridlist[1], "Rank", 0.2)
	guiGridListAddColumn(memberList.gridlist[1], "Last Online", 0.2)
	guiGridListAddColumn(memberList.gridlist[1], "WL", 0.2)
	memberList.button[1] = guiCreateButton(10, 296, 94, 24, "Promote", false, memberList.window[1])
	memberList.button[2] = guiCreateButton(120, 296, 94, 24, "Demote", false, memberList.window[1])
	memberList.button[3] = guiCreateButton(233, 296, 94, 24, "Kick", false, memberList.window[1])
	memberList.button[4] = guiCreateButton(347, 296, 94, 24, "Warn", false, memberList.window[1])
	memberList.button[5] = guiCreateButton(462, 296, 94, 24, "Close", false, memberList.window[1])
	addEventHandler("onClientGUIClick", memberList.window[1], memberListClick) -- Handle all clicks on this GUI in one function
	outputDebugString("Members: "..#members)
	for _, info in pairs(members) do
		info[5] = (info[5] or "Unknown").." days ago"
		if (info[5] == "0 days ago") then
			info[5] = "Today"
		elseif (info[5] == "1 days ago") then
			info[5] = "Yesterday"
		end
		
		local r, g, b
		local row = guiGridListAddRow(memberList.gridlist[1])
		guiGridListSetItemText(memberList.gridlist[1], row, 1, tostring(info[2]).." ("..tostring(info[3])..")", false, false)
		guiGridListSetItemText(memberList.gridlist[1], row, 2, tostring(info[4]), false, false)
		guiGridListSetItemText(memberList.gridlist[1], row, 3, tostring(info[5]).." "..tostring(getOnlineTimeString(info[6])), false, false)
		--guiGridListSetItemText(memberList.gridlist[1], row, 3, tostring(info[5]).." "..tostring((info[6])), false, false)
		guiGridListSetItemText(memberList.gridlist[1], row, 4, tostring(info[8] or 0).."%", false, true)
		guiGridListSetItemData(memberList.gridlist[1], row, 1, tostring(info[3])) -- Sets it to their account name for access
		
		if (info[1]) then -- The player is online
			r, g, b = 0, 200, 0
		else
			r, g, b = 200, 0, 0
		end
		guiGridListSetItemColor(memberList.gridlist[1], row, 1, r, g, b)
		guiGridListSetItemColor(memberList.gridlist[1], row, 2, r, g, b)
		guiGridListSetItemColor(memberList.gridlist[1], row, 3, r, g, b)
		guiGridListSetItemColor(memberList.gridlist[1], row, 4, r, g, b)
		-- 5 is days, 6 is time online in minutes, which is converted
	end
end
addEvent("UCDgroups.memberList", true)
addEventHandler("UCDgroups.memberList", root, viewMemberList)

function viewGroupList(groups)
	guiGridListClear(groupList.gridlist[1])
	if (groups and type(groups) == "table" and #groups) then
		if (not groupList.window[1].visible) then
			groupList.window[1].visible = true
			guiBringToFront(groupList.window[1])
		end
		--	Update regardless
		for i = 1, #groups do
			local row = guiGridListAddRow(groupList.gridlist[1])
			guiGridListSetItemText(groupList.gridlist[1], row, 1, groups[i].name, false, false)
			guiGridListSetItemText(groupList.gridlist[1], row, 2, tostring(groups[i].members).."/"..tostring(groups[i].slots), false, false)
		end
	else
		if (groupList.window[1].visible) then
			groupList.window[1].visible = false
		else
			-- request from the server then call this function back from the server
			triggerServerEvent("UCDgroups.requestGroupList", localPlayer)
		end
	end
end
addEvent("UCDgroups.groupList", true)
addEventHandler("UCDgroups.groupList", root, viewGroupList)

function viewInviteTo()
	sendInviteGUI.window[1].visible = not sendInviteGUI.window[1].visible
	if (sendInviteGUI.window[1].visible) then
		guiBringToFront(sendInviteGUI.window[1])
		guiGridListClear(sendInviteGUI.gridlist[1])
		for _, plr in pairs(Element.getAllByType("player")) do
			if (not plr:getData("group") and exports.UCDaccounts:isPlayerLoggedIn(plr)) then
				local row = guiGridListAddRow(sendInviteGUI.gridlist[1])
				guiGridListSetItemText(sendInviteGUI.gridlist[1], row, 1, tostring(plr.name), false, false)
				guiGridListSetItemData(sendInviteGUI.gridlist[1], row, 1, plr) -- We need to do this because a player might change their name
				guiGridListSetItemColor(sendInviteGUI.gridlist[1], row, 1, plr:getNametagColor())
			end
		end
	end
end

function sendInvite()
	if (sendInviteGUI.window[1] and isElement(sendInviteGUI.window[1]) and guiGridListGetRowCount(sendInviteGUI.gridlist[1]) >= 1) then
		local row = guiGridListGetSelectedItem(sendInviteGUI.gridlist[1])
		if (not row or row == nil or row == -1) then
			return
		end
		local plr = guiGridListGetItemData(sendInviteGUI.gridlist[1], row, 1)
		if (not plr or not isElement(plr) or plr.type ~= "player") then -- a player could have disconnected or sth
			exports.UCDdx:new("This player has disconnected", 255, 255, 0)
			return
		end
		if (plr:getData("group")) then -- They could have already joined a group double checks just to be sure
			exports.UCDdx:new("This player is already in a group - re-open this GUI to refresh", 255, 255, 0)
			return
		end
		triggerServerEvent("UCDgroups.sendInvite", localPlayer, plr)
		outputDebugString("triggerd")
	end
end

function handleInvite()
	if (source ~= plrInvites.button[1] and source ~= plrInvites.button[2]) then return end
	local row = guiGridListGetSelectedItem(plrInvites.gridlist[1])
	if (row and row ~= false and row ~= -1 and row ~= nil) then
		local group_ = guiGridListGetItemText(plrInvites.gridlist[1], row, 1)
		triggerServerEvent("UCDgroups.handleInvite", localPlayer, group_, source.text:lower())
	end
end

function viewInviteList(invites)
	if (invites) then
		guiGridListClear(plrInvites.gridlist[1])
		for _, data in pairs(invites) do
			local row = guiGridListAddRow(plrInvites.gridlist[1])
			guiGridListSetItemText(plrInvites.gridlist[1], row, 1, data[1], false, false)
			guiGridListSetItemText(plrInvites.gridlist[1], row, 2, data[2], false, false)
		end
	else
		plrInvites.window[1].visible = not plrInvites.window[1].visible
		if (plrInvites.window[1].visible) then
			guiBringToFront(plrInvites.window[1])
			triggerServerEvent("UCDgroups.requestInviteList", source)
		end
	end
end
addEvent("UCDgroups.inviteList", true)
addEventHandler("UCDgroups.inviteList", root, viewInviteList)

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

function memberListClick()
	local row = guiGridListGetSelectedItem(memberList.gridlist[1])
	-- If they don't have a row selected 
	if ((not row or row == -1 or row == nil) and source ~= source == memberList.button[5]) then
		return
	end
	if (source == memberList.button[5]) then
		--viewMemberList() -- This will hide it
		triggerEvent("UCDgroups.memberList", localPlayer)
	end
end

function createGroup()
	local name 
	name = mainGUI.edit[1].text
	for i = 1, #name do name = name:gsub("  ", " ") end
	name = name:gsub("UCD", "")
	
	--if (localPlayer:getData("group") ~= false or localPlayer:getData("group") ~= nil) then -- For some reason it can be false or nil like wtf???
	if (localPlayer:getData("group")) then
		exports.UCDdx:new("You cannot create a group because you are already in one. Leave your current group first", 255, 0, 0)
		return false
	end
	if (not name or name == nil or name:len() == 0 or name == "" or name == " ") then
		-- You need to specify a group name.
		exports.UCDdx:new("You need to specify a group name", 255, 0, 0)
		return false
	end
	if (#name < 2 or #name > 20) then
		exports.UCDdx:new("Your group name must be between 2 and 20 characters", 255, 0, 0)
		return false
	end
	triggerServerEvent("UCDgroups.createGroup", localPlayer, name)
end

function leaveGroup()
	-- Add a reason here
	if (localPlayer:getData("group")) then
		exports.UCDutil:createConfirmationWindow("UCDgroups.leaveGroup", nil, true, "UCD | Groups - Leave", "Are you sure you want to leave this group?")
	end
end

function deleteGroup()
	-- Create a confirmation window
	if (localPlayer:getData("group")) then
		--triggerServerEvent("mainGUI.deleteGroup", localPlayer)
		exports.UCDutil:createConfirmationWindow("UCDgroups.deleteGroup", nil, true, "UCD | Groups - Delete", "Are you sure you want to delete this group?")
	end
end

