Stocks = {}

function Stocks.create()
	phone.stocks = {gridlist = {}, button = {},	label = {}}
	
	phone.stocks.button["view_market"] = GuiButton(26, 480, 257, 38, "View Stock Market", false, phone.image["phone_window"])
	
	phone.stocks.gridlist["own"] = GuiGridList(26, 301, 257, 169, false, phone.image["phone_window"])
	phone.stocks.gridlist["all"]  = GuiGridList(26, 109, 257, 169, false, phone.image["phone_window"]) -- o = 113
	
	guiGridListAddColumn(phone.stocks.gridlist["all"], "Name", 0.3)
	guiGridListAddColumn(phone.stocks.gridlist["all"], "Value", 0.23)
	guiGridListAddColumn(phone.stocks.gridlist["all"], "Change", 0.37)
	
	guiGridListAddColumn(phone.stocks.gridlist["own"], "Name", 0.45)
	guiGridListAddColumn(phone.stocks.gridlist["own"], "Stocks", 0.45)
	
	phone.stocks.label["my_stocks"] = GuiLabel(26, 282, 257, 19, "My Stocks", false, phone.image["phone_window"])
	phone.stocks.label["all_stocks"] = GuiLabel(26, 90, 257, 19, "All Stocks", false, phone.image["phone_window"]) -- o = 94
	guiLabelSetHorizontalAlign(phone.stocks.label["my_stocks"], "center", false)
	guiLabelSetHorizontalAlign(phone.stocks.label["all_stocks"], "center", false)
	
	Stocks.all = {
		phone.stocks.button["view_market"], phone.stocks.gridlist["own"], phone.stocks.gridlist["all"], phone.stocks.label["my_stocks"], phone.stocks.label["all_stocks"]
	}
	
	for _, gui in pairs(Stocks.all) do
		gui.visible = false
	end
end
Stocks.create()

function Stocks.toggle()
	for _, gui in pairs(Stocks.all) do
		gui.visible = not gui.visible
	end
end

function Stocks.populate(all, own)
	phone.stocks.gridlist["own"]:clear()
	phone.stocks.gridlist["all"]:clear()
	
	for i, info in pairs(all) do		
		local curr = exports.UCDutil:mathround(info[2], 2)
		local prev = exports.UCDutil:mathround(info[3], 2)
		local diff = curr - prev
		local per = exports.UCDutil:mathround((diff / prev) * 100, 2) -- delta over original muliplied by 100%
			
		local row = guiGridListAddRow(phone.stocks.gridlist["all"])
		guiGridListSetItemText(phone.stocks.gridlist["all"], row, 1, tostring(i), false, false)
		guiGridListSetItemText(phone.stocks.gridlist["all"], row, 2, tostring(curr), false, false)
		guiGridListSetItemText(phone.stocks.gridlist["all"], row, 3, tostring(per).."% ("..tostring(diff)..")", false, false)
			
		if (per < 0) then
			guiGridListSetItemColor(phone.stocks.gridlist["all"], row, 1, 255, 0, 0)
			guiGridListSetItemColor(phone.stocks.gridlist["all"], row, 2, 255, 0, 0)
			guiGridListSetItemColor(phone.stocks.gridlist["all"], row, 3, 255, 0, 0)
		elseif (per == 0) then
			guiGridListSetItemColor(phone.stocks.gridlist["all"], row, 1, 255, 187, 0)
			guiGridListSetItemColor(phone.stocks.gridlist["all"], row, 2, 255, 187, 0)
			guiGridListSetItemColor(phone.stocks.gridlist["all"], row, 3, 255, 187, 0)
		else
			guiGridListSetItemColor(phone.stocks.gridlist["all"], row, 1, 0, 255, 0)
			guiGridListSetItemColor(phone.stocks.gridlist["all"], row, 2, 0, 255, 0)
			guiGridListSetItemColor(phone.stocks.gridlist["all"], row, 3, 0, 255, 0)
		end
	end
	
	for k, v in pairs(own) do
		local row = guiGridListAddRow(phone.stocks.gridlist["own"])
		guiGridListSetItemText(phone.stocks.gridlist["own"], row, 1, tostring(k), false, false)
		guiGridListSetItemText(phone.stocks.gridlist["own"], row, 2, tostring(exports.UCDutil:tocomma(v[1])), false, false)
			
		guiGridListSetItemColor(phone.stocks.gridlist["own"], row, 1, 0, 200, 200)
		guiGridListSetItemColor(phone.stocks.gridlist["own"], row, 2, 0, 200, 200)
	end
end
addEvent("UCDphone.populateStocks", true)
addEventHandler("UCDphone.populateStocks", root, Stocks.populate)

addEvent("onClientPlayerLogin", true)
addEventHandler("onClientPlayerLogin", localPlayer, 
	function ()
		triggerServerEvent("UCDphone.getStocks", localPlayer)
	end
)

function Stocks.onOpen(i)
	if (i == 12) then
		triggerServerEvent("UCDphone.getStocks", localPlayer)
	end
end
addEvent("UCDphone.onOpenApp")
addEventHandler("UCDphone.onOpenApp", root, Stocks.onOpen)

function Stocks.market()
	executeCommandHandler("stocks")
end
addEventHandler("onClientGUIClick", phone.stocks.button["view_market"], Stocks.market, false)
