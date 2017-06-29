local sX, sY = guiGetScreenSize()
local dxMessages = {}
local dxMessagesY = {-25, -25, -25, -25}
local dxMessagesTick = {}
local isMoving = false

function drawMessages()
	for index, messageData in pairs(dxMessages) do
		dxDrawText(messageData[1], sX / 4 + 1, (sY / 900) * (dxMessagesY[index] * 2) + 1, (sX / 4) * 3 + 1, (sY / 900) * 25 + 1, tocolor(0, 0, 0, 255), (sX / 1440) * 1.1, "default-bold", "center", "center", false, true, false)
		dxDrawText(messageData[1], sX / 4  + 1, (sY / 900) * (dxMessagesY[index] * 2) - 1, (sX / 4) * 3 + 1, (sY / 900) * 25 - 1, tocolor(0, 0, 0, 255), (sX / 1440) * 1.1, "default-bold", "center", "center", false, true, false)
		dxDrawText(messageData[1], sX / 4  - 1, (sY / 900) * (dxMessagesY[index] * 2) + 1, (sX / 4) * 3 - 1, (sY / 900) * 25 + 1, tocolor(0, 0, 0, 255), (sX / 1440) * 1.1, "default-bold", "center", "center", false, true, false)
		dxDrawText(messageData[1], sX / 4  - 1, (sY / 900) * (dxMessagesY[index] * 2) - 1, (sX / 4) * 3 - 1, (sY / 900) * 25 - 1, tocolor(0, 0, 0, 255), (sX / 1440) * 1.1, "default-bold", "center", "center", false, true, false)
		dxDrawText(messageData[1], sX / 4, (sY / 900) * (dxMessagesY[index] * 2), (sX / 4) * 3, (sY / 900) * 25, tocolor(messageData[2], messageData[3], messageData[4], 255), (sX / 1440) * 1.1, "default-bold", "center", "center", false, true, false)
	end
end
addEventHandler("onClientRender", root, drawMessages)

function new(message, r, g, b)
	message = tostring(message)
	if (dxGetTextWidth(message, (sX / 1440), "default-bold") > 750) then
		new(message:sub(1, 747).."...", 255, 0, 0)
		return
	end
	r, g, b = r or 255, g or 255, b or 255
	if (#dxMessages == 4 or isMoving) then
		Timer(new, 1000, 1, message, r, g, b)
		return
	end
	table.insert(dxMessages, {message, r, g, b})
	dxMessagesTick[#dxMessages] = getTickCount()
	addEventHandler("onClientRender", root, addMessage)
	isMoving = true
	outputConsole(message)
end
addEvent("UCDdx.new", true)
addEventHandler("UCDdx.new", root, new)

function addMessage()
	local index = #dxMessages
	local difference = (sY / 900) * 1.5
	dxMessagesY[index] = dxMessagesY[index] + difference
	if dxMessagesY[index] >= (index - 1) * 25 then
		dxMessagesY[index] = (index - 1) * 25
		if #dxMessages == 4 then
			isMoving = true
			addEventHandler("onClientRender", root, removeMessage)
			removeEventHandler("onClientRender", root, addMessage)
		else
			isMoving = false
			removeEventHandler("onClientRender", root, addMessage)
		end
	end
end

function removeMessage()
	local difference = (sY / 900) * 1.5
	for index = 1, #dxMessages do
		dxMessagesY[index] = dxMessagesY[index] - difference
	end
	if dxMessagesY[1] <= -25 then
		for index = 1, #dxMessages do
			dxMessages[index] = dxMessages[index + 1]
			dxMessagesTick[index] = dxMessagesTick[index + 1]
			dxMessagesY[index] = (index - 1) * 25
		end
		isMoving = false
		removeEventHandler("onClientRender", root, removeMessage)
		for index = 1, #dxMessagesY do
			if not dxMessages[index] then dxMessagesY[index] = -25 end
		end
	end
end

function removeReadMessages()
	for index, message in pairs(dxMessages) do
		local currentTick = getTickCount()
		if currentTick - dxMessagesTick[index] >= 7500 then
			removeMessage()
		end
	end
end
addEventHandler("onClientRender", root, removeReadMessages)

function clear()
	for i = 1, #dxMessages do
		removeMessage()
	end
	dxMessages = {}
	dxMessagesY = {-25, -25, -25, -25}
	dxMessagesTick = {}
	isMoving = false
	if (#getEventHandlers("onClientRender", root, removeMessage) > 0) then
		removeEventHandler("onClientRender", root, removeMessage)
	end
	if (#getEventHandlers("onClientRender", root, addMessage) > 0) then
		removeEventHandler("onClientRender", root, addMessage)
	end
end
addCommandHandler("cleardx", clear, false, false)