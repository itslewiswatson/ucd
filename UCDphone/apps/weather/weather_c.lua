Weather = {}
Weather.presets = {
	weather = {
		-- {"Name", ID},
		{"Reset Weather", -1},
		{"Default", 10},
		{"LA Extra Sunny", 0},
		{"LA Sunny", 1},
		{"LA Sunny Smog", 2},
		{"LA Smog", 3},
		{"LA Cloudy", 4},
		{"SF Sunny", 5},
		{"SF Extra Sunny", 6},
		{"SF Cloudy", 7},
		{"SF Rainy", 8},
		{"SF Foggy", 9},
		{"LV Sunny", 10},
		{"LV Extra Sunny", 11},
		{"LV Cloudy", 12},
		{"Country Extra Sunny", 13},
		{"Country Sunny", 14},
		{"Country Cloudy", 15},
		{"Country Rainy", 16},
		{"Desert Extra Sunny", 17},
		{"Desert Sunny", 18},
		{"Sandstorm", 19},
		{"Underwater", 20},
	},
	time = {
		-- {"Time", ID},
		{"Midnight", 0, 0},
		{"Dawn", 5, 0},
		{"Morning", 9, 0},
		{"Noon", 12, 0},
		{"Afternoon", 15, 0},
		{"Evening", 20, 0},
		{"Night", 22, 0},
	},
}
Weather.r2t = {}
Weather.r2w = {}
Weather.freezeTimer = nil
Weather.weatherID = nil -- For manusally set IDs (automatic weather system)
Weather.open = false

function Weather.create()
	phone.weather = {button = {}, gridlist = {}, label = {}, edit = {}}
	
	phone.weather.label["title.time"] = GuiLabel(24, 95, 253, 25, "Time:", false, phone.image["phone_window"])
	guiSetFont(phone.weather.label["title.time"], "clear-normal")
	guiLabelSetVerticalAlign(phone.weather.label["title.time"], "center")
	
	phone.weather.button["settime"] = GuiButton(174, 216, 105, 49, "Set Time", false, phone.image["phone_window"])
	
	--phone.weather.edit["settime.h"] = GuiEdit(174, 135, 44, 38, "", false, phone.image["phone_window"])
	--phone.weather.label["divider"] = GuiLabel(218, 135, 17, 38, ":", false, phone.image["phone_window"])
	--phone.weather.edit["settime.m"] = GuiEdit(235, 135, 44, 38, "", false, phone.image["phone_window"])
	
	phone.weather.edit["settime.h"] = GuiEdit(174, 165, 44, 38, "", false, phone.image["phone_window"])
	phone.weather.label["divider"] = GuiLabel(218, 165, 17, 38, ":", false, phone.image["phone_window"])
	phone.weather.edit["settime.m"] = GuiEdit(235, 165, 44, 38, "", false, phone.image["phone_window"])
	
	guiLabelSetHorizontalAlign(phone.weather.label["divider"], "center", false)
	guiLabelSetVerticalAlign(phone.weather.label["divider"], "center")
	
	--phone.weather.checkbox = GuiCheckBox(184, 185, 15, 15, "", false, false, phone.image["phone_window"])
	--phone.weather.label["freeze"] = GuiLabel(204, 185, 66, 15, "Freeze time", false, phone.image["phone_window"])
	
	phone.weather.checkbox = GuiCheckBox(184, 135, 15, 15, "", false, false, phone.image["phone_window"])
	phone.weather.label["freeze"] = GuiLabel(204, 135, 66, 15, "Freeze time", false, phone.image["phone_window"])
	
	phone.weather.gridlist["presettime"] = GuiGridList(34, 130, 130, 135, false, phone.image["phone_window"])
	guiGridListAddColumn(phone.weather.gridlist["presettime"], "Preset", 0.8)
	guiGridListSetSortingEnabled(phone.weather.gridlist["presettime"], false)
	
	phone.weather.label["title.weather"] = GuiLabel(26, 275, 253, 25, "Weather:", false, phone.image["phone_window"])
	guiSetFont(phone.weather.label["title.weather"], "clear-normal")
	guiLabelSetVerticalAlign(phone.weather.label["title.weather"], "center")
	
	phone.weather.gridlist["presetweather"] = GuiGridList(34, 310, 130, 207, false, phone.image["phone_window"])
	guiGridListAddColumn(phone.weather.gridlist["presetweather"], "Weather", 0.8)
	guiGridListSetSortingEnabled(phone.weather.gridlist["presetweather"], false)
	
	phone.weather.button["setweather"] = GuiButton(174, 355, 105, 162, "Set Weather", false, phone.image["phone_window"])
	phone.weather.edit["weatherid"] = GuiEdit(174, 310, 105, 35, "", false, phone.image["phone_window"])
	
	for ind, ent in pairs(Weather.presets) do
		for i, info in ipairs(ent) do
			if (ind == "time") then
				local row = guiGridListAddRow(phone.weather.gridlist["presettime"])
				guiGridListSetItemText(phone.weather.gridlist["presettime"], row, 1, tostring(info[1]), false, false)
				Weather.r2t[row] = {info[2], info[3]}
			else
				local row = guiGridListAddRow(phone.weather.gridlist["presetweather"])
				guiGridListSetItemText(phone.weather.gridlist["presetweather"], row, 1, tostring(info[1]), false, false)
				Weather.r2w[row] = {info[2]}
			end
		end
	end
	
	Weather.all = {
		phone.weather.label["title.time"], phone.weather.label["divider"], phone.weather.button["settime"], phone.weather.edit["settime.h"], phone.weather.edit["settime.m"],
		phone.weather.checkbox, phone.weather.label["freeze"], phone.weather.gridlist["presettime"], phone.weather.label["title.weather"], phone.weather.gridlist["presetweather"],
		phone.weather.button["setweather"], phone.weather.edit["weatherid"]
	}
	for _, gui in pairs(Weather.all) do
		gui.visible = false
	end
end
Weather.create()

function Weather.toggle()
	for _, gui in pairs(Weather.all) do
		gui.visible = not gui.visible
		Weather.open = gui.visible
	end
end

function Weather.onClickTime()
	local row = guiGridListGetSelectedItem(phone.weather.gridlist["presettime"])
	if (row and row ~= -1) then
		local weather = Weather.r2t[row]
		local h, m = weather[1], weather[2]
		phone.weather.edit["settime.h"].text = h
		phone.weather.edit["settime.m"].text = m
	end
end
addEventHandler("onClientGUIClick", phone.weather.gridlist["presettime"], Weather.onClickTime, false)

function Weather.setTime(h, m)
	if (not h or not m or not tonumber(h) or not tonumber(m)) then
		h, m = getTime()
	end
	return setTime(tonumber(h), tonumber(m))
end

function Weather.onClickSetTime()
	local h = phone.weather.edit["settime.h"].text
	local m = phone.weather.edit["settime.m"].text
	
	h = h:gsub("%a", ""):gsub(" ", "")
	m = m:gsub("%a", ""):gsub(" ", "")
	
	if (not m or m:len() == 0) then
		m = 0
	end
	if (not tonumber(h) or not tonumber(m)) then
		exports.CSGdx:new("Please enter numbers into both boxes", 255, 0, 0)
		return
	end
	local t = Weather.setTime(h, m)
	if (t) then
		if (Weather.freezeTimer or isTimer(Weather.freezeTimer)) then
			Weather.freezeTimer:destroy()
			Weather.freezeTimer = nil
		end
		Weather.freezeTimer = Timer(Weather.setTime, 500, 0, h, m)
	end
end
addEventHandler("onClientGUIClick", phone.weather.button["settime"], Weather.onClickSetTime, false)

function Weather.freezeTime()
	if (guiCheckBoxGetSelected(phone.weather.checkbox)) then
		if (Weather.freezeTimer or isTimer(Weather.freezeTimer)) then
			Weather.freezeTimer:destroy()
			Weather.freezeTimer = nil
		end
		local h, m = getTime()
		Weather.setTime(h, m)
		Weather.freezeTimer = Timer(Weather.setTime, 500, 0, h, m)
	else
		if (Weather.freezeTimer or isTimer(Weather.freezeTimer)) then
			Weather.freezeTimer:destroy()
			Weather.freezeTimer = nil
		end
	end
end
addEventHandler("onClientGUIClick", phone.weather.checkbox, Weather.freezeTime, false)

function Weather.onStop()
	if (Weather.freezeTimer or isTimer(Weather.freezeTimer)) then
		Weather.freezeTimer:destroy()
		Weather.freezeTimer = nil
	end
end
addEventHandler("onClientResourceStop", resourceRoot, Weather.onStop)

function Weather.setWeather(id)
	if (not id or not tonumber(id)) then
		return
	end
	return setWeather(id)
end

function Weather.onClickSetWeather()
	local id = phone.weather.edit["weatherid"].text
	id = id:gsub("%a", ""):gsub(" ", "")
	id = tonumber(id)
	if (not id or id < -1 or id > 175) then
		exports.CSGdx:new("Please enter a weather ID from 0 to 175", 255, 0, 0)
		return false
	end
	if (id == -1) then
		Weather.weatherID = nil
		triggerServerEvent("CSGphone.weather.getCurrentCycle", resourceRoot)
		return
	end
	Weather.weatherID = id
	Weather.setWeather(id)
end
addEventHandler("onClientGUIClick", phone.weather.button["setweather"], Weather.onClickSetWeather, false)

function Weather.command(_, id)
	if (not tonumber(id)) then
		exports.CSGdx:new("Syntax: /weather <id> (0 - 175)")
		return false
	end
	id = tonumber(id)
	if (id < 0 or id > 175) then
		exports.CSGdx:new("Syntax: /weather <id> (0 - 175)")
		return false
	end
	Weather.setWeather(id)
end
addCommandHandler("weather", Weather.command)

function Weather.onCycleChange(id)
	if (id) then
		if (Weather.weatherID) then
			-- Return for people who have a custom weather set
			return
		end
		setWeatherBlended(id)
	end
end
addEvent("CSGphone.weather.onCycleChange", true)
addEventHandler("CSGphone.weather.onCycleChange", root, Weather.onCycleChange)

function Weather.onClickWeather()
	local row = guiGridListGetSelectedItem(phone.weather.gridlist["presetweather"])
	if (row and row ~= -1) then
		local id = Weather.r2w[row][1]
		phone.weather.edit["weatherid"].text = id
	end
end
addEventHandler("onClientGUIClick", phone.weather.gridlist["presetweather"], Weather.onClickWeather, false)
