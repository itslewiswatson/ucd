-- People will use /sms
addCommandHandler("sms", 
	function ()
		exports.UCDdx:new("Syntax is: /im <player> <message>", 255, 174, 0)
	end
)

function _getPlayerFromName(name)
	local players = {}
	local name = name and name:gsub("#%x%x%x%x%x%x", ""):lower() or nil
	if name then
		for _, player in ipairs(Element.getAllByType("player")) do
			if (player ~= localPlayer) then
				local name_ = player.name:gsub("#%x%x%x%x%x%x", ""):lower()
				if name_:find(name, 1, true) then
					table.insert(players, player)
				end
			end
		end
		if (#players == 0) then
			return false
		end
		if (#players > 1) then
			return "There is more than one player matching this name"
		end
		return players[1]
	end
end

local antiSpam = {}
local antiSpamTimer = 1000

-- This is the function we use to send the IM
function instantMessage(_, target, ...)
	-- Actual messaging function
	if (not target) then exports.UCDdx:new("You must specify a player", 255, 0, 0) return end
	
    local recipient
	if (type(target) == "string") then
		recipient = _getPlayerFromName(target)
		if (type(recipient) == "string") then
			exports.UCDdx:new(tostring(recipient), 255, 0, 0)
			return
		elseif (not recipient) then
			exports.UCDdx:new("We could not find a player with this name", 255, 0, 0)
			return
		end
	else
		recipient = target
	end
	
	-- If we found a recipient
	if recipient then
		local msg = table.concat({...}, " ")
		if (msg == "" or msg == " " or msg:gsub(" ", "") == "") then return end
		if (msg:find("ucd")) then msg = msg:gsub("ucd", "UCD") end
		
		if (recipient.name == localPlayer.name) then exports.UCDdx:new("You cannot send an IM to yourself", 255, 0, 0) return end
		
        outputChatBox("[IM to "..recipient.name.."] "..msg, 250, 60, 60, true)
		
		-- source = player who got the msg, plr = player who sent it, msg = the message sent
		triggerEvent("onPlayerReceiveIM", recipient, localPlayer, msg)
		triggerEvent("UCDphone.appendMessage", localPlayer, false, recipient.name, msg)
		
		triggerServerEvent("UCDchat.instantMessage", localPlayer, recipient, msg)
    else
		exports.UCDdx:new("There is no player with that name online", 255, 0, 0)	
    end
end
addCommandHandler("im", instantMessage, false, false)
addCommandHandler("instantmessage", instantMessage, false, false)
addCommandHandler("imsg", instantMessage, false, false)
addCommandHandler("imessage", instantMessage, false, false)
addCommandHandler("instantmsg", instantMessage, false, false)

addEvent("UCDchat.onSendIMFromPhone", true)
addEventHandler("UCDchat.onSendIMFromPhone", root, 
	function (plrName, message)
		instantMessage(nil, plrName, message)
	end
)

function cacheLastSender(plr)
	Sound.playFrontEnd(1)
	lastMsg = plr
end
addEvent("UCDchat.cacheLastSender", true)
addEventHandler("UCDchat.cacheLastSender", root, cacheLastSender)

function quickReply(_, ...)
	if (lastMsg) then
		if (type(lastMsg) == "userdata" and not lastMsg.name) then
			exports.UCDdx:new("The last person to IM you is offline", 255, 0, 0)
			return
		end
		local msg = table.concat({...}, " ")
		if (msg == "" or msg == " " or msg:gsub(" ", "") == "") then return end
		if (msg:find("UCD")) then msg = msg:gsub("ucd", "UCD") end
		instantMessage(nil, lastMsg, msg)
	else
		exports.UCDdx:new("You have not been messaged by anyone", 255, 0, 0)
	end
end
addCommandHandler("re", quickReply, false, false)
addCommandHandler("r", quickReply, false, false)
