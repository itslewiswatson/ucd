function adminChat(plr, _, ...)
	if (not exports.UCDadmin:isPlayerAdmin(plr)) then return end
	local msg = string.gsub(table.concat({...}, " "), "#%x%x%x%x%x%x", "")
	if (not msg or msg:gsub(" ", "") == "") then 
		exports.UCDdx:new(plr, "Enter a message!", 255, 0, 0)
		return
	end
	for _, plr2 in ipairs(Element.getAllByType("player")) do
		if (exports.UCDadmin:isPlayerAdmin(plr2)) then
			outputChatBox("(UCD) "..tostring(plr.name).." "..tostring(msg), plr2, 255, 255, 255, true)
		end
	end
	exports.irc:ircSay(exports.irc:ircGetChannelFromName("#ucd.admin"), "14"..tostring(plr.name).." "..tostring(msg))
	exports.UCDlogging:new(plr, "ucd", tostring(msg))
end
addCommandHandler("ucd", adminChat, false, false)

addEventHandler("onIRCMessage", root,
	function(channel, msg)
		if (exports.irc:ircGetChannelName(channel) == "#ucd.admin" and exports.irc:ircGetUserNick(source) ~= "Ariana") then
			for _, plr2 in ipairs(Element.getAllByType("player")) do
				if (exports.UCDadmin:isPlayerAdmin(plr2)) then
					outputChatBox("(UCD-IRC) "..tostring(exports.irc:ircGetUserNick(source)).." "..tostring(msg), plr2, 255, 255, 255, true)
				end
			end
			-- Must add logging here, 1st argument is player and this is irc-user. Idk what to do xD
			exports.UCDlogging:new(tostring(exports.irc:ircGetUserNick(source)), "admin-irc", tostring(msg))
		end
	end
)

function adminNote(plr, _, ...)
	if (not exports.UCDadmin:isPlayerAdmin(plr)) then return end
	local msg = string.gsub(table.concat({...}, " "), "%x%x%x%x%x%x", "")
	if (not msg or msg:gsub(" ", "") == "") then
		exports.UCDdx:new(plr, "Enter a message!", 255, 0, 0)
		return
	end
	for _, plr2 in ipairs(Element.getAllByType("player")) do
		outputChatBox("(NOTE) "..plr.name.." #ffffff"..tostring(msg), plr2, 255, 0, 0, true)
	end
	exports.irc:ircSay(exports.irc:ircGetChannelFromName("#ucd.echo"), "4(NOTE) "..tostring(plr.name).." "..tostring(msg))
	exports.UCDlogging:new(plr, "adminnote", tostring(msg))
end
addCommandHandler("note", adminNote, false, false)
