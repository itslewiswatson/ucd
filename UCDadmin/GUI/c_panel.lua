
adminPanel = {
    tab = {},
    label = {},
    tabpanel = {},
    edit = {},
    gridlist = {},
    window = {},
    checkbox = {},
    button = {}
}
addEventHandler("onClientResourceStart", resourceRoot,
    function()
        adminPanel.window[1] = guiCreateWindow(697, 262, 665, 504, "UCD | Administrative & Management Panel", false)
        guiWindowSetSizable(adminPanel.window[1], false)
        guiSetVisible(adminPanel.window[1], false)

        adminPanel.tabpanel[1] = guiCreateTabPanel(10, 24, 645, 470, false, adminPanel.window[1])

        adminPanel.tab[1] = guiCreateTab("Players", adminPanel.tabpanel[1])

        adminPanel.gridlist[1] = guiCreateGridList(10, 40, 151, 395, false, adminPanel.tab[1])
        guiGridListAddColumn(adminPanel.gridlist[1], "Player Name", 0.9)
        guiGridListSetSortingEnabled(adminPanel.gridlist[1], false)
		
		for _, plr in pairs(Element.getAllByType("player")) do
			local row = guiGridListAddRow(adminPanel.gridlist[1])
			local r, g, b = plr.team:getColor()
			guiGridListSetItemText(adminPanel.gridlist[1], row, 1, plr.name, false, false)
			guiGridListSetItemData(adminPanel.gridlist[1], row, 1, plr)
			guiGridListSetItemColor(adminPanel.gridlist[1], row, 1, r, g, b)
		end
		
        adminPanel.edit[1] = guiCreateEdit(10, 10, 151, 26, "", false, adminPanel.tab[1])
        adminPanel.label[1] = guiCreateLabel(170, 26, 290, 20, "Name: PA~|H|Noki>Tr", false, adminPanel.tab[1])
        adminPanel.label[2] = guiCreateLabel(170, 86, 290, 20, "IP: 110.174.254.213", false, adminPanel.tab[1])
        guiLabelSetHorizontalAlign(adminPanel.label[2], "right", false)
        adminPanel.label[3] = guiCreateLabel(170, 66, 290, 20, "Serial: 7784D1745F2D9DD06DD223333311BEB4", false, adminPanel.tab[1])
        adminPanel.label[4] = guiCreateLabel(171, 86, 289, 20, "Version: 1.5.1-9.0765.0", false, adminPanel.tab[1])
        adminPanel.label[5] = guiCreateLabel(170, 46, 290, 20, "Account Name: Noki", false, adminPanel.tab[1])
        adminPanel.label[6] = guiCreateLabel(171, 375, 289, 21, "Playtime: 1024 Hours", false, adminPanel.tab[1])
        adminPanel.label[7] = guiCreateLabel(170, 126, 290, 22, "Country: Australia, AU", false, adminPanel.tab[1])
        adminPanel.label[8] = guiCreateLabel(171, 128, 289, 20, "Account ID: 1", false, adminPanel.tab[1])
        guiLabelSetHorizontalAlign(adminPanel.label[8], "right", false)
        adminPanel.label[9] = guiCreateLabel(170, 210, 290, 20, "Location: Redsands West, Las Venturas", false, adminPanel.tab[1])
        adminPanel.label[10] = guiCreateLabel(170, 230, 290, 20, "Dimension: 0", false, adminPanel.tab[1])
        adminPanel.label[11] = guiCreateLabel(170, 230, 290, 20, "Interior: 0", false, adminPanel.tab[1])
        guiLabelSetHorizontalAlign(adminPanel.label[11], "right", false)
        adminPanel.label[12] = guiCreateLabel(170, 106, 290, 20, "Email: lewis.watson@outlook.com", false, adminPanel.tab[1])
        adminPanel.label[13] = guiCreateLabel(170, 270, 290, 20, "Health: 100", false, adminPanel.tab[1])
        adminPanel.label[14] = guiCreateLabel(170, 270, 290, 20, "Armour: 100", false, adminPanel.tab[1])
        guiLabelSetHorizontalAlign(adminPanel.label[14], "right", false)
        adminPanel.label[15] = guiCreateLabel(171, 355, 289, 20, "Money: $99,999,999", false, adminPanel.tab[1])
        adminPanel.label[16] = guiCreateLabel(170, 355, 290, 20, "Bank: $99,999,999,999", false, adminPanel.tab[1])
        guiLabelSetHorizontalAlign(adminPanel.label[16], "right", false)
        adminPanel.label[17] = guiCreateLabel(170, 396, 291, 20, "Occupation: Pilot", false, adminPanel.tab[1])
        guiLabelSetHorizontalAlign(adminPanel.label[17], "right", false)
        adminPanel.label[18] = guiCreateLabel(171, 396, 290, 20, "Class: Law Enforcement", false, adminPanel.tab[1])
        adminPanel.label[19] = guiCreateLabel(171, 335, 289, 20, "Group: nR7Gaming", false, adminPanel.tab[1])
        adminPanel.label[20] = guiCreateLabel(171, 375, 289, 21, "Team: Civilian Workers", false, adminPanel.tab[1])
        guiLabelSetHorizontalAlign(adminPanel.label[20], "right", false)
        adminPanel.label[21] = guiCreateLabel(170, 250, 267, 20, "Skin: 150", false, adminPanel.tab[1])
        adminPanel.label[22] = guiCreateLabel(171, 250, 290, 20, "Weapon: Sawed-off", false, adminPanel.tab[1])
        guiLabelSetHorizontalAlign(adminPanel.label[22], "right", false)
        adminPanel.label[23] = guiCreateLabel(170, 26, 290, 20, "Ping: 3007", false, adminPanel.tab[1])
        guiLabelSetHorizontalAlign(adminPanel.label[23], "right", false)
        adminPanel.label[24] = guiCreateLabel(170, 416, 290, 20, "Vehicle: Andromeda", false, adminPanel.tab[1])
        adminPanel.label[25] = guiCreateLabel(170, 416, 290, 20, "Vehicle Health: 0%", false, adminPanel.tab[1])
        guiLabelSetHorizontalAlign(adminPanel.label[25], "right", false)
        adminPanel.label[26] = guiCreateLabel(170, 190, 290, 20, "X: 1000.119; Y = 5000.995; Z = 1000.436", false, adminPanel.tab[1])
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
        guiSetProperty(adminPanel.button[1], "NormalTextColour", "FFAAAAAA")
        adminPanel.button[2] = guiCreateButton(488, 10, 147, 36, "Punish", false, adminPanel.tab[1])
        guiSetProperty(adminPanel.button[2], "NormalTextColour", "FFAAAAAA")
        adminPanel.button[3] = guiCreateButton(488, 144, 72, 18, "Spectate", false, adminPanel.tab[1])
        guiSetProperty(adminPanel.button[3], "NormalTextColour", "FFAAAAAA")
        adminPanel.button[4] = guiCreateButton(488, 76, 147, 18, "Warp player to", false, adminPanel.tab[1])
        guiSetProperty(adminPanel.button[4], "NormalTextColour", "FFAAAAAA")
        adminPanel.button[5] = guiCreateButton(488, 100, 72, 18, "Reconnect", false, adminPanel.tab[1])
        guiSetProperty(adminPanel.button[5], "NormalTextColour", "FFAAAAAA")
        adminPanel.button[6] = guiCreateButton(563, 100, 72, 18, "Kick", false, adminPanel.tab[1])
        guiSetProperty(adminPanel.button[6], "NormalTextColour", "FFAAAAAA")
        adminPanel.button[7] = guiCreateButton(488, 122, 72, 18, "Freeze", false, adminPanel.tab[1])
        guiSetProperty(adminPanel.button[7], "NormalTextColour", "FFAAAAAA")
        adminPanel.button[8] = guiCreateButton(563, 122, 72, 18, "Shout", false, adminPanel.tab[1])
        guiSetProperty(adminPanel.button[8], "NormalTextColour", "FFAAAAAA")
        adminPanel.button[9] = guiCreateButton(563, 144, 72, 18, "Slap", false, adminPanel.tab[1])
        guiSetProperty(adminPanel.button[9], "NormalTextColour", "FFAAAAAA")
        adminPanel.button[10] = guiCreateButton(488, 167, 72, 18, "Rename", false, adminPanel.tab[1])
        guiSetProperty(adminPanel.button[10], "NormalTextColour", "FFAAAAAA")
        adminPanel.button[11] = guiCreateButton(488, 318, 147, 20, "View punishments", false, adminPanel.tab[1])
        guiSetProperty(adminPanel.button[11], "NormalTextColour", "FFAAAAAA")
        adminPanel.button[12] = guiCreateButton(563, 167, 72, 18, "Screenshot", false, adminPanel.tab[1])
        guiSetProperty(adminPanel.button[12], "NormalTextColour", "FFAAAAAA")
        adminPanel.button[13] = guiCreateButton(563, 195, 72, 18, "Set Skin", false, adminPanel.tab[1])
        guiSetProperty(adminPanel.button[13], "NormalTextColour", "FFAAAAAA")
        adminPanel.button[14] = guiCreateButton(488, 195, 72, 18, "Money", false, adminPanel.tab[1])
        guiSetProperty(adminPanel.button[14], "NormalTextColour", "FFAAAAAA")
        adminPanel.button[15] = guiCreateButton(488, 220, 72, 18, "Set Health", false, adminPanel.tab[1])
        guiSetProperty(adminPanel.button[15], "NormalTextColour", "FFAAAAAA")
        adminPanel.button[16] = guiCreateButton(563, 220, 72, 18, "Set Armour", false, adminPanel.tab[1])
        guiSetProperty(adminPanel.button[16], "NormalTextColour", "FFAAAAAA")
        adminPanel.button[17] = guiCreateButton(488, 244, 72, 18, "Dimension", false, adminPanel.tab[1])
        guiSetProperty(adminPanel.button[17], "NormalTextColour", "FFAAAAAA")
        adminPanel.button[18] = guiCreateButton(563, 244, 72, 18, "Interior", false, adminPanel.tab[1])
        guiSetProperty(adminPanel.button[18], "NormalTextColour", "FFAAAAAA")
        adminPanel.button[19] = guiCreateButton(488, 369, 72, 18, "Fix", false, adminPanel.tab[1])
        guiSetProperty(adminPanel.button[19], "NormalTextColour", "FFAAAAAA")
        adminPanel.button[20] = guiCreateButton(563, 369, 72, 18, "Eject", false, adminPanel.tab[1])
        guiSetProperty(adminPanel.button[20], "NormalTextColour", "FFAAAAAA")
        adminPanel.button[21] = guiCreateButton(488, 392, 72, 18, "Destroy", false, adminPanel.tab[1])
        guiSetProperty(adminPanel.button[21], "NormalTextColour", "FFAAAAAA")
        adminPanel.button[22] = guiCreateButton(563, 392, 72, 18, "Disable", false, adminPanel.tab[1])
        guiSetProperty(adminPanel.button[22], "NormalTextColour", "FFAAAAAA")
        adminPanel.button[23] = guiCreateButton(563, 266, 72, 18, "Set Job", false, adminPanel.tab[1])
        guiSetProperty(adminPanel.button[23], "NormalTextColour", "FFAAAAAA")
        adminPanel.button[24] = guiCreateButton(488, 341, 72, 18, "Anticheat", false, adminPanel.tab[1])
        guiSetProperty(adminPanel.button[24], "NormalTextColour", "FFAAAAAA")
        adminPanel.button[25] = guiCreateButton(563, 341, 72, 18, "View Weps", false, adminPanel.tab[1])
        guiSetProperty(adminPanel.button[25], "NormalTextColour", "FFAAAAAA")
        adminPanel.button[26] = guiCreateButton(488, 290, 72, 18, "Weapons", false, adminPanel.tab[1])
        guiSetProperty(adminPanel.button[26], "NormalTextColour", "FFAAAAAA")
        adminPanel.button[27] = guiCreateButton(488, 266, 72, 18, "Last Logins", false, adminPanel.tab[1])
        guiSetProperty(adminPanel.button[27], "NormalTextColour", "FFAAAAAA")
        adminPanel.button[28] = guiCreateButton(488, 416, 72, 18, "Blow", false, adminPanel.tab[1])
        guiSetProperty(adminPanel.button[28], "NormalTextColour", "FFAAAAAA")
        adminPanel.button[29] = guiCreateButton(563, 416, 72, 18, "Freeze", false, adminPanel.tab[1])
        guiSetProperty(adminPanel.button[29], "NormalTextColour", "FFAAAAAA")

        adminPanel.tab[2] = guiCreateTab("Resources", adminPanel.tabpanel[1])

        adminPanel.gridlist[2] = guiCreateGridList(10, 48, 245, 349, false, adminPanel.tab[2])
        guiGridListAddColumn(adminPanel.gridlist[2], "Resource", 0.5)
        guiGridListAddColumn(adminPanel.gridlist[2], "State", 0.5)
        guiGridListAddRow(adminPanel.gridlist[2])
        guiGridListSetItemText(adminPanel.gridlist[2], 0, 1, "-", false, false)
        guiGridListSetItemText(adminPanel.gridlist[2], 0, 2, "-", false, false)
        adminPanel.edit[2] = guiCreateEdit(10, 10, 245, 28, "", false, adminPanel.tab[2])
        adminPanel.button[30] = guiCreateButton(10, 407, 245, 29, "Refresh", false, adminPanel.tab[2])
        guiSetProperty(adminPanel.button[30], "NormalTextColour", "FFAAAAAA")
        adminPanel.edit[3] = guiCreateEdit(-548, 44, 15, 15, "", false, adminPanel.tab[2])
        adminPanel.edit[4] = guiCreateEdit(265, 282, 350, 30, "", false, adminPanel.tab[2])
        adminPanel.checkbox[1] = guiCreateCheckBox(380, 317, 15, 15, "", false, false, adminPanel.tab[2])
        adminPanel.label[30] = guiCreateLabel(410, 317, 105, 20, "Silent (srun/scrun)", false, adminPanel.tab[2])
        adminPanel.button[31] = guiCreateButton(290, 342, 140, 19, "Client", false, adminPanel.tab[2])
        guiSetProperty(adminPanel.button[31], "NormalTextColour", "FFAAAAAA")
        adminPanel.button[32] = guiCreateButton(454, 342, 140, 19, "Server", false, adminPanel.tab[2])
        guiSetProperty(adminPanel.button[32], "NormalTextColour", "FFAAAAAA")
        adminPanel.label[31] = guiCreateLabel(265, 366, 302, 18, "Last runs", false, adminPanel.tab[2])
        adminPanel.label[32] = guiCreateLabel(271, 384, 374, 18, "[UCD]Noki [server]: killPed(getPlayerFromName(\"Epozide\"))", false, adminPanel.tab[2])
        adminPanel.label[33] = guiCreateLabel(271, 402, 374, 18, "[UCD]Noki [server]: killPed(getPlayerFromName(\"Epozide\"))", false, adminPanel.tab[2])
        adminPanel.label[34] = guiCreateLabel(271, 420, 374, 16, "[UCD]Noki [server]: killPed(getPlayerFromName(\"Epozide\"))", false, adminPanel.tab[2])
        adminPanel.button[33] = guiCreateButton(282, 20, 148, 38, "Start", false, adminPanel.tab[2])
        guiSetProperty(adminPanel.button[33], "NormalTextColour", "FFAAAAAA")
        adminPanel.button[34] = guiCreateButton(457, 20, 148, 38, "Stop", false, adminPanel.tab[2])
        guiSetProperty(adminPanel.button[34], "NormalTextColour", "FFAAAAAA")
        adminPanel.button[35] = guiCreateButton(282, 70, 323, 38, "Restart", false, adminPanel.tab[2])
        guiSetProperty(adminPanel.button[35], "NormalTextColour", "FFAAAAAA")
        adminPanel.button[36] = guiCreateButton(457, 118, 148, 38, "Delete", false, adminPanel.tab[2])
        guiSetProperty(adminPanel.button[36], "NormalTextColour", "FFAAAAAA")
        adminPanel.button[37] = guiCreateButton(282, 118, 148, 38, "Move", false, adminPanel.tab[2])
        guiSetProperty(adminPanel.button[37], "NormalTextColour", "FFAAAAAA")
        adminPanel.label[35] = guiCreateLabel(265, 168, 178, 21, "Resource Information", false, adminPanel.tab[2])
        guiSetFont(adminPanel.label[35], "default-bold-small")
        guiLabelSetColor(adminPanel.label[35], 255, 0, 0)
        adminPanel.label[36] = guiCreateLabel(280, 189, 345, 20, "Name:", false, adminPanel.tab[2])
        adminPanel.label[37] = guiCreateLabel(280, 209, 345, 20, "Author:", false, adminPanel.tab[2])
        adminPanel.label[38] = guiCreateLabel(280, 229, 345, 20, "Version:", false, adminPanel.tab[2])
        adminPanel.label[39] = guiCreateLabel(280, 249, 345, 23, "Description:", false, adminPanel.tab[2])

        adminPanel.tab[3] = guiCreateTab("Server Management", adminPanel.tabpanel[1])
        adminPanel.tab[4] = guiCreateTab("Utilities", adminPanel.tabpanel[1])    
    end
)

function updatePlayerInformation(plr)
	-- Fetch the rest server-side
	local name = plr.name
	local loc = plr.position
	local accountID = plr:getData("accountID") or "N/A"
	local accountName = plr:getData("accountName") or "N/A"
	local skin = plr.model
	local dim = plr.dimension
	local int = plr.interior
	local health = plr.health
	local armour = plr.armor
	local money = plr:getMoney()
	local team = plr.team.name
	local group = plr:getData("group") or "N/A"
	local class = plr:getData("class") or "N/A"
	local occupation = plr:getData("occupation") or "N/A"
	local ping = plr.ping
	
	adminPanel.label[1]:setText("Name: "..name)
	adminPanel.label[5]:setText("Account Name: "..accountName)
	adminPanel.label[8]:setText("Account ID: "..accountID)
	adminPanel.label[15]:setText("Money: $"..tostring(exports.UCDutil:tocomma(money)))
	adminPanel.label[19]:setText("Group: "..group)
	adminPanel.label[20]:setText("Team: "..team)
	adminPanel.label[23]:setText("Ping: "..ping)
	
	
end

function click()
	if (source == adminPanel.gridlist[1]) then
		local row = guiGridListGetSelectedItem(adminPanel.gridlist[1])
		if (row and row ~= nil and row ~= -1 and row ~= false) then
			local plr = guiGridListGetItemData(adminPanel.gridlist[1], row, 1)
			--outputChatBox("Viewing data for: "..tostring(plr))
			updatePlayerInformation(plr)
		end
	end
end
addEventHandler("onClientGUIClick", guiRoot, click)


function toggleGUI()
	if (guiGetVisible(adminPanel.window[1])) then
		guiSetVisible(adminPanel.window[1], false)
	else
		guiSetVisible(adminPanel.window[1], true)
	end
	showCursor(not isCursorShowing())
end
addCommandHandler("adminpanel", toggleGUI)
bindKey("p", "down", toggleGUI)