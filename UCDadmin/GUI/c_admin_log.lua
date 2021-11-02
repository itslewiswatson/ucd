-- GUI
adminPanel.gridlist["adminLog"] = GuiGridList(10, 14, 625, 422, false, adminPanel.tab["adminLog"])
adminPanel.gridlist["adminLog"]:addColumn("Date", 0.25)
adminPanel.gridlist["adminLog"]:addColumn("Account", 0.1)
adminPanel.gridlist["adminLog"]:addColumn("Serial", 0.2)
adminPanel.gridlist["adminLog"]:addColumn("Action", 0.8)
adminPanel.gridlist["adminLog"]:setSortingEnabled(false)

-- Fetch data
triggerServerEvent("UCDadmin.fetchAdminLog", localPlayer)

-- Populate gridlist
function populateAdminLog(adminLog)
    outputDebugString("Received "..#adminLog)

    adminPanel.gridlist["adminLog"]:clear()

    for i, log in ipairs(adminLog) do
        local row = adminPanel.gridlist["adminLog"]:addRow()
        adminPanel.gridlist["adminLog"]:setItemText(row, 1, tostring(log.date), false, false)
        adminPanel.gridlist["adminLog"]:setItemText(row, 2, tostring(log.account), false, false)
        adminPanel.gridlist["adminLog"]:setItemText(row, 3, tostring(log.serial or "N/A"), false, false)
        adminPanel.gridlist["adminLog"]:setItemText(row, 4, tostring(log.action), false, false)
    end
end
addEvent("UCDadmin.populateAdminLog", true)
addEventHandler("UCDadmin.populateAdminLog", root, populateAdminLog)