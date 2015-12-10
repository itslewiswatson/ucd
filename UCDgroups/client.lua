mainGUI = {button = {}, window = {}, label = {}, edit = {}}
infoGUI = {button = {}, window = {}, memo = {}}

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
local notInGroup = {[1] = true, [2] = false, [3] = false, [4] = false, [5] = true, [6] = false, [7] = false, [8] = false, [9] = false, [10] = false, [11] = false, [12] = false, [13] = false, [14] = false, [15] = false, [16] = true}


function toggleGroupUI(updateOnly, groupName, groupInfo, permissions, rank, ranks)
	if (updateOnly ~= true) then
		if (not mainGUI.window[1].visible) then
			mainGUI.window[1].visible = true
			showCursor(true)
		else
			for _, gui in pairs(windows) do
				gui.visible = false
			end
			showCursor(false)
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
	else
		mainGUI.window[1].text = "UCD | Groups"
		mainGUI.edit[1].text = ""
		mainGUI.edit[1].enabled = true
		for index, bool in ipairs(notInGroup) do
			mainGUI.button[index].enabled = bool
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
	
	windows = {mainGUI.window[1], infoGUI.window[1]}
	
	addEventHandler("onClientGUIClick", mainGUI.button[1], createGroup, false)
	addEventHandler("onClientGUIClick", mainGUI.button[2], leaveGroup, false)
	addEventHandler("onClientGUIClick", mainGUI.button[3], deleteGroup, false)
	addEventHandler("onClientGUIClick", mainGUI.button[10], viewGroupInfo, false)
	addEventHandler("onClientGUIClick", mainGUI.button[16], function () executeCommandHandler("groups") end, false)

	-- 
	addEventHandler("onClientGUIClick", infoGUI.button[1], saveGroupInfo, false)
	addEventHandler("onClientGUIClick", infoGUI.button[2], viewGroupInfo, false)
end
addEventHandler("onClientResourceStart", resourceRoot, createGUI)

function boolean(var)
	return (not (not var))
end

function toggleGUI()
	if (mainGUI.window[1] and mainGUI.window[1].visible) then
		for _, gui in pairs(windows) do
			gui.visible = false
		end
		showCursor(false)
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
		triggerServerEvent("UCDgroups.updateInfo", localPlayer, infoGUI.window[1].text)
	end
end

--[[
function toggleGroupsGUI()
	if (not mainGUI.window[1] or not isElement(mainGUI.window[1])) then
		createGUI()
	else
		if (mainGUI.window[1].visible) then
			mainGUI.window[1].visible = false
			showCursor(false)
		else
			mainGUI.window[1].visible = true
			showCursor(true)
			triggerEvent("mainGUI.updateGUI", localPlayer)
		end
	end
end
addCommandHandler("groups", toggleGroupsGUI)
bindKey("F6", "down", "groups")
--]]

function createGroup()
	local name 
	name = mainGUI.edit[1].text
	for i = 1, #name do name = name:gsub("  ", " ") end
	name = name:gsub("UCD", "")
	
	if (localPlayer:getData("group") ~= false) then
		-- You cannot create a group because you are already in one. Leave your current group first.
		exports.UCDdx:new("You cannot create a group because you are already in one. Leave your current group first.", 255, 0, 0)
		return false
	end
	if (not name or name == nil or name:len() == 0 or name == "" or name == " ") then
		-- You need to specify a group name.
		exports.UCDdx:new("You need to specify a group name", 255, 0, 0)
		return false
	end
	if (#name < 2 or #name > 20) then
		-- Your group name must be between 2 and 20 characters.
		exports.UCDdx:new("Your group name must be between 2 and 20 characters", 255, 0, 0)
		return false
	end
	triggerServerEvent("UCDgroups.createGroup", localPlayer, name)
end

function leaveGroup()
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

