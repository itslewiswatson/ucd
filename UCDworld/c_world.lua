setBlurLevel(0)
setBirdsEnabled(false)

--[[function setWaterColour(cmd, r, g, b)
	if not (r) then outputChatBox("You must enter 3 numbers between 0 and 255") return end
	setWaterColor(tonumber(r), tonumber(g), tonumber(b))
	outputChatBox("You changed the water colour to: "..r..", "..g..", "..b.."")
end
addCommandHandler("water", setWaterColour)

function setWeatherToNumber(cmd, id)
	if not id then outputChatBox("You must enter a number") return end
	setWeather(tonumber(id))
	outputChatBox("Weather changed to: "..id.."")
end
addCommandHandler("weather", setWeatherToNumber)]]--

-- Backup
--[[
function setClientTime(cmd, newTime)
    newTime = tonumber(newTime)
    if not newTime then outputChatBox("Enter a number between 0 and 23") return end
    if (newTime > 23) or (newTime < 0) then
        outputChatBox("You must enter a number between 0 and 23.")
        return
    end
    setTime(tonumber(newTime), 0)
end
addCommandHandler("settime", setClientTime)
--]]

function setClientTime(cmd, newHr, newMin)
	newHr, newMin = tonumber(newHr), tonumber(newMin)
	if (not newHr) then
		exports.UCDdx:new("You must enter a new time", 255, 0, 0)
		return false
	end
	if (newHr > 24) or (newHr < 0) then
		exports.UCDdx:new("There's 24 hours in a day...", 255, 0, 0)
		return false
	end
	if (newMin) and (not newHr) then
		-- This is probably really fucking stupid so idk why it's in here
		return false
	end
    setTime(newHr, newMin)
end
addCommandHandler("settime", setClientTime)

function movePlayerHead()
	for k, players in ipairs (getElementsByType("player")) do
		local w, h = guiGetScreenSize()
		local lookatX, lookatY, lookatZ = getWorldFromScreenPosition(w/2, h/2, 10)
		setPedLookAt(players, lookatX, lookatY, lookatZ)
	end
end
addEventHandler("onClientRender", root, movePlayerHead)

-----------------------------------------