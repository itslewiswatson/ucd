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
	-- Free vehicles [Caddy, BMX & Sanchez]
	{x = 1183.4351, y = -1332.3489, z = 13.5823, rot = 270, vt = {}, colour = {r = 255, g = 255, b = 255}, vehs = {457, 481, 468}}, -- All Saints
	{x = 1183.4351, y = -1314.9749, z = 13.5823, rot = 270, vt = {}, colour = {r = 255, g = 255, b = 255}, vehs = {457, 481, 468}}, -- All Saints
	{x = 2000.1630, y = -1447.6506, z = 13.5604, rot = 135, vt = {}, colour = {r = 255, g = 255, b = 255}, vehs = {457, 481, 468}}, -- Jefferson Hospital
	{x = 2462.5354, y = -1670.5311, z = 13.4966 , rot = 0, vt = {}, colour = {r = 255, g = 255, b = 255}, vehs = {457, 481, 468}}, -- Grove Street
	
	{x = -2681.5947, y = 629.9854, z = 14.4531, rot = 180, vt = {}, colour = {r = 255, g = 255, b = 255}, vehs = {457, 481, 468}}, -- SF Hospital
	
	{x = 1629.8534, y = 1823.1659, z = 10.8203, rot = 0, vt = {}, colour = {r = 255, g = 255, b = 255}, vehs = {457, 481, 468}}, -- LV Hospital
	{x = 1633.8729, y = 1823.1659, z = 10.8203, rot = 0, vt = {}, colour = {r = 255, g = 255, b = 255}, vehs = {457, 481, 468}}, -- LV Hospital
	{x = 1583.5, y = 1823.1659, z = 10.8203, rot = 0, vt = {}, colour = {r = 255, g = 255, b = 255}, vehs = {457, 481, 468}}, -- LV Hospital
	{x = 1587.5, y = 1823.1659, z = 10.8203, rot = 0, vt = {}, colour = {r = 255, g = 255, b = 255}, vehs = {457, 481, 468}}, -- LV Hospital
	
	{x = 1541.0339, y = -1653.8572, z = 13.5585, rot = 90, vt = {}, colour = {r = 255, g = 255, b = 255}, vehs = {457, 481, 468}}, -- LSPD
	{x = 1541.0339, y = -1697.5802, z = 13.5585, rot = 90, vt = {}, colour = {r = 255, g = 255, b = 255}, vehs = {457, 481, 468}}, -- LSPD
	
	{x = 1409.2539, y = -1168.1426, z = 23.8247, rot = 0, vt = {}, colour = {r = 255, g = 255, b = 255}, vehs = {457, 481, 468}}, -- LS jail release
	{x = -1500.6077, y = 934.9801, z = 7.1875, rot = 270, vt = {}, colour = {r = 255, g = 255, b = 255}, vehs = {457, 481, 468}}, -- SF jail release
	{x = -1500.6077, y = 905.9801, z = 7.1875, rot = 270, vt = {}, colour = {r = 255, g = 255, b = 255}, vehs = {457, 481, 468}}, -- SF jail release
	
	{x = -321.9272, y = 1057.6918, z = 19.7422, rot = 359, vt = {}, colour = {r = 255, g = 255, b = 255}, vehs = {457, 481, 468}}, -- Fort Carson Hospital
	{x = -2196.4719, y = -2304.1282, z = 30.625, rot = 321.9, vt = {}, colour = {r = 255, g = 255, b = 255}, vehs = {457, 481, 468}},
	{x = 1238.2509, y = 335.6484, z = 19.7578, rot = 336.4438, vt = {}, colour = {r = 255, g = 255, b = 255}, vehs = {457, 481, 468}},
	
	-- Aviator 
	-- 		We have an 'a' value
	-- 		a = l -> large
	-- 		a = s -> smalll
	-- 		a = h -> heli
	-- Small planes (Beagle, Dodo, Shamal, Stuntplane)
	{x = 1364.3641, y = 1756.73, z = 10.8203, rot = 270, vt = {"Aviator"}, colour = {r = 255, g = 215, b = 0}, vehs = {511, 593, 513, 519}, a = "s"}, -- Las Venturas
	{x = 1364.3641, y = 1714.88, z = 10.8203, rot = 270, vt = {"Aviator"}, colour = {r = 255,  g = 215, b = 0}, vehs = {511, 593, 513, 519}, a = "s"}, -- Las Venturas
	{x = 1677.8402, y = 1627.1708, z = 10.8203, rot = 180, vt = {"Aviator"}, colour = {r = 255,  g = 215, b = 0}, vehs = {511, 593, 513, 519}, a = "s"}, -- Las Venturas
	{x = 1609.5867, y = 1627.1708, z = 10.8203, rot = 180, vt = {"Aviator"}, colour = {r = 255,  g = 215, b = 0}, vehs = {511, 593, 513, 519}, a = "s"}, -- Las Venturas
	{x = 414.5836, y = 2503.1677, z = 16.4844, rot = 90, vt = {"Aviator"}, colour = {r = 255,  g = 215, b = 0}, vehs = {511, 593, 513, 519}, a = "s"}, -- Verdant Meadows
	{x = 382.5719, y = 2539.615, z = 16.5391, rot = 180, vt = {"Aviator"}, colour = {r = 255,  g = 215, b = 0}, vehs = {511, 593, 513, 519}, a = "s"}, -- Verdant Meadows
	{x = -1246.6765, y = -97.359, z = 14.1484, rot = 135, vt = {"Aviator"}, colour = {r = 255,  g = 215, b = 0}, vehs = {511, 593, 513, 519}, a = "s"}, -- San Fierro
	{x = -1207.1486, y = -145.5417, z = 14.1484, rot = 135, vt = {"Aviator"}, colour = {r = 255,  g = 215, b = 0}, vehs = {511, 593, 513, 519}, a = "s"}, -- San Fierro
	{x = -1272.3878, y = -618.8027, z = 14.1484, rot = 0, vt = {"Aviator"}, colour = {r = 255,  g = 215, b = 0}, vehs = {511, 593, 513, 519}, a = "s"}, -- San Fierro
	{x = -1334.7905, y = -619.1797, z = 14.1484, rot = 0, vt = {"Aviator"}, colour = {r = 255,  g = 215, b = 0}, vehs = {511, 593, 513, 519}, a = "s"}, -- San Fierro
	{x = -1397.5046, y = -619.4011, z = 14.1484, rot = 0, vt = {"Aviator"}, colour = {r = 255,  g = 215, b = 0}, vehs = {511, 593, 513, 519}, a = "s"}, -- San Fierro
	{x = -1459.6853, y = -620.0172, z = 14.1484, rot = 0, vt = {"Aviator"}, colour = {r = 255,  g = 215, b = 0}, vehs = {511, 593, 513, 519}, a = "s"}, -- San Fierro
	{x = 1986.1161, y = -2315.9116, z = 13.5469, rot = 90, vt = {"Aviator"}, colour = {r = 255,  g = 215, b = 0}, vehs = {511, 593, 513, 519}, a = "s"}, -- Los Santos
	{x = 1986.1161, y = -2382.366, z = 13.5469, rot = 90, vt = {"Aviator"}, colour = {r = 255,  g = 215, b = 0}, vehs = {511, 593, 513, 519}, a = "s"}, -- Los Santos
	-- Heliopters (Maverick, Leviathan, Sparrow, Raindance, Cargobob)
	{x = 1378.4188, y = 1770.0908, z = 10.8203, rot = 180, vt = {"Aviator"}, colour = {r = 255, g = 215, b = 0}, vehs = {487, 417, 469, 563, 548}, a = "h"}, -- Las Venturas
	{x = 1399.5907, y = 1770.0908, z = 10.8203, rot = 180, vt = {"Aviator"}, colour = {r = 255, g = 215, b = 0}, vehs = {487, 417, 469, 563, 548}, a = "h"}, -- Las Venturas 
	{x = -1250.0161, y = -33.7229, z = 14.1484, rot = 135, vt = {"Aviator"}, colour = {r = 255, g = 215, b = 0}, vehs = {487, 417, 469, 563, 548}, a = "h"}, -- San Fierro
	{x = 1765.7296, y = -2286.4512, z = 26.796, rot = 180, vt = {"Aviator"}, colour = {r = 255, g = 215, b = 0}, vehs = {487, 417, 469, 563, 548}, a = "h"}, -- Los Santos
	{x = 2010.6317, y = -2447.6052, z = 13.5469, rot = 180, vt = {"Aviator"}, colour = {r = 255, g = 215, b = 0}, vehs = {487, 417, 469, 563, 548}, a = "h"}, -- Los Santos
	-- Large planes (Nevada, Andromada, AT-400, Shamal)
	{x = 1477.429, y = 1739.6221, z = 10.8125, rot = 180, vt = {"Aviator"}, colour = {r = 255, g = 215, b = 0}, vehs = {553, 577, 592, 519}, a = "l"}, -- Las Venturas 
	{x = 1477.429, y = 1245.4187, z = 10.8125, rot = 0, vt = {"Aviator"}, colour = {r = 255, g = 215, b = 0}, vehs = {553, 577, 592, 519}, a = "l"}, -- Las Venturas
	{x = 1564.7855, y = 1283.6118, z = 10.8125, rot = 45, vt = {"Aviator"}, colour = {r = 255, g = 215, b = 0}, vehs = {553, 577, 592, 519}, a = "l"}, -- Las Venturas
	{x = -1323.0562, y = -208.1613, z = 14.1484, rot = 315, vt = {"Aviator"}, colour = {r = 255, g = 215, b = 0}, vehs = {553, 577, 592, 519}, a = "l"}, -- San Fierro
	{x = -1657.6765, y = -164.9684, z = 14.1484, rot = 315, vt = {"Aviator"}, colour = {r = 255, g = 215, b = 0}, vehs = {553, 577, 592, 519}, a = "l"}, -- San Fierro
	{x = 2113.0366, y = -2467.2312, z = 13.5469, rot = 180, vt = {"Aviator"}, colour = {r = 255, g = 215, b = 0}, vehs = {553, 577, 592, 519}, a = "l"}, -- Los Santos
	-- Complimentary vehicles (Tug, Baggage)
	{x = 1443.3219, y = -2290.1899, z = 13.5469, rot = 90, vt = {"Aviator"}, colour = {r = 255, g = 215, b = 0}, vehs = {485, 583}}, -- Outside LS interior entry
	{x = 1443.3219, y = -2284.1802, z = 13.5469, rot = 90, vt = {"Aviator"}, colour = {r = 255, g = 215, b = 0}, vehs = {485, 583}}, -- Outside LS interior entry
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
	-- Ocean Docks
	{x = 2461.3496, y = -2104.6243, z = 13.5469, rot = 0, vt = {"Trucker"}, colour = {r = 255, g = 215, b = 0}, vehs = {403, 515}},
	{x = 2484.4426, y = -2104.6243, z = 13.5469, rot = 0, vt = {"Trucker"}, colour = {r = 255, g = 215, b = 0}, vehs = {403, 515}},
	{x = 2508.5732, y = -2104.6243, z = 13.5469, rot = 0, vt = {"Trucker"}, colour = {r = 255, g = 215, b = 0}, vehs = {403, 515}},
	{x = 2534.4783, y = -2104.6243, z = 13.5469, rot = 0, vt = {"Trucker"}, colour = {r = 255, g = 215, b = 0}, vehs = {403, 515}},
	
	-- Police/Law
	-- LSPD
	{x = 1556.9408, y = -1609.4148, z = 13.3828, rot = 180, vt = {"Police Officer", "Law"}, colour = {r = 30, g = 144, b = 255}, vehs = {596, 597, 598, 599}},
	{x = 1565.2158, y = -1609.4148, z = 13.3828, rot = 180, vt = {"Police Officer", "Law"}, colour = {r = 30, g = 144, b = 255}, vehs = {596, 597, 598, 599}},
	{x = 1574.371, y = -1609.4148, z = 13.3828, rot = 180, vt = {"Police Officer", "Law"}, colour = {r = 30, g = 144, b = 255}, vehs = {596, 597, 598, 599}},
	{x = 1600.889, y = -1612.8756, z = 13.4751, rot = 90, vt = {"Police Officer", "Law"}, colour = {r = 30, g = 144, b = 255}, vehs = {596, 597, 598, 599}},
	{x = 1600.889, y = -1624.8512, z = 13.4751, rot = 90, vt = {"Police Officer", "Law"}, colour = {r = 30, g = 144, b = 255}, vehs = {596, 597, 598, 599}},
	{x = 1565.3097, y = -1696.9613, z = 28.3956, rot = 90, vt = {"Police Officer", "Law"}, colour = {r = 30, g = 144, b = 255}, vehs = {497}},
	{x = 1565.3097, y = -1656.145, z = 28.3956, rot = 90, vt = {"Police Officer", "Law"}, colour = {r = 30, g = 144, b = 255}, vehs = {497}},
	{x = 1595.5148, y = -1710.0549, z = 5.8906, rot = 0, vt = {"Detective"}, colour = {r = 30, g = 144, b = 255}, vehs = {421, 426}},
	{x = 1587.4016, y = -1710.0549, z = 5.8906, rot = 0, vt = {"Detective"}, colour = {r = 30, g = 144, b = 255}, vehs = {421, 426}},
	{x = 1601, y = -1683.8301, z = 5.8906, rot = 90, vt = {"Traffic Officer"}, colour = {r = 30, g = 144, b = 255}, vehs = {415, 523}},
	{x = 1601, y = -1692.1, z = 5.8906, rot = 90, vt = {"Traffic Officer"}, colour = {r = 30, g = 144, b = 255}, vehs = {415, 523}},
	-- SFPD
	{x = -1628.6117, y = 651.6313, z = 7.1875, rot = 360, vt = {"Police Officer", "Law"}, colour = {r = 30, g = 144, b = 255}, vehs = {596, 597, 598, 599}},
	{x = -1616.4866, y = 651.6313, z = 7.1875, rot = 360, vt = {"Police Officer", "Law"}, colour = {r = 30, g = 144, b = 255}, vehs = {596, 597, 598, 599}},
	{x = -1605.2736, y = 651.6313, z = 7.1875, rot = 360, vt = {"Police Officer", "Law"}, colour = {r = 30, g = 144, b = 255}, vehs = {596, 597, 598, 599}},
	{x = -1593.4419, y = 651.6313, z = 7.1875, rot = 360, vt = {"Police Officer", "Law"}, colour = {r = 30, g = 144, b = 255}, vehs = {596, 597, 598, 599}},
	{x = -1588.0039, y = 748.7182, z = -5.2422, rot = 180, vt = {"Traffic Officer"}, colour = {r = 30, g = 144, b = 255}, vehs = {415, 523}},
	{x = -1596.1793, y = 748.4637, z = -5.2422, rot = 180, vt = {"Traffic Officer"}, colour = {r = 30, g = 144, b = 255}, vehs = {415, 523}},
	{x = -1574.6395, y = 742.7321, z = -5.2422, rot = 270, vt = {"Detective"}, colour = {r = 30, g = 144, b = 255}, vehs = {421, 426}},
	{x = -1574.8336, y = 735.1558, z = -5.2422, rot = 270, vt = {"Detective"}, colour = {r = 30, g = 144, b = 255}, vehs = {421, 426}},
	-- LVPD
	{x = 2256.0664, y = 2460.9648, z = 10.8203, rot = 180, vt = {"Police Officer", "Law"}, colour = {r = 30, g = 144, b = 255}, vehs = {596, 597, 598, 599}},
	{x = 2273.4031, y = 2460.9648, z = 10.8203, rot = 180, vt = {"Police Officer", "Law"}, colour = {r = 30, g = 144, b = 255}, vehs = {596, 597, 598, 599}},
	{x = 2273.3943, y = 2443.0896, z = 10.8203, rot = 0, vt = {"Police Officer", "Law"}, colour = {r = 30, g = 144, b = 255}, vehs = {596, 597, 598, 599}},
	{x = 2255.873, y = 2443.0896, z = 10.8203, rot = 0, vt = {"Police Officer", "Law"}, colour = {r = 30, g = 144, b = 255}, vehs = {596, 597, 598, 599}},
	-- Paramedic, LS All Saints
	{x = 1180.4978, y = -1338.8416, z = 13.8005, rot = -90, vt = {"Paramedic"}, colour = {r = 0, g = 255, b = 255}, vehs = {416}},
	{x = 1180.4978, y = -1308.5029, z = 13.8005, rot = -90, vt = {"Paramedic"}, colour = {r = 0, g = 255, b = 255}, vehs = {416}},
	-- Paramedic, LS Jefferson
	{x = 2032.86, y = -1446.4751, z = 17.2407, rot = 90, vt = {"Paramedic"}, colour = {r = 0, g = 255, b = 255}, vehs = {416}},
	{x = 2002.0824, y = -1414.672, z = 16.9922, rot = 180, vt = {"Paramedic"}, colour = {r = 0, g = 255, b = 255}, vehs = {416}},
	-- Paramedic, San Fierro
	{x = -2682.0452, y = 610.0144, z = 14.4531, rot = 180, vt = {"Paramedic"}, colour = {r = 0, g = 255, b = 255}, vehs = {416}},
	{x = -2634.4585, y = 610.0144, z = 14.4531, rot = 180, vt = {"Paramedic"}, colour = {r = 0, g = 255, b = 255}, vehs = {416}},
	-- Paramedic, Fort Carson
	{x = -295.5605, y = 1044.6532, z = 19.5938, rot = 0.97, vt = {"Paramedic"}, colour = {r = 0, g = 255, b = 255}, vehs = {416}},
	-- Paramedic, Las Venturas
	{x = 1624.7664, y = 1851.087, z = 10.8203, rot = 180, vt = {"Paramedic"}, colour = {r = 0, g = 255, b = 255}, vehs = {416}},
	{x = 1590.7393, y = 1851.087, z = 10.8203, rot = 180, vt = {"Paramedic"}, colour = {r = 0, g = 255, b = 255}, vehs = {416}},
	-- Paramedic, Montgomery
	{x = 1257.7942, y = 332.4998, z = 19.5547, rot = 335.4584, vt = {"Paramedic"}, colour = {r = 0, g = 255, b = 255}, vehs = {416}},
}
