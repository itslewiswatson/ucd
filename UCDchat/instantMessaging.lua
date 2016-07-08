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
	if (not exports.UCDchecking:canPlayerDoAction(source, "Chat")) then return end
	-- If we found a recipient
	if (recipient and isElement(recipient) and recipient.type == "player" and exports.UCDaccounts:isPlayerLoggedIn(recipient)) then
        outputChatBox("[IM from "..tostring(client.name).."]#FFFFFF "..tostring(msg), recipient, 255, 174, 0, true)
		triggerLatentClientEvent(recipient, "UCDchat.cacheLastSender", recipient, client)
		triggerLatentClientEvent(recipient, "UCDphone.appendMessage", recipient, true, client.name, msg)
		exports.UCDlogging:new(recipient, "IM", "[IM from "..tostring(client.name).."] "..tostring(msg))
		--exports.UCDlogging:new(client, "IM", "[IM to "..tostring(recipient.name).."] "..tostring(msg))
    end
end
addEvent("UCDchat.instantMessage", true)
addEventHandler("UCDchat.instantMessage", root, instantMessage)
