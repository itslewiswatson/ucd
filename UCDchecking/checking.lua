

local actions = {
	["Chat"] = {
		{"s", "NoMuted"},
	},
	["RobHouse"] = {
		{"a", "RobHouse", "AFK"},
		{"s", "NoVehicle", "NoArrest", "NoJailed", "NoJetpack", "NoDead"},
	},
	["EnterHouse"] = {
		{"a", "AFK"},
		{"s", "NoVehicle", "NoArrest", "NoJailed", "NoJetpack", "NoDead"},
	},
	["Jetpack"] = {
		{"a", "AFK"},
		{"s", "NoVehicle", "NoArrest", "NoJailed", "NoDead", "NoCustody"},
		{"w", 1},
	},
	["JobVehicle"] = {
		{"a", "RobHouse", "AFK"},
		{"ld", 3}, {"i", 0}, {"d", 0}, {"w", 2}, {"s", "NoVehicle", "NoArrest", "NoJailed", "NoJetpack", "NoDead"},
	},
	["Builder"] = {
		{"a", "RobHouse", "AFK"},
		{"i", 0}, {"d", 0}, {"s", "NoVehicle", "NoDead", "NoArrest", "NoJailed", "NoJetpack", "NoDead", "NoCustody"},
	},
	["BankRob"] = {
		{"a", "Builder", "AFK", "RobHouse"},
		{"s", "NoVehicle", "NoArrest", "NoCustody", "NoJailed", "NoDead"},
	},
}

function canPlayerDoAction(plr, action)
	if (not plr or not action or not actions[action] or not isElement(plr) or plr.type ~= "player" or plr.account.guest) then
		return false
	end
	local currentActivity = exports.UCDactions:getAction(plr) -- plr:getData("a")
	for _, dat in pairs(actions[action]) do
		for i, dat2 in pairs(dat) do
			if (dat[1] == "a" and dat2 == currentActivity) then
				exports.UCDdx:new(plr, "An activity you're doing blocks this action", 255, 0, 0)
				return false
			end
			if (dat[1] == "w" and i ~= 1) then
				if (plr.wantedLevel >= dat2) then
					exports.UCDdx:new(plr, "Your wanted level blocks this action", 255, 0, 0)
					return false
				end
			end
			if (dat[1] == "i" and plr.interior ~= dat2 and i ~= 1) then
				exports.UCDdx:new(plr, "Your interior blocks this action", 255, 0, 0)
				return false
			end
			if (dat[1] == "d" and plr.dimension ~= dat2 and i ~= 1) then
				exports.UCDdx:new(plr, "Your dimension blocks this action", 255, 0, 0)
				return false
			end
			if (dat[1] == "s") then
				if (dat2 == "NoVehicle" and plr.vehicle) then
					exports.UCDdx:new(plr, "Being in a vehicle blocks this action", 255, 0, 0)
					return false
				end
				if (dat2 == "NoDead" and plr.dead) then
					exports.UCDdx:new(plr, "Being dead blocks this action", 255, 0, 0)
					return false
				end
				if (dat2 == "NoJetpack" and plr:doesHaveJetpack()) then
					exports.UCDdx:new(plr, "Having a jetpack blocks this action", 255, 0, 0)
					return false
				end
				if (dat2 == "NoMuted" and plr.muted) then
					exports.UCDdx:new(plr, "Being muted blocks this action", 255, 0, 0)
					return false
				end
				if (dat2 == "NoArrest" and exports.UCDlaw:isPlayerArrested(plr)) then
					exports.UCDdx:new(plr, "Being arrested blocks this action", 255, 0, 0)
					return false
				end
				if (dat2 == "NoJailed" and exports.UCDjail:isPlayerJailed(plr)) then
					exports.UCDdx:new(plr, "Being in jail blocks this action", 255, 0, 0)
					return false
				end
				if (dat2 == "NoCustody" and #exports.UCDlaw:getPlayerArrests(plr) > 0) then
					exports.UCDdx:new(plr, "Having players in your custody blocks this action", 255, 0, 0)
					return false
				end
			end
		end
	end
	return true
end
