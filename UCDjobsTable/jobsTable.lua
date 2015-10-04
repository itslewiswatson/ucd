

local jobsTable = 
{
	["Pilot"] = 
	{
		team = "Aviators",
		markerCoords =
		{
			{1447, -2287, 13},
			{1308.4971, 1618.2949, 10.8203},
			{-1242.5739, 21.0195, 14.1484},
		},
		markerColour =
		{
			255, 255, 255
		},
		skin =
		{
			{61, "Male Pilot"},
			{0, "Placeholder"},
		},
		blipID = 56,
		desc = "A pilot's job is to transport goods and people around San Andreas, via the airways",
	},
}

function getJobTable()
	return jobsTable
end

------------------------------------------------------------------------
-- Testing out the table loop
------------------------------------------------------------------------

for i, v in pairs(jobsTable) do
	for a, b in pairs(v.markerCoords) do
		local marker = createMarker(b[1], b[2], b[3])
		createBlipAttachedTo(marker, v.blipID)
	end
end
