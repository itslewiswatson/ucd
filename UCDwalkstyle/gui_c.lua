wStyles = {
	{"Default", 0},
	{"Sneak", 69},
	{"Shuffle", 119},
	{"Old Man", 120},
	{"Gang 1", 121},
	{"Gang 2", 122},
	{"Old Fat Man", 123},
	{"Fat Man", 124},
	{"Male Jogger", 125},
	{"Drunk", 126},
	{"Blind", 127},
	{"SWAT", 128},
	{"Woman", 129},
	{"Shopping", 130},
	{"Busy Woman", 131},
	{"Sexy Woman", 132},
	{"Pro", 133},
	{"Old Woman", 134},
	{"Fat Woman", 135},
	{"Female Jogger", 136},
	{"Old Fat Woman", 137},
}

window = guiCreateWindow(0.37, 0.23, 0.26, 0.50, "", true)
guiWindowSetSizable(window, false)
guiSetVisible(window, false)

purchaseBtn = guiCreateButton(0.07, 0.80, 0.37, 0.14, "Purchase", true, window)
closeBtn = guiCreateButton(0.55, 0.80, 0.37, 0.14, "Exit", true, window)
gridlist = guiCreateGridList(27, 44, 301, 244, false, window)
column = guiGridListAddColumn(gridlist, "Name", 0.9)     

function openUI()
	guiSetVisible(window, true)
	showCursor(true)
	updateGridListWithStyles()
end
addCommandHandler("walk", openUI)

function updateGridListWithStyles()
	guiGridListClear(gridlist)                        
	for k, v in pairs(wStyles) do
		local row = guiGridListAddRow(gridlist)
		guiGridListSetItemText(gridlist, row, column, v[1], false, false)
		guiGridListSetItemData(gridlist, row, column, v[2])
	end
end

addEventHandler("onClientGUIClick", guiRoot,
	function ()
		if (source == purchaseBtn) then
			local row = guiGridListGetSelectedItem(gridlist)
			if row ~= nil and row ~= false and row ~= -1 then
				local id = guiGridListGetItemData(gridlist, row, column)
				local name = guiGridListGetItemText(gridlist, row, column)
				triggerServerEvent("walkStyleBuy", localPlayer, id, name) -- passes the player's walkstyle id choice to the server
     		else
				exports.dx:new("You did not select a walking style", 0, 255, 0)
			end
		elseif (source == closeBtn) then
			guiSetVisible(window, false)
			showCursor(false)
		end
	end
)
