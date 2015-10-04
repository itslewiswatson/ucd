admin = {
    tab = {},
    window = {},
    tabpanel = {},
    gridlist = {}
}

admin.window[1] = guiCreateWindow(381, 202, 1135, 569, "UCD | Administrative & Management Panel", false)
guiWindowSetSizable(admin.window[1], false)
guiSetVisible(admin.window[1], false)
admin.tabpanel[1] = guiCreateTabPanel(13, 26, 1112, 533, false, admin.window[1])

admin.tab[1] = guiCreateTab("Players", admin.tabpanel[1])
admin.gridlist[1] = guiCreateGridList(11, 10, 231, 488, false, admin.tab[1])
guiGridListAddColumn(admin.gridlist[1], "Name", 0.9)
for _, v in pairs(getElementsByType("player")) do
	local row = guiGridListAddRow(admin.gridlist[1])
	local r, g, b = getPlayerNametagColor(v)
	guiGridListSetItemText(admin.gridlist[1], row, 1, getPlayerName(v), false, false)
	guiGridListSetItemColor(admin.gridlist[1], row, 1, r, g, b)
end

admin.tab[2] = guiCreateTab("Resources", admin.tabpanel[1])
admin.tab[3] = guiCreateTab("Server Management", admin.tabpanel[1])

function toggleGUI()
	if (guiGetVisible(admin.window[1])) then
		guiSetVisible(admin.window[1], false)
	else
		guiSetVisible(admin.window[1], true)
	end
	showCursor(not isCursorShowing())
end
addCommandHandler("adminpanel", toggleGUI)
bindKey("p", "down", toggleGUI)