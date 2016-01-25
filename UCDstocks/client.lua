GUI = {
    gridlist = {},
    window = {},
    button = {},
    label = {}
}

GUI.window = GuiWindow(447, 150, 560, 511, "UCD | Stock Market", false)
GUI.window.alpha = 1
GUI.window.sizable = false

-- All stocks
GUI.gridlist["all"] = GuiGridList(10, 42, 253, 315, false, GUI.window)
guiGridListAddColumn(GUI.gridlist["all"], "Name", 0.3)
guiGridListAddColumn(GUI.gridlist["all"], "Value", 0.3)
guiGridListAddColumn(GUI.gridlist["all"], "Change", 0.3)
GUI.label["all.share_name"] = GuiLabel(10, 367, 253, 16, "Name: Zorque Industries (ZOR)", false, GUI.window)
GUI.label["all.total_worth"] = GuiLabel(10, 383, 253, 16, "Total Worth: $5,666,112", false, GUI.window)
GUI.label["all.total_shares"] = GuiLabel(10, 399, 253, 16, "Total Shares: 10,000", false, GUI.window)
GUI.label["all.available_shares"] = GuiLabel(10, 415, 253, 16, "Available Shares: 5,684", false, GUI.window)
GUI.label["all.equity_holders"] = GuiLabel(10, 431, 253, 16, "Equity Holders: 12", false, GUI.window)
GUI.label["all.minimum_investment"] = GuiLabel(10, 447, 253, 16, "Minimum Investment: 100", false, GUI.window)
GUI.button["all.buy_shares"] = GuiButton(10, 473, 123, 27, "Buy Shares", false, GUI.window)
GUI.button["all.view_history"] = GuiButton(140, 472, 123, 28, "View History", false, GUI.window)

-- Misc labels
GUI.label["all_shares"] = GuiLabel(12, 23, 251, 15, "All shares:", false, GUI.window)
guiLabelSetHorizontalAlign(GUI.label["all_shares"], "center", false)
GUI.label["divider"] = GuiLabel(263, 20, 34, 492, "|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|", false, GUI.window)
guiLabelSetHorizontalAlign(GUI.label["divider"], "center", false)
GUI.label["own_shares"] = GuiLabel(297, 23, 251, 15, "My shares:", false, GUI.window)
guiLabelSetHorizontalAlign(GUI.label["own_shares"], "center", false)

-- Own stocks
GUI.gridlist["own"] = GuiGridList(296, 43, 252, 314, false, GUI.window)
guiGridListAddColumn(GUI.gridlist["own"], "Name", 0.5)
guiGridListAddColumn(GUI.gridlist["own"], "Shares", 0.5)
GUI.label["own.share_name"] = GuiLabel(297, 367, 253, 16, "Name: Zorque Industries (ZOR)", false, GUI.window)
GUI.label["own.worth"] = GuiLabel(297, 383, 253, 16, "Worth of own shares: $2,123,000", false, GUI.window)
GUI.label["own.worth_at_pur"] = GuiLabel(297, 399, 253, 16, "Worth at purchase: $1,200,000", false, GUI.window)
GUI.label["own.my_shares"] = GuiLabel(297, 415, 253, 16, "My shares: 2,500", false, GUI.window)
GUI.label["own.percentage"] = GuiLabel(297, 431, 253, 16, "Stakeholder percentage: 25%", false, GUI.window)
GUI.label["own.min_sell"] = GuiLabel(297, 447, 253, 16, "Minimum Sellout: 100", false, GUI.window)
GUI.button["own.sell_shares"] = GuiButton(297, 474, 123, 28, "Sell Shares", false, GUI.window)

-- Close button
GUI.button["close"] = GuiButton(427, 474, 123, 28, "Close", false, GUI.window)
