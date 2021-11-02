adminPanel = {tab = {}, label = {}, tabpanel = {}, edit = {}, gridlist = {}, window = {}, checkbox = {}, button = {}}
confirm = {button = {}, window = {}, label = {}, edit = {}}
giveWeapon_ = {edit = {}, button = {}, window = {}, label = {}, combobox = {}}
WPT = {gridlist = {}, window = {}, button = {}, label = {}}
punish = {checkbox = {}, label = {}, radiobutton = {}, button = {}, window = {}, edit = {}, combobox = {}}

function getSelectedPlayer()
	local row = guiGridListGetSelectedItem(adminPanel.gridlist[1])
	if (row ~= false and row ~= nil and row ~= -1) then
		local player = guiGridListGetItemData(adminPanel.gridlist[1], row, 1)
		return player
	end
end

local reasons = {
	"Removing Punishment",
	"Custom Reason",
	"#1: Flaming/Insulting",
	"#2: Exploiting",
	"#3: Trolling/Griefing",
	"#4: Impersonation",
	"#5: Illegal transactions",
	"#6: Non-English",
	"#7: Ignoring administrators",
	"#9: Advertising other servers",
	"#10: Hate speech",
	"Bugged",
}
local actions = {
	"Mute",
	"Admin Jail",
	"Ban",
	"Unmute",
	"Unjail",
}

adminPanel.window = GuiWindow(697, 262, 665, 504, "UCD | Administrative & Management Panel", false)
guiWindowSetSizable(adminPanel.window, false)
guiSetVisible(adminPanel.window, false)
exports.UCDutil:centerWindow(adminPanel.window)
adminPanel.window.alpha = 1

adminPanel.tabpanel = guiCreateTabPanel(10, 24, 645, 470, false, adminPanel.window)

adminPanel.tab["players"] = guiCreateTab("Players", adminPanel.tabpanel)

	adminPanel.gridlist[1] = guiCreateGridList(10, 40, 151, 395, false, adminPanel.tab["players"])
	guiGridListAddColumn(adminPanel.gridlist[1], "Player Name", 0.9)
	guiGridListSetSortingEnabled(adminPanel.gridlist[1], false)

	adminPanel.edit[1] = GuiEdit(10, 10, 151, 26, "", false, adminPanel.tab["players"])
	adminPanel.label[1] = GuiLabel(170, 26, 290, 20, "Name: ", false, adminPanel.tab["players"])
	adminPanel.label[2] = GuiLabel(170, 86, 290, 20, "IP: ", false, adminPanel.tab["players"])
	guiLabelSetHorizontalAlign(adminPanel.label[2], "right", false)
	adminPanel.label[3] = GuiLabel(170, 66, 290, 20, "Serial: ", false, adminPanel.tab["players"])
	adminPanel.label[4] = GuiLabel(171, 86, 289, 20, "Version: ", false, adminPanel.tab["players"])
	adminPanel.label[5] = GuiLabel(170, 46, 290, 20, "Account Name: ", false, adminPanel.tab["players"])
	adminPanel.label[6] = GuiLabel(171, 375, 289, 21, "Play time: ", false, adminPanel.tab["players"])
	adminPanel.label[7] = GuiLabel(170, 126, 290, 22, "Country: ", false, adminPanel.tab["players"])
	adminPanel.label[9] = GuiLabel(170, 210, 290, 20, "Location: ", false, adminPanel.tab["players"])
	adminPanel.label[10] = GuiLabel(170, 230, 290, 20, "Dimension: ", false, adminPanel.tab["players"])
	adminPanel.label[11] = GuiLabel(170, 230, 290, 20, "Interior: ", false, adminPanel.tab["players"])
	guiLabelSetHorizontalAlign(adminPanel.label[11], "right", false)
	adminPanel.label[12] = GuiLabel(170, 106, 290, 20, "Email: ", false, adminPanel.tab["players"])
	adminPanel.label[13] = GuiLabel(170, 270, 290, 20, "Health: ", false, adminPanel.tab["players"])
	adminPanel.label[14] = GuiLabel(170, 270, 290, 20, "Armour: ", false, adminPanel.tab["players"])
	guiLabelSetHorizontalAlign(adminPanel.label[14], "right", false)
	adminPanel.label[15] = GuiLabel(171, 355, 289, 20, "Money: ", false, adminPanel.tab["players"])
	adminPanel.label[16] = GuiLabel(170, 355, 290, 20, "Bank: ", false, adminPanel.tab["players"])
	guiLabelSetHorizontalAlign(adminPanel.label[16], "right", false)
	adminPanel.label[17] = GuiLabel(170, 396, 291, 20, "Occupation: ", false, adminPanel.tab["players"])
	guiLabelSetHorizontalAlign(adminPanel.label[17], "right", false)
	adminPanel.label[18] = GuiLabel(171, 396, 290, 20, "Class: ", false, adminPanel.tab["players"])
	adminPanel.label[19] = GuiLabel(171, 335, 289, 20, "Group: ", false, adminPanel.tab["players"])
	adminPanel.label[20] = GuiLabel(171, 375, 289, 21, "Team: ", false, adminPanel.tab["players"])
	guiLabelSetHorizontalAlign(adminPanel.label[20], "right", false)
	adminPanel.label[21] = GuiLabel(170, 250, 267, 20, "Model: ", false, adminPanel.tab["players"])
	adminPanel.label[22] = GuiLabel(171, 250, 290, 20, "Weapon: ", false, adminPanel.tab["players"])
	guiLabelSetHorizontalAlign(adminPanel.label[22], "right", false)
	adminPanel.label[23] = GuiLabel(170, 26, 290, 20, "Ping: ", false, adminPanel.tab["players"])
	guiLabelSetHorizontalAlign(adminPanel.label[23], "right", false)
	adminPanel.label[24] = GuiLabel(170, 416, 290, 20, "Vehicle: ", false, adminPanel.tab["players"])
	adminPanel.label[25] = GuiLabel(170, 416, 290, 20, "Vehicle Health: ", false, adminPanel.tab["players"])
	guiLabelSetHorizontalAlign(adminPanel.label[25], "right", false)
	adminPanel.label[26] = GuiLabel(170, 190, 290, 20, "X: N/A; Y: N/A; Z: N/A", false, adminPanel.tab["players"])
	adminPanel.label[27] = GuiLabel(170, 168, 49, 22, "Locality", false, adminPanel.tab["players"])
	guiSetFont(adminPanel.label[27], "default-bold-small")
	guiLabelSetColor(adminPanel.label[27], 255, 0, 0)
	adminPanel.label[28] = GuiLabel(170, 4, 49, 22, "Player", false, adminPanel.tab["players"])
	guiSetFont(adminPanel.label[28], "default-bold-small")
	guiLabelSetColor(adminPanel.label[28], 255, 0, 0)
	adminPanel.label[29] = GuiLabel(170, 313, 49, 22, "Misc", false, adminPanel.tab["players"])
	guiSetFont(adminPanel.label[29], "default-bold-small")
	guiLabelSetColor(adminPanel.label[29], 255, 0, 0)
	adminPanel.button[1] = GuiButton(488, 52, 147, 18, "Warp to player", false, adminPanel.tab["players"])
	adminPanel.button[2] = GuiButton(488, 10, 147, 36, "Punish", false, adminPanel.tab["players"])
	adminPanel.button[3] = GuiButton(488, 144, 72, 18, "Spectate", false, adminPanel.tab["players"])
	adminPanel.button[4] = GuiButton(488, 76, 147, 18, "Warp player to", false, adminPanel.tab["players"])
	adminPanel.button[5] = GuiButton(488, 100, 72, 18, "Reconnect", false, adminPanel.tab["players"])
	adminPanel.button[6] = GuiButton(563, 100, 72, 18, "Kick", false, adminPanel.tab["players"])
	adminPanel.button[7] = GuiButton(488, 122, 72, 18, "Freeze", false, adminPanel.tab["players"])
	adminPanel.button[8] = GuiButton(563, 122, 72, 18, "Shout", false, adminPanel.tab["players"])
	adminPanel.button[9] = GuiButton(563, 144, 72, 18, "Slap", false, adminPanel.tab["players"])
	adminPanel.button[10] = GuiButton(488, 167, 72, 18, "Rename", false, adminPanel.tab["players"])
	adminPanel.button[11] = GuiButton(488, 318, 147, 20, "View Punishments", false, adminPanel.tab["players"])
	adminPanel.button[12] = GuiButton(563, 167, 72, 18, "Screenshot", false, adminPanel.tab["players"])
	adminPanel.button[13] = GuiButton(563, 195, 72, 18, "Set Model", false, adminPanel.tab["players"])
	adminPanel.button[14] = GuiButton(488, 195, 72, 18, "Set Money", false, adminPanel.tab["players"])
	adminPanel.button[15] = GuiButton(488, 220, 72, 18, "Set Health", false, adminPanel.tab["players"])
	adminPanel.button[16] = GuiButton(563, 220, 72, 18, "Set Armour", false, adminPanel.tab["players"])
	adminPanel.button[17] = GuiButton(488, 244, 72, 18, "Dimension", false, adminPanel.tab["players"])
	adminPanel.button[18] = GuiButton(563, 244, 72, 18, "Interior", false, adminPanel.tab["players"])
	adminPanel.button[19] = GuiButton(488, 369, 72, 18, "Fix", false, adminPanel.tab["players"])
	adminPanel.button[20] = GuiButton(563, 369, 72, 18, "Eject", false, adminPanel.tab["players"])
	adminPanel.button[21] = GuiButton(488, 392, 72, 18, "Destroy", false, adminPanel.tab["players"])
	adminPanel.button[22] = GuiButton(563, 392, 72, 18, "Disable", false, adminPanel.tab["players"])
	adminPanel.button[23] = GuiButton(563, 266, 72, 18, "Set Job", false, adminPanel.tab["players"])
	adminPanel.button[24] = GuiButton(488, 341, 72, 18, "Anticheat", false, adminPanel.tab["players"])
	adminPanel.button[25] = GuiButton(563, 341, 72, 18, "View Weps", false, adminPanel.tab["players"])
	adminPanel.button[26] = GuiButton(488, 290, 72, 18, "Give Wep", false, adminPanel.tab["players"])
	adminPanel.button[27] = GuiButton(488, 266, 72, 18, "Give Vehicle", false, adminPanel.tab["players"])
	adminPanel.button[28] = GuiButton(488, 416, 72, 18, "Blow", false, adminPanel.tab["players"])
	adminPanel.button[29] = GuiButton(563, 416, 72, 18, "Freeze", false, adminPanel.tab["players"])
	adminPanel.button[30] = GuiButton(563, 290, 72, 18, "Last Logins", false, adminPanel.tab["players"])

	-- Disable all at first
	for i = 1, #adminPanel.button do
		adminPanel.button[i].enabled = false
	end

	confirm.window[1] = GuiWindow(792, 480, 324, 111, "UCD | Admin - ", false)
	confirm.window[1].sizable = false
	confirm.window[1].visible = false
	confirm.button[1] = GuiButton(58, 82, 101, 19, "Confirm", false, confirm.window[1])
	confirm.button[2] = GuiButton(169, 82, 101, 19, "Cancel", false, confirm.window[1])
	confirm.edit[1] = GuiEdit(35, 47, 260, 25, "", false, confirm.window[1])
	confirm.label[1] = GuiLabel(36, 21, 259, 20, "Set the motherfucking label text nigga", false, confirm.window[1])
	guiLabelSetHorizontalAlign(confirm.label[1], "center", false)
	guiLabelSetVerticalAlign(confirm.label[1], "center") 
	 
	WPT.window[1] = GuiWindow(850, 390, 201, 348, "UCD Admin | Warp Player To", false)
	WPT.window[1].sizable = false
	WPT.window[1].visible = false
	WPT.button[1] = GuiButton(10, 304, 85, 34, "Warp Player To", false, WPT.window[1])
	WPT.label[1] = GuiLabel(10, 24, 179, 21, "Select a player from the grid", false, WPT.window[1])
	guiLabelSetHorizontalAlign(WPT.label[1], "center", false)
	WPT.gridlist[1] = guiCreateGridList(10, 45, 178, 249, false, WPT.window[1])
	guiGridListAddColumn(WPT.gridlist[1], "Player", 0.9)
	WPT.button[2] = GuiButton(103, 304, 85, 34, "Close", false, WPT.window[1])

	local weapons = {
		"Colt 45", "Silenced", "Deagle", "Shotgun", "Sawed-off", "Combat Shotgun",
		"Uzi", "MP5", "Tec-9", "AK-47", "M4", "Rifle", "Sniper",
		"Minigun", "Grenade", "Satchel", "Teargas", "Parachute"
	}
	giveWeapon_.window[1] = GuiWindow(244, 682, 317, 160, "UCD | Admin - Give Weapon", false)
	giveWeapon_.window[1].sizable = false
	giveWeapon_.window[1].visible = false
	giveWeapon_.edit[1] = GuiEdit(226, 48, 81, 25, "", false, giveWeapon_.window[1])
	giveWeapon_.combobox[1] = GuiComboBox(10, 48, 197, 100, "", false, giveWeapon_.window[1])
	for _, wep in ipairs(weapons) do
		guiComboBoxAddItem(giveWeapon_.combobox[1], wep)
	end
	giveWeapon_.label[1] = GuiLabel(10, 24, 197, 19, "Weapon", false, giveWeapon_.window[1])
	guiLabelSetHorizontalAlign(giveWeapon_.label[1], "center", false)
	guiLabelSetVerticalAlign(giveWeapon_.label[1], "center")
	giveWeapon_.label[2] = GuiLabel(226, 24, 81, 19, "Ammo", false, giveWeapon_.window[1])
	guiLabelSetHorizontalAlign(giveWeapon_.label[2], "center", false)
	guiLabelSetVerticalAlign(giveWeapon_.label[2], "center")
	giveWeapon_.button[1] = GuiButton(66, 120, 87, 22, "Confirm", false, giveWeapon_.window[1])
	giveWeapon_.button[2] = GuiButton(168, 120, 87, 22, "Close", false, giveWeapon_.window[1])
		
	-- Punish window
	punish.window = GuiWindow(535, 156, 272, 358, "UCD | Admin - Punish", false)
	punish.window.visible = false
	punish.window.sizable = false
	punish.window.alpha = 255
	punish.combobox["rules"] = GuiComboBox(9, 73, 253, 240, "Select rule", false, punish.window)
	for _, reason in ipairs(reasons) do
		guiComboBoxAddItem(punish.combobox["rules"], tostring(reason))
	end
	punish.edit["custom"] = GuiEdit(9, 38, 253, 25, "", false, punish.window)
	punish.button["cancel"] = GuiButton(10, 310, 105, 38, "Cancel", false, punish.window)
	punish.button["punish"] = GuiButton(157, 310, 105, 38, "Punish", false, punish.window)
	punish.checkbox["custom_duration"] = GuiCheckBox(9, 141, 16, 16, "", false, false, punish.window)
	punish.label[1] = GuiLabel(34, 141, 228, 16, "Use custom duration (otherwise it's auto)", false, punish.window)
	punish.edit["min"] = GuiEdit(10, 167, 65, 29, "", false, punish.window)
	punish.edit["hour"] = GuiEdit(99, 167, 65, 29, "", false, punish.window)
	punish.edit["day"] = GuiEdit(188, 167, 65, 29, "", false, punish.window)
	punish.radiobutton[1] = GuiRadioButton(10, 206, 15, 15, "", false, punish.window)
	punish.label[2] = GuiLabel(35, 206, 40, 15, "Mins", false, punish.window)
	punish.radiobutton[2] = GuiRadioButton(99, 206, 15, 15, "", false, punish.window)
	punish.label[3] = GuiLabel(124, 206, 40, 15, "Hours", false, punish.window)
	punish.radiobutton[3] = GuiRadioButton(187, 206, 15, 15, "", false, punish.window)
	punish.label[4] = GuiLabel(212, 206, 40, 15, "Days", false, punish.window)
	punish.combobox["punishtype"] = GuiComboBox(9, 231, 253, 117, "Select punish type", false, punish.window)
	for _, action in ipairs(actions) do
		guiComboBoxAddItem(punish.combobox["punishtype"], tostring(action))
	end
	punish.edit["reason"] = GuiEdit(9, 106, 253, 25, "", false, punish.window)
	punish.label[5] = GuiLabel(9, 21, 253, 16, "Manual syntax: acc:name or serial (bans only)", false, punish.window)
	guiLabelSetHorizontalAlign(punish.label[5], "center", false)
	punish.label[6] = GuiLabel(9, 271, 252, 16, "-1 minutes = permanent (bans only)", false, punish.window)
	guiLabelSetHorizontalAlign(punish.label[6], "center", false)

	-- Set job window
	
	setJob = {}
	setJob.window = GuiWindow(362, 112, 614, 376, "UCD | Set Job", false)
	setJob.window.sizable = false
	setJob.window.visible = false
	setJob.window.alpha = 1
	setJob.playersGrid = GuiGridList(9, 25, 187, 281, false, setJob.window)
	setJob.playersGrid:addColumn("Player:", 0.9)
	setJob.jobsGrid = GuiGridList(213, 25, 187, 281, false, setJob.window)
	setJob.jobsGrid:addColumn("Job:", 0.9)
	setJob.skinsGrid = GuiGridList(416, 25, 187, 281, false, setJob.window)
	setJob.skinsGrid:addColumn("Skin:", 0.5)
	setJob.skinsGrid:addColumn("Skin ID:", 0.4)
	setJob.setButton = GuiButton(9, 316, 187, 46, "Set player job", false, setJob.window)
	setJob.removeButton = GuiButton(213, 316, 187, 46, "Remove player from job", false, setJob.window)
	setJob.cancelButton = GuiButton(416, 316, 187, 46, "Cancel", false, setJob.window)

	-- fuark this identation but i have to do the same
	-- View punishments window
	
	viewPunish = {tab = {}, grid = {}}
	viewPunish.window = GuiWindow(0, 0, 825, 536, "UCD | Admin - View Punishments", false)
	viewPunish.window.sizable = false
	viewPunish.window.visible = false
	viewPunish.tabpanel = GuiTabPanel(0, 20, 825, 455, false, viewPunish.window)
	viewPunish.tab[1] = GuiTab("Serial punishments", viewPunish.tabpanel)
	viewPunish.tab[2] = GuiTab("Account punishments", viewPunish.tabpanel)
	viewPunish.grid[1] = GuiGridList(10, 10, 790, 410, false, viewPunish.tab[1])
	viewPunish.grid[2] = GuiGridList(10, 10, 790, 410, false, viewPunish.tab[2])
	viewPunish.editButton = GuiButton(0, 480, 825, 20, "Enable/disable punishment", false, viewPunish.window)
	viewPunish.closeButton = GuiButton(0, 505, 825, 20, "Close", false, viewPunish.window)
	viewPunish.grid[1]:addColumn("Account", 0.125)
	viewPunish.grid[1]:addColumn("Log", 0.855)
	viewPunish.grid[2]:addColumn("Serial", 0.25)
	viewPunish.grid[2]:addColumn("Log", 0.7)
	
adminPanel.tab["bans"] = guiCreateTab("Bans", adminPanel.tabpanel)
	adminPanel.gridlist["banList"] = GuiGridList(348, 11, 287, 425, false, adminPanel.tab["bans"])
	
	adminPanel.label["banInfo"] = GuiLabel(10, 11, 328, 77, "Search, manage and remove bans here.\n\nNote: when searching for bans, prefix the ban value.\nAccounts are acc:name.\nSerials are always 32 characters in length.", false, adminPanel.tab["bans"])
	
	adminPanel.edit["searchValue"] = GuiEdit(10, 126, 246, 29, "", false, adminPanel.tab["bans"])
	adminPanel.edit["searchBanisher"] = GuiEdit(10, 195, 246, 29, "", false, adminPanel.tab["bans"])
	
	adminPanel.label["valueLabel"] = GuiLabel(10, 106, 246, 20, "Value:", false, adminPanel.tab["bans"])
	adminPanel.label["banisherLabel"] = GuiLabel(10, 175, 246, 20, "Banisher:", false, adminPanel.tab["bans"])
	
	adminPanel.button["searchLabel"] = GuiButton(56, 234, 152, 36, "Search", false, adminPanel.tab["bans"])
	adminPanel.label["withSelected"] = GuiLabel(10, 289, 246, 16, "With selected:", false, adminPanel.tab["bans"])
	adminPanel.button["editBan"] = GuiButton(10, 400, 152, 36, "Edit Ban", false, adminPanel.tab["bans"])
	adminPanel.button["unban"] = GuiButton(172, 400, 152, 36, "Unban", false, adminPanel.tab["bans"])
	adminPanel.label["and/or"] = GuiLabel(10, 155, 246, 20, "and/or", false, adminPanel.tab["bans"])
	
	adminPanel.label["bannedValue"] = GuiLabel(31, 311, 293, 15, "Value: ", false, adminPanel.tab["bans"])
	adminPanel.label["bannedOn"] = GuiLabel(31, 326, 293, 15, "When: ", false, adminPanel.tab["bans"])
	adminPanel.label["bannedDuration"] = GuiLabel(31, 341, 293, 15, "Duration: ", false, adminPanel.tab["bans"])
	adminPanel.label["bannedReason"] = GuiLabel(31, 356, 293, 15, "Reason:", false, adminPanel.tab["bans"])
	adminPanel.label["bannedBanisher"] = GuiLabel(31, 371, 293, 15, "Banisher:", false, adminPanel.tab["bans"])

adminPanel.tab["adminLog"] = guiCreateTab("Admin Log", adminPanel.tabpanel) 

windows = {adminPanel.window, giveWeapon_.window[1], WPT.window[1], punish.window, setJob.window, viewPunish.window}
for _, gui in ipairs(windows) do
	if (gui and isElement(gui)) then
		exports.UCDutil:centerWindow(gui)
	end
end

function togglePunishWindow(plr)
	punish.window.visible = not punish.window.visible
	guiBringToFront(punish.window)
	punish.edit["custom"].text = ""
	_plr = nil
	if (plr and isElement(plr) and plr.type == "player") then
		punish.window.text = "UCD | Admin - "..tostring(plr.name)
		_plr = plr
		punish.edit["custom"].enabled = false
	else
		punish.window.text = "UCD | Admin - Punish"
		punish.edit["custom"].enabled = true
	end
end
addEventHandler("onClientGUIClick", punish.button["cancel"], togglePunishWindow, false)

function giveWeaponHandler()
	if (source == giveWeapon_.button[1]) then
		local plr = getSelectedPlayer()
		if (not plr) then
			exports.UCDdx:new("A player was not selected", 255, 0, 0)
			return
		end
		local w = guiComboBoxGetSelected(giveWeapon_.combobox[1])
		if (not w or w == -1) then
			exports.UCDdx:new("You must select a weapon from the drop down menu")
			return
		end
		local ammo, weapon = giveWeapon_.edit[1].text, getWeaponIDFromName(guiComboBoxGetItemText(giveWeapon_.combobox[1], w))
		if (tonumber(ammo) == nil) then
			ammo = 100
		end
		triggerServerEvent("UCDadmin.giveWeapon", localPlayer, plr, weapon, ammo)
	elseif (source == giveWeapon_.button[2]) then
		showGiveWeapon()
	end
end
addEventHandler("onClientGUIClick", giveWeapon_.button[1], giveWeaponHandler, false)
addEventHandler("onClientGUIClick", giveWeapon_.button[2], giveWeaponHandler, false)

function showGiveWeapon()
	if (getSelectedPlayer()) then
		if (giveWeapon_.window[1].visible) then
			giveWeapon_.window[1].visible = false
			return
		end
		giveWeapon_.window[1].visible = true
		giveWeapon_.edit[1].text = "100"
		guiBringToFront(giveWeapon_.window[1])
	else
		if (giveWeapon_.window[1].visible) then
			giveWeapon_.window[1].visible = false
			giveWeapon_.edit[1].text = "100"
			guiComboBoxClear(giveWeapon_.combobox[1])
		end
	end
end
addEventHandler("onClientGUIClick", adminPanel.button[26], showGiveWeapon, false)

for _, plr in pairs(Element.getAllByType("player")) do
	local row = guiGridListAddRow(adminPanel.gridlist[1])
	local r, g, b
	if plr.team then
		r, g, b = plr.team:getColor()
	else
		r, g, b = 255, 255, 255
	end
	guiGridListSetItemText(adminPanel.gridlist[1], row, 1, plr.name, false, false)
	guiGridListSetItemData(adminPanel.gridlist[1], row, 1, plr)
	guiGridListSetItemColor(adminPanel.gridlist[1], row, 1, r, g, b)
end

function searchFromPlayerList()
	if (source ~= adminPanel.edit[1]) then return end
	guiGridListClear(adminPanel.gridlist[1])
	local name = adminPanel.edit[1]:getText()
    for _, plr in pairs(Element.getAllByType("player")) do
        if string.find(plr.name:lower(), name:lower()) then
			local r, g, b
			if (plr.team) then
				r, g, b = plr.team:getColor()
			else
				r, g, b = 255, 255, 255
			end

			local row = guiGridListAddRow(adminPanel.gridlist[1])
			guiGridListSetItemText(adminPanel.gridlist[1], row, 1, plr.name, false, false)
			guiGridListSetItemData(adminPanel.gridlist[1], row, 1, plr)
			guiGridListSetItemColor(adminPanel.gridlist[1], row, 1, r, g, b)
        end
    end
end
addEventHandler("onClientGUIChanged", guiRoot, searchFromPlayerList)

-- Add a player when they join
addEventHandler("onClientPlayerJoin", root,
	function ()
		local row = guiGridListAddRow(adminPanel.gridlist[1])
		guiGridListSetItemText(adminPanel.gridlist[1], row, 1, source.name, false, false)
		guiGridListSetItemData(adminPanel.gridlist[1], row, 1, source)
		local r, g, b
		if source.team then
			r, g, b = source.team:getColor()
		else
			r, g, b = 255, 255, 255
		end
		guiGridListSetItemColor(adminPanel.gridlist[1], row, 1, r, g, b)
	end
)

-- Remove a player when they quit
addEventHandler("onClientPlayerQuit", root,
	function ()
		for i = 0, guiGridListGetRowCount(adminPanel.gridlist[1]) - 1 do
			if (guiGridListGetItemData(adminPanel.gridlist[1], i, 1) == source) then
                guiGridListRemoveRow(adminPanel.gridlist[1], i)
				break
			end
		end
	end
)

-- When a player changes his nick
addEventHandler("onClientPlayerChangeNick", root,
    function (oldNick, newNick)
        for i = 0, guiGridListGetRowCount(adminPanel.gridlist[1]) - 1 do
            if (guiGridListGetItemText(adminPanel.gridlist[1], i, 1) == oldNick) then
                guiGridListSetItemText(adminPanel.gridlist[1], i, 1, newNick, false, false)
			end
        end
    end
)

function updateInformation()
	if (adminPanel.window.visible) then
		-- Update team colours
		for i = 0, guiGridListGetRowCount(adminPanel.gridlist[1]) - 1 do
			local plr = guiGridListGetItemData(adminPanel.gridlist[1], i, 1)
			if (plr) then
				local r, g, b
				if plr.team then
					r, g, b = plr.team:getColor()
				else
					r, g, b = 255, 255, 255
				end
				guiGridListSetItemColor(adminPanel.gridlist[1], i, 1, r, g, b)

				if (plr.name ~= guiGridListGetItemText(adminPanel.gridlist[1], i, 1)) then
					guiGridListSetItemText(adminPanel.gridlist[1], i, 1, plr.name, false, false)
				end
			end
		end
		if (getSelectedPlayer()) then
			updatePlayerInformation(getSelectedPlayer(), false) -- We don't want it triggering events every second, plus we don't want to repeat code
		end
	end
end

function updatePlayerInformation(plr, getServerSidedData)
	-- Fetch the rest server-side
	local name = plr.name
	local loc = plr.position
	local accountID = plr:getData("accountID") or "N/A"
	local accountName = plr:getData("accountName") or "N/A"
	local model = plr.model or 0
	local dim = plr.dimension or 0
	local int = plr.interior or 0
	local health = plr.health or 0
	local armour = math.floor(plr.armor) or 0
	--local money = plr:getMoney() or "N/A"
	local team = plr.team.name or "Not logged in"
	local group = plr:getData("group") or "N/A"
	local class = plr:getData("Class") or "N/A"
	local occupation = plr:getData("Occupation") or "N/A"
	local ping = plr.ping
	local suburb, city = getZoneName(loc), getZoneName(loc, true)
	local country = plr:getData("Country") or "N/A"
	local playtime = plr:getData("dxscoreboard_playtime") or "N/A"
	
	--local ammo, weapon
	--if (getPedWeapon(plr)) then
	--	ammo, weapon = getPedTotalAmmo(plr, getPedWeaponSlot(plr)), getWeaponNameFromID(getPedWeapon(plr))
	--else
	--	ammo = "1"
	--	weapon = "Fist"
	--end
	
	local vehicle, vehicleHealth
	if not plr.vehicle then 
		vehicle = "Not in a vehicle" 
		vehicleHealth = "N/A"
	else 
		vehicle = plr.vehicle.name
		vehicleHealth = tostring(exports.UCDutil:mathround(plr.vehicle.health / 10).."%")
	end
	
	adminPanel.label[1]:setText("Name: "..tostring(name))
	adminPanel.label[5]:setText("Account Name: "..tostring(accountName))
	adminPanel.label[6]:setText("Play Time: "..tostring(playtime))
	adminPanel.label[7]:setText("Country: "..tostring(country))
	adminPanel.label[9]:setText("Location: "..tostring(suburb)..", "..tostring(city))
	adminPanel.label[10]:setText("Dimension: "..tostring(dim))
	adminPanel.label[11]:setText("Interior: "..tostring(int))
	adminPanel.label[13]:setText("Health: "..tostring(health))
	adminPanel.label[14]:setText("Armour: "..tostring(armour))
	adminPanel.label[17]:setText("Occupation: "..tostring(occupation))
	adminPanel.label[18]:setText("Class: "..tostring(class))
	adminPanel.label[19]:setText("Group: "..tostring(group))
	adminPanel.label[20]:setText("Team: "..tostring(team))
	adminPanel.label[21]:setText("Model: "..tostring(model))
	adminPanel.label[23]:setText("Ping: "..tostring(ping))
	adminPanel.label[24]:setText("Vehicle: "..tostring(vehicle))
	adminPanel.label[25]:setText("Vehicle Health: "..tostring(vehicleHealth))
	adminPanel.label[26]:setText("X: "..tostring(exports.UCDutil:mathround(loc.x, 3)).."; Y: "..tostring(exports.UCDutil:mathround(loc.y, 3)).."; Z: "..tostring(exports.UCDutil:mathround(loc.z, 3)))
	
	if (getServerSidedData) then
		-- This has a callback function where the data is updated
		triggerServerEvent("UCDadmin.requestPlayerData", localPlayer, plr)
	end
end

function requestPlayerData_callback(sync)
	--outputDebugString("Client callback")
	local data = sync

	adminPanel.label[2]:setText("IP: "..data["ip"])
	adminPanel.label[3]:setText("Serial: "..data["serial"])
	adminPanel.label[4]:setText("Version: "..data["version"])
	adminPanel.label[12]:setText("Email: "..data["email"] or "N/A")
	adminPanel.label[16]:setText("Bank: ".."$"..tostring(exports.UCDutil:tocomma(data["bank"])))
	adminPanel.label[15]:setText("Money: $"..tostring(exports.UCDutil:tocomma(data["money"])))
	adminPanel.label[2]:setText("IP: "..tostring(data["ip"] or "N/A"))
	adminPanel.label[3]:setText("Serial: "..tostring(data["serial"] or "N/A"))
	adminPanel.label[4]:setText("Version: "..tostring(data["version"] or "N/A"))
	adminPanel.label[12]:setText("Email: "..tostring(data["email"] or "N/A"))
	adminPanel.label[16]:setText("Bank: ".."$"..tostring(exports.UCDutil:tocomma(data["bank"]) or "0"))
	adminPanel.label[15]:setText("Money: $"..tostring(exports.UCDutil:tocomma(data["money"]) or "0"))
	adminPanel.label[22]:setText("Weapon: "..tostring(data["weapon"]))
end
addEvent("UCDadmin.requestPlayerData:callback", true)
addEventHandler("UCDadmin.requestPlayerData:callback", root, requestPlayerData_callback)

function playerSelection()
	if (source == adminPanel.gridlist[1]) then
		local row = guiGridListGetSelectedItem(adminPanel.gridlist[1])
		if (row and row ~= nil and row ~= -1 and row ~= false) then
			local plr = guiGridListGetItemData(adminPanel.gridlist[1], row, 1)
			--outputChatBox("Viewing data for: "..tostring(plr))
			updatePlayerInformation(plr, true)
		else
			-- Set everything blank
			adminPanel.label[1]:setText("Name: ")
			adminPanel.label[2]:setText("IP: ")
			adminPanel.label[3]:setText("Serial: ")
			adminPanel.label[4]:setText("Version: ")
			adminPanel.label[5]:setText("Account Name: ")
			adminPanel.label[6]:setText("Play Time: ")
			adminPanel.label[7]:setText("Country: ")
			adminPanel.label[9]:setText("Location: ")
			adminPanel.label[10]:setText("Dimension: ")
			adminPanel.label[12]:setText("Email: ")
			adminPanel.label[11]:setText("Interior: ")
			adminPanel.label[13]:setText("Health: ")
			adminPanel.label[14]:setText("Armour: ")
			adminPanel.label[15]:setText("Money: ")
			adminPanel.label[16]:setText("Bank: ")
			adminPanel.label[17]:setText("Occupation: ")
			adminPanel.label[18]:setText("Class: ")
			adminPanel.label[19]:setText("Group: ")
			adminPanel.label[20]:setText("Team: ")
			adminPanel.label[21]:setText("Model: ")
			adminPanel.label[22]:setText("Weapon: ")
			adminPanel.label[23]:setText("Ping: ")
			adminPanel.label[24]:setText("Vehicle: ")
			adminPanel.label[25]:setText("Vehicle Health: ")
			adminPanel.label[26]:setText("X: N/A; Y: N/A; Z: N/A")
		end
	end
end
addEventHandler("onClientGUIClick", guiRoot, playerSelection)

function toggleWPT(plr)
	WPT.window[1].visible = not WPT.window[1].visible
	guiGridListClear(WPT.gridlist[1])
	if (plr and isElement(plr) and exports.UCDaccounts:isPlayerLoggedIn(plr)) then
		playerToWarp = plr
		if (WPT.window[1].visible) then
			guiBringToFront(WPT.window[1])
			for _, player in ipairs(Element.getAllByType("player")) do
				if (plr ~= player and exports.UCDaccounts:isPlayerLoggedIn(player)) then
					
					local r, g, b = 255, 255, 255
					
					if (player.team) then
						r, g, b = player.team:getColor()
					end
					
					local row = guiGridListAddRow(WPT.gridlist[1])
					guiGridListSetItemText(WPT.gridlist[1], row, 1, tostring(player.name), false, false)
					guiGridListSetItemData(WPT.gridlist[1], row, 1, player)
					guiGridListSetItemColor(WPT.gridlist[1], row, 1, r, g, b)
				end
			end
		end
	end
end
addEvent("UCDadmin.toggleWPT", true)
addEventHandler("UCDadmin.toggleWPT", root, toggleWPT)

function handleWPTInput()
	if (source == WPT.button[1]) then
		local row = guiGridListGetSelectedItem(WPT.gridlist[1])
		if (row and row ~= -1) then
			local plr = guiGridListGetItemData(WPT.gridlist[1], row, 1)
			if playerToWarp then
				triggerServerEvent("UCDadmin.warpPlayerTo", localPlayer, playerToWarp, plr)
			end
			triggerEvent("UCDadmin.toggleWPT", localPlayer)
		end
	elseif (source == WPT.button[2]) then
		triggerEvent("UCDadmin.toggleWPT", localPlayer)
	end
end
addEventHandler("onClientGUIClick", WPT.button[1], handleWPTInput)
addEventHandler("onClientGUIClick", WPT.button[2], handleWPTInput)

function adminAction()
	if (source ~= adminPanel.gridlist[1] and source.parent == adminPanel.tab["players"]) then
		local plr = getSelectedPlayer()
		local action = source.text:lower()
		if not action then return end
		
		if (action == "punish") then
			togglePunishWindow(plr)
			return
		end
		
		if (not plr) then
			--exports.UCDdx:new("You must select a player first!", 255, 0, 0)
			return
		end
		
		if (action == "punish") then
			-- open punish gui
		elseif (action == "warp to player") then
			triggerServerEvent("UCDadmin.warpToPlayer", localPlayer, plr)
		elseif (action == "warp player to") then
			triggerEvent("UCDadmin.toggleWPT", localPlayer, plr)
		elseif (action == "reconnect") then
			triggerServerEvent("UCDadmin.reconnect", localPlayer, plr)
		elseif (action == "kick") then
			--triggerServerEvent("UCDadmin.kick", localPlayer, plr, "Annoying admins and creating a negative atmosphere")
			createInputBox("UCD | Admin - Kick", "Enter a reason [Note: this will be logged]", "", "UCDadmin.kick", localPlayer, plr)
		elseif (action == "freeze") then
			if (source == adminPanel.button[29]) then -- If it's the vehicle one
				triggerServerEvent("UCDadmin.freeze", localPlayer, plr.vehicle, plr)
			else -- We're dealing with the player one
				triggerServerEvent("UCDadmin.freeze", localPlayer, plr)
			end
		elseif (action == "shout") then
			createInputBox("UCD | Admin - Shout", "Enter the desired text", "", "UCDadmin.shout", localPlayer, plr)
		elseif (action == "spectate") then
			triggerServerEvent("UCDadmin.spectate", resourceRoot, plr)
		elseif (action == "slap") then
			triggerServerEvent("UCDadmin.slap", localPlayer, plr)
		elseif (action == "rename") then
			createInputBox("UCD | Admin - Rename", "Enter the desired name", exports.UCDutil:randomstring(8), "UCDadmin.rename", localPlayer, plr)
		elseif (action == "screenshot") then
			triggerServerEvent("UCDadmin.takeScreenshot", resourceRoot, plr)
		elseif (action == "set money") then
			createInputBox("UCD | Admin - Set Money", "Enter the desired amount of money", "", "UCDadmin.setMoney", localPlayer, plr)
		elseif (action == "set model") then
			createInputBox("UCD | Admin - Model", "Enter the desired model", 0, "UCDadmin.setModel", localPlayer, plr)
		elseif (action == "set health") then
			createInputBox("UCD | Admin - Health", "Enter the armour value", 200, "UCDadmin.setHealth", localPlayer, plr)
		elseif (action == "set armour") then
			-- Open another GUI with an input box
			--triggerServerEvent("UCDadmin.setArmour", localPlayer, plr, 100)
			createInputBox("UCD | Admin - Armour", "Enter the armour value", 100, "UCDadmin.setArmour", localPlayer, plr)
		elseif (action == "dimension") then
			createInputBox("UCD | Admin - Dimension", "Enter the desired dimension", 0, "UCDadmin.setDimension", localPlayer, plr)
		elseif (action == "interior") then
			createInputBox("UCD | Admin - Interior", "Enter the desired interior", 0, "UCDadmin.setInterior", localPlayer, plr)
		elseif (action == "last logins") then
			triggerServerEvent("UCDlastLogins.onRequestLogins", resourceRoot, plr)
		elseif (action == "set job") then
			openGUI(plr)
		-- elseif (action == "give wep") then handled #328

		elseif (action == "view punishments") then
			triggerServerEvent("UCDadmin.punishments.onViewPunishments", localPlayer, plr)
			viewPunish.window.visible = true
			guiBringToFront(viewPunish.window)
		elseif (action == "anticheat") then

		elseif (action == "view weps") then
			outputChatBox("VIEWING "..tostring(plr.name).."'s WEAPONS", 255, 255, 0)
			outputChatBox("FORMAT: SLOT - ID - NAME - AMMO", 255, 140, 0)
			for i = 0, 13 do
				local wep = getPedWeapon(plr, i)
				if (wep and wep > 0) then
					local ammo = getPedTotalAmmo(plr, i)
					if (ammo and ammo > 0) then
						local str = string.format("%s - %s - %s - %s",
						tostring(i),
						tostring(wep),
						tostring(getWeaponNameFromID(wep)),
						tostring(getPedTotalAmmo(plr, i))
						) -- just like tables(table = {row1, row2, ...\n})
						outputChatBox(str, 255, 0, 255)
					end
				end
			end
			outputChatBox("DONE - P.S. If the player has no weapons no lines would be outputted", 255, 255, 0)
		elseif (action == "fix") then
			if (plr.vehicle) then
				triggerServerEvent("UCDadmin.fixVehicle", localPlayer, plr, plr.vehicle)
			end
		elseif (action == "eject") then
			if (plr.vehicle) then
				triggerServerEvent("UCDadmin.ejectPlayer", localPlayer, plr, plr.vehicle)
			end
		elseif (action == "destroy") then
			if (plr.vehicle) then
				if (plr.vehicle:getData("vehicleID")) then
					exports.UCDdx:new(plr.name.."'s vehicle is a player vehicle. Hiding it instead...", 0, 255, 0)
					triggerServerEvent("UCDvehicles.hideVehicle", plr, plr.vehicle:getData("vehicleID"), true, true)
					--triggerServerEvent("UCDadmin.destroyVehicle", localPlayer, plr)
					return
				end
				triggerServerEvent("UCDadmin.destroyVehicle", localPlayer, plr, plr.vehicle)
			--else
			--	exports.UCDdx:new("This player is not in a vehicle", 255, 0, 0)
			end
		elseif (action == "disable") then
			if (plr.vehicle) then
				triggerServerEvent("UCDadmin.disableVehicle", resourceRoot, plr, plr.vehicle)
			end
		elseif (action == "blow") then

		elseif (action == "give vehicle") then
			if (plr.vehicle) then
				exports.UCDdx:new("You can't give this player a vehicle as they are already in one", 255, 0, 0)
				return
			end
			createInputBox("UCD | Admin - Give Vehicle", "Enter a vehicle ID or name", "", "UCDadmin.giveVehicle", localPlayer, plr)
		end
	end
end
addEventHandler("onClientGUIClick", guiRoot, adminAction)

function toggleGUI()
	if (not _permissions) then return end
	adminPanel.window.visible = not adminPanel.window.visible
	showCursor(adminPanel.window.visible)
	if (adminPanel.window.visible) then
		guiSetInputMode("no_binds_when_editing")
	else
		guiSetInputMode("allow_binds")
		for _, gui in ipairs(windows) do
			if (gui and isElement(gui)) then
				gui.visible = false
			end
		end
	end
	if (confirm.window[1]) then
		closeInputBox()
	end
end
addCommandHandler("adminpanel", toggleGUI, false, false)
bindKey("p", "down", "adminpanel")
