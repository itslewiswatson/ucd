markers = 
{
	-- Low End
	{x = 2131.8516, y = -1149.7815, z = 24.2298, r = 0, t = "Low End", p = Vector3(2125.0593, -1136.9047, 25.3666), c = Vector3(2121.704, -1121.803, 29.597)}, -- Jefferson
	{x = 1658.4023, y = 2199.8137, z = 10.8203, r = 270, t = "Low End", p = Vector3(1658.473, 2192.307, 10.616), c = Vector3(1651.561, 2198.024, 11.814)},
	{x = -1952.0233, y = 280.6862, z = 35.4688, r = 0, t = "Low End", p = Vector3(-1988.744, 263.534, 34.899), c = Vector3(-1991.986, 269.628, 35.709)},
	
	-- High End
	{x = 552.5023, y = -1260.7535, z = 17.2422, r = 330, t = "High End", p = Vector3(547.2733, -1277.1145, 17.2482), c = Vector3(563.549, -1267.290, 20.107)},
	{x = 1947.5898, y = 2068.8875, z = 10.8203, r = 0, t = "High End", p = Vector3(1940.735, 2063.175, 10.547), c = Vector3(1935.111, 2071.453, 13.073)},
	{x = 1125.7128, y = -1471.1128, z = 15.7642, r = 0, t = "High End", p = Vector3(1129.007, -1446.494, 15.524), c = Vector3(1134.938, -1439.053, 17.252)},
	{x = -1661.1222, y = 1209.6344, z = 13.6781, r = 45, t = "High End", p = Vector3(-1642.129, 1214.210, 6.877), c = Vector3(-1643.337, 1221.979, 7.717)}, -- SF
	
	-- Bikes
	{x = 2200.8186, y = 1393.6287, z = 10.8203, r = 90, t = "Bikes", p = Vector3(2206.197, 1386.606, 10.547), c = Vector3(2199.920, 1380.903, 11.884)}, -- LV
	{x = 701.6217, y = -519.2266, z = 16.3302, r = 270, t = "Bikes", p = Vector3(706.5789, -525.0184, 16.3359), c = Vector3(713.849, -529.844, 16.880)}, -- Dillimore
	{x = -2240.2598, y = 109.3667, z = 35.3203, r = 90, t = "Bikes", p = Vector3(-2226.4236, 103.52, 35.3203), c = Vector3(-2230.106, 106.856, 36.473)}, -- SF
	
	-- Watercraft
	{x = 715.5214, y = -1691.8789, z = 2.4297, r = 180, t = "Watercraft", p = Vector3(728.6, -1696.8011, 0.6), c = Vector3(730.078, -1718.146, 8.865)}, -- South LS
	{x = 2359.2549, y = 526.001, z = 1.7969, r = 270, t = "Watercraft", p = Vector3(2358.8223, 500, 1), c = Vector3(2376.8628, 533.1199, 10.1202)}, -- South LV boat shop
	{x = -2329.6672, y = 2315.0901, z = 3.5, r = 180, t = "Watercraft", p = Vector3(-2319.729, 2308.8669, 1), c = Vector3(-2339.1572, 2292.0168, 13.8656)}, -- Tierra Robada
	
	-- Aircraft
	{x = 1902.2667, y = -2235.2734, z = 13.5469, r = 270, t = "Aircraft", p = Vector3(1882.551, -2286.463, 14.741), c = Vector3(1914.542, -2268.412, 27.075)}, -- LS
	{x = -1670.8544, y = -412.0009, z = 14.1484, r = 0, t = "Aircraft", p = Vector3(-1652.490, -331.442, 15.343), c = Vector3(-1674.293, -293.189, 33.777)}, -- SF
	{x = 410.3679, y = 2532.0371, z = 16.573, r = 180, t = "Aircraft", p = Vector3(360.031, 2539.906, 17.750), c = Vector3(393.952, 2506.435, 26.795)}, -- VM
	{x = 1340.8613, y = 1804.8071, z = 10.8203, r = 225, t = "Aircraft", p = Vector3(1362.139, 1838.092, 12.016), c = Vector3(1337.243, 1803.167, 21.213)}, -- LV

	-- Country
	{x = -2100.2747, y = -2222.8884, z = 30.625, r = 180, t = "Country", p = Vector3(-2100.702, -2243.026, 30.214), c = Vector3(-2111.979, -2242.712, 32.159)},
	{x = -1534.2935, y = 2647.7964, z = 55.8359, r = 270, t = "Country", p = Vector3(-1527.741, 2635.297, 55.584), c = Vector3(-1536.290, 2642.594, 58.030)},
	{x = 1267.7129, y = 170.2782, z = 19.6741, r = 68, t = "Country", p = Vector3(1279.353, 176.605, 19.735), c = Vector3(1270.561, 173.596, 21.499)},
}

-- c = the position of the camera
-- p = vehicle position and where the camera looks at

--[[
vehicles = 
{
	["High End"] = {
		411, 451, 415, 429, 541, 480, 434, 494, 503, 502, 560, 506, 580
	},
	["Low End"] = {
		474,
	},
	["Bikes"] = {
		581, 509, 481, 462, 521, 463, 510, 522, 461, 448, 468, 586
	},
	["Country"] = {
		499,
	},
	["Aircraft"] = {
		-- All except Hydra, Hunter, AT-400, Seasparrow, Skimmer, Police Maverick
		592, 511, 548, 512, 593, 417, 487, 553, 488, 563, 476, 519, 469, 513
	},
	["Watercraft"] = {
		472, 473, 493, 595, 484, 430, 453, 452, 446, 454, 460
	},
}
--]]
vehicles = 
{
	["High End"] = {
		429, 541, 415, 480, 562, 565, 434, 494, 502, 503, 411, 559, 561, 560, 506, 451, 558, 555, 477, 602, 587, 533, 526, 409, 579, 400, 404, 489, 479, 442, 458, 402, 495, 504, 424, 568, 536, 575, 534, 567, 535, 576, 412
	},
	["Low End"] = {
		496, 401, 518, 527, 419, 474, 545, 517, 600, 410, 436, 439, 549, 445, 507, 585, 466, 492, 546, 551, 516, 467, 426, 547, 405, 580, 550, 566, 540, 421, 529, 589, 499, 498, 588, 423, 414, 456, 459, 482, 418, 582, 413, 440, 542, 603, 475
	},
	["Bikes"] = {
		581, 509, 481, 462, 521, 463, 510, 522, 461, 448, 468, 586, 571, 471, 457
	},
	["Country"] = {
		524, 532, 578, 486, 406, 573, 455, 403, 423, 443, 515, 514, 531, 530, 572, 583, 478, 554, 422, 543, 444, 556, 557, 508, 483, 564, 594, 441
	},
	["Aircraft"] = {
		-- All except Hydra, Hunter, AT-400, Seasparrow, Skimmer, Police Maverick
		592, 511, 512, 593, 553, 476, 519, 513, 548, 417, 487, 488, 563, 469
	},
	["Watercraft"] = {
		472, 473, 493, 595, 484, 430, 453, 452, 446, 454, 460, 539
	},
}

blips = 
{
	["High End"] = 55,
	["Low End"] = 55,
	["Bikes"] = ":lol/bike.png",
	["Country"] = 55,
	["Aircraft"] = 5,
	["Watercraft"] = 9,
}

prices = 
{
	-- Aircraft
	["Andromada"] = 300000, ["Beagle"] = 120000, ["Cargobob"] = 125700, ["Cropduster"] = 80000, ["Dodo"] = 60000, ["Leviathan"] = 130000, ["Maverick"] = 230000,
	["Nevada"] = 260000, ["News Chopper"] = 190000, ["Raindance"] = 110000, ["Shamal"] = 290000, ["Rustler"] = 5000000, ["Sparrow"] = 90000, ["Stuntplane"] = 140000,
	
	-- Watercraft
	["Dinghy"] = 25000, ["Jetmax"] = 2400000, ["Skimmer"] = 190000, ["Marquis"] = 200000, ["Coastguard"] = 50000, ["Vortex"] = 330000,
	["Launch"] = 230000, ["Reefer"] = 110000, ["Squalo"] = 270000, ["Tropic"] = 250000, ["Speeder"] = 170000, ["Predator"] = 390000,
	
	-- High End
	["Infernus"] = 400000, ["Stafford"] = 90000, ["Turismo"] = 350000, ["Cheetah"] = 290000, ["Banshee"] = 2300000, ["Comet"] = 20000, ["Super GT"] = 380000, 
	["Sultan"] = 125700, ["Bullet"] = 420000, ["Hotknife"] = 90000, ["Hotring Racer"] = 300000, ["Hotring Racer 2"] = 300000, ["Hotring Racer 3"] = 300000,	
    ["Elegy"] = 110000, ["Flash"] = 90000, ["Jester"] = 91000, ["Stratum"] = 64000, ["Uranus"] = 85000, ["Windsor"] = 72000, ["ZR-350"] = 92000,	

	-- Bikes
	["NRG-500"] = 500000, ["BF-400"] = 40000, ["Bike"] = 250, ["BMX"] = 500, ["Mountain Bike"] = 750, ["Faggio"] = 5000, ["FCR-900"] = 130000, ["Freeway"] = 125000,
	["Pizzaboy"] = 7500, ["PCJ-600"] = 120000, ["Sanchez"] = 70000, ["Wayfarer"] = 60000, ["Caddy"] = 15000, ["Kart"] = 15000, ["Quadbike"] = 60000, 

	-- Compact
	["Alpha"] = 50000, ["Blista Compact"] = 25000, ["Bravura"] = 35000, ["Buccaneer"] = 60000, ["Cadrona"] = 30000, ["Club"] = 20000, ["Esperanto"] = 40000,
    ["Euros"] = 32000, ["Feltzer"] = 49000, ["Fortune"] = 41000, ["Hermes"] = 31000, ["Hustler"] = 26000, ["Majestic"] = 43000, ["Manana"] = 45000, ["Picador"] = 33000,
    ["Previon"] = 29000, ["Stallion"] = 36000, ["Tampa"] = 40000, ["Virgo"] = 37000,

	-- Luxury
	["Admiral"] = 53000, ["Elegant"] = 39000, ["Emperor"] = 56000, ["Glendale"] = 70000, ["Greenwood"] = 45000, ["Intruder"] = 38000, ["Merit"] = 69000, ["Nebula"] = 58000,
    ["Oceanic"] = 41500, ["Premier"] = 59000, ["Primo"] = 60000, ["Sentinel"] = 61000, ["Stafford"] = 67000, ["Stretch"] = 99000, ["Sunrise"] = 65000, ["Tahoma"] = 35000,
    ["Vincent"] = 35000, ["Washington"] = 70000, ["Willard"] = 39750,

	-- Civil
	["Baggage"] = 7500, ["Bus"] = 77000, ["Cabbie"] = 25000, ["Coach"] = 80000, ["Taxi"] = 25000, ["Utility Van"] = 54000,

    -- Heavy Trucks
    ["Benson"] = 71000, ["Boxville"] = 68000, ["Cement Truck"] = 67000, ["Combine Harvester"] = 12000, ["DFT-30"] = 140000, ["Dozer"] = 180000, ["Dumper"] = 420000,
    ["Dune"] = 90000, ["Flatbed"] = 110000, ["Linerunner"] = 120000, ["Mr. Whoopee"] = 55000, ["Mule"] = 49000, ["Packer"] = 87000, 
    ["Roadtrain"] = 120000, ["Tanker"] = 120000, ["Tractor"] = 75000, ["Yankee"] = 72000,

    -- Light Trucks
    ["Bobcat"] = 61000, ["Burrito"] = 50000, ["Forklift"] = 36000, ["Moonbeam"] = 25000, ["Mower"] = 15000, ["News Van"] = 35000, ["Pony"] = 56000, ["Rumpo"] = 55000,
    ["Sadler"] = 36000, ["Tug"] = 13000, ["Walton"] = 34000, ["Yosemite"] = 43000, ["Camper"] = 36000, ["Journey"] = 34000,

    -- Lowriders
    ["Blade"] = 78000, ["Broadway"] = 65000, ["Remington"] = 75000, ["Savanna"] = 77000, ["Slamvan"] = 69000, ["Tornado"] = 58000, ["Voodoo"] = 61000,

    -- Muscle Cars
    ["Buffalo"] = 91000, ["Clover"] = 87000, ["Phoenix"] = 81000, ["Sabre"] = 79000,

    -- Offroad
    ["Bandito"] = 44000, ["BF Injection"] = 56000, ["Bloodring Banger"] = 80000, ["Mesa"] = 35000, ["Monster"] = 95000, ["Monster 1"] = 95000, ["Monster 2"] = 95000, ["Monster 3"] = 95000,
    ["Sandking"] = 78000,

    -- RC Vehicles
    ["RC Bandit"] = 15000, ["RC Cam"] = 5000, ["RC Tiger"] = 22000,

	-- SUV
	["Huntley"] = 65000, ["Landstalker"] = 35000, ["Perennial"] = 55000, ["Rancher"] = 56000, ["Regina"] = 54000, ["Romero"] = 44000, ["Solair"] = 39000, 
	
	--- jja
	["Newsvan"] = 30000, ["Berkley's RC Van"] = 30000, ["Hotdog"] = 45000,
}
