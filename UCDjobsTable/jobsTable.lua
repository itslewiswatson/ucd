local jobsTable = 
{
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
		colour = {r = 255, g = 255, b = 0},
		blipID = 56,
		desc = "An aviator's job is to transport cargo and passengers both \ndomestically and internationally with various aircraft. \nAn aviator has a repertoire of only the best engineered \naircraft to get his/her job done. The job has a \nsubstantially high risk factor, aviators are compensated for \ntheir risk with lump sums of cash after every flight.\n\nGo to a blip to spawn a plane, or use your own.\nFrom there, wait to be assigned a flight path. \nOnce assigned, pick up your cargo and fly to your \ndestination, which will be marked on your radar and map.",
	},
	["Trucker"] = 
	{
		team = "Citizens",
		markers = 
		{
			
		},
		skins = 
		{
			{128, "Trucker 1"},
			{133, "Trucker 2"},
			{201, "Trucker 3"},
			{202, "Trucker 4"},
			{206, "Trucker 5"},
		},
		colour = {r = 255, g = 255, b = 0},
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
		colour = {r = 255, g = 255, b = 0},
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
			{309, "Mechanic 3"},
		},
		colour = {r = 255, g = 255, b = 0},
		blipID = 56,
		desc = "",
	}
}

function getJobTable()
	return jobsTable
end

local jobsRanks = 
{
	["Aviator"] = 
	{
		ranks = 
		{
			[0] = "Student Pilot",
			[1] = "Amateur Aviator",
			[2] = "Licensed Aviator",
			[3] = "Competent Aviator",
			[4] = "Flight Instructor",
			[5] = "Flight Engineer",
			[6] = "Flight Officer",
			[7] = "Co-Captain",
			[8] = "Captain",
			[9] = "Executive",
			[10] = "Chairman",
		},
		bonuses = {
			[0] = 0,
			[1] = 0,
			[2] = 0,
			[3] = 0,
			[4] = 0,
			[5] = 0,
			[6] = 0,
			[7] = 0,
			[8] = 0,
			[9] = 0,
			[10] = 0,
		},
	},
	["Trucker"] = 
	{
		ranks =
		{
			[0] = "Unlicensed Trucker",
			[1] = "Licensed Trucker",
			[2] = "Advanced Trucker",
			[3] = "Commercial Trucker",
			[4] = "Light Load Trucker",
			[5] = "Medium Load Trucker",
			[6] = "Heavy Load Trucker",
			[7] = "Expert Trucker",
			[8] = "Executive Trucker",
			[9] = "Chief Executive",
			[10] = "Roadrunner",
		},
		bonuses = {
			[0] = 0,
			[1] = 0,
			[2] = 0,
			[3] = 0,
			[4] = 0,
			[5] = 0,
			[6] = 0,
			[7] = 0,
			[8] = 0,
			[9] = 0,
			[10] = 0,
		},
	},
}

function getJobRanks(jobName)
	return jobsRanks[jobName]
end