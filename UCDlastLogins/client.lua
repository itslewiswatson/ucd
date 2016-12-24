local gui = {}

gui.window = GuiWindow(1150, 412, 531, 319, "UCD | Last Logins", false)
gui.window.visible = false
gui.window.sizable = false
gui.window.alpha = 1
exports.UCDutil:centerWindow(gui.window)

gui.account = GuiLabel(11, 252, 511, 18, "Account:", false, gui.window)
gui.account.font = "clear-normal"

gui.serial = GuiLabel(11, 270, 511, 18, "Serial:", false, gui.window)
gui.serial.font = "clear-normal"

gui.ip = GuiLabel(11, 288, 511, 18, "IP:", false, gui.window)
gui.ip.font = "clear-normal"

gui.close = GuiButton(404, 252, 117, 36 + 18, "Close", false, gui.window)

function destroyGridList()
	if (gui.gridlist and isElement(gui.gridlist)) then
		gui.gridlist:destroy()
		gui.gridlist = nil
	end
end

function forceClose()
	gui.window.visible = false
	showCursor(false)
	destroyGridList()
end
addEventHandler("onClientGUIClick", gui.close, forceClose, false)

function onToggleGUI()
	if (gui.window.visible) then
		forceClose()
	else
		triggerServerEvent("UCDlastLogins.onRequestSelfLogins", resourceRoot)
	end
end
addCommandHandler("lastlogins", onToggleGUI, false, false)

function onPopulateClient(account, serial, ip, data)
	destroyGridList()
	if (data and type(data) == "table") then
		gui.account.text = "Account: "..tostring(account)
		gui.serial.text = "Serial: "..tostring(serial)
		gui.ip.text = "IP:"..tostring(ip)
		
		gui.gridlist = GuiGridList(11, 26, 510, 216, false, gui.window)
		gui.gridlist:addColumn("Date & Time", 0.29)
		gui.gridlist:addColumn("Name", 0.15)
		gui.gridlist:addColumn("IP Address", 0.21)
		gui.gridlist:addColumn("Serial", 0.3)
		
		for i = 1, #data do
			local row = gui.gridlist:addRow()
			gui.gridlist:setItemText(row, 1, tostring(data[i].datum), false, false)
			gui.gridlist:setItemText(row, 2, tostring(data[i].name), false, false)
			gui.gridlist:setItemText(row, 3, tostring(data[i].ip), false, false)
			gui.gridlist:setItemText(row, 4, tostring(data[i].serial), false, false)
			
			if (tostring(data[i].ip) == ip) then
				gui.gridlist:setItemColor(row, 3, 0, 255, 0)
			else
				gui.gridlist:setItemColor(row, 3, 255, 0, 0)
			end
			if (tostring(data[i].serial) == serial) then
				gui.gridlist:setItemColor(row, 4, 0, 255, 0)
			else
				gui.gridlist:setItemColor(row, 4, 255, 0, 0)
			end
		end
	end
	gui.window.visible = true
	showCursor(true)
end
addEvent("UCDlastLogins.onPopulateClient", true)
addEventHandler("UCDlastLogins.onPopulateClient", root, onPopulateClient)