mainGUI = {button = {}, window = {}, label = {}, edit = {}}
infoGUI = {button = {}, window = {}, memo = {}}
memberList = {gridlist = {}, window = {}, button = {}}
groupList = {window = {}, button = {}, gridlist = {}, edit = {}}
banking = {button = {}, window = {}, edit = {}, label = {}}
sendInviteGUI = {gridlist = {}, window = {}, button = {}}
plrInvites = {gridlist = {}, window = {}, button = {}}
warningAdjust = {progressbar = {}, edit = {}, button = {}, window = {}, label = {}}
blacklistGUI = {tab = {}, tabpanel = {}, button = {}, window = {}, gridlist = {}}
addBL = {button = {}, window = {}, edit = {}, label = {}}
historyGUI = {edit = {}, button = {}, window = {}, label = {}, gridlist = {}}
ranksGUI = {checkbox = {}, scrollpane = {}, label = {}, button = {}, window = {}, gridlist = {}}
groupSettings = {edit = {}, button = {}, window = {}, label = {}, combobox = {}}
addRankGUI = {checkbox = {}, scrollpane = {}, edit = {}, button = {}, window = {}, label = {}, combobox = {}}
editRankGUI = {checkbox = {}, scrollpane = {}, edit = {}, button = {}, window = {}, label = {}}
PD = {edit = {}, button = {}, window = {}, label = {}, combobox = {}}
allianceGUI = {button = {}, window = {}, label = {}, edit = {}}
a_members = {window = {}, gridlist = {}, button = {}}
a_info = {button = {}, window = {}, memo = {}}
a_history = {edit = {}, button = {}, window = {}, label = {}, gridlist = {}}
a_banking = {button = {}, window = {}, edit = {}, label = {}}
a_send_invite = {gridlist = {}, window = {}, button = {}}

original = {}
groupList_ = {}
settings_ = {}
permissions_ = {}

_permissions = {
	[1] = "Ability to demote members",
	[2] = "Ability to promote members",
	[3] = "Abilty to kick members",
	[4] = "Abilty to promote members until own rank",
	[5] = "Abilty to edit group info",
	[6] = "Abilty to invite players to group",
	[7] = "Abilty to delete the group",
	[8] = "Abilty to edit the group whitelist",
	[9] = "Abilty to edit the group blacklist",
	[10] = "Abilty to view the group's history",
	[11] = "Abilty to demote members with same rank",
	[12] = "Abilty to deposit into group bank",
	[13] = "Abilty to withdraw from group bank",
	[14] = "Abilty to change the group color",
	[15] = "Abilty to manage alliances",
	[16] = "Abilty to change the group chat color",
	[17] = "Abilty to warn group members",
	[18] = "Ability to use group staff chat (/gsc)",
	[19] = "Ability to set GMOTD",
	----------------------------------------------------
	--[[
	[20] = "Ability to take the group job",
	[21] = "Ability to edit the base information",
	[22] = "Ability to edit the job information",
	[23] = "Ability to modify group spawners",
	--]]	
}
forbiddenPermsForTrial = {[1] = true, [2] = true, [3] = true, [4] = true, [7] = true, [11] = true}

-- These are GUI buttons, don't confuse with the permissions
local notInGroup = {[1] = true, [2] = false, [3] = false, [4] = false, [5] = true, [6] = false, [7] = false, [8] = false, [9] = true, [10] = false, [11] = false, [12] = false, [13] = false, [14] = false, [15] = false, [16] = true}

function toggleGUI()
	if (not exports.UCDaccounts:isPlayerLoggedIn(localPlayer)) then
		return
	end
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

function toggleGroupUI(updateOnly, groupName, groupInfo, permissions, rank, ranks, memberCount, groupSlots, created)
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
		permissions_ = permissions
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
		mainGUI.button[7].enabled = true -- Everyone should be able to view ranks, though not everyone should be able to edit them
		mainGUI.button[8].enabled = boolean(permissions[10])
		mainGUI.button[9].enabled = true
		mainGUI.button[10].enabled = true
		mainGUI.button[11].enabled = boolean(permissions[9])
		mainGUI.button[12].enabled = boolean(permissions[8])
		mainGUI.button[13].enabled = boolean(permissions[12]) or boolean(permissions[13])
		mainGUI.button[14].enabled = boolean(permissions[16]) or boolean(permissions[14]) or boolean(permissions[19])
		mainGUI.button[15].enabled = true -- boolean(permissions[15]) -- Alliances, so you should be able to open it regardless
		mainGUI.button[16].enabled = true
		
		--allianceGUI.button[1].enabled = boolean(permissions_[15]) and 
		
		infoGUI.memo[1].text = groupInfo
		guiMemoSetReadOnly(infoGUI.memo[1], not boolean(permissions[5]))
		infoGUI.button[1].enabled = boolean(permissions[5])
		
		banking.button[1].enabled = boolean(permissions[12])
		banking.button[2].enabled = boolean(permissions[13])
		
		-- Group colour
		for i = 1, 3 do
			groupSettings.edit[i].readOnly = not boolean(permissions[14])
		end
		-- Group chat colour
		for i = 3, 6 do
			groupSettings.edit[i].readOnly = not boolean(permissions[16])
		end
		-- Combobox for highest ranks only
		groupSettings.combobox[1].enabled = boolean(permissions[-1])
		groupSettings.combobox[2].enabled = boolean(permissions[-1])
		mainGUI.label[1].text = "Founded: "..tostring(created)
		mainGUI.label[2].text = "Members: "..tostring(memberCount).."/"..tostring(groupSlots)
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
		mainGUI.label[1].text = "Founded: N/A"
		mainGUI.label[2].text = "Members: N/A"
		allianceGUI.button[1].enabled = false
	end
end
addEvent("UCDgroups.toggleGUI", true)
addEventHandler("UCDgroups.toggleGUI", root, toggleGroupUI)

function toggleAlliance()
	if (not exports.UCDaccounts:isPlayerLoggedIn(localPlayer)) then
		return
	end
	if (allianceGUI.window[1] and allianceGUI.window[1].visible) then
		for i = 1, #allianceGUI.window do
			allianceGUI.window[i].visible = false
		end
	else
		triggerServerEvent("UCDgroups.alliance.viewUI", localPlayer)
	end
end

function toggleAllianceUI(updateOnly, alliance, allianceInfo, alliancePerms, created)
	if (updateOnly ~= true) then
		if (not allianceGUI.window[1].visible) then
			allianceGUI.window[1].visible = true
			guiBringToFront(allianceGUI.window[1])
		else
			for i = 1, #allianceGUI.window do
				allianceGUI.window[i].visible = false
			end
		end
	end
	if (alliance and alliance ~= "") then
		allianceGUI.window[1].text = "UCD | Alliances - "..alliance
		allianceGUI.edit[1].text = alliance
		allianceGUI.edit[1].enabled = false
		allianceGUI.label[1].text = "Founded: "..created
		
		a_info.memo[1].text = allianceInfo
		
		allianceGUI.button[1].enabled = false
		allianceGUI.button[2].enabled = true
		allianceGUI.button[3].enabled = boolean(alliancePerms[3])
		allianceGUI.button[4].enabled = true
		allianceGUI.button[5].enabled = true
		allianceGUI.button[6].enabled = boolean(alliancePerms[6])
		allianceGUI.button[7].enabled = true
		allianceGUI.button[8].enabled = true
		allianceGUI.button[9].enabled = true
		allianceGUI.button[10].enabled = true
		
		a_members.button[1].enabled = boolean(permissions_[15]) and boolean(alliancePerms[3]) and boolean(alliancePerms[6])
		a_members.button[2].enabled = boolean(permissions_[15]) and boolean(alliancePerms[3]) and boolean(alliancePerms[6])
		a_members.button[3].enabled = boolean(permissions_[15]) and boolean(alliancePerms[3]) and boolean(alliancePerms[6])
	else
		allianceGUI.window[1].text = "UCD | Alliances"
		allianceGUI.edit[1].text = ""
		allianceGUI.edit[1].enabled = true
		allianceGUI.label[1].text = "Founded: N/A"
		
		allianceGUI.button[1].enabled = boolean(permissions_[15]) -- This one is the main one that controls it
		allianceGUI.button[2].enabled = false
		allianceGUI.button[3].enabled = false
		allianceGUI.button[4].enabled = false
		allianceGUI.button[5].enabled = false
		allianceGUI.button[6].enabled = false
		allianceGUI.button[7].enabled = false
		allianceGUI.button[8].enabled = false
		allianceGUI.button[9].enabled = false
		allianceGUI.button[10].enabled = false
		
		a_members.button[1].enabled = false
		a_members.button[2].enabled = false
		a_members.button[3].enabled = false
	end	
end
addEvent("UCDgroups.alliance.toggleGUI", true)
addEventHandler("UCDgroups.alliance.toggleGUI", root, toggleAllianceUI)

function createGUI()
	-- Main info
	mainGUI.window[1] = GuiWindow(756, 353, 450, 360, "UCD | Groups", false)
	mainGUI.window[1].visible = false
	guiWindowSetSizable(mainGUI.window[1], false)
	exports.UCDutil:centerWindow(mainGUI.window[1])
	mainGUI.edit[1] = GuiEdit(10, 31, 167, 30, "", false, mainGUI.window[1])
	guiEditSetMaxLength(mainGUI.edit[1], 20)
	mainGUI.button[1] = GuiButton(10, 76, 130, 36, "Create Group", false, mainGUI.window[1])
	mainGUI.button[2] = GuiButton(157, 76, 130, 36, "Leave Group", false, mainGUI.window[1])
	mainGUI.button[3] = GuiButton(307, 76, 130, 36, "Delete Group", false, mainGUI.window[1])
	mainGUI.button[4] = GuiButton(10, 122, 130, 36, "Group Members", false, mainGUI.window[1])
	mainGUI.button[5] = GuiButton(157, 122, 130, 36, "Group List", false, mainGUI.window[1])
	mainGUI.button[6] = GuiButton(307, 122, 130, 36, "Invite to Group", false, mainGUI.window[1])
	mainGUI.button[7] = GuiButton(10, 168, 130, 36, "Group Ranks", false, mainGUI.window[1])
	mainGUI.button[8] = GuiButton(157, 168, 130, 36, "Group History", false, mainGUI.window[1])
	mainGUI.button[9] = GuiButton(307, 168, 130, 36, "Group Invites", false, mainGUI.window[1])
	mainGUI.button[10] = GuiButton(10, 214, 130, 36, "Group Info", false, mainGUI.window[1])
	mainGUI.button[11] = GuiButton(10, 260, 130, 36, "Group Blacklist", false, mainGUI.window[1])
	mainGUI.button[12] = GuiButton(157, 260, 130, 36, "Group Whitelist", false, mainGUI.window[1])
	mainGUI.button[13] = GuiButton(157, 214, 130, 36, "Group Bank", false, mainGUI.window[1])
	mainGUI.button[14] = GuiButton(307, 214, 130, 36, "Group Settings", false, mainGUI.window[1])
	mainGUI.button[15] = GuiButton(307, 260, 130, 36, "Alliance", false, mainGUI.window[1]) -- 169.229.3.91
	mainGUI.button[16] = GuiButton(10, 306, 430, 36, "Close", false, mainGUI.window[1])
	mainGUI.label[1] = GuiLabel(177, 31, 267, 15, "Founded: N/A", false, mainGUI.window[1])
	guiLabelSetHorizontalAlign(mainGUI.label[1], "center", false)
	guiLabelSetVerticalAlign(mainGUI.label[1], "center")
	mainGUI.label[2] = GuiLabel(177, 46, 267, 15, "Members: N/A", false, mainGUI.window[1])
	guiLabelSetHorizontalAlign(mainGUI.label[2], "center", false)
	guiLabelSetVerticalAlign(mainGUI.label[2], "center")
	
	-- Group info
	infoGUI.window[1] = GuiWindow(690, 338, 571, 380, "UCD | Groups - Information", false)
	infoGUI.window[1].visible = false
	guiWindowSetSizable(infoGUI.window[1], false)
	infoGUI.memo[1] = guiCreateMemo(10, 23, 551, 316, "", false, infoGUI.window[1])
	infoGUI.button[1] = GuiButton(10, 349, 270, 21, "Save group information", false, infoGUI.window[1])
	infoGUI.button[2] = GuiButton(291, 349, 270, 21, "Close", false, infoGUI.window[1])   
	
	-- Group list
	groupList.window[1] = GuiWindow(812, 336, 298, 346, "UCD | Groups - List", false)
	groupList.window[1].sizable = false
	groupList.window[1].visible = false
	groupList.button[1] = GuiButton(209, 307, 79, 29, "Close", false, groupList.window[1])
	groupList.gridlist[1] = GuiGridList(12, 26, 276, 276, false, groupList.window[1])
	guiGridListAddColumn(groupList.gridlist[1], "Group", 0.65)
	guiGridListAddColumn(groupList.gridlist[1], "Members", 0.25)
	groupList.edit[1] = GuiEdit(12, 307, 187, 29, "", false, groupList.window[1])

	-- Banking
	banking.window[1] = GuiWindow(805, 430, 316, 161, "UCD | Groups - Banking", false)
	guiWindowSetSizable(banking.window[1], false)
	banking.window[1].visible = false
	banking.button[1] = GuiButton(10, 106, 85, 43, "Deposit", false, banking.window[1])
	banking.label[1] = GuiLabel(10, 24, 293, 24, "Current balance: $999,999,999,999", false, banking.window[1])
	guiLabelSetHorizontalAlign(banking.label[1], "center", false)
	guiLabelSetVerticalAlign(banking.label[1], "center")
	banking.edit[1] = GuiEdit(10, 58, 293, 38, "", false, banking.window[1])
	banking.button[2] = GuiButton(116, 106, 85, 43, "Withdraw", false, banking.window[1])
	banking.button[3] = GuiButton(218, 106, 85, 43, "Close", false, banking.window[1])
	
	-- Invitations [outgoing]
	sendInviteGUI.window[1] = GuiWindow(837, 343, 235, 317, "UCD | Groups - Send Invitation", false)
	sendInviteGUI.window[1].visible = false
	sendInviteGUI.window[1].sizable = false
	sendInviteGUI.gridlist[1] = GuiGridList(9, 25, 216, 242, false, sendInviteGUI.window[1])
	guiGridListAddColumn(sendInviteGUI.gridlist[1], "Name", 0.9)
	sendInviteGUI.button[1] = GuiButton(9, 272, 103, 34, "Send Invite", false, sendInviteGUI.window[1])
	sendInviteGUI.button[2] = GuiButton(122, 272, 103, 34, "Close", false, sendInviteGUI.window[1])
	
	-- Invitations [incoming]
	plrInvites.window[1] = GuiWindow(777, 425, 360, 250, "UCD | Groups - Received Invitations", false)
	plrInvites.window[1].visible = false
	guiWindowSetSizable(plrInvites.window[1], false)
	plrInvites.gridlist[1] = GuiGridList(10, 26, 338, 169, false, plrInvites.window[1])
	guiGridListSetSortingEnabled(plrInvites.gridlist[1], false)
	guiGridListAddColumn(plrInvites.gridlist[1], "Group", 0.5)
	guiGridListAddColumn(plrInvites.gridlist[1], "Invited By", 0.4)
	plrInvites.button[1] = GuiButton(10, 203, 106, 35, "Accept", false, plrInvites.window[1])
	plrInvites.button[2] = GuiButton(128, 203, 106, 35, "Deny", false, plrInvites.window[1])
	plrInvites.button[3] = GuiButton(244, 203, 106, 35, "Close", false, plrInvites.window[1])
	
	-- Warnings
	warningAdjust.window[1] = GuiWindow(814, 393, 285, 220, "UCD | Groups - Warnings", false)
	warningAdjust.window[1].sizable = false
	warningAdjust.window[1].visible = false
	warningAdjust.progressbar[1] = guiCreateProgressBar(10, 30, 261, 25, false, warningAdjust.window[1])
	warningAdjust.button[1] = GuiButton(10, 173, 126, 37, "Set Warning", false, warningAdjust.window[1])
	warningAdjust.edit[1] = GuiEdit(89, 82, 105, 22, "", false, warningAdjust.window[1])
	warningAdjust.edit[2] = GuiEdit(10, 141, 262, 22, "", false, warningAdjust.window[1])   
	warningAdjust.label[1] = GuiLabel(10, 59, 261, 18, "Enter the new warning level", false, warningAdjust.window[1])
	guiLabelSetHorizontalAlign(warningAdjust.label[1], "center", false)
	warningAdjust.label[2] = GuiLabel(10, 31, 261, 24, "0% (+0)", false, warningAdjust.window[1])
	guiLabelSetColor(warningAdjust.label[2], 0, 0, 0)
	guiLabelSetHorizontalAlign(warningAdjust.label[2], "center", false)
	guiLabelSetVerticalAlign(warningAdjust.label[2], "center")
	warningAdjust.button[1] = GuiButton(10, 173, 126, 37, "Set Warning", false, warningAdjust.window[1])
	warningAdjust.button[2] = GuiButton(146, 173, 126, 37, "Close", false, warningAdjust.window[1])
	warningAdjust.label[3] = GuiLabel(10, 119, 261, 18, "Enter the reason", false, warningAdjust.window[1])
	guiLabelSetHorizontalAlign(warningAdjust.label[3], "center", false)
	
	-- Blacklist
	blacklistGUI.window[1] = GuiWindow(397, 191, 600, 310, "UCD | Groups - Blacklist", false)
	blacklistGUI.window[1].sizable = false
	blacklistGUI.window[1].visible = false
	blacklistGUI.tabpanel[1] = guiCreateTabPanel(9, 24, 581, 239, false, blacklistGUI.window[1])
	blacklistGUI.tab[1] = guiCreateTab("Account", blacklistGUI.tabpanel[1])
	blacklistGUI.gridlist[1] = GuiGridList(9, 6, 562, 158, false, blacklistGUI.tab[1])
	guiGridListAddColumn(blacklistGUI.gridlist[1], "Account", 0.2)
	guiGridListAddColumn(blacklistGUI.gridlist[1], "Reason", 0.3)
	guiGridListAddColumn(blacklistGUI.gridlist[1], "Date", 0.23)
	guiGridListAddColumn(blacklistGUI.gridlist[1], "Blacklisted by", 0.2)
	blacklistGUI.button[1] = GuiButton(10, 174, 130, 28, "Add New", false, blacklistGUI.tab[1])
	blacklistGUI.button[2] = GuiButton(150, 174, 130, 28, "Delete Selected", false, blacklistGUI.tab[1])
	blacklistGUI.tab[2] = guiCreateTab("Serial", blacklistGUI.tabpanel[1])
	blacklistGUI.gridlist[2] = GuiGridList(9, 6, 562, 158, false, blacklistGUI.tab[2])
	guiGridListAddColumn(blacklistGUI.gridlist[2], "Serial", 0.2)
	guiGridListAddColumn(blacklistGUI.gridlist[2], "Reason", 0.3)
	guiGridListAddColumn(blacklistGUI.gridlist[2], "Date", 0.23)
	guiGridListAddColumn(blacklistGUI.gridlist[2], "Blacklisted by", 0.2)
	blacklistGUI.button[3] = GuiButton(10, 174, 130, 28, "Add New", false, blacklistGUI.tab[2])
	blacklistGUI.button[4] = GuiButton(150, 174, 130, 28, "Delete Selected", false, blacklistGUI.tab[2])
	blacklistGUI.button[5] = GuiButton(9, 269, 581, 31, "Close", false, blacklistGUI.window[1])
	
	-- Blacklist add
	addBL.window[1] = GuiWindow(516, 288, 346, 148, "UCD | Groups - New Blacklist Item", false)
	addBL.window[1].sizable = false
	addBL.window[1].visible = false
	addBL.label[1] = GuiLabel(10, 30, 124, 23, "Account name", false, addBL.window[1])
	guiLabelSetHorizontalAlign(addBL.label[1], "center", false)
	guiLabelSetVerticalAlign(addBL.label[1], "center")
	addBL.label[2] = GuiLabel(10, 59, 124, 23, "Reason", false, addBL.window[1])
	guiLabelSetHorizontalAlign(addBL.label[2], "center", false)
	guiLabelSetVerticalAlign(addBL.label[2], "center")
	addBL.button[1] = GuiButton(24, 99, 132, 36, "Confirm", false, addBL.window[1])
	addBL.edit[1] = GuiEdit(134, 30, 190, 23, "", false, addBL.window[1])
	addBL.edit[2] = GuiEdit(134, 59, 190, 23, "", false, addBL.window[1])
	addBL.button[2] = GuiButton(176, 99, 132, 36, "Cancel", false, addBL.window[1])
	
	-- History
	historyGUI.window[1] = GuiWindow(684, 343, 589, 350, "UCD | Groups - History", false)
	historyGUI.window[1].sizable = false
	historyGUI.window[1].visible = false
	historyGUI.gridlist[1] = GuiGridList(9, 24, 570, 277, false, historyGUI.window[1])
	guiGridListAddColumn(historyGUI.gridlist[1], "Log", 1.5)
	guiGridListSetSortingEnabled(historyGUI.gridlist[1], false)
	historyGUI.button[1] = GuiButton(455, 310, 124, 30, "Close", false, historyGUI.window[1])
	historyGUI.label[1] = GuiLabel(15, 310, 199, 15, "Group:", false, historyGUI.window[1])
	historyGUI.label[2] = GuiLabel(15, 325, 199, 15, "Viewing:", false, historyGUI.window[1])
	historyGUI.edit[1] = GuiEdit(194, 310, 176, 35, "", false, historyGUI.window[1])
	
	-- Custom ranks
	ranksGUI.window[1] = GuiWindow(698, 408, 519, 286, "UCD | Groups - Ranks", false)
	ranksGUI.window[1].sizable = false
	ranksGUI.window[1].visible = false
	ranksGUI.gridlist[1] = GuiGridList(10, 25, 186, 201, false, ranksGUI.window[1])
	guiGridListSetSortingEnabled(ranksGUI.gridlist[1], false)
	guiGridListAddColumn(ranksGUI.gridlist[1], "Group Ranks", 0.9)
	ranksGUI.button[1] = GuiButton(10, 236, 117, 35, "Add Rank", false, ranksGUI.window[1])
	ranksGUI.button[2] = GuiButton(137, 236, 117, 34, "Edit Rank", false, ranksGUI.window[1])
	ranksGUI.button[3] = GuiButton(264, 236, 117, 34, "Remove Rank", false, ranksGUI.window[1])
	ranksGUI.button[4] = GuiButton(391, 236, 117, 34, "Close", false, ranksGUI.window[1])
	ranksGUI.scrollpane[1] = guiCreateScrollPane(206, 25, 302, 201, false, ranksGUI.window[1])
	local cbc = 0
	for i, ent in ipairs(_permissions) do
		ranksGUI.label[i] = GuiLabel(21, cbc * 19, 266, 15, ent, false, ranksGUI.scrollpane[1])
		ranksGUI.checkbox[i] = guiCreateCheckBox(0, 19 * cbc, 15, 15, "", false, false, ranksGUI.scrollpane[1])
		cbc = cbc + 1
	end
	
	-- Add rank
	addRankGUI.window[1] = GuiWindow(82, 118, 319, 368, "UCD | Groups - Add Rank", false)
	addRankGUI.window[1].sizable = false
	addRankGUI.window[1].visible = false
	addRankGUI.button[1] = GuiButton(10, 329, 141, 29, "Add Rank", false, addRankGUI.window[1])
	addRankGUI.button[2] = GuiButton(168, 330, 141, 28, "Close", false, addRankGUI.window[1])
	addRankGUI.label[1] = GuiLabel(10, 23, 71, 22, "Rank Name:", false, addRankGUI.window[1])
	guiLabelSetHorizontalAlign(addRankGUI.label[1], "center", false)
	guiLabelSetVerticalAlign(addRankGUI.label[1], "center")
	addRankGUI.edit[1] = GuiEdit(87, 23, 222, 22, "", false, addRankGUI.window[1])
	addRankGUI.label[2] = GuiLabel(10, 50, 71, 22, "Create After:", false, addRankGUI.window[1])
	guiLabelSetHorizontalAlign(addRankGUI.label[2], "center", false)
	guiLabelSetVerticalAlign(addRankGUI.label[2], "center")
	addRankGUI.combobox[1] = guiCreateComboBox(94, 51, 215, 172, "", false, addRankGUI.window[1])
	addRankGUI.scrollpane[1] = guiCreateScrollPane(10, 79, 299, 240, false, addRankGUI.window[1])
	--addRankGUI.checkbox[1] = guiCreateCheckBox(0, 0, 15, 15, "", false, false, addRankGUI.scrollpane[1])
	--addRankGUI.label[3] = GuiLabel(20, 0, 279, 15, "Ability to demote members", false, addRankGUI.scrollpane[1])
	local cbc = 0
	for i, ent in ipairs(_permissions) do
		addRankGUI.label[i] = GuiLabel(20, cbc * 19, 279, 15, ent, false, addRankGUI.scrollpane[1])
		addRankGUI.checkbox[i] = guiCreateCheckBox(0, 19 * cbc, 15, 15, "", false, false, addRankGUI.scrollpane[1])
		cbc = cbc + 1
	end
	
	-- Edit rank
	editRankGUI.window[1] = GuiWindow(774, 393, 319, 368, "UCD | Groups - Edit Rank", false)
	editRankGUI.window[1].sizable = false
	editRankGUI.window[1].visible = false
	editRankGUI.button[1] = GuiButton(10, 329, 141, 29, "Update Rank", false, editRankGUI.window[1])
	editRankGUI.button[2] = GuiButton(168, 330, 141, 28, "Close", false, editRankGUI.window[1])
	editRankGUI.label[1] = GuiLabel(10, 23, 71, 22, "Rank Name:", false, editRankGUI.window[1])
	guiLabelSetHorizontalAlign(editRankGUI.label[1], "center", false)
	guiLabelSetVerticalAlign(editRankGUI.label[1], "center")
	editRankGUI.edit[1] = GuiEdit(87, 23, 222, 22, "", false, editRankGUI.window[1])
	editRankGUI.scrollpane[1] = guiCreateScrollPane(10, 55, 299, 264, false, editRankGUI.window[1])
	local cbc = 0
	for i, ent in ipairs(_permissions) do
		editRankGUI.label[i] = GuiLabel(20, cbc * 19, 279, 15, ent, false, editRankGUI.scrollpane[1])
		editRankGUI.checkbox[i] = guiCreateCheckBox(0, 19 * cbc, 15, 15, "", false, false, editRankGUI.scrollpane[1])
		cbc = cbc + 1
	end
	
	-- Settings
	groupSettings.window[1] = GuiWindow(930, 213, 297, 396, "UCD | Groups - Settings", false)
	groupSettings.window[1].sizable = false
	groupSettings.window[1].visible = false
	-- group colour
	groupSettings.edit[1] = GuiEdit(134, 34, 43, 24, "", false, groupSettings.window[1])
	groupSettings.edit[2] = GuiEdit(187, 34, 43, 24, "", false, groupSettings.window[1])
	groupSettings.edit[3] = GuiEdit(240, 34, 43, 24, "", false, groupSettings.window[1])
	-- group chat colour
	groupSettings.edit[4] = GuiEdit(134, 68, 43, 24, "", false, groupSettings.window[1])
	groupSettings.edit[5] = GuiEdit(187, 68, 43, 24, "", false, groupSettings.window[1])
	groupSettings.edit[6] = GuiEdit(240, 68, 43, 24, "", false, groupSettings.window[1])
	for i = 1, 6 do
		guiEditSetMaxLength(groupSettings.edit[i], 3)
	end
	
	--
	groupSettings.label[1] = GuiLabel(10, 34, 114, 24, "Group colour", false, groupSettings.window[1])
	guiLabelSetHorizontalAlign(groupSettings.label[1], "center", false)
	guiLabelSetVerticalAlign(groupSettings.label[1], "center")
	groupSettings.label[2] = GuiLabel(10, 68, 114, 24, "Group chat colour", false, groupSettings.window[1])
	guiLabelSetHorizontalAlign(groupSettings.label[2], "center", false)
	guiLabelSetVerticalAlign(groupSettings.label[2], "center")
	groupSettings.label[3] = GuiLabel(10, 92, 273, 15, "________________________________________", false, groupSettings.window[1])
	groupSettings.button[1] = GuiButton(10, 117, 129, 32, "Edit base info", false, groupSettings.window[1])
	groupSettings.button[2] = GuiButton(154, 117, 129, 32, "Edit job info", false, groupSettings.window[1])
	groupSettings.button[3] = GuiButton(10, 159, 129, 32, "Modify spawner permissions", false, groupSettings.window[1])
	groupSettings.button[4] = GuiButton(154, 159, 129, 32, "Change group name", false, groupSettings.window[1])
	for i = 1, 4 do
		groupSettings.button[i].enabled = false
	end
	groupSettings.label[4] = GuiLabel(10, 191, 273, 15, "________________________________________", false, groupSettings.window[1])
	--
	groupSettings.combobox[1] = guiCreateComboBox(154, 216, 129, 65, "", false, groupSettings.window[1])
	guiComboBoxAddItem(groupSettings.combobox[1], "No")
	guiComboBoxAddItem(groupSettings.combobox[1], "Yes")
	groupSettings.combobox[2] = guiCreateComboBox(154, 245, 129, 65, "", false, groupSettings.window[1])
	guiComboBoxAddItem(groupSettings.combobox[2], "No")
	guiComboBoxAddItem(groupSettings.combobox[2], "Yes")
	-- default setting
	guiComboBoxSetSelected(groupSettings.combobox[1], 0)
	guiComboBoxSetSelected(groupSettings.combobox[2], 1)
	--
	groupSettings.label[5] = GuiLabel(10, 216, 129, 19, "Lock invites", false, groupSettings.window[1])
	guiLabelSetHorizontalAlign(groupSettings.label[5], "center", false)
	guiLabelSetVerticalAlign(groupSettings.label[5], "center")
	groupSettings.label[6] = GuiLabel(11, 245, 129, 19, "Group staff chat", false, groupSettings.window[1])
	guiLabelSetHorizontalAlign(groupSettings.label[6], "center", false)
	guiLabelSetVerticalAlign(groupSettings.label[6], "center")
	groupSettings.button[5] = GuiButton(10, 350, 128, 36, "Save", false, groupSettings.window[1])
	groupSettings.button[6] = GuiButton(154, 350, 128, 36, "Close", false, groupSettings.window[1])
	groupSettings.label[7] = GuiLabel(10, 264, 273, 15, "________________________________________", false, groupSettings.window[1])
	groupSettings.edit[7] = GuiEdit(10, 318, 273, 22, "", false, groupSettings.window[1])
	guiEditSetMaxLength(groupSettings.edit[7], 96)
	groupSettings.label[8] = GuiLabel(11, 289, 272, 19, "Group message of the day (GMOTD)", false, groupSettings.window[1])
	guiLabelSetHorizontalAlign(groupSettings.label[8], "center", false)
	guiLabelSetVerticalAlign(groupSettings.label[8], "center")
	for i = 1, #groupSettings.edit do
		groupSettings.edit[i].enabled = false
	end
	
	-- promote demote
	PD.window[1] = GuiWindow(474, 357, 324, 169, "UCD | Groups - ", false)
	PD.window[1].sizable = false
	PD.window[1].visible = false
	PD.button[1] = GuiButton(58, 140, 101, 19, "Confirm", false, PD.window[1])
	PD.button[2] = GuiButton(169, 140, 101, 19, "Cancel", false, PD.window[1])
	PD.edit[1] = GuiEdit(36, 105, 260, 25, "", false, PD.window[1])
	PD.label[1] = GuiLabel(37, 80, 259, 20, "Enter the reason for ", false, PD.window[1])
	PD.label[2] = GuiLabel(37, 22, 259, 20, "Select the new rank", false, PD.window[1])
	guiLabelSetHorizontalAlign(PD.label[1], "center", false)
	guiLabelSetVerticalAlign(PD.label[1], "center")
	guiLabelSetHorizontalAlign(PD.label[2], "center", false)
	guiLabelSetVerticalAlign(PD.label[2], "center")
	PD.combobox[1] = guiCreateComboBox(37, 46, 259, 150, "", false, PD.window[1])
	
	-- Alliances
	allianceGUI.window[1] = guiCreateWindow(752, 413, 447, 256, "UCD | Alliances", false)
	allianceGUI.window[1].sizable = false
	allianceGUI.window[1].visible = false
	
	allianceGUI.edit[1] = GuiEdit(10, 28, 161, 30, "", false, allianceGUI.window[1])
	allianceGUI.button[1] = GuiButton(10, 68, 130, 36, "Create Alliance", false, allianceGUI.window[1])
	allianceGUI.button[2] = GuiButton(157, 68, 130, 36, "Leave Alliance", false, allianceGUI.window[1])
	allianceGUI.button[3] = GuiButton(307, 68, 130, 36, "Delete Alliance", false, allianceGUI.window[1])
	allianceGUI.button[4] = GuiButton(10, 114, 130, 36, "Alliance Members", false, allianceGUI.window[1])
	allianceGUI.button[5] = GuiButton(157, 114, 130, 36, "Alliance List", false, allianceGUI.window[1])
	allianceGUI.button[6] = GuiButton(307, 114, 130, 36, "Invite to Alliance", false, allianceGUI.window[1])
	allianceGUI.button[7] = GuiButton(157, 160, 130, 36, "Alliance History", false, allianceGUI.window[1])
	allianceGUI.button[8] = GuiButton(307, 160, 130, 36, "Alliance Invites", false, allianceGUI.window[1])
	allianceGUI.button[9] = GuiButton(10, 206, 130, 36, "Alliance Bank", false, allianceGUI.window[1])
	allianceGUI.button[10] = GuiButton(10, 160, 130, 36, "Alliance Info", false, allianceGUI.window[1])
	allianceGUI.button[11] = GuiButton(157, 206, 280, 36, "Close", false, allianceGUI.window[1])
	allianceGUI.label[1] = guiCreateLabel(170, 28, 267, 30, "Founded: N/A", false, allianceGUI.window[1])
	guiLabelSetHorizontalAlign(allianceGUI.label[1], "center", false)
	guiLabelSetVerticalAlign(allianceGUI.label[1], "center")
	
	a_members.window[1] = GuiWindow(785, 421, 348, 206, "UCD | Alliances - Members", false)
	a_members.window[1].visible = false
	a_members.window[1].sizable = false
	a_members.gridlist[1] = GuiGridList(10, 27, 326, 133, false, a_members.window[1])
	guiGridListAddColumn(a_members.gridlist[1], "Group", 0.3)
	guiGridListAddColumn(a_members.gridlist[1], "Members", 0.3)
	guiGridListAddColumn(a_members.gridlist[1], "Rank", 0.3)
	guiGridListSetSortingEnabled(a_members.gridlist[1], false)
	a_members.button[1] = GuiButton(10, 170, 74, 22, "Promote", false, a_members.window[1])
	a_members.button[2] = GuiButton(94, 170, 74, 22, "Demote", false, a_members.window[1])
	a_members.button[3] = GuiButton(178, 170, 74, 22, "Kick", false, a_members.window[1])
	a_members.button[4] = GuiButton(262, 170, 74, 22, "Close", false, a_members.window[1])
	
	a_info.window[1] = GuiWindow(690, 338, 571, 380, "UCD | Alliances - Information", false)
	a_info.window[1].visible = false
	a_info.window[1].sizable = false
	a_info.memo[1] = guiCreateMemo(10, 23, 551, 316, "", false, a_info.window[1])
	a_info.button[1] = GuiButton(10, 349, 270, 21, "Save alliance information", false, a_info.window[1])
	a_info.button[2] = GuiButton(291, 349, 270, 21, "Close", false, a_info.window[1])
	
	a_history.window[1] = GuiWindow(684, 343, 589, 350, "UCD | Alliances - History", false)
	a_history.window[1].sizable = false
	a_history.window[1].visible = false
	a_history.gridlist[1] = GuiGridList(9, 24, 570, 277, false, a_history.window[1])
	guiGridListAddColumn(a_history.gridlist[1], "Group", 0.15)
	guiGridListAddColumn(a_history.gridlist[1], "Log", 1.5)
	guiGridListSetSortingEnabled(a_history.gridlist[1], false)
	a_history.button[1] = GuiButton(455, 310, 124, 30, "Close", false, a_history.window[1])
	a_history.label[1] = GuiLabel(15, 310, 199, 15, "Alliance:", false, a_history.window[1])
	a_history.label[2] = GuiLabel(15, 325, 199, 15, "Viewing:", false, a_history.window[1])
	a_history.edit[1] = GuiEdit(194, 310, 176, 35, "", false, a_history.window[1])
	
	a_banking.window[1] = GuiWindow(805, 430, 316, 161, "UCD | Alliances - Banking", false)
	a_banking.window[1].sizable = false
	a_banking.window[1].visible = false
	a_banking.button[1] = GuiButton(10, 106, 85, 43, "Deposit", false, a_banking.window[1])
	a_banking.label[1] = GuiLabel(10, 24, 293, 24, "Current balance:", false, a_banking.window[1])
	guiLabelSetHorizontalAlign(a_banking.label[1], "center", false)
	guiLabelSetVerticalAlign(a_banking.label[1], "center")
	a_banking.edit[1] = GuiEdit(10, 58, 293, 38, "", false, a_banking.window[1])
	a_banking.button[2] = GuiButton(116, 106, 85, 43, "Withdraw", false, a_banking.window[1])
	a_banking.button[3] = GuiButton(218, 106, 85, 43, "Close", false, a_banking.window[1])
	
	-- Invitations [outgoing]
	a_send_invite.window[1] = GuiWindow(837, 343, 235, 317, "UCD | Alliance - Send Invitation", false)
	a_send_invite.window[1].visible = false
	a_send_invite.window[1].sizable = false
	a_send_invite.gridlist[1] = GuiGridList(9, 25, 216, 242, false, a_send_invite.window[1])
	guiGridListAddColumn(a_send_invite.gridlist[1], "Group", 0.9)
	a_send_invite.button[1] = GuiButton(9, 272, 103, 34, "Send Invite", false, a_send_invite.window[1])
	a_send_invite.button[2] = GuiButton(122, 272, 103, 34, "Close", false, a_send_invite.window[1])
	
	-- All the group GUI windows
	windows = {mainGUI.window[1], infoGUI.window[1], memberList.window[1], groupList.window[1], banking.window[1], sendInviteGUI.window[1], plrInvites.window[1], warningAdjust.window[1], blacklistGUI.window[1], addBL.window[1], historyGUI.window[1], ranksGUI.window[1], groupSettings.window[1], addRankGUI.window[1], editRankGUI.window[1], PD.window[1], allianceGUI.window[1], a_members.window[1], a_info.window[1], a_history.window[1], a_banking.window[1], a_send_invite.window[1]}
	for _, gui in pairs(windows) do
		if (gui and isElement(gui)) then
			exports.UCDutil:centerWindow(gui)
			gui.alpha = 1
		end
	end
	
	-- Event handlers
	addEventHandler("onClientGUIClick", mainGUI.button[1], createGroup, false)
	addEventHandler("onClientGUIClick", mainGUI.button[2], leaveGroup, false)
	addEventHandler("onClientGUIClick", mainGUI.button[3], deleteGroup, false)
	addEventHandler("onClientGUIClick", mainGUI.button[4], function () triggerEvent("UCDgroups.memberList", localPlayer) end, false)
	addEventHandler("onClientGUIClick", mainGUI.button[5], function () triggerEvent("UCDgroups.groupList", localPlayer) end, false)
	addEventHandler("onClientGUIClick", mainGUI.button[6], viewInviteTo, false)
	addEventHandler("onClientGUIClick", mainGUI.button[7], viewGroupRanks, false)
	addEventHandler("onClientGUIClick", mainGUI.button[8], viewGroupHistory, false)
	addEventHandler("onClientGUIClick", mainGUI.button[9], function () triggerEvent("UCDgroups.inviteList", localPlayer) end, false)
	addEventHandler("onClientGUIClick", mainGUI.button[10], viewGroupInfo, false)
	addEventHandler("onClientGUIClick", mainGUI.button[11], function () triggerEvent("UCDgroups.blacklist", localPlayer) end, false)
	addEventHandler("onClientGUIClick", mainGUI.button[13], function () triggerServerEvent("UCDgroups.requestBalance", localPlayer) end, false)
	addEventHandler("onClientGUIClick", mainGUI.button[14], viewGroupSettings, false)
	addEventHandler("onClientGUIClick", mainGUI.button[15], toggleAlliance, false)
	addEventHandler("onClientGUIClick", mainGUI.button[16], function () executeCommandHandler("groups") end, false)
	--
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
	addEventHandler("onClientGUIClick", warningAdjust.button[1], warnMember, false)
	addEventHandler("onClientGUIClick", warningAdjust.button[2], function () triggerEvent("UCDgroups.warningLevelGUI", localPlayer, 0) end, false)
	addEventHandler("onClientGUIClick", blacklistGUI.button[1], handleBlacklist, false)
	addEventHandler("onClientGUIClick", blacklistGUI.button[2], handleBlacklist, false)
	addEventHandler("onClientGUIClick", blacklistGUI.button[3], handleBlacklist, false)
	addEventHandler("onClientGUIClick", blacklistGUI.button[4], handleBlacklist, false)
	addEventHandler("onClientGUIClick", blacklistGUI.button[5], function () triggerEvent("UCDgroups.blacklist", localPlayer) end, false)
	addEventHandler("onClientGUIClick", addBL.button[2], handleBlacklist, false)
	addEventHandler("onClientGUIClick", addBL.button[1], handleBlacklist, false)
	addEventHandler("onClientGUIClick", historyGUI.button[1], viewGroupHistory, false)
	addEventHandler("onClientGUIClick", ranksGUI.button[4], viewGroupRanks, false)
	-- Edit this
	--addEventHandler("onClientGUIClick", guiRoot, pieceofshit, false)
	
	--addEventHandler("onClientGUIClick", guiRoot, groupRankHandler, false)
	addEventHandler("onClientGUIClick", ranksGUI.gridlist[1], groupRankHandler, false)
	addEventHandler("onClientGUIClick", ranksGUI.button[1], groupRankHandler, false)
	addEventHandler("onClientGUIClick", ranksGUI.button[2], groupRankHandler, false)
	addEventHandler("onClientGUIClick", ranksGUI.button[3], groupRankHandler, false)
	addEventHandler("onClientGUIClick", ranksGUI.button[4], groupRankHandler, false)
	addEventHandler("onClientGUIClick", addRankGUI.button[1], groupRankHandler, false)
	addEventHandler("onClientGUIClick", addRankGUI.button[2], groupRankHandler, false)
	addEventHandler("onClientGUIClick", editRankGUI.button[1], groupRankHandler, false)
	addEventHandler("onClientGUIClick", editRankGUI.button[2], groupRankHandler, false)
	
	addEventHandler("onClientGUIClick", groupSettings.button[6], viewGroupSettings, false)
	addEventHandler("onClientGUIClick", groupSettings.button[5], settingsHandler, false)
	
	addEventHandler("onClientGUIClick", PD.button[1], confirmPD, false)
	addEventHandler("onClientGUIClick", PD.button[2], promoteDemoteWindow, false)
	
	-- Alliances
	addEventHandler("onClientGUIClick", allianceGUI.button[1], createAlliance, false)
	addEventHandler("onClientGUIClick", allianceGUI.button[2], leaveAlliance, false)
	addEventHandler("onClientGUIClick", allianceGUI.button[3], deleteAlliance, false)
	addEventHandler("onClientGUIClick", allianceGUI.button[4], function () triggerEvent("UCDgroups.alliance.memberList", localPlayer) end, false)
	addEventHandler("onClientGUIClick", allianceGUI.button[6], viewAllianceInviteTo, false)
	addEventHandler("onClientGUIClick", allianceGUI.button[7], viewAllianceHistory, false)
	addEventHandler("onClientGUIClick", allianceGUI.button[9], function () triggerServerEvent("UCDgroups.requestAllianceBalance", localPlayer) end, false)
	addEventHandler("onClientGUIClick", allianceGUI.button[10], viewAllianceInfo, false)
	addEventHandler("onClientGUIClick", allianceGUI.button[11], toggleAlliance, false)
	
	addEventHandler("onClientGUIClick", a_members.button[4], function () triggerEvent("UCDgroups.alliance.memberList", localPlayer) end, false)
	addEventHandler("onClientGUIClick", a_members.window[1], allianceMemberListHandler, true)
	addEventHandler("onClientGUIClick", a_info.button[1], saveAllianceInfo, false)
	addEventHandler("onClientGUIClick", a_info.button[2], viewAllianceInfo, false)
	addEventHandler("onClientGUIClick", a_history.button[1], viewAllianceHistory, false)
	addEventHandler("onClientGUIClick", a_banking.button[1], function () triggerEvent("UCDgroups.alliance.balanceWindow", localPlayer, "deposit") end, false)
	addEventHandler("onClientGUIClick", a_banking.button[2], function () triggerEvent("UCDgroups.alliance.balanceWindow", localPlayer, "withdraw") end, false)
	addEventHandler("onClientGUIClick", a_banking.button[3], function () triggerEvent("UCDgroups.alliance.balanceWindow", localPlayer, "toggle") end, false)
	addEventHandler("onClientGUIClick", a_send_invite.button[2], viewAllianceInviteTo, false)
	
	addEventHandler("onClientGUITabSwitched", guiRoot, blacklistTabSwitch)
	addEventHandler("onClientGUIChanged", guiRoot, onClientGUIChanged)
	
	-- Need these to properly check changes
	addEventHandler("onClientGUIChanged", groupSettings.window[1], onSettingsChange)
	addEventHandler("onClientGUIFocus", groupSettings.window[1], onSettingsChange)
	addEventHandler("onClientGUIComboBoxAccepted", groupSettings.window[1], onSettingsChange)
end
addEventHandler("onClientResourceStart", resourceRoot, createGUI)

function groupRankHandler()
	if (source == ranksGUI.gridlist[1] or source.parent == ranksGUI.gridlist[1] or source == ranksGUI.button[3] or source == ranksGUI.button[2] or source == editRankGUI.button[2]) then
		local row = guiGridListGetSelectedItem(ranksGUI.gridlist[1])
		if (row and row ~= -1) then
			outputDebugString(tostring(row))
			local rank = guiGridListGetItemText(ranksGUI.gridlist[1], row, 1)
			
			-- Set permissions of specified rank in the GUI
			if (groupRanks_[rank][2] == -1) then
				for i = 1, #ranksGUI.checkbox do
					ranksGUI.checkbox[i].selected = true
				end
			else
				for i = 1, #ranksGUI.checkbox do
					ranksGUI.checkbox[i].selected = boolean(groupRanks_[rank][1][i])
				end
			end
			
			-- Delete rank
			if (source == ranksGUI.button[3]) then
				-- A row should already be selected
				exports.UCDutil:createConfirmationWindow("UCDgroups.deleteRank", rank, true, "UCD | Groups - Delete Rank", "Are you sure you want to delete this rank?\n Anyone with this rank will be demoted")
			-- Edit rank
			elseif (source == ranksGUI.button[2] or source == editRankGUI.button[2]) then
				rankToChange = rank
				editRankGUI.window[1].visible = not editRankGUI.window[1].visible
				if (editRankGUI.window[1].visible) then
					guiBringToFront(editRankGUI.window[1])
					editRankGUI.edit[1].text = rank
					for i = 1, #editRankGUI.checkbox do
						if (groupRanks_[rank][2] == -1) then
							editRankGUI.checkbox[i].selected = true
							editRankGUI.checkbox[i].enabled = false
						elseif (groupRanks_[rank][2] == 0) then
							for i in pairs(forbiddenPermsForTrial) do
								editRankGUI.checkbox[i].enabled = false
							end
						else
							editRankGUI.checkbox[i].selected = boolean(groupRanks_[rank][1][i])
							editRankGUI.checkbox[i].enabled = true
						end
					end
				else
					editRankGUI.edit[1].text = ""
					for i = 1, #editRankGUI.checkbox do
						editRankGUI.checkbox[i].selected = false
						editRankGUI.checkbox[i].enabled = true
					end
				end
			end
		else
			-- If there is no row selected, clear everything
			editRankGUI.window[1].visible = false
			editRankGUI.edit[1].text = ""
			for i = 1, #editRankGUI.checkbox do
				editRankGUI.checkbox[i].selected = false
				editRankGUI.checkbox[i].enabled = true
			end
			for i = 1, #ranksGUI.checkbox do
				ranksGUI.checkbox[i].selected = false
			end
		end
	end
	-- Opening/closing the add rank gui
	if (source == ranksGUI.button[1] or source == addRankGUI.button[2]) then
		addRankGUI.window[1].visible = not addRankGUI.window[1].visible
		addRankGUI.edit[1].text = ""
		guiComboBoxClear(addRankGUI.combobox[1])
		guiBringToFront(addRankGUI.window[1])
		for i = 1, #addRankGUI.checkbox do
			addRankGUI.checkbox[i].selected = false
		end
		local curIndex = 0
		for k, v in pairs(groupRanks_) do
			if (v[2] > -1) then
				for key, val in pairs(groupRanks_) do
					if (val[2] == curIndex) then
						guiComboBoxAddItem(addRankGUI.combobox[1], key)
					end
				end
				curIndex = curIndex + 1
			end
		end	
	-- Adding a rank
	elseif (source == addRankGUI.button[1]) then
		if (addRankGUI.window[1].visible) then
			local rankName = addRankGUI.edit[1].text
			if (not rankName or rankName == "" or rankName == " " or rankName:gsub(" ", "") == "") then
				exports.UCDdx:new("Please enter a valid rank name", 255, 255, 0)
				return
			end
			if (rankName:len() < 2 or rankName:len() > 30) then
				exports.UCDdx:new("A rank name must be between 2 and 30 characters", 255, 255, 0)
				return
			end
			local row = guiComboBoxGetSelected(addRankGUI.combobox[1])
			local prevRank 
			if (row and row ~= -1 and row ~= nil) then
				prevRank = guiComboBoxGetItemText(addRankGUI.combobox[1], row)
			end
			outputDebugString("prevRank = "..prevRank)
			
			if (not groupRanks_[prevRank] or prevRank == "" or not prevRank) then
				exports.UCDdx:new("Invalid previous rank selected", 255, 255, 0)
				return
			end
			-- Gather permissions
			local temp = {}
			for i = 1, #addRankGUI.checkbox do
				if (addRankGUI.checkbox[i].selected) then
					temp[i] = true
 				end
			end
			triggerServerEvent("UCDgroups.addRank", localPlayer, rankName, prevRank, temp)
		end
	-- Edit rank
	elseif (source == editRankGUI.button[1]) then
		local rank = editRankGUI.edit[1].text
		if (rank ~= rankToChange) then
			if (not rank or rank == "" or rank == " " or rank:gsub(" ", "") == "") then
				exports.UCDdx:new("Please enter a valid rank name", 255, 255, 0)
				return
			end
			if (rank:len() < 2 or rank:len() > 30) then
				exports.UCDdx:new("A rank name must be between 2 and 30 characters", 255, 255, 0)
				return
			end
			
		end
		-- Gather permissions
		local temp = {}
		if (groupRanks_[rankToChange][2] == -1) then
			for i = 1, 30 do
				temp[i] = true
			end
		else
			for i = 1, #editRankGUI.checkbox do
				if (editRankGUI.checkbox[i].selected) then
					temp[i] = true
				end
			end
		end
		triggerServerEvent("UCDgroups.editRank", localPlayer, rankToChange, rank, temp or {})
		outputDebugString("trigger")
	end
end

function settingsHandler()
	-- Will add support for other things later [edit base, spawners, etc]
	-- Save button
	if (source == groupSettings.button[5]) then
		if (tostring(settings_.groupColour[1]) ~= groupSettings.edit[1].text or tostring(settings_.groupColour[2]) ~= groupSettings.edit[2].text or tostring(settings_.groupColour[3]) ~= groupSettings.edit[3].text
		or tostring(settings_.chatColour[1]) ~= groupSettings.edit[4].text or tostring(settings_.chatColour[2]) ~= groupSettings.edit[5].text or tostring(settings_.chatColour[3]) ~= groupSettings.edit[6].text
		or settings_.lockInvites ~= guiComboBoxGetSelected(groupSettings.combobox[1]) or settings_.enableGSC ~= guiComboBoxGetSelected(groupSettings.combobox[2])
		or settings_.gmotd ~= groupSettings.edit[7].text) then
			outputDebugString("something has changed")
			for i = 1, 6 do -- First 6 edits should be numbers
				if (tonumber(groupSettings.edit[i].text) == nil) then
					exports.UCDdx:new("You need to enter a number from 0 to 255 in the boxes", 255, 0, 0)
					return
				end
				if (tonumber(groupSettings.edit[i].text) < 0 or tonumber(groupSettings.edit[i].text) > 255) then
					exports.UCDdx:new("You need to enter a number from 0 to 255 in the boxes", 255, 0, 0)
					return
				end
			end
			local temp = {
				["groupColour"] = {tonumber(groupSettings.edit[1].text), tonumber(groupSettings.edit[2].text), tonumber(groupSettings.edit[3].text)},
				["chatColour"] = {tonumber(groupSettings.edit[4].text), tonumber(groupSettings.edit[5].text), tonumber(groupSettings.edit[6].text)},
				["lockInvites"] = guiComboBoxGetSelected(groupSettings.combobox[1]),
				["enableGSC"] = guiComboBoxGetSelected(groupSettings.combobox[2]),
				["gmotd"] = groupSettings.edit[7].text,
 			}
			triggerServerEvent("UCDgroups.updateSettings", localPlayer, temp)
		end
	end
end
function onSettingsChange()
	if (tostring(settings_.groupColour[1]) ~= groupSettings.edit[1].text or tostring(settings_.groupColour[2]) ~= groupSettings.edit[2].text or tostring(settings_.groupColour[3]) ~= groupSettings.edit[3].text
	or tostring(settings_.chatColour[1]) ~= groupSettings.edit[4].text or tostring(settings_.chatColour[2]) ~= groupSettings.edit[5].text or tostring(settings_.chatColour[3]) ~= groupSettings.edit[6].text
	or settings_.lockInvites ~= guiComboBoxGetSelected(groupSettings.combobox[1]) or settings_.enableGSC ~= guiComboBoxGetSelected(groupSettings.combobox[2])
	or settings_.gmotd ~= groupSettings.edit[7].text) then
		groupSettings.button[5].enabled = true
	else
		groupSettings.button[5].enabled = false
	end
end

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

function viewGroupInfo()
	infoGUI.window[1].visible = not infoGUI.window[1].visible
	if (infoGUI.window[1].visible) then
		guiBringToFront(infoGUI.window[1])
	end
end

function saveGroupInfo()
	if (infoGUI.window[1].visible) then
		if (infoGUI.memo[1].text:len() > 10000) then
			exports.UCDdx:new("The group information can't be more than 10,000 characters.", 200, 0, 0)
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
	-- If a player closes his/her group GUI while the latent event is in progress, we need to not show this
	if (not mainGUI.window[1].visible) then
		return
	end
	memberList.window[1] = GuiWindow(690, 369, 566, 330, "UCD | Groups - Members", false)
	memberList.window[1].sizable = false
	memberList.window[1].alpha = 255
	exports.UCDutil:centerWindow(memberList.window[1])
	memberList.gridlist[1] = GuiGridList(9, 25, 547, 266, false, memberList.window[1])
	guiGridListAddColumn(memberList.gridlist[1], "Name", 0.3)
	guiGridListAddColumn(memberList.gridlist[1], "Rank", 0.2)
	guiGridListAddColumn(memberList.gridlist[1], "Last Online", 0.3)
	guiGridListAddColumn(memberList.gridlist[1], "WL", 0.1)
	memberList.button[1] = GuiButton(10, 296, 94, 24, "Promote", false, memberList.window[1])
	memberList.button[2] = GuiButton(120, 296, 94, 24, "Demote", false, memberList.window[1])
	memberList.button[3] = GuiButton(233, 296, 94, 24, "Kick", false, memberList.window[1])
	memberList.button[4] = GuiButton(347, 296, 94, 24, "Warn", false, memberList.window[1])
	memberList.button[5] = GuiButton(462, 296, 94, 24, "Close", false, memberList.window[1])
	addEventHandler("onClientGUIClick", memberList.window[1], memberListClick) -- Handle all clicks on this GUI in one function
	outputDebugString("Members: "..#members)
	
	-- Permissions
	memberList.button[1].enabled = boolean(permissions_[2]) or boolean(permissions_[11])
	memberList.button[2].enabled = boolean(permissions_[1])
	memberList.button[3].enabled = boolean(permissions_[3])
	memberList.button[4].enabled = boolean(permissions_[17])
	
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
		guiGridListSetItemText(memberList.gridlist[1], row, 4, tostring(info[7] or 0).."%", false, true)
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
	groupList.edit[1].text = ""
	if (groups and type(groups) == "table" and #groups) then
		if (not groupList.window[1].visible) then
			groupList.window[1].visible = true
			guiBringToFront(groupList.window[1])
		end
		--	Update regardless
		--for i = 1, #groups do
		for name, data in pairs(groups) do
			local row = guiGridListAddRow(groupList.gridlist[1])
			guiGridListSetItemText(groupList.gridlist[1], row, 1, name, false, false)
			guiGridListSetItemText(groupList.gridlist[1], row, 2, tostring(data.members).."/"..tostring(data.slots), false, false)
		end
		groupList_ = groups -- So we can search it later
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

function warningLevelGUI(level)
	original = {level}
	warningAdjust.window[1].visible = not warningAdjust.window[1].visible
	if (warningAdjust.window[1].visible) then
		guiBringToFront(warningAdjust.window[1])
		guiProgressBarSetProgress(warningAdjust.progressbar[1], level)
		warningAdjust.label[2].text = level.."% (+0)"
		addEventHandler("onClientGUIChanged", warningAdjust.edit[1], updateEditForWarning)
	else
		warningAdjust.edit[1].text = ""
		warningAdjust.edit[2].text = ""
		removeEventHandler("onClientGUIChanged", warningAdjust.edit[1], updateEditForWarning)
		guiProgressBarSetProgress(warningAdjust.progressbar[1], 0)
	end
end
addEvent("UCDgroups.warningLevelGUI", true)
addEventHandler("UCDgroups.warningLevelGUI", root, warningLevelGUI)

function warnMember()
	local warningLvl = guiProgressBarGetProgress(warningAdjust.progressbar[1])
	local reason = warningAdjust.edit[2].text
	if (reason:gsub(" ", "") == "") then reason = "No Reason" end
	triggerServerEvent("UCDgroups.warnMember", localPlayer, accounToBeWarned, warningLvl, reason)
	triggerEvent("UCDgroups.warningLevelGUI", localPlayer, 0)
end

function viewGroupSettings(settings)
	if (settings and type(settings) == "table") then
		settings_ = settings
		if (not groupSettings.window[1].visible) then
			groupSettings.window[1].visible = true
			guiBringToFront(groupSettings.window[1])
		end
		for i = 1, #groupSettings.edit do
			groupSettings.edit[i].enabled = true
		end
		groupSettings.button[5].enabled = false
		-- gmotd
		groupSettings.edit[7].text = settings.gmotd
		-- group colour
		groupSettings.edit[1].text = settings.groupColour[1]
		groupSettings.edit[2].text = settings.groupColour[2]
		groupSettings.edit[3].text = settings.groupColour[3]
		-- chat colour
		groupSettings.edit[4].text = settings.chatColour[1]
		groupSettings.edit[5].text = settings.chatColour[2]
		groupSettings.edit[6].text = settings.chatColour[3]
		-- other settings
		guiComboBoxSetSelected(groupSettings.combobox[1], settings.lockInvites)
		guiComboBoxSetSelected(groupSettings.combobox[2], settings.enableGSC)
	else
		if (groupSettings.window[1].visible) then
			groupSettings.window[1].visible = false
			groupSettings.button[5].enabled = false
			for i = 1, #groupSettings.edit do
				groupSettings.edit[i].enabled = false
			end
		else
			triggerServerEvent("UCDgroups.requestGroupSettings", localPlayer)
		end
	end
end
addEvent("UCDgroups.settings", true)
addEventHandler("UCDgroups.settings", root, viewGroupSettings)

function viewBlackList(blacklist)
	guiGridListClear(blacklistGUI.gridlist[1])
	guiGridListClear(blacklistGUI.gridlist[2])
	if (blacklist and type(blacklist) == "table") then
		if (not blacklistGUI.window[1].visible) then
			blacklistGUI.window[1].visible = true
			guiBringToFront(blacklistGUI.window[1])
		end
		--	Update regardless
		--for i = 1, #blacklist do
		for i, data in pairs(blacklist) do
			local type_
			if (data.serialAccount:len() == 32) then -- it's a serial
				type_ = 2
			else
				type_ = 1
			end
			local row = guiGridListAddRow(blacklistGUI.gridlist[type_])
			guiGridListSetItemText(blacklistGUI.gridlist[type_], row, 1, data.serialAccount, false, false)
			guiGridListSetItemText(blacklistGUI.gridlist[type_], row, 2, data.reason, false, false)
			guiGridListSetItemText(blacklistGUI.gridlist[type_], row, 3, data.datum, false, false)
			guiGridListSetItemText(blacklistGUI.gridlist[type_], row, 4, data.by, false, false)
		end
	else
		if (blacklistGUI.window[1].visible) then
			blacklistGUI.window[1].visible = false
		else
			-- request from the server then call this function back from the server
			triggerServerEvent("UCDgroups.requestBlacklist", localPlayer)
		end
	end
end
addEvent("UCDgroups.blacklist", true)
addEventHandler("UCDgroups.blacklist", root, viewBlackList)

function viewGroupHistory(hist, logNum, logCount)
	guiGridListClear(historyGUI.gridlist[1])
	historyGUI.edit[1].text = ""
	if (hist and type(hist) == "table" and #hist) then
		_hist = hist
		if (not historyGUI.window[1].visible) then
			historyGUI.window[1].visible = true
			guiBringToFront(historyGUI.window[1])
		end
		for _, data in pairs(hist) do
			local row = guiGridListAddRow(historyGUI.gridlist[1])
			guiGridListSetItemText(historyGUI.gridlist[1], row, 1, tostring(data.log_), false, false)
			guiGridListSetItemColor(historyGUI.gridlist[1], row, 1, 0, 200, 200)
		end
		historyGUI.label[1].text = "Group: "..source:getData("group")
		historyGUI.label[2].text = "Viewing: "..logCount.." of "..logNum
	else
		if (historyGUI.window[1].visible) then
			historyGUI.window[1].visible = false
		else
			-- request from the server then call this function back from the server
			triggerServerEvent("UCDgroups.requestGroupHistory", localPlayer)
		end
	end
end
addEvent("UCDgroups.history", true)
addEventHandler("UCDgroups.history", root, viewGroupHistory)

function viewGroupRanks(ranks)
	ranksGUI.gridlist[1]:clear()
	if (ranks and type(ranks) == "table" and #ranks) then
		if (not ranksGUI.window[1].visible) then
			ranksGUI.window[1].visible = true
			guiBringToFront(ranksGUI.window[1])
		end
		for k, v in pairs(ranks) do
			if (v[2] == 0) then
				local row = guiGridListAddRow(ranksGUI.gridlist[1])
				guiGridListSetItemText(ranksGUI.gridlist[1], row, 1, k, false, false)
			end
		end
		local curIndex = 1
		for k, v in pairs(ranks) do
			if (v[2] > 0) then
				for key, val in pairs(ranks) do
					if (val[2] == curIndex) then
						local row = guiGridListAddRow(ranksGUI.gridlist[1])
						guiGridListSetItemText(ranksGUI.gridlist[1], row, 1, key, false, false)
					end
				end
				curIndex = curIndex + 1
			end
		end
		for k, v in pairs(ranks) do
			if (v[2] == -1) then
				local row = guiGridListAddRow(ranksGUI.gridlist[1])
				guiGridListSetItemText(ranksGUI.gridlist[1], row, 1, k, false, false)
			end
		end
		for i = 1, #ranksGUI.checkbox do
			ranksGUI.checkbox[i].enabled = false
			ranksGUI.checkbox[i].selected = false
		end
		
		-- Global var to access these perms later
		groupRanks_ = ranks
	else
		if (ranksGUI.window[1].visible) then
			ranksGUI.window[1].visible = false
		else
			triggerServerEvent("UCDgroups.requestGroupRanks", localPlayer)
		end
	end
end
addEvent("UCDgroups.groupRanks", true)
addEventHandler("UCDgroups.groupRanks", root, viewGroupRanks)

function handleBlacklist()
	-- Adding a new blacklist item
	if (source == blacklistGUI.button[1]) then
		addBL.label[1].text = "Account name"
	elseif (source == blacklistGUI.button[3]) then
		addBL.label[1].text = "Serial"
	end
	
	if (source == addBL.button[1]) then
		local a, b = addBL.edit[1].text, addBL.edit[2].text
		
		if (a == "" or a:gsub(" ", "") == "") then
			exports.UCDdx:new("You need to specify an account name or serial", 255, 0, 0)
			return
		end
		if (addBL.label[1].text == "Account name") then -- account
			if (a:len() < 2 or a:len() > 20) then
				exports.UCDdx:new("Please enter a valid account name", 255, 0, 0)
				return
			end
		else -- serial
			if (a:len() ~= 32) then
				exports.UCDdx:new("Please enter a valid serial (32 characters in length)", 255, 0, 0)
				return
			end
		end
		if (b:gsub(" ", "") == "") then exports.UCDdx:new("You must provide a reason for this blacklisting", 255, 0, 0) return end
		triggerServerEvent("UCDgroups.addBlacklistEntry", localPlayer, a, b)
		addBL.edit[1].text = ""
		addBL.edit[2].text = ""
		addBL.window[1].visible = false
		
	elseif (source == blacklistGUI.button[2] or source == blacklistGUI.button[4]) then
		local accountRow, serialRow = guiGridListGetSelectedItem(blacklistGUI.gridlist[1]), guiGridListGetSelectedItem(blacklistGUI.gridlist[2])
		local selected
		if (accountRow == -1 or not accountRow or accountRow == nil) then
			if (serialRow == -1 or not serialRow or serialRow == nil) then
				exports.UCDdx:new("You need to select a row from the blacklist", 255, 0, 0)
				return
			end
			selected = 2
		else
			selected = 1
		end
		local row = guiGridListGetSelectedItem(blacklistGUI.gridlist[selected])
		local serialAccount = guiGridListGetItemText(blacklistGUI.gridlist[selected], row, 1)
		triggerServerEvent("UCDgroups.removeBlacklistEntry", localPlayer, serialAccount)
	end
	
	if (source == blacklistGUI.button[1] or source == blacklistGUI.button[3] or source == addBL.button[2]) then
		addBL.window[1].visible = not addBL.window[1].visible
		if (addBL.window[1].visible) then
			guiBringToFront(addBL.window[1])
			addBL.edit[1].text = ""
			addBL.edit[2].text = ""
		end
	end
end

function memberListClick()
	local row = guiGridListGetSelectedItem(memberList.gridlist[1])
	-- If they don't have a row selected
	if ((not row or row == -1 or row == nil) and source ~= memberList.button[5]) then
		return
	end
	
	if (source == memberList.button[5]) then -- close
		triggerEvent("UCDgroups.memberList", localPlayer)
		return
	end
	
	local account
	account = split(tostring(guiGridListGetItemText(memberList.gridlist[1], row, 1)), " ")[2]
	account = account:gsub("%)", "")
	account = account:gsub("%(", "")
	
	for i = 1, #memberList.button do
		if (memberList.button[i] == source) then
			if (account:match("%W")) then
				exports.UCDdx:new("An error with this account has occured. Please notify an administrator", 255, 0, 0)
				return
			end
		end
	end
	
	if (account == localPlayer:getData("accountName") and localPlayer.name ~= "Noki") then return end
	
	if (source == memberList.button[1]) then -- promote
		--exports.UCDutil:createInputBox("UCD | Groups - Promote", "Enter the reason for promotion", "", "UCDgroups.promoteMember", localPlayer, account)
		triggerEvent("UCDgroups.promoteDemoteWindow", localPlayer, nil, "UCD | Groups - Promote", "Enter the reason for promotion", "UCDgroups.promoteMember", account)
	elseif (source == memberList.button[2]) then -- demote
		--exports.UCDutil:createInputBox("UCD | Groups - Demote", "Enter the reason for demotion", "", "UCDgroups.demoteMember", localPlayer, account) -- The reason will be passed by the GUI
		triggerEvent("UCDgroups.promoteDemoteWindow", localPlayer, nil, "UCD | Groups - Demote", "Enter the reason for demotion", "UCDgroups.demoteMember", account)
	elseif (source == memberList.button[3]) then -- kick
		exports.UCDutil:createInputBox("UCD | Groups - Kick", "Enter the reason for kick", "", "UCDgroups.kickMember", localPlayer, account) 
	elseif (source == memberList.button[4]) then -- warn
		local level = guiGridListGetItemText(memberList.gridlist[1], row, 4):gsub("%%", "")
		triggerEvent("UCDgroups.warningLevelGUI", localPlayer, tonumber(level))
		accounToBeWarned = account
	end
end

function confirmPD()
	local rank = guiComboBoxGetSelected(PD.combobox[1])
	if (not rank or rank == -1) then
		exports.UCDdx:new("You must select a rank from the drop down menu", 255, 0, 0)
		return
	end
	if (source == PD.button[1]) then
		local reason = PD.edit[1].text
		if (reason == "" or reason == " " or reason:gsub(" ", "") == "") then
			reason = "No Reason"
		end
		if (not accountForAction) then
			exports.UCDdx:new("No member was selected for action", 255, 0, 0)
			return
		end
		local rankName = guiComboBoxGetItemText(PD.combobox[1], rank)
		if (PD.window[1].text:lower():find("demote")) then
			triggerServerEvent("UCDgroups.demoteMember", localPlayer, accountForAction, rankName, reason)
		else
			triggerServerEvent("UCDgroups.promoteMember", localPlayer, accountForAction, rankName, reason)
		end
	end
end

function promoteDemoteWindow(ranks, title, labeltext, event, arg)
	PD.edit[1].text = ""
	guiComboBoxClear(PD.combobox[1])
	if (title and labeltext) then
		PD.window[1].text = title
		PD.label[1].text = labeltext
	end
	if (ranks and type(ranks) == "table") then
		if (not PD.window[1].visible) then
			PD.window[1].visible = true
		end
		guiBringToFront(PD.window[1])
		
		-- Create a temp table to store values in (so we can get max and minimum numbers)
		local temp = {}
		
		-- Put the index in temp if it's not -1
		for i in pairs(ranks) do
			if (i ~= -1) then
				table.insert(temp, i)
			end
		end
		
		if (ranks[0]) then
			outputDebugString("0 exists")
		end
		
		local start, end_
		if (#temp and unpack(temp)) then
			-- Get the minimum and maximum values
			start = math.min(unpack(temp))
			end_ = math.max(unpack(temp))
			outputDebugString("start = "..start.." end_ = "..end_)
		end
		
		-- This way we loop from 2 to 4, for example
		if (start and end_) then
			for i = start, end_ do
				guiComboBoxAddItem(PD.combobox[1], tostring(ranks[i]))
			end
		end
		
		-- If a the founder rank exists, we always create it last
		if (ranks[-1]) then
			guiComboBoxAddItem(PD.combobox[1], tostring(ranks[-1]))
		end
		
		accountForAction = arg
	else
		if (PD.window[1].visible) then
			PD.window[1].visible = false
		else
			if (event:find("demote")) then
				triggerServerEvent("UCDgroups.requestGroupsForPD", localPlayer, true, arg)
			else
				triggerServerEvent("UCDgroups.requestGroupsForPD", localPlayer, false, arg)
			end
		end
	end
end
addEvent("UCDgroups.promoteDemoteWindow", true)
addEventHandler("UCDgroups.promoteDemoteWindow", root, promoteDemoteWindow)

function createGroup()
	local name = mainGUI.edit[1].text
	for i = 1, #name do name = name:gsub("  ", " ") end
	name = name:gsub("UCD", "")
	
	--if (localPlayer:getData("group") ~= false or localPlayer:getData("group") ~= nil) then -- For some reason it can be false or nil like wtf???
	if (localPlayer:getData("group")) then
		exports.UCDdx:new("You cannot create a group because you are already in one. Leave your current group first", 255, 0, 0)
		return false
	end
	if (not name or name == nil or name:len() == 0 or name == "" or name == " " or name:gsub(" ", "") == "") then
		-- You need to specify a group name.
		exports.UCDdx:new("You need to specify a group name", 255, 0, 0)
		return false
	end
	if (name:len() < 2 or name:len() > 20) then
		exports.UCDdx:new("Your group name must be between 2 and 20 characters", 255, 0, 0)
		return false
	end
	triggerServerEvent("UCDgroups.createGroup", localPlayer, name)
end

function leaveGroup()
	if (localPlayer:getData("group")) then
		--exports.UCDutil:createConfirmationWindow("UCDgroups.leaveGroup", nil, true, "UCD | Groups - Leave", "Are you sure you want to leave this group?")
		exports.UCDutil:createInputBox("UCD | Groups - Leave", "Enter the reason for leaving (can be left blank)", "", "UCDgroups.leaveGroup", localPlayer)
	end
end

function deleteGroup()
	-- Add some sort of account confirmation
	if (localPlayer:getData("group")) then
		if (boolean(permissions_[-1]) == true) then
			exports.UCDutil:createConfirmationWindow("UCDgroups.deleteGroup", nil, true, "UCD | Groups - Delete", "Are you sure you want to delete this group?")
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

function createAlliance()
	local name = allianceGUI.edit[1].text
	for i = 1, #name do name = name:gsub("  ", " ") end
	name = name:gsub("UCD", "")
	
	if (not localPlayer:getData("group")) then
		exports.UCDdx:new("You cannot create an alliance because you are not in a group", 255, 0, 0)
		return false
	end
	if (not name or name == nil or name:len() == 0 or name == "" or name == " " or name:gsub(" ", "") == "") then
		-- You need to specify a group name.
		exports.UCDdx:new("You need to specify an alliance name", 255, 0, 0)
		return false
	end
	if (name:len() < 2 or name:len() > 20) then
		exports.UCDdx:new("Your alliance name must be between 2 and 20 characters", 255, 0, 0)
		return false
	end
	triggerServerEvent("UCDgroups.createAlliance", localPlayer, name)
end

function deleteAlliance()
	-- Add some sort of account confirmation
	if (localPlayer:getData("group")) then
		if (boolean(permissions_[15]) == true) then
			exports.UCDutil:createConfirmationWindow("UCDgroups.deleteAlliance", nil, true, "UCD | Alliances - Delete", "Are you sure you want to delete this alliance?")
		end
	end
end

function leaveAlliance()
	-- Add some sort of account confirmation
	if (localPlayer:getData("group")) then
		if (boolean(permissions_[15]) == true) then
			exports.UCDutil:createConfirmationWindow("UCDgroups.leaveAlliance", nil, true, "UCD | Alliances - Leave", "Are you sure you want to leave this alliance?")
		end
	end
end

function viewAllianceMemberList(list)
	if (list and type(list) == "table") then
		a_members.gridlist[1]:clear()
		guiBringToFront(a_members.window[1])
		for i = 1, #list do
			local row = guiGridListAddRow(a_members.gridlist[1])
			local r, g, b = list[i].colour[1], list[i].colour[2], list[i].colour[3]
			guiGridListSetItemText(a_members.gridlist[1], row, 1, tostring(list[i].groupName), false, false)
			guiGridListSetItemText(a_members.gridlist[1], row, 2, tostring(list[i].memberCount).."/"..tostring(list[i].slots), false, false)
			guiGridListSetItemText(a_members.gridlist[1], row, 3, tostring(list[i].rank), false, false)
			guiGridListSetItemColor(a_members.gridlist[1], row, 1, r, g, b)
			guiGridListSetItemColor(a_members.gridlist[1], row, 2, r, g, b)
			guiGridListSetItemColor(a_members.gridlist[1], row, 3, r, g, b)
		end
		a_members.window[1].visible = true
	else
		if (a_members.window[1].visible) then
			a_members.window[1].visible = false
			return
		end
		triggerServerEvent("UCDgroups.alliance.requestMemberList", source)
	end
end
addEvent("UCDgroups.alliance.memberList", true)
addEventHandler("UCDgroups.alliance.memberList", root, viewAllianceMemberList)

function allianceMemberListHandler()
	if (boolean(permissions_[15]) and (source == a_members.button[1] or source == a_members.button[2] or source == a_members.button[3])) then
		local row = guiGridListGetSelectedItem(a_members.gridlist[1])
		if (not row or row == -1) then
			return false
		end
		local groupName = guiGridListGetItemText(a_members.gridlist[1], row, 1)
		if (groupName == localPlayer:getData("group")) then
			exports.UCDdx:new("You cannot perform these actions on your own group", 255, 0, 0)
			return false
		end
		local rank = guiGridListGetItemText(a_members.gridlist[1], row, 3)
		
		if (source == a_members.button[1]) then
			-- Promote
			if (rank == "Leader") then
				exports.UCDdx:new("You cannot promote this group further", 255, 0, 0)
				return
			end
			triggerServerEvent("UCDgroups.promoteGroup", resourceRoot, groupName)
		elseif (source == a_members.button[2]) then
			-- Demote
			if (rank == "Member") then
				exports.UCDdx:new("You cannot demote this group further", 255, 0, 0)
				return
			end
			triggerServerEvent("UCDgroups.demoteGroup", resourceRoot, groupName)
		elseif (source == a_members.button[3]) then
			-- Kick
			exports.UCDutil:createConfirmationWindow("UCDgroups.kickGroup", groupName, true, "UCD | Alliances - Kick", "Are you sure you want to kick this group?")
			--triggerServerEvent("UCDgroups.kickGroup", resourceRoot, groupName)
		end
	end
end

function viewAllianceInfo()
	a_info.window[1].visible = not a_info.window[1].visible
	if (a_info.window[1].visible) then
		guiBringToFront(a_info.window[1])
	end
end

function saveAllianceInfo()
	if (a_info.window[1].visible) then
		if (a_info.memo[1].text:len() > 10000) then
			exports.UCDdx:new("The alliance information can't be more than 10,000 characters.", 200, 0, 0)
			return
		end
		triggerServerEvent("UCDgroups.alliance.updateInfo", localPlayer, a_info.memo[1].text)
	end
end

function viewAllianceHistory(hist, logNum, logCount, alliance)
	a_history.gridlist[1]:clear()
	a_history.edit[1].text = ""
	if (hist and type(hist) == "table" and #hist) then
		a_hist = hist
		if (not a_history.window[1].visible) then
			a_history.window[1].visible = true
			guiBringToFront(a_history.window[1])
		end
		for _, data in pairs(hist) do
			local row = guiGridListAddRow(a_history.gridlist[1])
			
			guiGridListSetItemText(a_history.gridlist[1], row, 1, tostring(data.groupName), false, false)
			guiGridListSetItemColor(a_history.gridlist[1], row, 1, 0, 200, 200)
			
			guiGridListSetItemText(a_history.gridlist[1], row, 2, tostring(data.log_), false, false)
			guiGridListSetItemColor(a_history.gridlist[1], row, 2, 0, 200, 200)
		end
		a_history.label[1].text = "Group: "..alliance
		a_history.label[2].text = "Viewing: "..logCount.." of "..logNum
	else
		if (a_history.window[1].visible) then
			a_history.window[1].visible = false
		else
			-- request from the server then call this function back from the server
			triggerServerEvent("UCDgroups.requestAllianceHistory", localPlayer)
		end
	end
end
addEvent("UCDgroups.alliance.history", true)
addEventHandler("UCDgroups.alliance.history", root, viewAllianceHistory)

function allianceBankingHandler(action, balance)
	if (action == "toggle") then
		a_banking.window[1].visible = not a_banking.window[1].visible
		if (a_banking.window[1].visible) then
			guiBringToFront(a_banking.window[1])
			a_banking.label[1].text = "Current balance: $"..tostring(exports.UCDutil:tocomma(balance))
		end
	elseif (action == "update") then
		a_banking.label[1].text = "Current balance: $"..tostring(exports.UCDutil:tocomma(balance))
	else
		local balance = gettok(a_banking.label[1].text, 2, "$"):gsub(",", "")
		local text
		text = a_banking.edit[1].text:gsub(",", "")		
		if (tonumber(text) == nil) then
			exports.UCDdx:new("You must enter a valid number to "..action, 255, 255, 0)
			return
		end
		if (tonumber(text) > source:getMoney() and action == "deposit") then
			exports.UCDdx:new("You don't have this much money to "..action, 255, 255, 0)
			return
		end
		if (tonumber(balance) < tonumber(text) and action == "withdraw") then
			exports.UCDdx:new("You can't withdraw more than what is in the bank", 255, 255, 0)
			return
		end
		triggerServerEvent("UCDgroups.alliance.changeBalance", source, action, tonumber(text))
	end
end
addEvent("UCDgroups.alliance.balanceWindow", true)
addEventHandler("UCDgroups.alliance.balanceWindow", root, allianceBankingHandler)

------------------------------------------------------------->>>>>>>>>>>>

function viewAllianceInviteTo(groups)
	if (groups and type(groups) == "table") then
	
		a_send_invite.window[1].visible = true
		
		guiBringToFront(a_send_invite.window[1])
		guiGridListClear(a_send_invite.gridlist[1])
		
		if (#groups > 0) then
			for _, data in pairs(groups) do
				local row = guiGridListAddRow(a_send_invite.gridlist[1])
				guiGridListSetItemText(a_send_invite.gridlist[1], row, 1, tostring(data.group_), false, false)
				guiGridListSetItemColor(a_send_invite.gridlist[1], row, 1, data.r, data.g, data.b)
			end
		end
	else
		if (not a_send_invite.window[1].visible) then
			triggerServerEvent("UCDgroups.alliance.requestGroupsForInvite", localPlayer)
		else
			a_send_invite.window[1].visible = false
		end
	end
end
addEvent("UCDgroups.alliance.viewInviteGroups", true)
addEventHandler("UCDgroups.alliance.viewInviteGroups", root, viewAllianceInviteTo)
