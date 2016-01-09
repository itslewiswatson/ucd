local jobsTable = 
{
	-- Other jobs
	["Gangster"] = 
	{
		team = "Gangsters",
	},
	["Criminal"] = 
	{
		team = "Criminals",
	},
	[""] = 
	{
		team = "Citizens",
	},
	
	-- Proper jobs
	["Aviator"] = 
	{
		team = "Citizens",
		markers =
		{
			{x = -1868.595, y = 46.0555, z = 1055.1953, interior = 14, dimension = 50000}, -- Los Santos
			{x = -1868.595, y = 46.0555, z = 1055.1953, interior = 14, dimension = 50001}, -- San Fierro 
			{x = -1868.595, y = 46.0555, z = 1055.1953, interior = 14, dimension = 50002}, -- Las Venturas
			{x = 413.7399, y = 2536.8147, z = 19.1484, interior = 0, dimension = 0}, -- Verdant Meadows
		},
		skins =
		{
			{61, "Male Aviator"},
			{66, "Female Aviator"},
		},
		colour = {r = 255, g = 215, b = 0},
		blipID = 56,
		desc = "An aviator's job is to transport cargo and passengers both \ndomestically and internationally with various aircraft. \nAn aviator has a repertoire of only the best engineered \naircraft to get his/her job done. The job has a \nsubstantially high risk factor, aviators are compensated for \ntheir risk with lump sums of cash after every flight.\n\nGo to a blip to spawn a plane, or use your own.\nFrom there, wait to be assigned a flight path. \nOnce assigned, pick up your cargo and fly to your \ndestination, which will be marked on your radar and map.",
	},
	["Trucker"] = 
	{
		team = "Citizens",
		markers = 
		{
			{x = 81.3992, y = -283.6037, z = 1.5781, interior = 0, dimension = 0},
		},
		skins = 
		{
			{128, "Trucker 1"},
			{133, "Trucker 2"},
			{201, "Trucker 3"},
			{202, "Trucker 4"},
			{206, "Trucker 5"},
		},
		colour = {r = 255, g = 215, b = 0},
		blipID = 56,
		desc = "",
	},
	["Prostitute"] = 
	{
		team = "Citizens",
		markers = 
		{
			
		},
		skins = 
		{
			
		},
		colour = {r = 255, g = 215, b = 0},
		blipID = 56,
		desc = "",
	},
	["Mechanic"] = 
	{
		team = "Citizens",
		markers = 
		{	
			{x = -2053.3015, y = 165.2379, z = 28.8359, interior = 1, dimension = 50000},
			{x = -2053.3015, y = 165.2379, z = 28.8359, interior = 1, dimension = 50001},
			{x = -2053.3015, y = 165.2379, z = 28.8359, interior = 1, dimension = 50002},
			{x = -2053.3015, y = 165.2379, z = 28.8359, interior = 1, dimension = 50003},
		},
		skins = 
		{
			{50, "Mechanic 1"},
			{268, "Mechanic 2"},
			{305, "Mechanic 3"},
		},
		colour = {r = 255, g = 215, b = 0},
		blipID = 56,
		desc = "",
	},
	["Paramedic"] = 
	{
		team = "Citizens",
		markers = 
		{
			{x = 234.5989, y = 159.3621, z = 1003.0234, interior = 3, dimension = 50000},
			{x = 234.5989, y = 159.3621, z = 1003.0234, interior = 3, dimension = 50001},
			{x = 234.5989, y = 159.3621, z = 1003.0234, interior = 3, dimension = 50002},
			{x = 234.5989, y = 159.3621, z = 1003.0234, interior = 3, dimension = 50003},
			{x = 234.5989, y = 159.3621, z = 1003.0234, interior = 3, dimension = 50004},
			{x = 234.5989, y = 159.3621, z = 1003.0234, interior = 3, dimension = 50005},
			{x = 234.5989, y = 159.3621, z = 1003.0234, interior = 3, dimension = 50006},
		},
		skins = 
		{
			{275, "Female Medic"},
			{274, "Male Medic 1"},
			{276, "Male Medic 2"},
		},
		colour = {r = 0, g = 255, b = 255},
		blipID = 56,
		desc = "A paramedic's job is to heal the people of San Andreas. \nA paramedic is given both helicopters and\n ambulances to be the first responders to an ordeal. \nTo heal players, a paramedic must be still and within one \nmetre of the patient they want to heal. \n\nA paramedic has a centralized computer to see the status \nof people that require healing around SA. This is accessed \nusing the F5 key when on-duty.",
	},
	["Iron Miner"] = 
	{
		team = "Citizens",
		markers = 
		{
			{x = 590.1082, y = 870.6659, z = -42.4973, interior = 0, dimension = 0},
		},
		skins = 
		{
			{},
		},
		colour = {r = 255, g = 215, b = 0},
		blipID = 56,
		desc = "",
	},
}

function getJobTable()
	return jobsTable
end

local jobsRanks = 
{
	["Aviator"] = 
	{
		-- It takes about 3 minutes to go from LS to SF to LV in a Shamal
		
		-- Bonus in percentage of original price - the end income will be: base + (bonus % of base)
		-- Requirements in number of flights
		-- 0 - 2 = blue, 3 - 5 = yellow, 6 - 8 = green, 9 - 10 = red
		[0] = {name = "Student Pilot", bonus = 0, req = 0, colour = {r1 = 0, g1 = 0, b1 = 255, r2 = 255, g2 = 255, b2 = 255}}, -- Blue
		[1] = {name = "Amateur Aviator", bonus = 15, req = 15, colour = {r1 = 0, g1 = 0, b1 = 255, r2 = 255, g2 = 255, b2 = 255}}, -- Blue
		[2] = {name = "Licensed Aviator", bonus = 25, req = 40, colour = {r1 = 0, g1 = 0, b1 = 255, r2 = 0, g2 = 0, b2 = 255}}, -- Blue
		
		[3] = {name = "Competent Aviator", bonus = 40, req = 75, colour = {r1 = 255, g1 = 255, b1 = 0, r2 = 255, g2 = 255, b2 = 255}}, -- Yellow
		[4] = {name = "Flight Instructor", bonus = 65, req = 165, colour = {r1 = 255, g1 = 255, b1 = 0, r2 = 255, g2 = 255, b2 = 255}}, -- Yellow
		[5] = {name = "Flight Engineer", bonus = 95, req = 300, colour = {r1 = 255, g1 = 255, b1 = 0, r2 = 255, g2 = 255, b2 = 0}}, -- Yellow
		
		[6] = {name = "Flight Officer", bonus = 130, req = 460, colour = {r1 = 0, g1 = 255, b1 = 0, r2 = 255, g2 = 255, b2 = 255}}, -- Green
		[7] = {name = "Co-Captain", bonus = 165, req = 630, colour = {r1 = 0, g1 = 255, b1 = 0, r2 = 255, g2 = 255, b2 = 255}}, -- Green
		[8] = {name = "Captain", bonus = 200, req = 800, colour = {r1 = 0, g1 = 255, b1 = 0, r2 = 0, g2 = 255, b2 = 0}}, -- Green
		
		[9] = {name = "Executive", bonus = 230, req = 1000, colour = {r1 = 255, g1 = 0, b1 = 0, r2 = 255, g2 = 255, b2 = 255}}, -- Red
		[10] = {name = "Ace", bonus = 300, req = 1250, colour = {r1 = 255, g1 = 0, b1 = 0, r2 = 255, g2 = 0, b2 = 0}}, -- Red
	},
	["Trucker"] = {
		-- Still need to do calculations, but this is a basic guideline for now
		[0] = {name = "Unlicensed Trucker", bonus = 0, req = 0, colour = {r1 = 255, g1 = 255, b1 = 255, r2 = 255, g2 = 255, b2 = 255}},
		[1] = {name = "Licensed Trucker", bonus = 15, req = 30, colour = {r1 = 0, g1 = 0, b1 = 255, r2 = 255, g2 = 255, b2 = 255}},
		[2] = {name = "Advanced Trucker", bonus = 25, req = 75, colour = {r1 = 0, g1 = 0, b1 = 255, r2 = 0, g2 = 0, b2 = 0}},
		[3] = {name = "Commercial Trucker", bonus = 40, req = 165, colour = {r1 = 255, g1 = 255, b1 = 0, r2 = 255, g2 = 255, b2 = 255}},
		[4] = {name = "Light Load Trucker", bonus = 65, req = 280, colour = {r1 = 255, g1 = 255, b1 = 0, r2 = 255, g2 = 255, b2 = 255}},
		[5] = {name = "Medium Load Trucker", bonus = 95, req = 380, colour = {r1 = 255, g1 = 255, b1 = 0, r2 = 255, g2 = 255, b2 = 255}},
		[6] = {name = "Heavy Load Trucker", bonus = 130, req = 500, colour = {r1 = 255, g1 = 255, b1 = 0, r2 = 255, g2 = 255, b2 = 0}},
		[7] = {name = "Expert Trucker", bonus = 165, req = 750, colour = {r1 = 255, g1 = 0, b1 = 0, r2 = 255, g2 = 255, b2 = 255}},
		[8] = {name = "Executive Trucker", bonus = 200, req = 925, colour = {r1 = 255, g1 = 0, b1 = 0, r2 = 255, g2 = 255, b2 = 255}},
		[9] = {name = "Chief Executive", bonus = 230, req = 1150, colour = {r1 = 255, g1 = 0, b1 = 0, r2 = 255, g2 = 0, b2 = 0}},
		[10] = {name = "The Hauler", bonus = 300, req = 1350, colour = {r1 = 0, g1 = 0, b1 = 0, r2 = 0, g2 = 0, b2 = 0}},
	},
}

function getJobRanks(jobName)
	return jobsRanks[jobName]
end

local rankRestrictions = 
{
	["Aviator"] = 
	{
		[519] = 2, -- Shamal
		[487] = 2, -- Maverick
		[592] = 3, -- Andromada
		[553] = 3, -- Nevada
		[577] = 5, -- AT-400 (this is higher than the rest because of the allahu akbar types of people)
	},
}
function getRestricedVehicles(jobName)
	return rankRestrictions[jobName] or false
end

