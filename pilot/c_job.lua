local spawners = 
{
	small = {
		-- LS
		{1983.8929, -2383.3296, 13.5469},
		{1983.8929, -2315.3296, 13.5469},
	},
	large = {
		-- LS
		{1939.9171, -2343.4268, 13.5469},
	},
}

local vehicles = 
{
	["large"] = {592, 577, 553, 519},
	["small"] = {511, 512, 593, 513},
}

function handleMarkerHit(hitPlayer, matchingDimension)
	if (hitPlayer == localPlayer) and (matchingDimension) then
		local _, _, pZ = getElementPosition(localPlayer)
		local _, _, mZ = getElementPosition(source)
		if (pZ) <= (mZ + 1) then
			GUI_open(source)
		end
	end
end

for k, v in pairs(spawners) do
	for x, y in pairs(v) do
		s = createMarker(y[1], y[2], y[3] - 1, "cylinder", 2, 0, 0, 0, 255, 125)
		setElementData(s, "pilot.markerType", k)
		addEventHandler("onClientMarkerHit", s, handleMarkerHit)
	end
end
