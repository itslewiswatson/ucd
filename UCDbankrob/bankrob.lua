local bank = ColShape.Cuboid(271.1458, 88.778, 928.7627, 130, 100, 60)

function updateCount(players)
	exports.UCDdx:add("bankrob.count", "#C80000"..tostring(#players.criminals).." criminals #FFFFFFvs #1E90FF"..tostring(#players.law).." law", 255, 255, 255)
end
addEvent("UCDbankrob.updateCount", true)
addEventHandler("UCDbankrob.updateCount", root, updateCount)

function removeCount()
	exports.UCDdx:del("bankrob.count")
end
addEventHandler("onClientColShapeLeave", bank, function (ele) if (ele == localPlayer) then removeCount() end end)
addEvent("UCDbankrob.removeCount", true)
addEventHandler("UCDbankrob.removeCount", root, removeCount)

function getBank()
	return bank
end

function playAlarm()
	Sound("alarm.mp3", false, false)
end
addEvent("UCDbankrob.alarm", true)
addEventHandler("UCDbankrob.alarm", root, playAlarm)

-- Timeleft
local timeLeft
local winTimer

function decrement()
	timeLeft = timeLeft - 1
	local r, g, b = localPlayer.team:getColor()
	local mins = math.floor(timeLeft / 60)
	if (mins < 1) then
		mins = math.floor(timeLeft)
		exports.UCDdx:add("bankrob.timeleft", tostring(mins).." seconds left", r, g, b)
		return
	end
	exports.UCDdx:add("bankrob.timeleft", tostring(mins).." minute"..tostring(mins == 1 and "" or "s").." left", r, g, b)
end

function onReceivedTimer(_timeLeft)
	outputDebugString("onReceivedTimer > "..tostring(_timeLeft))
	timeLeft = _timeLeft
	local r, g, b = localPlayer.team:getColor()
	local mins = math.floor(timeLeft / 60)
	if (not winTimer and not isTimer(winTimer)) then
		outputDebugString("Setting timer")
		winTimer = Timer(decrement, 1000, 0)
	end
	exports.UCDdx:add("bankrob.timeleft", tostring(mins).." minutes left", r, g, b)
end
addEvent("UCDbankrob.onReceivedTimer", true)
addEventHandler("UCDbankrob.onReceivedTimer", root, onReceivedTimer)

function removeTimer()
	if (winTimer and isTimer(winTimer)) then
		winTimer:destroy()
		winTimer = nil
	end
	exports.UCDdx:del("bankrob.timeleft")
end
addEventHandler("onClientColShapeLeave", bank, function (ele) if (ele == localPlayer) then removeTimer() end end)
addEvent("UCDbankrob.removeTimer", true)
addEventHandler("UCDbankrob.removeTimer", root, removeTimer)
