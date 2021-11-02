local settings = {
	-- ["category"] = {["settingName"] = {default = value, len = length, chars = {{from, to}, individual}}}
	-- USE STRING.BYTE(CHAR) FOR ASII NUMBERS OF CHARACTERS
	-- A-Z = 65, 90 | a-z 97, 122 | 0-9 = 48, 57 | 1-9 = 49, 57
	-- EXAMPLES:
	-- ["test1"] = {
		-- ["test11"] = {name = "Test 11", desc = "Whether you're a kid1 or not.", default = "kid", len = 12, chars = {{65, 90}, {97, 122}}},
	-- },
	-- ["test2"] = {
		-- ["test22"] = {name = "Test 22", desc = "Whether you're a kid2 or not.", default = "yea", len = 12, chars = {{65, 90}, {97, 122}, 32}},
	-- },
	-- ["test3"] = {
		-- ["test33"] = {name = "Test 33", desc = "Whether you're a kid3 or not.", default = "noe", len = 12, chars = {{65, 90}, {97, 122}, 32}},
	-- },
	-- ["test4"] = {
		-- ["test44"] = {name = "Test 44", desc = "Whether you're a kid4 or not.", default = "Yes", values = {"Yes", "No", "Maybe"}},
	-- },
	-- SETTINGS:
	["World & performance"] = {
		["farclipdist"] = {
			name = "Far Clip Distance",
			desc = "Set far clip distance(numbers only)\nLowering it results into better performance\nbut would lower the view distance.\nMin: 300 | Max: 99999 | Default: 860",
			default = 860,
			len = 5,
			chars = {{48, 57}},
			min = 300,
			max = 99999
		},
		["fpslimit"] = {
			name = "FPS Limit",
			desc = "Set FPS limit(numbers only)\nIf your PC performance is good, increase it\nup to 60.\nATTENTION: More than 60 would cause\nsync bugs that's why max is 60.\nMin: 25 | Max: 60 | Default: 60",
			default = 60,
			len = 2,
			chars = {{48, 57}},
			min = 25,
			max = 60
		},
	},
	["Miscellaneous"] = {
		["dxmsgs"] = {
			name = "Enable DX Messages",
			desc = "If you set this to 'No', DX messages will appear in chatbox instead.\nDefault: Yes",
			default = "Yes",
			values = {"Yes", "No"}
		},
		["indicatetexts"] = {
			name = "Enable Indicate Texts",
			desc = "If you set this to 'No', 3D indicate texts above markers will not appear.\nDefault: Yes",
			default = "Yes",
			values = {"Yes", "No"}
		},
		["saferadarareas"] = {
			name = "Enable Safe Radar Areas",
			desc = "If you set this to 'No', radar areas which belong to safe zones (in green color) will not appear.\nDefault: Yes",
			default = "Yes",
			values = {"Yes", "No"}
		},
		["speedunit"] = {
			name = "Set Speed Unit",
			desc = "Choose the unit that you want to appear in the vehicle HUD.\nDefault: kph",
			default = "kph",
			values = {"kph", "mph"}
		},
	},
}
local loadedSettings = {}

function loadSettings()
	local xml = XML.load("settings.xml")
	if (not xml) then
		xml = XML("settings.xml", "settings")
		xml:saveFile()
	end
	for category, settingsInCategory in pairs(settings) do
		for setting, data in pairs(settingsInCategory) do
			if (not xml:findChild(setting, 0)) then
				xml:createChild(setting).value = data.default
			end
		end
	end
	for i, child in ipairs(xml.children) do
		if (getSettingsData()[child.name]) then
			local y, n = isValueAcceptableForSetting(child.value, child.name)
			if (isValueAcceptableForSetting(child.value, child.name)) then
				loadedSettings[child.name] = child.value
			else
				loadedSettings[child.name] = getSettingData(child.name).default
			end
		end
	end
	xml:unload()
	triggerEvent("onClientLoadSettings", localPlayer)
end
Timer(loadSettings, 1000, 1)
addEvent("onClientLoadSettings", true)

function getSetting(setting)
	if (not setting or type(setting) ~= "string" or not getSettingsData()[setting]) then
		return false
	end
	return loadedSettings[setting]
end

function getSettingCategory(setting)
	if (not setting or type(setting) ~= "string" or not getSettingsData()[setting]) then
		return false
	end
	for category, settingsInCategory in pairs(settings) do
		if (settingsInCategory[setting]) then
			return category
		end
	end
end

function getSettingsCategories()
	local temp = {}
	for category in pairs(settings) do
		table.insert(temp, category)
	end
	return temp
end

function getSettingData(setting)
	if (not setting or type(setting) ~= "string" or not getSettingsData()[setting]) then
		return false
	end
	return getSettingsData()[setting]
end

function getSettingsData()
	local settingsData = {}
	for category in pairs(settings) do
		for setting, data in pairs(settings[category]) do
			settingsData[setting] = data
		end
	end
	return settingsData
end

function getAllSettings()
	local allSettings = {}
	for setting, value in pairs(loadedSettings) do
		local category = getSettingCategory(setting)
		if (not allSettings[category]) then
			allSettings[category] = {}
		end
		allSettings[category][setting] = value
	end
	return allSettings
end

function setSetting(setting, value)
	if (not setting or not value or type(setting)~= "string"or type(value) ~= "string" or not (loadedSettings[setting])) then
		return false
	end
	local acceptable, msg = isValueAcceptableForSetting(value, setting)
	if (not acceptable) then
		return acceptable, msg
	end
	triggerEvent("onClientSettingChange", localPlayer, setting, getSetting(setting), value)
	loadedSettings[setting] = value
	return true
end
addEvent("onClientSettingChange", true)

function isValueAcceptableForSetting(value, setting)
	if (not setting or not value or type(setting)~= "string" or type(value) ~= "string" or value == "" or value == " " or #value:gsub(" ", "") == 0 or not getSettingsData()[setting]) then
		return false
	end
	local data = getSettingData(setting)
	local valueCheck = value
	if (data.values) then
		for _, allowedValue in ipairs(data.values) do
			if (allowedValue == value) then
				return true
			end
		end
		return false
	elseif (data.chars) then
		local maxLen = getSettingData(setting).len
		if (#value > maxLen) then
			return false, "(Chars written)"..#value.." > "..maxLen.."(Max amount of chars)"
		end
		for _, allowed in ipairs(data.chars) do
			if (type(allowed) == "table") then
				local from, to = allowed[1], allowed[2]
				for asii = from, to do
					local char = string.char(asii)
					valueCheck = valueCheck:gsub(char, "")
				end
			else
				valueCheck = valueCheck:gsub(string.char(allowed), "")
			end
		end
	end
	if (data.min or data.max) then
		local valueNum = tonumber(value)
		if (valueNum) then
			if (data.min and valueNum < data.min) then
				return false, "(Value written)"..value.." < "..data.min.."(Minimum)"
			end
			if (data.max and valueNum > data.max) then
				return false, "(Value written)"..value.." > "..data.max.."(Maximum)"
			end
		end
	end
	if (#valueCheck ~= 0) then
		return false, "Unallowed character"..(#value > 1 and "s were" or " was").." written: "..value
	end
	return true
end

function saveSettings()
	local xml = XML("settings.xml", "settings")
	for setting, val in pairs(loadedSettings) do
		xml:createChild(setting).value = val
	end
	xml:saveFile()
	xml:unload()
end
addEventHandler("onClientResourceStop", resourceRoot, saveSettings)
