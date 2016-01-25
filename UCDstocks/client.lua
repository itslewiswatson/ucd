GUI = {gridlist = {}, window = {}, button = {}, label = {}}
buyGUI = {button = {}, window = {}, label = {}, edit = {}}

addEvent("onClientStockMarketUpdate", true)
addEventHandler("onClientStockMarketUpdate", root, 
	function ()
		exports.UCDdx:new("The stock market has updated", 255, 255, 255)
		if (GUI.window.visible or buyGUI.window[1].visible) then
			buyGUI.window[1].visible = false
		end
	end
)

addEventHandler("onClientResourceStart", resourceRoot,
	function ()
		buyGUI.window[1] = GuiWindow(571, 342, 285, 143, "UCD | Stock Market - Purchase", false)
		buyGUI.window[1].sizable = false
		buyGUI.window[1].visible = false
		buyGUI.window[1].alpha = 1
		buyGUI.edit[1] = GuiEdit(9, 52, 266, 35, "", false, buyGUI.window[1])
		buyGUI.button[1] = GuiButton(9, 97, 122, 37, "Buy", false, buyGUI.window[1])
		buyGUI.button[2] = GuiButton(152, 97, 122, 37, "Close", false, buyGUI.window[1])
		buyGUI.label[1] = GuiLabel(9, 25, 265, 17, "Buying stock options of ", false, buyGUI.window[1])
		guiLabelSetHorizontalAlign(buyGUI.label[1], "center", false)

		GUI.window = GuiWindow(447, 150, 560, 511, "UCD | Stock Market", false)
		GUI.window.alpha = 1
		GUI.window.sizable = false
		GUI.window.visible = false
		exports.UCDutil:centerWindow(GUI.window)

		-- All stocks
		GUI.gridlist["all"] = GuiGridList(10, 42, 253, 315, false, GUI.window)
		guiGridListAddColumn(GUI.gridlist["all"], "Name", 0.3)
		guiGridListAddColumn(GUI.gridlist["all"], "Value", 0.2)
		guiGridListAddColumn(GUI.gridlist["all"], "Change", 0.4)
		GUI.label["all.share_name"] = GuiLabel(10, 367, 253, 16, "Name: ", false, GUI.window)
		GUI.label["all.total_worth"] = GuiLabel(10, 383, 253, 16, "Total Worth: ", false, GUI.window)
		GUI.label["all.total_shares"] = GuiLabel(10, 399, 253, 16, "Total Shares: ", false, GUI.window)
		GUI.label["all.available_shares"] = GuiLabel(10, 415, 253, 16, "Available Shares: ", false, GUI.window)
		GUI.label["all.shareholders"] = GuiLabel(10, 431, 253, 16, "Shareholders: ", false, GUI.window)
		GUI.label["all.minimum_investment"] = GuiLabel(10, 447, 253, 16, "Minimum Investment: ", false, GUI.window)
		GUI.button["all.buy_shares"] = GuiButton(10, 473, 123, 27, "Buy Shares", false, GUI.window)
		GUI.button["all.view_history"] = GuiButton(140, 472, 123, 28, "View History", false, GUI.window)
		
		GUI.button["all.buy_shares"].enabled = false
		GUI.button["all.view_history"].enabled = false
		
		-- Misc labels
		GUI.label["all_shares"] = GuiLabel(12, 23, 251, 15, "All shares:", false, GUI.window)
		guiLabelSetHorizontalAlign(GUI.label["all_shares"], "center", false)
		GUI.label["divider"] = GuiLabel(263, 20, 34, 492, "|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|", false, GUI.window)
		guiLabelSetHorizontalAlign(GUI.label["divider"], "center", false)
		GUI.label["own_shares"] = GuiLabel(297, 23, 251, 15, "My shares:", false, GUI.window)
		guiLabelSetHorizontalAlign(GUI.label["own_shares"], "center", false)

		-- Own stocks
		GUI.gridlist["own"] = GuiGridList(296, 43, 252, 314, false, GUI.window)
		guiGridListAddColumn(GUI.gridlist["own"], "Name", 0.45)
		guiGridListAddColumn(GUI.gridlist["own"], "Shares", 0.45)
		GUI.label["own.share_name"] = GuiLabel(297, 367, 253, 16, "Name: ", false, GUI.window)
		GUI.label["own.worth"] = GuiLabel(297, 383, 253, 16, "Worth of own shares: ", false, GUI.window)
		GUI.label["own.worth_at_pur"] = GuiLabel(297, 399, 253, 16, "Worth at purchase: $1,200,000", false, GUI.window)
		GUI.label["own.my_shares"] = GuiLabel(297, 415, 253, 16, "My shares: ", false, GUI.window)
		GUI.label["own.percentage"] = GuiLabel(297, 431, 253, 16, "Stakeholder percentage: ", false, GUI.window)
		GUI.label["own.min_sell"] = GuiLabel(297, 447, 253, 16, "Minimum Sellout: ", false, GUI.window)
		GUI.button["own.sell_shares"] = GuiButton(297, 474, 123, 28, "Sell Shares", false, GUI.window)
		GUI.button["own.sell_shares"].enabled = false

		-- Close button
		GUI.button["close"] = GuiButton(427, 474, 123, 28, "Close", false, GUI.window)
		
		addEventHandler("onClientGUIClick", GUI.button["close"], toggleGUI, false)
		addEventHandler("onClientGUIClick", GUI.gridlist["all"], onClickStock, false)
		addEventHandler("onClientGUIClick", GUI.gridlist["own"], onClickStock, false)
		addEventHandler("onClientGUIClick", GUI.button["all.buy_shares"], onClickBuyStock, false)
		addEventHandler("onClientGUIClick", buyGUI.button[2], onClickBuyStock, false)
	end
)

function toggleGUI(data, own)
	GUI.gridlist["all"]:clear()
	GUI.gridlist["own"]:clear()
	buyGUI.window[1].visible = false
	if (data and type(data) == "table" and own and type(own) == "table") then
		_stocks = data
		_own = own
		GUI.window.visible = true
		showCursor(true)
		for k, v in pairs(data) do
			local curr = exports.UCDutil:mathround(v[2], 2)
			local prev = exports.UCDutil:mathround(v[3], 2)
			local diff = curr - prev
			local per = exports.UCDutil:mathround((diff / prev) * 100, 2) -- delta over original muliplied by 100%
			
			local row = guiGridListAddRow(GUI.gridlist["all"])
			guiGridListSetItemText(GUI.gridlist["all"], row, 1, tostring(k), false, false)
			guiGridListSetItemText(GUI.gridlist["all"], row, 2, tostring(curr), false, false)
			guiGridListSetItemText(GUI.gridlist["all"], row, 3, tostring(per).."% ("..tostring(diff)..")", false, false)
			
			if (per < 0) then
				guiGridListSetItemColor(GUI.gridlist["all"], row, 1, 255, 0, 0)
				guiGridListSetItemColor(GUI.gridlist["all"], row, 2, 255, 0, 0)
				guiGridListSetItemColor(GUI.gridlist["all"], row, 3, 255, 0, 0)
			elseif (per == 0) then
				guiGridListSetItemColor(GUI.gridlist["all"], row, 1, 255, 187, 0)
				guiGridListSetItemColor(GUI.gridlist["all"], row, 2, 255, 187, 0)
				guiGridListSetItemColor(GUI.gridlist["all"], row, 3, 255, 187, 0)
			else
				guiGridListSetItemColor(GUI.gridlist["all"], row, 1, 0, 255, 0)
				guiGridListSetItemColor(GUI.gridlist["all"], row, 2, 0, 255, 0)
				guiGridListSetItemColor(GUI.gridlist["all"], row, 3, 0, 255, 0)
			end
		end
		for k, v in pairs(own) do
			local row = guiGridListAddRow(GUI.gridlist["own"])
			guiGridListSetItemText(GUI.gridlist["own"], row, 1, tostring(k), false, false)
			guiGridListSetItemText(GUI.gridlist["own"], row, 2, tostring(v[1]), false, false)
			
			guiGridListSetItemColor(GUI.gridlist["own"], row, 1, 0, 200, 200)
			guiGridListSetItemColor(GUI.gridlist["own"], row, 2, 0, 200, 200)
		end
	else
		if (GUI.window.visible) then
			GUI.window.visible = false
			showCursor(false)
		else
			triggerServerEvent("UCDstocks.getStocks", localPlayer)
		end
	end
end
addEvent("UCDstocks.toggleGUI", true)
addEventHandler("UCDstocks.toggleGUI", root, toggleGUI)
addCommandHandler("stocks", toggleGUI)

function onClickStock()
	local row = guiGridListGetSelectedItem(GUI.gridlist["all"])
	if (row and row ~= -1) then
		local acronym = guiGridListGetItemText(GUI.gridlist["all"], row, 1)
		local data = _stocks[acronym]
		
		--local totalworth = math.floor(data[5] * data[4])
		local totalworth = exports.UCDutil:mathround(data[2] * data[6], 2)
		local available = data[5] - data[6]
		local sg
		if (data[7] == 1) then
			sg = "option"
		else
			sg = "options"
		end
		
		GUI.label["all.share_name"].text = "Name: "..data[1].." ("..acronym..")"
		GUI.label["all.total_worth"].text = "Total Worth: $"..exports.UCDutil:tocomma(totalworth)
		GUI.label["all.total_shares"].text = "Total Shares: "..exports.UCDutil:tocomma(data[5])
		GUI.label["all.available_shares"].text = "Available Shares: "..exports.UCDutil:tocomma(available)
		GUI.label["all.shareholders"].text = "Shareholders: "..data[4]
		GUI.label["all.minimum_investment"].text = "Minimum Investment: "..data[7].." "..sg
		
		if (available <= data[5]) then
			GUI.button["all.buy_shares"].enabled = true
		else
			GUI.button["all.buy_shares"].enabled = false
		end
		GUI.button["all.view_history"].enabled = true
	else
		GUI.label["all.share_name"].text = "Name: "
		GUI.label["all.total_worth"].text = "Total Worth: "
		GUI.label["all.total_shares"].text = "Total Shares: "
		GUI.label["all.available_shares"].text = "Available Shares: "
		GUI.label["all.shareholders"].text = "Shareholders: "
		GUI.label["all.minimum_investment"].text = "Minimum Investment: "
		
		GUI.button["all.buy_shares"].enabled = false
		GUI.button["all.view_history"].enabled = false
	end
	local row = guiGridListGetSelectedItem(GUI.gridlist["own"])
	if (row and row ~= -1) then
		local acronym = guiGridListGetItemText(GUI.gridlist["own"], row, 1)
		local data = _own[acronym]
		
		local stake = 100 / (_stocks[acronym][5] / data[1])
		local worth = exports.UCDutil:mathround(data[1] * _stocks[acronym][2], 2)
		
		GUI.label["own.share_name"].text = "Name: ".._stocks[acronym][1].." ("..acronym..")"
		GUI.label["own.worth"].text = "Worth of own shares: $"..exports.UCDutil:tocomma(worth)
		GUI.label["own.worth_at_pur"].text = "Worth at purchase: $"..exports.UCDutil:tocomma(data[2])
		GUI.label["own.my_shares"].text = "My shares: "..data[1]
		GUI.label["own.percentage"].text = "Stakeholder percentage: "..stake.."%"
		GUI.label["own.min_sell"].text = "Minimum Sellout: ".._stocks[acronym][8]
		
		GUI.button["own.sell_shares"].enabled = true
	else
		GUI.label["own.share_name"].text = "Name:"
		GUI.label["own.worth"].text = "Worth of own shares: "
		GUI.label["own.worth_at_pur"].text = "Worth at purchase:"
		GUI.label["own.my_shares"].text = "My shares: "
		GUI.label["own.percentage"].text = "Stakeholder percentage: "
		GUI.label["own.min_sell"].text = "Minimum Sellout: "
		
		GUI.button["own.sell_shares"].enabled = false
	end
end

function onClickBuyStock()
	buyGUI.window[1].visible = not buyGUI.window[1].visible
	buyGUI.edit[1].text = "1"
	guiBringToFront(buyGUI.window[1])
	if (buyGUI.window[1].visible) then
		local row = guiGridListGetSelectedItem(GUI.gridlist["all"])
		if (row and row ~= -1) then
			local acronym = guiGridListGetItemText(GUI.gridlist["all"], row, 1)
			buyGUI.label[1].text = "Buying stock options of "..acronym
		end
	end
end