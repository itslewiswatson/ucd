Settings = {}
Settings.open = false

function Settings.create()
	phone.settings = {}
	
	phone.settings.gridlist = GuiGridList(19, 90, 272, 275, false, phone.image["phone_window"])
	phone.settings.gridlist.sortingEnabled = false
	phone.settings.gridlist:addColumn("Setting/category name", 0.55)
	phone.settings.gridlist:addColumn("Setting value", 0.35)
	
	phone.settings.memo = GuiMemo(19, 370, 272, 60, "Select a setting to view its description here", false, phone.image["phone_window"])
	phone.settings.memo.readOnly = true
	
	phone.settings.combobox = GuiComboBox(19, 432.5, 272, 35, "Select a setting first", false, phone.image["phone_window"])
	phone.settings.combobox.enabled = false
	
	phone.settings.editbox = GuiEdit(19, 457.5, 272, 25, "Select a setting first", false, phone.image["phone_window"])
	phone.settings.editbox.enabled = false
	
	phone.settings.button = GuiButton(19, 485, 272, 25, "Set setting value(right click = default)", false, phone.image["phone_window"])
	phone.settings.button.enabled = false
	
	phone.settings.label = GuiLabel(19, 510, 272, 25, "Info goes here", false, phone.image["phone_window"])
	phone.settings.label:setHorizontalAlign("center")
	phone.settings.label:setColor(255, 140, 0)
	
	Settings.all = {
		phone.settings.gridlist, phone.settings.memo, phone.settings.combobox, phone.settings.editbox, phone.settings.button, phone.settings.label
	}
	for _, gui in ipairs(Settings.all) do
		gui.visible = false
	end
end
Settings.create()

function Settings.toggle()
	for _, gui in pairs(Settings.all) do
		gui.visible = not gui.visible
		Settings.open = gui.visible
	end
	if (Settings.open) then
		Settings.load()
	end
end

function Settings.load(button)
	phone.settings.gridlist:clear()
	-- It gets cleared, we go default
	phone.settings.memo.text = "Select a setting to view its description here"
	phone.settings.combobox.enabled = false
	phone.settings.combobox:clear()
	phone.settings.combobox.text = "Select a setting first"
	phone.settings.editbox.enabled = false
	phone.settings.editbox.text = "Select a setting first"
	phone.settings.button.enabled = false
	if (button) then
		local x, y = guiGetPosition(phone.image["phone_window"], false)
		x, y = x + 19 + (272 / 2), y + 510
		setCursorPosition(x, y) -- So it gets disabled fully
	else
		phone.settings.label.text = "Info goes here"
		phone.settings.label:setColor(255, 140, 0)
	end
	local settings = exports.UCDsettings:getAllSettings()
	for category, settingsInCategory in pairs(settings) do
		local row = phone.settings.gridlist:addRow()
		phone.settings.gridlist:setItemText(row, 1, category, true, false)
		for setting, value in pairs(settingsInCategory) do
			local row = phone.settings.gridlist:addRow()
			local data = exports.UCDsettings:getSettingData(setting)
			if (data) then
				phone.settings.gridlist:setItemText(row, 1, data.name, false, false)
				phone.settings.gridlist:setItemData(row, 1, setting)
				phone.settings.gridlist:setItemText(row, 2, value, false, false)
			end
		end
	end
end

function Settings.select(button)
	if (source ~= phone.settings.gridlist or button ~= "left") then
		return false
	end
	local row = phone.settings.gridlist:getSelectedItem()
	if (not row or row == -1) then
		-- No row selected, all goes default
		phone.settings.memo.text = "Select a setting to view its description here"
		phone.settings.combobox.enabled = false
		phone.settings.combobox:clear()
		phone.settings.combobox.text = "Select a setting first"
		phone.settings.editbox.enabled = false
		phone.settings.editbox.text = "Select a setting first"
		phone.settings.button.enabled = false
		return false
	end
	local setting = phone.settings.gridlist:getItemData(row, 1)
	local data = exports.UCDsettings:getSettingData(setting)
	phone.settings.memo.text = data.desc
	-- Reset all things before enabling
	phone.settings.combobox.enabled = false
	phone.settings.combobox:clear()
	phone.settings.editbox.enabled = false
	phone.settings.editbox.text = ""
	phone.settings.button.enabled = true
	if (data.values) then
		-- If it has specific values
		phone.settings.editbox.text = "Can't be used with this setting"
		phone.settings.combobox.enabled = true
		phone.settings.combobox.text = "Select a value"
		phone.settings.combobox:setSize(272, #data.values * 15 + 30, false)
		for _, value in ipairs(data.values) do
			phone.settings.combobox:addItem(value)
		end
	elseif (data.chars) then
		-- Custom values by client
		phone.settings.combobox.text = "Can't be used with this setting"
		phone.settings.editbox.enabled = true
	end
end
addEventHandler("onClientGUIClick", phone.settings.gridlist, Settings.select)

function Settings.setValue(button)
	if (source ~= phone.settings.button) then
		return false
	end
	
	local row = phone.settings.gridlist:getSelectedItem()
	if (not row or row == -1) then
		return false
	end
	local settingName = phone.settings.gridlist:getItemText(row, 1)
	local setting = phone.settings.gridlist:getItemData(row, 1)
	local value
	if (button == "left") then
		if (phone.settings.combobox.enabled) then
			value = phone.settings.combobox:getItemText(phone.settings.combobox.selected)
		elseif (phone.settings.editbox.enabled) then
			value = phone.settings.editbox.text
		end
	elseif (button == "right") then
		value = exports.UCDsettings:getSettingData(setting).default
	end
	local acceptable, msg = exports.UCDsettings:isValueAcceptableForSetting(value, setting)
	if (acceptable) then
		phone.settings.label.text = "Set '"..settingName.."' to '"..value.."'"
		phone.settings.label:setColor(0, 255, 0)
		exports.UCDsettings:setSetting(setting, value)
		Settings.load(true)
	else
		phone.settings.label.text = msg or "ERROR 404"
		phone.settings.label:setColor(255, 0, 0)
	end
end
addEventHandler("onClientGUIClick", phone.settings.button, Settings.setValue)