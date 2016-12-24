enabled = true -- DEFAULT

function updateEnabled(setting, oldValue, newValue, retry)
	if (eventName == "onClientLoadSettings") then
		enabled = exports.UCDsettings:getSetting("dxmsgs") == "Yes" and true or false
	elseif (eventName == "onClientSettingChange" and setting == "dxmsgs") then
		enabled = newValue == "Yes" and true or false
	elseif (eventName == "onClientResourceStart" or retry) then
		if (not Resource.getFromName("UCDsettings")) then
			Timer(updateEnabled, 5000, 1, _, _, _, true) -- retry in 5 seconds
			return
		end
		enabled = exports.UCDsettings:getSetting("dxmsgs") == "Yes" and true or false
	end
end
addEventHandler("onClientResourceStart", resourceRoot, updateEnabled)
addEventHandler("onClientLoadSettings", localPlayer, updateEnabled)
addEventHandler("onClientSettingChange", localPlayer, updateEnabled)