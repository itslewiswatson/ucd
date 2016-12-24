function toggleAreas(create)
	create = create == "Yes" and true or false
	if (create) then
		if (radarAreas) then return end
		radarAreas = {}
		for i, data in ipairs(zones) do
			radarAreas[i] = createRadarArea(data[2], data[3], data[4], data[5], 0, 200, 0, 85)
		end
	else
		if (not radarAreas) then return end
		for i, v in ipairs(radarAreas) do
			v:destroy()
		end
		radarAreas = nil
	end
end

function updateSafeAreas(setting, oldValue, newValue, retry)
	if (eventName == "onClientLoadSettings") then
		toggleAreas(exports.UCDsettings:getSetting("saferadarareas"))
	elseif (eventName == "onClientSettingChange" and setting == "saferadarareas") then
		toggleAreas(newValue)
	elseif (eventName == "onClientResourceStart" or retry) then
		if (not Resource.getFromName("UCDsettings")) then
			Timer(updateSafeAreas, 5000, 1, _, _, _, true) -- retry in 5 seconds
			return
		end
		toggleAreas(exports.UCDsettings:getSetting("saferadarareas"))
	end
end
addEventHandler("onClientResourceStart", resourceRoot, updateSafeAreas)
addEventHandler("onClientLoadSettings", localPlayer, updateSafeAreas)
addEventHandler("onClientSettingChange", localPlayer, updateSafeAreas)