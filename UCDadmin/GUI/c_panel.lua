adminPanel = {tab = {}, label = {}, tabpanel = {}, edit = {}, gridlist = {}, window = {}, checkbox = {}, button = {}}
confirm = {button = {}, window = {}, label = {}, edit = {}}
giveWeapon_ = {edit = {}, button = {}, window = {}, label = {}, combobox = {}}
WPT = {gridlist = {}, window = {}, button = {}, label = {}}

function getSelectedPlayer()
	local row = guiGridListGetSelectedItem(adminPanel.gridlist[1])
	if (row ~= false and row ~= nil and row ~= -1) then
		local player = guiGridListGetItemData(adminPanel.gridlist[1], row, 1)
		return player
	end
end

local punishments = {
	"#0: Removing Punishment",
	"#0: Deathmatching",
	"Bugged",
}

local punishmentTimes = {
	-- From punishments table
	-- ["#0: Deathmatching"] = {[1] = 300, [2] = 600, [3] = 1200, [4] = 1800, [5] = 2400, [6] = ban (21600 - 6 hrs), -- repeat 6}
}

--addEventHandler("onClientResourceStart", resourceRoot,
--	function()
        adminPanel.window[1] = guiCreateWindow(697, 262, 665, 504, "UCD | Administrative & Management Panel", false)
        guiWindowSetSizable(adminPanel.window[1], false)
        guiSetVisible(adminPanel.window[1], false)
		exports.UCDutil:centerWindow(adminPanel.window[1])

        adminPanel.tabpanel[1] = guiCreateTabPanel(10, 24, 645, 470, false, adminPanel.window[1])

        adminPanel.tab[1] = guiCreateTab("Players", adminPanel.tabpanel[1])

        adminPanel.gridlist[1] = guiCreateGridList(10, 40, 151, 395, false, adminPanel.tab[1])
        guiGridListAddColumn(adminPanel.gridlist[1], "Player Name", 0.9)
        guiGridListSetSortingEnabled(adminPanel.gridlist[1], false)
		
        adminPanel.edit[1] = guiCreateEdit(10, 10, 151, 26, "", false, adminPanel.tab[1])
        adminPanel.label[1] = guiCreateLabel(170, 26, 290, 20, "Name: ", false, adminPanel.tab[1])
        adminPanel.label[2] = guiCreateLabel(170, 86, 290, 20, "IP: ", false, adminPanel.tab[1])
        guiLabelSetHorizontalAlign(adminPanel.label[2], "right", false)
        adminPanel.label[3] = guiCreateLabel(170, 66, 290, 20, "Serial: ", false, adminPanel.tab[1])
        adminPanel.label[4] = guiCreateLabel(171, 86, 289, 20, "Version: ", false, adminPanel.tab[1])
        adminPanel.label[5] = guiCreateLabel(170, 46, 290, 20, "Account Name: ", false, adminPanel.tab[1])
        adminPanel.label[6] = guiCreateLabel(171, 375, 289, 21, "Playtime: ", false, adminPanel.tab[1])
        adminPanel.label[7] = guiCreateLabel(170, 126, 290, 22, "Country: ", false, adminPanel.tab[1])
      --  adminPanel.label[8] = guiCreateLabel(171, 128, 289, 20, "Account ID: ", false, adminPanel.tab[1])
       -- guiLabelSetHorizontalAlign(adminPanel.label[8], "right", false)
        adminPanel.label[9] = guiCreateLabel(170, 210, 290, 20, "Location: ", false, adminPanel.tab[1])
        adminPanel.label[10] = guiCreateLabel(170, 230, 290, 20, "Dimension: ", false, adminPanel.tab[1])
        adminPanel.label[11] = guiCreateLabel(170, 230, 290, 20, "Interior: ", false, adminPanel.tab[1])
        guiLabelSetHorizontalAlign(adminPanel.label[11], "right", false)
        adminPanel.label[12] = guiCreateLabel(170, 106, 290, 20, "Email: ", false, adminPanel.tab[1])
        adminPanel.label[13] = guiCreateLabel(170, 270, 290, 20, "Health: ", false, adminPanel.tab[1])
        adminPanel.label[14] = guiCreateLabel(170, 270, 290, 20, "Armour: ", false, adminPanel.tab[1])
        guiLabelSetHorizontalAlign(adminPanel.label[14], "right", false)
        adminPanel.label[15] = guiCreateLabel(171, 355, 289, 20, "Money: ", false, adminPanel.tab[1])
        adminPanel.label[16] = guiCreateLabel(170, 355, 290, 20, "Bank: ", false, adminPanel.tab[1])
        guiLabelSetHorizontalAlign(adminPanel.label[16], "right", false)
        adminPanel.label[17] = guiCreateLabel(170, 396, 291, 20, "Occupation: ", false, adminPanel.tab[1])
        guiLabelSetHorizontalAlign(adminPanel.label[17], "right", false)
        adminPanel.label[18] = guiCreateLabel(171, 396, 290, 20, "Class: ", false, adminPanel.tab[1])
        adminPanel.label[19] = guiCreateLabel(171, 335, 289, 20, "Group: ", false, adminPanel.tab[1])
        adminPanel.label[20] = guiCreateLabel(171, 375, 289, 21, "Team: ", false, adminPanel.tab[1])
        guiLabelSetHorizontalAlign(adminPanel.label[20], "right", false)
        adminPanel.label[21] = guiCreateLabel(170, 250, 267, 20, "Model: ", false, adminPanel.tab[1])
        adminPanel.label[22] = guiCreateLabel(171, 250, 290, 20, "Weapon: ", false, adminPanel.tab[1])
        guiLabelSetHorizontalAlign(adminPanel.label[22], "right", false)
        adminPanel.label[23] = guiCreateLabel(170, 26, 290, 20, "Ping: ", false, adminPanel.tab[1])
        guiLabelSetHorizontalAlign(adminPanel.label[23], "right", false)
        adminPanel.label[24] = guiCreateLabel(170, 416, 290, 20, "Vehicle: ", false, adminPanel.tab[1])
        adminPanel.label[25] = guiCreateLabel(170, 416, 290, 20, "Vehicle Health: ", false, adminPanel.tab[1])
        guiLabelSetHorizontalAlign(adminPanel.label[25], "right", false)
        adminPanel.label[26] = guiCreateLabel(170, 190, 290, 20, "X: N/A; Y: N/A; Z: N/A", false, adminPanel.tab[1])
        adminPanel.label[27] = guiCreateLabel(170, 168, 49, 22, "Locality", false, adminPanel.tab[1])
        guiSetFont(adminPanel.label[27], "default-bold-small")
        guiLabelSetColor(adminPanel.label[27], 255, 0, 0)
        adminPanel.label[28] = guiCreateLabel(170, 4, 49, 22, "Player", false, adminPanel.tab[1])
        guiSetFont(adminPanel.label[28], "default-bold-small")
        guiLabelSetColor(adminPanel.label[28], 255, 0, 0)
        adminPanel.label[29] = guiCreateLabel(170, 313, 49, 22, "Misc", false, adminPanel.tab[1])
        guiSetFont(adminPanel.label[29], "default-bold-small")
        guiLabelSetColor(adminPanel.label[29], 255, 0, 0)
        adminPanel.button[1] = guiCreateButton(488, 52, 147, 18, "Warp to player", false, adminPanel.tab[1])
        adminPanel.button[2] = guiCreateButton(488, 10, 147, 36, "Punish", false, adminPanel.tab[1])
        adminPanel.button[3] = guiCreateButton(488, 144, 72, 18, "Spectate", false, adminPanel.tab[1])
        adminPanel.button[4] = guiCreateButton(488, 76, 147, 18, "Warp player to", false, adminPanel.tab[1])
        adminPanel.button[5] = guiCreateButton(488, 100, 72, 18, "Reconnect", false, adminPanel.tab[1])
        adminPanel.button[6] = guiCreateButton(563, 100, 72, 18, "Kick", false, adminPanel.tab[1])
        adminPanel.button[7] = guiCreateButton(488, 122, 72, 18, "Freeze", false, adminPanel.tab[1])
        adminPanel.button[8] = guiCreateButton(563, 122, 72, 18, "Shout", false, adminPanel.tab[1])
        adminPanel.button[9] = guiCreateButton(563, 144, 72, 18, "Slap", false, adminPanel.tab[1])
        adminPanel.button[10] = guiCreateButton(488, 167, 72, 18, "Rename", false, adminPanel.tab[1])
        adminPanel.button[11] = guiCreateButton(488, 318, 147, 20, "View punishments", false, adminPanel.tab[1])
        adminPanel.button[12] = guiCreateButton(563, 167, 72, 18, "Screenshot", false, adminPanel.tab[1])
        adminPanel.button[13] = guiCreateButton(563, 195, 72, 18, "Set Model", false, adminPanel.tab[1])
        adminPanel.button[14] = guiCreateButton(488, 195, 72, 18, "Money", false, adminPanel.tab[1])
        adminPanel.button[15] = guiCreateButton(488, 220, 72, 18, "Set Health", false, adminPanel.tab[1])
        adminPanel.button[16] = guiCreateButton(563, 220, 72, 18, "Set Armour", false, adminPanel.tab[1])
        adminPanel.button[17] = guiCreateButton(488, 244, 72, 18, "Dimension", false, adminPanel.tab[1])
        adminPanel.button[18] = guiCreateButton(563, 244, 72, 18, "Interior", false, adminPanel.tab[1])
        adminPanel.button[19] = guiCreateButton(488, 369, 72, 18, "Fix", false, adminPanel.tab[1])
        adminPanel.button[20] = guiCreateButton(563, 369, 72, 18, "Eject", false, adminPanel.tab[1])
        adminPanel.button[21] = guiCreateButton(488, 392, 72, 18, "Destroy", false, adminPanel.tab[1])
        adminPanel.button[22] = guiCreateButton(563, 392, 72, 18, "Disable", false, adminPanel.tab[1])
        adminPanel.button[23] = guiCreateButton(563, 266, 72, 18, "Set Job", false, adminPanel.tab[1])
        adminPanel.button[24] = guiCreateButton(488, 341, 72, 18, "Anticheat", false, adminPanel.tab[1])
        adminPanel.button[25] = guiCreateButton(563, 341, 72, 18, "View Weps", false, adminPanel.tab[1])
        adminPanel.button[26] = guiCreateButton(488, 290, 72, 18, "Weapons", false, adminPanel.tab[1])
        adminPanel.button[27] = guiCreateButton(488, 266, 72, 18, "Give Vehicle", false, adminPanel.tab[1])
        adminPanel.button[28] = guiCreateButton(488, 416, 72, 18, "Blow", false, adminPanel.tab[1])
        adminPanel.button[29] = guiCreateButton(563, 416, 72, 18, "Freeze", false, adminPanel.tab[1])
		adminPanel.button[27] = guiCreateButton(563, 290, 72, 18, "Last Logins", false, adminPanel.tab[1])

        adminPanel.tab[2] = guiCreateTab("Resources", adminPanel.tabpanel[1])

        adminPanel.gridlist[2] = guiCreateGridList(10, 48, 245, 349, false, adminPanel.tab[2])
        guiGridListAddColumn(adminPanel.gridlist[2], "Resource", 0.5)
        guiGridListAddColumn(adminPanel.gridlist[2], "State", 0.4)
        guiGridListSetItemText(adminPanel.gridlist[2], 0, 1, "-", false, false)
        guiGridListSetItemText(adminPanel.gridlist[2], 0, 2, "-", false, false)
        adminPanel.edit[2] = guiCreateEdit(10, 10, 245, 28, "", false, adminPanel.tab[2])
        adminPanel.button[30] = guiCreateButton(10, 407, 245, 29, "Refresh", false, adminPanel.tab[2])
        adminPanel.edit[3] = guiCreateEdit(-548, 44, 15, 15, "", false, adminPanel.tab[2])
        adminPanel.edit[4] = guiCreateEdit(265, 282, 350, 30, "", false, adminPanel.tab[2])
        adminPanel.checkbox[1] = guiCreateCheckBox(410, 317, 15, 15, "", false, false, adminPanel.tab[2])
        adminPanel.label[30] = guiCreateLabel(435, 317, 105, 20, "Silent", false, adminPanel.tab[2])
        adminPanel.button[31] = guiCreateButton(290, 342, 140, 19, "Client", false, adminPanel.tab[2])
        adminPanel.button[32] = guiCreateButton(454, 342, 140, 19, "Server", false, adminPanel.tab[2])
        adminPanel.label[31] = guiCreateLabel(265, 366, 302, 18, "Last runs", false, adminPanel.tab[2])
        adminPanel.label[32] = guiCreateLabel(271, 384, 374, 18, "[UCD]Noki [server]: killPed(getPlayerFromName(\"Epozide\"))", false, adminPanel.tab[2])
        adminPanel.label[33] = guiCreateLabel(271, 402, 374, 18, "[UCD]Noki [server]: killPed(getPlayerFromName(\"Epozide\"))", false, adminPanel.tab[2])
        adminPanel.label[34] = guiCreateLabel(271, 420, 374, 16, "[UCD]Noki [server]: killPed(getPlayerFromName(\"Epozide\"))", false, adminPanel.tab[2])
        adminPanel.button[33] = guiCreateButton(282, 20, 148, 38, "Start", false, adminPanel.tab[2])
        adminPanel.button[34] = guiCreateButton(457, 20, 148, 38, "Stop", false, adminPanel.tab[2])
        adminPanel.button[35] = guiCreateButton(282, 70, 323, 38, "Restart", false, adminPanel.tab[2])
        adminPanel.button[36] = guiCreateButton(457, 118, 148, 38, "Delete", false, adminPanel.tab[2])
        adminPanel.button[37] = guiCreateButton(282, 118, 148, 38, "Move", false, adminPanel.tab[2])
        adminPanel.label[35] = guiCreateLabel(265, 168, 178, 21, "Resource Information", false, adminPanel.tab[2])
        guiSetFont(adminPanel.label[35], "default-bold-small")
        guiLabelSetColor(adminPanel.label[35], 255, 0, 0)
        adminPanel.label[36] = guiCreateLabel(280, 189, 345, 20, "Name:", false, adminPanel.tab[2])
        adminPanel.label[37] = guiCreateLabel(280, 209, 345, 20, "Author:", false, adminPanel.tab[2])
        adminPanel.label[38] = guiCreateLabel(280, 229, 345, 20, "Version:", false, adminPanel.tab[2])
        adminPanel.label[39] = guiCreateLabel(280, 249, 345, 23, "Description:", false, adminPanel.tab[2])
        adminPanel.tab[3] = guiCreateTab("Server Management", adminPanel.tabpanel[1])
        adminPanel.tab[4] = guiCreateTab("Utilities", adminPanel.tabpanel[1])    
		
		
        confirm.window[1] = guiCreateWindow(792, 480, 324, 111, "UCD | Admin - ", false)
        confirm.window[1].sizable = false
        confirm.window[1].visible = false
        confirm.button[1] = guiCreateButton(58, 82, 101, 19, "Confirm", false, confirm.window[1])
        confirm.button[2] = guiCreateButton(169, 82, 101, 19, "Cancel", false, confirm.window[1])
        confirm.edit[1] = guiCreateEdit(35, 47, 260, 25, "", false, confirm.window[1])
        confirm.label[1] = guiCreateLabel(36, 21, 259, 20, "Set the motherfucking label text nigga", false, confirm.window[1])
        guiLabelSetHorizontalAlign(confirm.label[1], "center", false)
        guiLabelSetVerticalAlign(confirm.label[1], "center") 
		
		-- 
		WPT.window[1] = guiCreateWindow(850, 390, 201, 348, "UCD Admin | Warp Player To", false)
		WPT.window[1].sizable = false
		WPT.window[1].visible = false
		WPT.button[1] = guiCreateButton(10, 304, 85, 34, "Warp Player To", false, WPT.window[1])
		WPT.label[1] = guiCreateLabel(10, 24, 179, 21, "Select a player from the grid", false, WPT.window[1])
		guiLabelSetHorizontalAlign(WPT.label[1], "center", false)
		WPT.gridlist[1] = guiCreateGridList(10, 45, 178, 249, false, WPT.window[1])
		guiGridListAddColumn(WPT.gridlist[1], "Player", 0.9)
		WPT.button[2] = guiCreateButton(103, 304, 85, 34, "Close", false, WPT.window[1])
		
		--
		local weapons = {
			"Colt 45", "Silenced", "Deagle", "Shotgun", "Sawed-off", "Combat Shotgun",
			"Uzi", "MP5", "Tec-9", "AK-47", "M4", "Rifle", "Sniper",
			"Rocket Launcher", "Minigun", "Grenade", "Satchel", "Teargas", "Parachute"
		}
		giveWeapon_.window[1] = guiCreateWindow(244, 682, 317, 126, "UCD | Admin - Give Weapon", false)
		giveWeapon_.window[1].sizable = false
		giveWeapon_.window[1].visible = false
		giveWeapon_.edit[1] = guiCreateEdit(226, 48, 81, 25, "", false, giveWeapon_.window[1])
		giveWeapon_.combobox[1] = guiCreateComboBox(10, 48, 197, 100, "", false, giveWeapon_.window[1])
		for _, wep in ipairs(weapons) do
			guiComboBoxAddItem(giveWeapon_.combobox[1], wep)
		end
		giveWeapon_.label[1] = guiCreateLabel(10, 24, 197, 19, "Weapon", false, giveWeapon_.window[1])
		guiLabelSetHorizontalAlign(giveWeapon_.label[1], "center", false)
		guiLabelSetVerticalAlign(giveWeapon_.label[1], "center")
		giveWeapon_.label[2] = guiCreateLabel(226, 24, 81, 19, "Ammo", false, giveWeapon_.window[1])
		guiLabelSetHorizontalAlign(giveWeapon_.label[2], "center", false)
		guiLabelSetVerticalAlign(giveWeapon_.label[2], "center")
		giveWeapon_.button[1] = guiCreateButton(66, 92, 87, 22, "Confirm", false, giveWeapon_.window[1])
		giveWeapon_.button[2] = guiCreateButton(168, 92, 87, 22, "Close", false, giveWeapon_.window[1])

		windows = {adminPanel.window[1], giveWeapon_.window[1], WPT.window[1]}
		for _, gui in ipairs(windows) do
			if (gui and isElement(gui)) then
				exports.UCDutil:centerWindow(gui)
			end
		end
--    end
--)

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

function updateResources(kk)
	if (kk and type(kk) == "table") then
		guiGridListClear(adminPanel.gridlist[2])
		for i, res in ipairs(kk) do
			local row = guiGridListAddRow(adminPanel.gridlist[2])

			local r, g, b
			if (res[2] == "running" or res[2] == "starting") then
				r, g, b = 0, 255, 0
			else
				r, g, b = 255, 0 ,0
			end
			guiGridListSetItemText(adminPanel.gridlist[2], row, 1, tostring(res[1]), false, false)
			guiGridListSetItemText(adminPanel.gridlist[2], row, 2, tostring(res[2]), false, false)
			guiGridListSetItemColor(adminPanel.gridlist[2], row, 1, r, g, b)
			guiGridListSetItemColor(adminPanel.gridlist[2], row, 2, r, g, b)
		end
	end
end
addEvent("UCDadmin.updateResources", true)
addEventHandler("UCDadmin.updateResources", root, updateResources)

function aa()
	triggerServerEvent("UCDadmin.getResources", localPlayer)
end
addEventHandler("onClientResourceStart", resourceRoot, aa)
addEventHandler("onClientGUIClick", adminPanel.button[30], aa, false)

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
		--if source.name:lower():find(adminPanel.edit[1]:getText():lower()) then
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
		--end
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

addEventHandler("onClientRender", root,
	function ()
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
)

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
	local armour = plr.armor or 0
	local money = plr:getMoney() or "N/A"
	local team = plr.team.name or "Not logged in"
	local group = plr:getData("group") or "N/A"
	local class = plr:getData("Class") or "N/A"
	local occupation = plr:getData("Occupation") or "N/A"
	local ping = plr.ping
	local suburb, city = getZoneName(loc.x, loc.y, loc.z), getZoneName(loc.x, loc.y, loc.z, true)
	local country = plr:getData("Country") or "N/A"
	local playtime = plr:getData("dxscoreboard_playtime") or "N/A"
	
	local ammo, weapon
	if (getPedWeapon(plr)) then
		ammo, weapon = getPedTotalAmmo(plr), getWeaponNameFromID(getPedWeapon(plr))
	else
		ammo = "1"
		weapon = "Fist"
	end
	
	local vehicle, vehicleHealth
	if not plr.vehicle then 
		vehicle = "Not in a vehicle" 
		vehicleHealth = "N/A" 
	else 
		vehicle = plr.vehicle.name
		vehicleHealth = tostring(exports.UCDutil:mathround(plr.vehicle.health / 10).."%")
	end
	
	adminPanel.label[1]:setText("Name: "..name)
	adminPanel.label[5]:setText("Account Name: "..accountName)
	adminPanel.label[6]:setText("Playtime: "..playtime)
	adminPanel.label[7]:setText("Country: "..country)
	--adminPanel.label[8]:setText("Account ID: "..accountID)
	adminPanel.label[9]:setText("Location: "..suburb..", "..city)
	adminPanel.label[10]:setText("Dimension: "..dim)
	adminPanel.label[11]:setText("Interior: "..int)
	adminPanel.label[13]:setText("Health: "..health)
	adminPanel.label[14]:setText("Armour: "..armour)
	adminPanel.label[15]:setText("Money: ".."$"..tostring(exports.UCDutil:tocomma(money)))
	adminPanel.label[17]:setText("Occupation: "..occupation)
	adminPanel.label[18]:setText("Class: "..class)
	adminPanel.label[19]:setText("Group: "..group)
	adminPanel.label[20]:setText("Team: "..team)
	adminPanel.label[21]:setText("Model: "..model)
	adminPanel.label[22]:setText("Weapon: "..tostring(weapon).." ["..tostring(ammo).."]")
	adminPanel.label[23]:setText("Ping: "..ping)
	adminPanel.label[24]:setText("Vehicle: "..vehicle)
	adminPanel.label[25]:setText("Vehicle Health: "..vehicleHealth)
	adminPanel.label[26]:setText("X: "..exports.UCDutil:mathround(loc.x, 3).."; Y: "..exports.UCDutil:mathround(loc.y, 3).."; Z: "..exports.UCDutil:mathround(loc.z, 3))
	
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
	adminPanel.label[12]:setText("Email: "..data["email"])
	adminPanel.label[16]:setText("Bank: ".."$"..tostring(exports.UCDutil:mathround(data["bank"])))
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
			adminPanel.label[6]:setText("Playtime: ")
			adminPanel.label[7]:setText("Country: ")
			--adminPanel.label[8]:setText("Account ID: ")
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
	if (plr) then
		playerToWarp = plr
		if (WPT.window[1].visible) then
			guiBringToFront(WPT.window[1])
			for _, player in ipairs(Element.getAllByType("player")) do
				if (exports.UCDaccounts:isPlayerLoggedIn(plr)) then
					local r, g, b
					if (player.team) then
						r, g, b = player.team:getColor()
					else
						r, g, b = 255, 255, 255
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
	if (source ~= adminPanel.gridlist[1] and source.parent == adminPanel.tab[1]) then
		local plr = getSelectedPlayer()
		if (not plr) then
			--exports.UCDdx:new("You must select a player first!", 255, 0, 0)
			return
		end
		
		local action = source.text:lower()
		if not action then return end
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
			
		elseif (action == "spectate") then
			triggerServerEvent("UCDadmin.spectate", localPlayer, plr)
		elseif (action == "slap") then
			triggerServerEvent("UCDadmin.slap", localPlayer, plr)
		elseif (action == "rename") then
			createInputBox("UCD | Admin - Rename", "Enter the desired name", exports.UCDutil:randomstring(8), "UCDadmin.rename", localPlayer, plr)
		elseif (action == "screenshot") then
			
		elseif (action == "money") then
			
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
			
		elseif (action == "set job") then
			
		elseif (action == "weapons") then
			
		elseif (action == "view punishments") then
			
		elseif (action == "anticheat") then
			
		elseif (action == "view weps") then
			
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
					triggerServerEvent("UCDvehicleSystem.hideVehicle", plr, plr.vehicle:getData("vehicleID"))
					--triggerServerEvent("UCDadmin.destroyVehicle", localPlayer, plr)
					return
				end
				triggerServerEvent("UCDadmin.destroyVehicle", localPlayer, plr, plr.vehicle)
			else
				exports.UCDdx:new("This player is not in a vehicle", 255, 0, 0)
			end
		elseif (action == "disable") then
			
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
	--[[
	if (guiGetVisible(adminPanel.window[1])) then
		adminPanel.window[1]:setVisible(false)
	else
		adminPanel.window[1]:setVisible(true)
	end
	--]]
	adminPanel.window[1].visible = not adminPanel.window[1].visible
	showCursor(adminPanel.window[1].visible)
	if (adminPanel.window[1].visible) then
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
addCommandHandler("adminpanel", toggleGUI)
bindKey("p", "down", toggleGUI)
