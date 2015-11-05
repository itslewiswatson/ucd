local playerStyles = {}

-- Add to the table on resource start
for _, plr in pairs(Element.getAllByType("player")) do
	if (exports.UCDaccounts:isPlayerLoggedIn(plr)) then
		local id = exports.UCDaccounts:GAD(plr, "walkstyle")
		if (id and id ~= nil) then
			setPlayerWalkingStyle(plr, id)
		end
	end
end

function getPlayerWalkingStyle(plr)
	if (not plr) then return nil end
	if (plr:getType() ~= "player") then return false end
	if (not playerStyles[plr] or playerStyles[plr] == nil) then return nil end
	if playerStyles[plr] ~= nil and playerStyles[plr] ~= false then
		return playerStyles[plr]
	else
		return exports.UCDaccounts:GAD(plr, "walkstyle")
	end
end

function setPlayerWalkingStyle(plr, id, tosync)
	if (not plr) then return nil end
	if (plr:getType() ~= "player" or tonumber(id) == nil) then return false end
	playerStyles[plr] = id
	plr:setWalkingStyle(id)
	
	-- An option for whether we sync this to the database [usually just used for logins]
	if (tosync == true) then
		exports.UCDaccounts:SAD(plr, "walkstyle", id)
	end
	
	return true
end
