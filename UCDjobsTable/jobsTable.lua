
local jobsTable = 
{
	["Pilot"] = 
	{
		team = "Citizens",
		marker =
		{
			color = 
			{
				r = 255, g = 255, b = 0,
			},
			coords = 
			{
				{1953.5154, -2188.354, 13.5469},
			},
		},
		skins =
		{
			{61, "Male Pilot"},
			{0, "Placeholder"},
		},
		blipID = 56,
		desc = "A pilot's job is to transport cargo and passengers both \ndomestically and internationally with various aircraft. \nA pilot has a repertoire of only the best engineered \naircraft to get his/her job done. The job has a \nsubstantially high risk factor, pilots are compensated for \ntheir risk with lump sums of cash after every flight.\n\nGo to a blip to spawn a plane, or use your own.\nFrom there, wait to be assigned a flight path. \nOnce assigned, pick up your cargo and fly to your \ndestination, which will be marked.",
	},
}

function getJobTable()
	return jobsTable
end
