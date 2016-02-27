locs = 
{
	{2290.5786, -1676.5746, 14.3835}, -- Grove Street
	{1854.7446, -2409.2378, 13.5547}, -- LS Airport
	{ 721.8774, -1634.1714, -0.05}, -- Near canal boat shop, LS
}

for k, v in ipairs(locs) do
	local m = Marker(v[1], v[2], v[3] - 1, "cylinder", 4, 255, 100, 100, 255)
	Blip.createAttachedTo(m, 63, nil, nil, nil, nil, nil, 0, 350)
end

