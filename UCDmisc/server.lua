function getPlayerFromPartialName(name)
    local name = name and name:gsub("#%x%x%x%x%x%x", ""):lower() or nil
    if name then
        for _, player in ipairs(getElementsByType("player")) do
            local name_ = getPlayerName(player):gsub("#%x%x%x%x%x%x", ""):lower()
            if name_:find(name, 1, true) then
                return player
            end
        end
    end
end

function eject(plr, _, plr2)
	if (plr.vehicle and plr.vehicle.controller == plr) then
		if (plr2 == "*") then
			local occupants = plr.vehicle.occupants
			if (occupants) then
				for _, plr2 in ipairs(plr.vehicle.occupants) do
					plr2:removeFromVehicle(plr.vehicle)
					exports.UCDdx:new(plr2, "You got ejected from the vehicle by "..tostring(plr.name), 255, 0, 0)
				end
				exports.UCDdx:new(plr, "You have ejected all players inside your vehicle", 0, 255, 0)
			end
		elseif (tostring(plr2)) then
			local plr2 = getPlayerFromPartialName(plr2)
			if (isElement(plr2)) then
				if (plr2.vehicle == plr.vehicle) then
					plr2:removeFromVehicle(plr.vehicle)
					exports.UCDdx:new(plr2, "You got ejected from the vehicle by "..tostring(plr.name), 255, 0, 0)
					exports.UCDdx:new(plr, "You have ejected "..tostring(plr2.name).." from the vehicle", 0, 255, 0)
				end
			end
		end
	end
end
addCommandHandler("eject", eject)