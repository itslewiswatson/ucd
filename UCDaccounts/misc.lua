addEventHandler("onPlayerChangeNick", root,
	function (_, new)
		if (not isPlayerLoggedIn(source)) then
			cancelEvent()
			return
		end
		if (not wasEventCancelled() and new and type(new) == "string") then
			exports.UCDdx:new(source, "You have changed your nick to: "..tostring(new), 0, 255, 0)
			SAD(source.account.name, "lastUsedName", new)
		end
	end
)
