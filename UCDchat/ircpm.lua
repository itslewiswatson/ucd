function ircc(plr, cmd, user, ...)
    local msg = table.concat({...}, " ")
	local ircUsr = exports.irc:ircGetUserFromNick(user)
	local server = exports.irc:ircGetUserServer(exports.irc:ircGetUserFromNick("Ariana"))
	if (ircUsr and #msg > 0) then
		exports.irc:ircSay(ircUsr, "(In-game message) "..tostring(plr.name)..": "..tostring(msg))
		exports.UCDdx:new(plr, "Your message was sent to "..tostring(exports.irc:ircGetUserNick(ircUsr)).." on IRC", 0, 255, 0)
		--exports.CSGlogging:createLogRow( plr, "IRCPM", "-> "..user..": "..msg )
		exports.UCDlogging:new(plr, "ircpm", tostring(msg))
	else
		exports.UCDdx:new(plr, "Could not find an IRC user with that name", 255, 0, 0)
	end
end
addCommandHandler("ircpm", ircc)
