function isNickAllowed(plr, nick)
	if (nick:match("#%x%x%x%x%x%x")) then
		return false
	end
	if (type(nick:lower():find("[ucd]", 1, true)) == "number") then
		if (exports.UCDadmin:isPlayerAdmin(plr)) then
			return true
		end
		return false
	end
	return true
end

addEventHandler("onPlayerChangeNick", root,
	function (old, new)
		if (not isPlayerLoggedIn(source)) then
			cancelEvent()
			return
		end
		
		if (not isNickAllowed(source, new)) then
			exports.UCDdx:new(source, "You cannot use this nick as it contains forbidden characters", 255, 0, 0)
			cancelEvent()
			return
		end
		if (not wasEventCancelled() and new and type(new) == "string" and isPlayerLoggedIn(source)) then
			exports.UCDdx:new(source, "You nick has been changed to: "..tostring(new), 0, 255, 0)
			SAD(source.account.name, "lastUsedName", new)
			exports.UCDlogging:new(source, "nick", tostring(old).." > "..tostring(new))
		end
	end
)

addEventHandler("onPlayerJoin", root,
	function ()
		source.name = source.name:gsub("#%x%x%x%x%x%x", "")
	end
)

addEventHandler("onPlayerLogin", root,
	function ()
		if (not isNickAllowed(source, source.name)) then
			source.name = source.name:gsub("[ucd]", ""):gsub("[UCD]", ""):gsub("#%x%x%x%x%x%x", "")
		end
	end
)
