local jailTimer = nil
local timeLeft = nil

function decrementJailTime()
	timeLeft = timeLeft - 1
	if (timeLeft <= 0) then
		triggerServerEvent("UCDjail.releasePlayer", resourceRoot)
		return
	end
	exports.UCDdx:add("jailTimer", "Jailed: "..tostring(exports.UCDutil:tocomma(timeLeft)).. " Seconds Remaining", 200, 0, 0)
end

function onClientPlayerJailed(timeLeft_)
	clear()
	timeLeft = timeLeft_
	jailTimer = Timer(decrementJailTime, 1000, 0)
	exports.UCDdx:add("jailTimer", "Jailed: "..tostring(exports.UCDutil:tocomma(timeLeft)).. " Seconds Remaining", 200, 0, 0)
end
addEvent("onClientPlayerJailed", true)
addEventHandler("onClientPlayerJailed", root, onClientPlayerJailed)

addEventHandler("onClientResourceStop", resourceRoot, function () exports.UCDdx:del("jailTimer") end)

function clear()
	if (type(jailTimer) == "userdata") then
		jailTimer:destroy()
	end
	jailTimer = nil
	timeLeft = nil
	exports.UCDdx:del("jailTimer")
end
addEvent("onClientPlayerReleased", true)
addEventHandler("onClientPlayerReleased", root, clear)
	

function isPlayerJailed(plr)
	if (not plr) then plr = localPlayer end
	if (plr:getData("jailed") == true) then
		return true
	end
	return false
end

