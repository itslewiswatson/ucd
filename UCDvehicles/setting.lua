unit = "km/h" -- DEFAULT

function updateUnit(setting, oldValue, newValue, retry)
	if (eventName == "onClientLoadSettings") then
		unit = exports.UCDsettings:getSetting("speedunit")
	elseif (eventName == "onClientSettingChange" and setting == "speedunit") then
		unit = newValue
	elseif (eventName == "onClientResourceStart" or retry) then
		if (not Resource.getFromName("UCDsettings")) then
			Timer(updateUnit, 5000, 1, _, _, _, true) -- retry in 5 seconds
			return
		end
		unit = exports.UCDsettings:getSetting("speedunit")
	end
end
addEventHandler("onClientResourceStart", resourceRoot, updateUnit)
addEventHandler("onClientLoadSettings", localPlayer, updateUnit)
addEventHandler("onClientSettingChange", localPlayer, updateUnit)