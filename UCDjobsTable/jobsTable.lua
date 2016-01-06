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
			{x = 83.2926, y = -285.0277, z = 1.5781, interior = 0, dimension = 0},
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
		colour = {r = 255, g = 255, b = 0},
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
		
		-- Bonus in percentage of original price (the end income will be base + bonus * base)
		-- Requirements in number of flights
		[0] = {name = "Student Pilot", bonus = 0, req = 0},
		[1] = {name = "Amateur Aviator", bonus = 15, req = 15},
		[2] = {name = "Licensed Aviator", bonus = 25, req = 40},
		[3] = {name = "Competent Aviator", bonus = 40, req = 75}, 
		[4] = {name = "Flight Instructor", bonus = 65, req = 165},
		[5] = {name = "Flight Engineer", bonus = 95, req = 300},
		[6] = {name = "Flight Officer", bonus = 130, req = 460},
		[7] = {name = "Co-Captain", bonus = 165, req = 630},
		[8] = {name = "Captain", bonus = 200, req = 800},
		[9] = {name = "Executive", bonus = 230, req = 1000},
		[10] = {name = "Chairman", bonus = 300, req = 1250},
	},
	["Trucker"] = {
		--[[
		[0] = {name = "Unlicensed Trucker", bonus = , req = },
		[1] = {name = "Licensed Trucker", bonus = , req = },
		[2] = {name = "Advanced Trucker", bonus = , req = },
		[3] = {name = "Commercial Trucker", bonus = , req = },
		[4] = {name = "Light Load Trucker", bonus = , req = },
		[5] = {name = "Medium Load Trucker", bonus = , req = },
		[6] = {name = "Heavy Load Trucker", bonus = , req = },
		[7] = {name = "Expert Trucker", bonus = , req = },
		[8] = {name = "Executive Trucker", bonus = , req = },
		[9] = {name = "Chief Executive", bonus = , req = },
		[10] = {name = "Roadrunner", bonus = , req = },
		--]]
	},
}

function getJobRanks(jobName)
	return jobsRanks[jobName]
end
