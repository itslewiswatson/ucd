-- Cancel in-built MTA messaging
addEventHandler("onPlayerPrivateMessage", root,
	function ()
		exports.UCDdx:new(source, "This function is not depracated. Use /im <message> instead.", 255, 174, 0)
		cancelEvent()
	end
)

local antiSpam = {}
local antiSpamTimer = 1000

function clearAntiSpam(plr)
	if (antiSpam[plr]) then
		antiSpam[plr] = nil
	end
end
addEventHandler("onPlayerQuit", root, clearAntiSpam)

-- This is the function we use to send the IM
function instantMessage(plr, _, target, ...)
	-- If they have already sent a message
	if (antiSpam[plr]) then
		exports.UCDdx:new(plr, "Your last IM was sent less than one second ago!", 255, 0, 0)
		return false
	end
	-- Actual messaging function
	if (not target) then exports.UCDdx:new(plr, "You must specify a player", 255, 0, 0) return end
    local recipient = exports.UCDutil:getPlayerFromPartialName(target)
	-- If we found a recipient
	if recipient then
		local msg = table.concat({...}, " ")
		if (msg == "" or msg == " " or msg:gsub(" ", "") == "") then return end
		if (msg:find("ucd")) then msg = msg:gsub("ucd", "UCD") end
		
		if (recipient.name == player.name) then exports.UCDdx:new(plr, "You cannot send an IM to yourself", 255, 0, 0) return end
        local imTo = outputChatBox("[IM to "..recipient.name.."] "..msg, plr, 200, 30, 200, true)
        local imFrom = outputChatBox("[IM from "..plr.name.."] " .. msg, recipient, 200, 30, 200, true)

		--exports.UCDlogging:new(plr, "IM", msg, )
    else
		exports.UCDdx:new(player, "There is no player named "..target.." online", 255, 0, 0)
    end
end
addCommandHandler("im", instantMessage, false, false)
addCommandHandler("instantmessage", instantMessage, false, false)

