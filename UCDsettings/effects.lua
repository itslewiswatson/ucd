function effects(setting, old, new)
	if (eventName == "onClientSettingChange") then
		if (setting == "farclipdist") then
			setFarClipDistance(new)
		elseif (setting == "fpslimit") then
			setFPSLimit(new)
		-- elseif (setting == "dxmsgs") then
			-- exports.UCDdx:enable(new)
		elseif (setting == "indicatetexts") then
			exports.UCDworld:enable(new)
		-- elseif (setting == "saferadarareas") then
			-- exports.UCDsafeZones:enable(new)
		elseif (setting == "vehicleownerdx") then
			exports.UCDvehicles:toggleVehicleOwnerDX(new)
		end
		return
	end
	setFarClipDistance(getSetting("farclipdist"))
	setFPSLimit(getSetting("fpslimit"))
	-- exports.UCDdx:enable(getSetting("dxmsgs"))
	-- exports.UCDworld:enable(getSetting("indicatetexts"))
	-- exports.UCDsafeZones:enable(getSetting("saferadarareas"))
end
addEventHandler("onClientSettingChange", localPlayer, effects)
addEventHandler("onClientLoadSettings", localPlayer, effects)