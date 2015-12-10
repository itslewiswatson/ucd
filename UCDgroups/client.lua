UCDgroups = {button = {}, window = {}, label = {}, edit = {}}

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


function updateGUI()
	if (UCDgroups.window[1]) then
		local titleText, groupName
		
		if (not source:getData("group")) then
			titleText = "UCD | Groups"
			groupName = ""
			
			for index, bool in ipairs(notInGroup) do
				UCDgroups.button[index].enabled = bool
			end
		else
			titleText = "UCD | Groups - "..source:getData("group")
			groupName = localPlayer:getData("group")
			UCDgroups.button[1].enabled = false
			
		end
		if (not UCDgroups.window[1] == titleText) then UCDgroups.window[1]:setText(titleText) end
		if (not UCDgroups.edit[1] == groupName) then UCDgroups.edit[1]:setText(groupName) end
	end
end
addEvent("UCDgroups.updateGUI", true)
addEventHandler("UCDgroups.updateGUI", root, updateGUI)

function createGUI()
	UCDgroups.window[1] = guiCreateWindow(756, 353, 450, 360, "UCD | Groups", false)
	guiWindowSetSizable(UCDgroups.window[1], false)
	UCDgroups.window[1].visible = false
	UCDgroups.edit[1] = guiCreateEdit(10, 31, 167, 30, "", false, UCDgroups.window[1])
	guiEditSetMaxLength(UCDgroups.edit[1], 20)
	
	UCDgroups.button[1] = guiCreateButton(10, 76, 130, 36, "Create Group", false, UCDgroups.window[1])
	UCDgroups.button[2] = guiCreateButton(157, 76, 130, 36, "Leave Group", false, UCDgroups.window[1])
	UCDgroups.button[3] = guiCreateButton(307, 76, 130, 36, "Delete Group", false, UCDgroups.window[1])
	UCDgroups.button[4] = guiCreateButton(10, 122, 130, 36, "Group Members", false, UCDgroups.window[1])
	UCDgroups.button[5] = guiCreateButton(157, 122, 130, 36, "Group List", false, UCDgroups.window[1])
	UCDgroups.button[6] = guiCreateButton(307, 122, 130, 36, "Invite to Group", false, UCDgroups.window[1])
	UCDgroups.button[7] = guiCreateButton(10, 168, 130, 36, "Group Ranks", false, UCDgroups.window[1])
	UCDgroups.button[8] = guiCreateButton(157, 168, 130, 36, "Group History", false, UCDgroups.window[1])
	UCDgroups.button[9] = guiCreateButton(307, 168, 130, 36, "Group Invites", false, UCDgroups.window[1])
	UCDgroups.button[10] = guiCreateButton(10, 214, 130, 36, "Group Info", false, UCDgroups.window[1])
	UCDgroups.button[11] = guiCreateButton(10, 260, 130, 36, "Group Blacklist", false, UCDgroups.window[1])
	UCDgroups.button[12] = guiCreateButton(157, 260, 130, 36, "Group Whitelist", false, UCDgroups.window[1])
	UCDgroups.button[13] = guiCreateButton(157, 214, 130, 36, "Group Bank", false, UCDgroups.window[1])
	UCDgroups.button[14] = guiCreateButton(307, 214, 130, 36, "Group Settings", false, UCDgroups.window[1])
	UCDgroups.button[15] = guiCreateButton(307, 260, 130, 36, "Alliance", false, UCDgroups.window[1])
	UCDgroups.button[16] = guiCreateButton(10, 306, 430, 36, "Close", false, UCDgroups.window[1])
	
	UCDgroups.label[1] = guiCreateLabel(177, 31, 267, 15, "Founded: 25/12/2015 - 16:33", false, UCDgroups.window[1])
	guiLabelSetHorizontalAlign(UCDgroups.label[1], "center", false)
	guiLabelSetVerticalAlign(UCDgroups.label[1], "center")
	UCDgroups.label[2] = guiCreateLabel(177, 46, 267, 15, "Members: 100/150", false, UCDgroups.window[1])
	guiLabelSetHorizontalAlign(UCDgroups.label[2], "center", false)
	guiLabelSetVerticalAlign(UCDgroups.label[2], "center")
	
	windows = {UCDgroups.window[1]}
		
	--triggerEvent("UCDgroups.updateGUI", localPlayer)
	
	addEventHandler("onClientGUIClick", UCDgroups.button[1], createGroup, false)
	addEventHandler("onClientGUIClick", UCDgroups.button[3], deleteGroup, false)
	addEventHandler("onClientGUIClick", UCDgroups.button[16], function () executeCommandHandler("groups") end, false)
end
addEventHandler("onClientResourceStart", resourceRoot, createGUI)

function toggleGroupUI(updateOnly, groupName, groupInfo, permissions, rank, ranks)
	if (updateOnly ~= true) then
		if (not UCDgroups.window[1].visible) then
			UCDgroups.window[1].visible = true
			showCursor(true)
		else
			for _, gui in pairs(windows) do
				gui.visible = false
			end
			showCursor(false)
		end
	end
	if (groupName ~= "") then
		UCDgroups.window[1].text = "UCD | Groups - "..groupName
		-- Permissions table thing here
	else
		UCDgroups.window[1].text = "UCD | Groups"
		for index, bool in ipairs(notInGroup) do
			UCDgroups.button[index].enabled = bool
		end
	end
	
end
addEvent("UCDgroups.toggleGUI", true)
addEventHandler("UCDgroups.toggleGUI", root, toggleGroupUI)

function toggleGUI()
	if (UCDgroups.window[1] and UCDgroups.window[1].visible) then
		for _, gui in pairs(windows) do
			gui.visible = false
		end
		showCursor(false)
	else
		triggerServerEvent("UCDgroups.viewUI", root)
	end
end
addCommandHandler("groups", toggleGUI)
bindKey("F6", "down", "groups")

--[[
function toggleGroupsGUI()
	if (not UCDgroups.window[1] or not isElement(UCDgroups.window[1])) then
		createGUI()
	else
		if (UCDgroups.window[1].visible) then
			UCDgroups.window[1].visible = false
			showCursor(false)
		else
			UCDgroups.window[1].visible = true
			showCursor(true)
			triggerEvent("UCDgroups.updateGUI", localPlayer)
		end
	end
end
addCommandHandler("groups", toggleGroupsGUI)
bindKey("F6", "down", "groups")
--]]

function createGroup()
	local name 
	name = UCDgroups.edit[1].text
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

function deleteGroup()
	-- Create a confirmation window
	if (localPlayer:getData("group")) then
		--triggerServerEvent("UCDgroups.deleteGroup", localPlayer)
		exports.UCDutil:createConfirmationWindow("UCDgroups.deleteGroup", nil, true, "UCD | Groups - Delete", "Are you sure you want to delete this group?")
	end
end

