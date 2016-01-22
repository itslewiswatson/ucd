-- Cancel in-built MTA messaging
addEventHandler("onPlayerPrivateMessage", root,
	function ()
		exports.UCDdx:new(source, "This function is depracated. Use /im <player> <message> instead.", 255, 174, 0)
		cancelEvent()
	end
)
-- People will use /sms
addCommandHandler("sms", 
	function (plr)
		exports.UCDdx:new(plr, "This function is depracated. Use /im <player> <message> instead.", 255, 174, 0)
	end
)

local antiSpam = {}
local antiSpamTimer = 1000

-- This is the function we use to send the IM
function instantMessage(plr, _, target, ...)
	-- Actual messaging function
	if (not target) then exports.UCDdx:new(plr, "You must specify a player", 255, 0, 0) return end
    local recipient = exports.UCDutil:getPlayerFromPartialName(target)
	-- If we found a recipient
	if recipient then
		local msg = table.concat({...}, " ")
		if (msg == "" or msg == " " or msg:gsub(" ", "") == "") then return end
		if (msg:find("ucd")) then msg = msg:gsub("ucd", "UCD") end
		
		if (recipient.name == plr.name) then exports.UCDdx:new(plr, "You cannot send an IM to yourself", 255, 0, 0) return end
				
        outputChatBox("[IM to "..recipient.name.."] "..msg, plr, 255, 174, 0, true)
        outputChatBox("[IM from "..plr.name.."] "..msg, recipient, 255, 174, 0, true)
		
		-- source = player who got the msg, plr = player who sent it, msg = the message sent
		triggerEvent("onPlayerReceiveIM", recipient, plr, msg)
		triggerClientEvent(plr, "UCDphone.appendMessage", plr, false, recipient.name, msg)
		triggerClientEvent(recipient, "UCDphone.appendMessage", recipient, true, plr.name, msg)

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
		instantMessage(client, nil, plrName, message)
	end
)

local lastMsg = {}
function onReceiveIM(sender, message)
	lastMsg[source] = sender
end
addEvent("onPlayerReceiveIM")
addEventHandler("onPlayerReceiveIM", root, onReceiveIM)

function quickReply(plr, _, ...)
	if (lastMsg[plr]) then
		local recipient = lastMsg[plr]
		local msg = table.concat({...}, " ")
		if (msg == "" or msg == " " or msg:gsub(" ", "") == "") then return end
		if (msg:find("UCD")) then msg = msg:gsub("ucd", "UCD") end
		instantMessage(plr, nil, recipient.name, msg)
	else
		exports.UCDdx:new(plr, "The last person to IM you is offline", 255, 0, 0)
	end
end
addCommandHandler("re", quickReply, false, false)
addCommandHandler("r", quickReply, false, false)

function clear()
	if (lastMsg[source]) then
		lastMsg[source] = nil
	end
	for i, plr in pairs(lastMsg) do
		if (plr == source) then
			lastMsg[i] = nil
		end
	end
end
addEventHandler("onPlayerQuit", root, clear)
