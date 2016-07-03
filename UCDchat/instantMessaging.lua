-- Cancel in-built MTA messaging
addEventHandler("onPlayerPrivateMessage", root,
	function ()
		exports.UCDdx:new(source, "This function is depracated. Use /im <player> <message> instead.", 255, 174, 0)
		cancelEvent()
	end
)

local antiSpam = {}
local antiSpamTimer = 1000

-- This is the function we use to send the IM
function instantMessage(recipient, msg)
	if (not exports.UCDchecking:canPlayerDoAction(plr, "Chat")) then return end
	-- If we found a recipient
	if (recipient and isElement(recipient) and recipient.type == "player") then
		
        outputChatBox("[IM from "..client.name.."] "..msg, recipient, 255, 174, 0, true)
		
		-- source = player who got the msg, plr = player who sent it, msg = the message sent
		triggerClientEvent("UCDchat.cacheLastSender", recipient, client)
		triggerClientEvent(recipient, "UCDphone.appendMessage", recipient, true, client.name, msg)

		--exports.UCDlogging:new(plr, "IM", msg, )
    else
		exports.UCDdx:new(client, "There is no player named "..target.." online", 255, 0, 0)
    end
end
addEvent("UCDchat.instantMessage", true)
addEventHandler("UCDchat.instantMessage", root, instantMessage)
--[[
addCommandHandler("im", instantMessage, false, false)
addCommandHandler("instantmessage", instantMessage, false, false)
addCommandHandler("imsg", instantMessage, false, false)
addCommandHandler("imessage", instantMessage, false, false)
addCommandHandler("instantmsg", instantMessage, false, false)
--]]
