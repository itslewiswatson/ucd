local stats = {
	[69] = 1000,  -- Pistol
	[70] = 1000,  -- Silenced pistol
	[71] = 1000,  -- Desert eagle
	[72] = 1000,  -- Shotgun
	[73] = 1000,  -- Sawnoff, 999 for duel wield
	[74] = 1000,  -- Spas-12
	[75] = 1000,  -- Micro-uzi & Tec-9, 999 for duel wield
	[76] = 1000,  -- MP5
	[77] = 1000,  -- AK-47
	[78] = 1000,  -- M4
	[79] = 1000,  -- Sniper rifle & country rifle
	[160] = 1000, -- Driving
	[229] = 1000, -- Biking
	[230] = 1000  -- Cycling
}

local function applyStatsForPlayer(player)
	for stat, value in pairs(stats) do
		player:setStat(stat, value)
	end
end

local function applyStatsForEveryone()
	for _, plr in ipairs(Element.getAllByType "player") do
		applyStatsForPlayer(plr)
	end
end
addEventHandler("onResourceStart", resourceRoot, applyStatsForEveryone)

local function applyStatsForSource()
	applyStatsForPlayer(source)
end
addEventHandler("onPlayerJoin", root, applyStatsForSource)
addEventHandler("onPlayerSpawn", root, applyStatsForSource)