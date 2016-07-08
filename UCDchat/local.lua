-- Local chat
local antiSpam = {}
local antiSpamTime = 1000
local range = 100

function localChat(player, _, ...)
	if (not exports.UCDaccounts:isPlayerLoggedIn(player)) then return end
	if (not exports.UCDchecking:canPlayerDoAction(player, "Chat")) then return end
	-- Check for anti spam
	if (antiSpam[player]) and (getTickCount() - antiSpam[player] < antiSpamTime) then
		exports.UCDdx:new(player, "You cannot send a message in local chat more than once a second.", 255, 0, 0)
		return false
	end
	
	local msg = table.concat({...}, " ")
	if (msg == "" or msg == " " or msg:gsub(" ", "") == "") then return end
	if (msg:find("ucd")) then msg = msg:gsub("ucd", "UCD") end
	
	local p = player.position
	local pR, pG, pB = getPlayerNametagColor(player)
	local plrTable = {}
	
	if (msg:sub(1, 1) == "/") then
		executeCommandHandler(msg:sub(2, #msg), player)
		return
	end
		
	for _, v in ipairs(Element.getAllByType("player")) do
		if (v.dimension == player.dimension and v.interior == player.interior and exports.UCDutil:isPlayerInRangeOfPoint(v, p.x, p.y, p.z, range)) then
			table.insert(plrTable, v)
		end
	end
	local playerCount = #plrTable - 1
	
	for _, v in pairs(plrTable) do
		if (getElementAlpha(v) == 0) then playerCount = playerCount - 1 end
		if (playerCount < 0) then playerCount = 0 end
		outputChatBox("(LOC) ["..playerCount.."] "..player.name.." #FFFFFF"..msg, v, pR, pG, pB, true)
	end
	
	triggerClientEvent("onMessageIncome", player, msg)
	exports.UCDlogging:new(player, "Local", msg, playerCount)
	
	-- The player has chatted, let's get the tick so we can compare it to the next time they talk
	antiSpam[player] = getTickCount()
end
addCommandHandler("local", localChat, false, false)
addCommandHandler("loc", localChat, false, false)
addCommandHandler("localchat", localChat, false, false)

function bindKey_()
	for _, v in pairs(Element.getAllByType("player")) do
		bindKey(v, "u", "down", "chatbox", "loc")
	end
end
addEventHandler("onResourceStart", resourceRoot, bindKey_)

function bindKey_2()
	bindKey(source, "u", "down", "chatbox", "loc")
end
addEventHandler("onPlayerJoin", root, bindKey_2)
