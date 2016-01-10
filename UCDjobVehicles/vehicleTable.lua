--[[
	x, y, z = self explanatory
	vt = job it is visible to - leave blank for all
	colour (r, g, b) = colour of the marker
	vehs = a table of all the vehicles
	res = if restricted to a group (or whatever else), a table containing the name of what it is restricted to
	rot = rotation 
--]]

jobVehicles = 
{
	-- Aviator
	-- Small planes (Beagle, Dodo, Shamal, Stuntplane)
	{x = 1364.3641, y = 1756.73, z = 10.8203, rot = 270, vt = {"Aviator"}, colour = {r = 255, g = 215, b = 0}, vehs = {511, 593, 513, 519}}, -- Las Venturas
	{x = 1364.3641, y = 1714.88, z = 10.8203, rot = 270, vt = {"Aviator"}, colour = {r = 255,  g = 215, b = 0}, vehs = {511, 593, 513, 519}}, -- Las Venturas
	{x = 1677.8402, y = 1627.1708, z = 10.8203, rot = 180, vt = {"Aviator"}, colour = {r = 255,  g = 215, b = 0}, vehs = {511, 593, 513, 519}}, -- Las Venturas
	{x = 1609.5867, y = 1627.1708, z = 10.8203, rot = 180, vt = {"Aviator"}, colour = {r = 255,  g = 215, b = 0}, vehs = {511, 593, 513, 519}}, -- Las Venturas
	{x = 414.5836, y = 2503.1677, z = 16.4844, rot = 90, vt = {"Aviator"}, colour = {r = 255,  g = 215, b = 0}, vehs = {511, 593, 513, 519}}, -- Verdant Meadows
	{x = 382.5719, y = 2539.615, z = 16.5391, rot = 180, vt = {"Aviator"}, colour = {r = 255,  g = 215, b = 0}, vehs = {511, 593, 513, 519}}, -- Verdant Meadows
	{x = -1246.6765, y = -97.359, z = 14.1484, rot = 135, vt = {"Aviator"}, colour = {r = 255,  g = 215, b = 0}, vehs = {511, 593, 513, 519}}, -- San Fierro
	{x = -1207.1486, y = -145.5417, z = 14.1484, rot = 135, vt = {"Aviator"}, colour = {r = 255,  g = 215, b = 0}, vehs = {511, 593, 513, 519}}, -- San Fierro
	{x = -1272.3878, y = -618.8027, z = 14.1484, rot = 0, vt = {"Aviator"}, colour = {r = 255,  g = 215, b = 0}, vehs = {511, 593, 513, 519}}, -- San Fierro
	{x = -1334.7905, y = -619.1797, z = 14.1484, rot = 0, vt = {"Aviator"}, colour = {r = 255,  g = 215, b = 0}, vehs = {511, 593, 513, 519}}, -- San Fierro
	{x = -1397.5046, y = -619.4011, z = 14.1484, rot = 0, vt = {"Aviator"}, colour = {r = 255,  g = 215, b = 0}, vehs = {511, 593, 513, 519}}, -- San Fierro
	{x = -1459.6853, y = -620.0172, z = 14.1484, rot = 0, vt = {"Aviator"}, colour = {r = 255,  g = 215, b = 0}, vehs = {511, 593, 513, 519}}, -- San Fierro
	{x = 1986.1161, y = -2315.9116, z = 13.5469, rot = 90, vt = {"Aviator"}, colour = {r = 255,  g = 215, b = 0}, vehs = {511, 593, 513, 519}}, -- Los Santos
	{x = 1986.1161, y = -2382.366, z = 13.5469, rot = 90, vt = {"Aviator"}, colour = {r = 255,  g = 215, b = 0}, vehs = {511, 593, 513, 519}}, -- Los Santos
	-- Heliopters (Maverick, Leviathan, Sparrow, Raindance, Cargobob)
	{x = 1378.4188, y = 1770.0908, z = 10.8203, rot = 180, vt = {"Aviator"}, colour = {r = 255, g = 215, b = 0}, vehs = {487, 417, 469, 563, 548}}, -- Las Venturas
	{x = 1399.5907, y = 1770.0908, z = 10.8203, rot = 180, vt = {"Aviator"}, colour = {r = 255, g = 215, b = 0}, vehs = {487, 417, 469, 563, 548}}, -- Las Venturas 
	{x = -1250.0161, y = -33.7229, z = 14.1484, rot = 135, vt = {"Aviator"}, colour = {r = 255, g = 215, b = 0}, vehs = {487, 417, 469, 563, 548}}, -- San Fierro
	{x = 1765.7296, y = -2286.4512, z = 26.796, rot = 180, vt = {"Aviator"}, colour = {r = 255, g = 215, b = 0}, vehs = {487, 417, 469, 563, 548}}, -- Los Santos
	{x = 2010.6317, y = -2447.6052, z = 13.5469, rot = 180, vt = {"Aviator"}, colour = {r = 255, g = 215, b = 0}, vehs = {487, 417, 469, 563, 548}}, -- Los Santos
	-- Large planes (Nevada, Andromada, AT-400, Shamal)
	{x = 1477.429, y = 1739.6221, z = 10.8125, rot = 180, vt = {"Aviator"}, colour = {r = 255, g = 215, b = 0}, vehs = {553, 577, 592, 519}}, -- Las Venturas
	{x = 1477.429, y = 1245.4187, z = 10.8125, rot = 0, vt = {"Aviator"}, colour = {r = 255, g = 215, b = 0}, vehs = {553, 577, 592, 519}}, -- Las Venturas
	{x = 1564.7855, y = 1283.6118, z = 10.8125, rot = 45, vt = {"Aviator"}, colour = {r = 255, g = 215, b = 0}, vehs = {553, 577, 592, 519}}, -- Las Venturas
	{x = -1323.0562, y = -208.1613, z = 14.1484, rot = 315, vt = {"Aviator"}, colour = {r = 255, g = 215, b = 0}, vehs = {553, 577, 592, 519}}, -- San Fierro
	{x = -1657.6765, y = -164.9684, z = 14.1484, rot = 315, vt = {"Aviator"}, colour = {r = 255, g = 215, b = 0}, vehs = {553, 577, 592, 519}}, -- San Fierro
	{x = 2113.0366, y = -2467.2312, z = 13.5469, rot = 180, vt = {"Aviator"}, colour = {r = 255, g = 215, b = 0}, vehs = {553, 577, 592, 519}}, -- Los Santos
	-- Complimentary vehicles (Tug, Baggage)
	{x = 1443.3219, y = -2290.1899, z = 13.5469, rot = 270, vt = {"Aviator"}, colour = {r = 255, g = 215, b = 0}, vehs = {485, 583}}, -- Outside LS interior entry
	{x = 1443.3219, y = -2284.1802, z = 13.5469, rot = 270, vt = {"Aviator"}, colour = {r = 255, g = 215, b = 0}, vehs = {485, 583}}, -- Outside LS interior entry
	{x = -1233.8478, y = 22.4323, z = 14.1484, rot = 135, vt = {"Aviator"}, colour = {r = 255, g = 215, b = 0}, vehs = {485, 583}}, -- Outside SF interior entry
	{x = 1311.8883, y = 1256.8636, z =  10.8203, rot = 0, vt = {"Aviator"}, colour = {r = 255, g = 215, b = 0}, vehs = {485, 583}}, -- Outside LV interior entry
	{x = 1327.4552, y = 1256.8636, z =  10.8203, rot = 0, vt = {"Aviator"}, colour = {r = 255, g = 215, b = 0}, vehs = {485, 583}}, -- Outside LV interior entry
	
	-- Trucker (Linerunner, Roadtrain)
	-- Blueberry Acres
	{x = 102.8701, y = -285.973, z = 1.5781, rot = 0, vt = {"Trucker"}, colour = {r = 255, g = 215, b = 0}, vehs = {403, 515}},
	{x = 90.4732, y = -285.973, z = 1.5781, rot = 0, vt = {"Trucker"}, colour = {r = 255, g = 215, b = 0}, vehs = {403, 515}},
	{x = 64.8113, y = -285.973, z = 1.5781, rot = 0, vt = {"Trucker"}, colour = {r = 255, g = 215, b = 0}, vehs = {403, 515}},
	{x = 51.9532, y = -285.973, z = 1.7036, rot = 0, vt = {"Trucker"}, colour = {r = 255, g = 215, b = 0}, vehs = {403, 515}},
	{x = 39.329, y = -285.973, z = 2.0362, rot = 0, vt = {"Trucker"}, colour = {r = 255, g = 215, b = 0}, vehs = {403, 515}},
	-- Easter Basin
	{x =  -1706.3956, y = 13.2921, z = 3.5547, rot = 315, vt = {"Trucker"}, colour = {r = 255, g = 215, b = 0}, vehs = {403, 515}},
	{x = -1668.9581, y = -8.8188, z = 3.5547, rot = 45, vt = {"Trucker"}, colour = {r = 255, g = 215, b = 0}, vehs = {403, 515}},
	{x = -1654.2281, y = 40.4067, z = 3.5547, rot = 135, vt = {"Trucker"}, colour = {r = 255, g = 215, b = 0}, vehs = {403, 515}},
	{x = -1698.495, y = 43.8636, z = 3.5495, rot = 225, vt = {"Trucker"}, colour = {r = 255, g = 215, b = 0}, vehs = {403, 515}},
}
