-- Global variables
local playerTickCount = {}

-- Events
function onLogin(_, theCurrentAccount)
	if (not isGuestAccount(theCurrentAccount)) then
		source:setData("playtime", exports.UCDaccounts:GAD(source, "playtime"), true)
		playerTickCount[source] = getTickCount()
	end
end
addEventHandler("onPlayerLogin", root, onLogin)

function onQuit()
	if (not exports.UCDaccounts:isPlayerLoggedIn(source)) then
		return
	end
	
	local pAccTime  = exports.UCDaccounts:GAD(source, "playtime")
	local pPlayTime = math.floor((getTickCount() - playerTickCount[source]) / 1000)
	exports.UCDaccounts:SAD(source, "playtime", tonumber(pAccTime + pPlayTime))
	playerTickCount[source] = nil
end
addEventHandler("onPlayerQuit", root, onQuit)

function updateScoreboard()
	for _, plr in pairs(Element.getAllByType("player")) do
		if (not exports.UCDaccounts:isPlayerLoggedIn(plr)) then 
			return
		end
		if (not playerTickCount[plr]) then
			playerTickCount[plr] = getTickCount()
		end
		
		local currentTime = math.floor((getTickCount() - playerTickCount[plr]) / 1000)
		local totalTime   = plr:getData("playtime") + currentTime
		plr:setData("dxscoreboard_playtime", exports.UCDutil:secondsToHoursMinutes(totalTime))
	end
end

function onStart()
	for _, plr in pairs(Element.getAllByType("player")) do
		if (exports.UCDaccounts:isPlayerLoggedIn(plr)) then
			if (not playerTickCount[plr]) then
				playerTickCount[plr] = getTickCount()
			end
			plr:setData("playtime", exports.UCDaccounts:GAD(plr, "playtime"), true)
		end
	end
	
	updateScoreboard()
	setTimer(updateScoreboard, 900, 0) -- There is no need to define a variable for the timer but we might need this variable in the future.
end
addEventHandler("onResourceStart", resourceRoot, onStart)

function onStop()
	for _, plr in pairs(Element.getAllByType("player")) do
		if (not exports.UCDaccounts:isPlayerLoggedIn(plr)) then		
			local accPlayTime  = exports.UCDaccounts:GAD(plr, "playtime")
			local currPlayTime = math.floor((getTickCount() - playerTickCount[plr]) / 1000)
			exports.UCDaccounts:SAD(plr, "playtime", tonumber(accPlayTime + currPlayTime))
			playerTickCount[plr] = nil
		end
	end
end
addEventHandler("onResourceStop", resourceRoot, onStop)
