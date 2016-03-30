-- People will use /sms
addCommandHandler("sms", 
	function ()
		exports.UCDdx:new("Syntax is: /im <player> <message>", 255, 174, 0)
	end
)

local antiSpam = {}
local antiSpamTimer = 1000

-- This is the function we use to send the IM
function instantMessage(_, target, ...)
	-- Actual messaging function
	if (not target) then exports.UCDdx:new("You must specify a player", 255, 0, 0) return end
    local recipient = exports.UCDutil:getPlayerFromPartialName(target)
	-- If we found a recipient
	if recipient then
		local msg = table.concat({...}, " ")
		if (msg == "" or msg == " " or msg:gsub(" ", "") == "") then return end
		if (msg:find("ucd")) then msg = msg:gsub("ucd", "UCD") end
		
		if (recipient.name == localPlayer.name) then exports.UCDdx:new("You cannot send an IM to yourself", 255, 0, 0) return end
		
        outputChatBox("[IM to "..recipient.name.."] "..msg, 255, 174, 0, true)
		
		-- source = player who got the msg, plr = player who sent it, msg = the message sent
		triggerEvent("onPlayerReceiveIM", recipient, localPlayer, msg)
		triggerEvent("UCDphone.appendMessage", localPlayer, false, recipient.name, msg)
		
		triggerServerEvent("UCDchat.instantMessage", localPlayer, recipient, msg)

		--exports.UCDlogging:new(plr, "IM", msg, )
    else
		exports.UCDdx:new(plr, "There is no player named "..target.." online", 255, 0, 0)
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

function cacheLastSender(name)
	lastMsg = name
end
addEvent("UCDchat.cacheLastSender", true)
addEventHandler("UCDchat.cacheLastSender", root, cacheLastSender)

function quickReply(_, ...)
	if (lastMsg) then
		local recipient = Player(lastMsg)
		if (not recipient) then
			exports.UCDdx:new("The last person to IM you is offline", 255, 0, 0)
			return
		end
		local msg = table.concat({...}, " ")
		if (msg == "" or msg == " " or msg:gsub(" ", "") == "") then return end
		if (msg:find("UCD")) then msg = msg:gsub("ucd", "UCD") end
		instantMessage(nil, lastMsg, msg)
	else
		exports.UCDdx:new("The last person to IM you is offline", 255, 0, 0)
	end
end
addCommandHandler("re", quickReply, false, false)
addCommandHandler("r", quickReply, false, false)

