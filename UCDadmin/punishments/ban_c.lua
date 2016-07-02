local _banData
local durationString = ""
local timeString = ""

function banScreen()
	if (_banData) then
		local sX, sY = guiGetScreenSize()
		local val = _banData[1]
		local reason = _banData[2]
		local banisher = _banData[3]
		local bannedOn = _banData[4]
		local duration = _banData[5]
		
		local type_
		if (val:len() ~= 32) then
			type_ = "IP"
		else
			type_ = "Serial"
		end
		
		if (duration ~= -1) then -- If it's not a permanent ban
			-- Time left
			local timeLeft = (bannedOn + duration) - getRealTime().timestamp
			if (timeLeft <= 0) then
				timeString = "Your ban has expired - please reconnect"
			else
				local days, hours, minutes, seconds
				days = math.floor(timeLeft / 86400)
				hours = math.floor((timeLeft - (days * 86400)) / 3600)
				minutes = math.floor((timeLeft - ((days * 86400) + (hours * 3600))) / 60)
				seconds = math.floor(timeLeft - ((days * 86400) + (hours * 3600) + (minutes * 60)))
				if (days < 1) then
					if (hours < 1) then
						timeString = minutes.." minutes, "..seconds.." seconds"
						if (minutes < 1) then
							timeString = seconds.." seconds"
						else
							timeString = minutes.." minutes, "..seconds.." seconds"
						end
					else
						timeString = hours.." hours, "..minutes.." minutes, "..seconds.." seconds"
					end
				else
					timeString = days.." days, "..hours.." hours, "..minutes.." minutes, "..seconds.." seconds"
				end
			end
		end
		
		dxDrawText("You have been banned from this server", 10 - 1, 0 - 1, 708 - 1, 66 - 1, tocolor(0, 0, 0, 255), 2, "default", "left", "center", false, false, false, false, false)
		dxDrawText("You have been banned from this server", 10 + 1, 0 - 1, 708 + 1, 66 - 1, tocolor(0, 0, 0, 255), 2, "default", "left", "center", false, false, false, false, false)
		dxDrawText("You have been banned from this server", 10 - 1, 0 + 1, 708 - 1, 66 + 1, tocolor(0, 0, 0, 255), 2, "default", "left", "center", false, false, false, false, false)
		dxDrawText("You have been banned from this server", 10 + 1, 0 + 1, 708 + 1, 66 + 1, tocolor(0, 0, 0, 255), 2, "default", "left", "center", false, false, false, false, false)
		dxDrawText("You have been banned from this server", 10, 0, 708, 66, tocolor(255, 255, 255, 255), 2, "default", "left", "center", false, false, false, false, false)
		dxDrawText("- Duration: "..tostring(durationString).." ("..tostring(timeString)..")", 10 - 1, 76 - 1, 708 - 1, 142 - 1, tocolor(0, 0, 0, 255), 2, "default", "left", "center", false, false, false, false, false)
		dxDrawText("- Duration: "..tostring(durationString).." ("..tostring(timeString)..")", 10 + 1, 76 - 1, 708 + 1, 142 - 1, tocolor(0, 0, 0, 255), 2, "default", "left", "center", false, false, false, false, false)
		dxDrawText("- Duration: "..tostring(durationString).." ("..tostring(timeString)..")", 10 - 1, 76 + 1, 708 - 1, 142 + 1, tocolor(0, 0, 0, 255), 2, "default", "left", "center", false, false, false, false, false)
		dxDrawText("- Duration: "..tostring(durationString).." ("..tostring(timeString)..")", 10 + 1, 76 + 1, 708 + 1, 142 + 1, tocolor(0, 0, 0, 255), 2, "default", "left", "center", false, false, false, false, false)
		dxDrawText("- Duration: "..tostring(durationString).." ("..tostring(timeString)..")", 10, 76, 708, 142, tocolor(255, 255, 255, 255), 2, "default", "left", "center", false, false, false, false, false)
		dxDrawText("- Reason: "..tostring(reason).." - "..tostring(banisher), 10 - 1, 152 - 1, 708 - 1, 218 - 1, tocolor(0, 0, 0, 255), 2, "default", "left", "center", false, false, false, false, false)
		dxDrawText("- Reason: "..tostring(reason).." - "..tostring(banisher), 10 + 1, 152 - 1, 708 + 1, 218 - 1, tocolor(0, 0, 0, 255), 2, "default", "left", "center", false, false, false, false, false)
		dxDrawText("- Reason: "..tostring(reason).." - "..tostring(banisher), 10 - 1, 152 + 1, 708 - 1, 218 + 1, tocolor(0, 0, 0, 255), 2, "default", "left", "center", false, false, false, false, false)
		dxDrawText("- Reason: "..tostring(reason).." - "..tostring(banisher), 10 + 1, 152 + 1, 708 + 1, 218 + 1, tocolor(0, 0, 0, 255), 2, "default", "left", "center", false, false, false, false, false)
		dxDrawText("- Reason: "..tostring(reason).." - "..tostring(banisher), 10, 152, 708, 218, tocolor(255, 255, 255, 255), 2, "default", "left", "center", false, false, false, false, false)
		dxDrawText("- "..type_..": "..tostring(val), 10 - 1, 228 - 1, 708 - 1, 294 - 1, tocolor(0, 0, 0, 255), 2, "default", "left", "center", false, false, false, false, false)
		dxDrawText("- "..type_..": "..tostring(val), 10 + 1, 228 - 1, 708 + 1, 294 - 1, tocolor(0, 0, 0, 255), 2, "default", "left", "center", false, false, false, false, false)
		dxDrawText("- "..type_..": "..tostring(val), 10 - 1, 228 + 1, 708 - 1, 294 + 1, tocolor(0, 0, 0, 255), 2, "default", "left", "center", false, false, false, false, false)
		dxDrawText("- "..type_..": "..tostring(val), 10 + 1, 228 + 1, 708 + 1, 294 + 1, tocolor(0, 0, 0, 255), 2, "default", "left", "center", false, false, false, false, false)
		dxDrawText("- "..type_..": "..tostring(val), 10, 228, 708, 294, tocolor(255, 255, 255, 255), 2, "default", "left", "center", false, false, false, false, false)
	end
end

function displayBanScreen(banData)
	_banData = banData
	if (banData[5] == -1) then
		-- Permanent ban
		timeString = "N/A"
		durationString = "Indefinite"
	else
		local days, hours, minutes
		days = math.floor(banData[5] / 86400)
		hours = math.floor((banData[5] - (days * 86400)) / 3600)
		minutes = math.floor((banData[5] - ((days * 86400) + (hours * 3600))) / 60)
		if (days < 1) then
			if (hours < 1) then
				durationString = minutes.." minutes"
			else
				durationString = hours.." hours, "..minutes.." minutes"
				if (minutes < 1) then
					durationString = hours.." hours"
				end
			end
		else
			durationString = days.." days, "..hours.." hours, "..minutes.." minutes"
			if (hours < 1) then
				durationString = days.." days, "..minutes.." minutes"
				if (minutes < 1) then
					durationString = days.." days"
				end
			else
				durationString = days.." days, "..hours.." hours, "..minutes.." minutes"
				if (minutes < 1) then
					durationString = days.." days, "..hours.." hours"
				end
			end
		end
	end
	
	addEventHandler("onClientRender", root, banScreen)
end
addEvent("UCDadmin.banScreen", true)
addEventHandler("UCDadmin.banScreen", root, displayBanScreen)