actions = {}

function getAction(plr)
	if (not plr or not isElement(plr) or plr.type ~= "player" or plr.account.guest) then
		return false
	end
	return actions[plr] or nil
end

function setAction(plr, action)
	if (not plr or not action or not isElement(plr) or plr.type ~= "player" or plr.account.guest) then
		return false
	end
	if (actions[plr]) then
		outputDebugString(plr.name.." is already performing an action... Updating...")
	end
	actions[plr] = action
	if (#getEventHandlers("onPlayerQuit", plr, onQuit) == 0) then
		addEventHandler("onPlayerQuit", plr, onQuit)
	end
	plr:setData("a", action)
	return true
end

function clearAction(plr)
	if (actions[plr]) then
		actions[plr] = nil
	end
	return true
end

function onQuit()
	clearAction(source)
end
