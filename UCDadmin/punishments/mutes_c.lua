local timeLeft = nil
local muteTimer = nil

function decrementMuteTime()
	timeLeft = timeLeft - 1
	if (timeLeft <= 0) then
		triggerServerEvent("UCDadmin.onPlayerUnmuted", resourceRoot)
		return
	end
	exports.UCDdx:add("muteTimer", "Muted: "..tostring(exports.UCDutil:tocomma(timeLeft)).." Seconds Remaining", 200, 0, 0)
end

function onClientPlayerMuted(timeLeft_)
	timeLeft = timeLeft_
	muteTimer = Timer(decrementMuteTime, 1000, 0)
	exports.UCDdx:add("muteTimer", "Muted: "..tostring(exports.UCDutil:tocomma(timeLeft)).." Seconds Remaining", 200, 0, 0)
end
addEvent("onClientPlayerMuted", true)
addEventHandler("onClientPlayerMuted", root, onClientPlayerMuted)

function onClientPlayerUnmuted()
	muteTimer:destroy()
	muteTimer = nil
	timeLeft = nil
	exports.UCDdx:del("muteTimer")
end
addEvent("onClientPlayerUnmuted", true)
addEventHandler("onClientPlayerUnmuted", root, onClientPlayerUnmuted)

addEventHandler("onClientResourceStop", resourceRoot, function () exports.UCDdx:del("muteTimer") end)
