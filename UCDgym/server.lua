local markersData =
{
	["walk"] =
	{
		{x = 773.0488, y = 5.4462, z = 1000.7802, dim = 13000, int = 5}, -- LS Gym
		{x = 763.2203, y = -47.9901, z = 1000.5859, dim = 13001, int = 6}, -- SF Gym
		{x = 765.072, y = -76.6134, z = 1000.6563, dim = 13002, int = 7}, -- LV Gym
	},
	["fight"] =
	{
		{x = 761.3682, y = 5.5028, z = 1000.7098, dim = 13000, int = 5}, -- LS Gym
		{x = 768.0975, y = -37.4607, z = 1000.6865, dim = 13001, int = 6}, -- SF Gym
		{x = 766.7685, y = -62.0495, z = 1000.6563, dim = 13002, int = 7}, -- LV Gym
	}
}
local markers = {}

function onMarkerHit(plr, matchingDimension)
	if (not plr or not isElement(plr) or plr.type ~= "player" or not matchingDimension) then return end
	local style
	for name, markers2 in pairs(markers) do
		for _, marker in ipairs(markers2) do
			if (source == marker) then
				style = name
			end
		end
	end
	if (not style) then return end
	triggerClientEvent(plr, "showStyleGUI", resourceRoot, style)
end
addEventHandler("onMarkerHit", root, onMarkerHit)

for name, positions in pairs(markersData) do
	for _, data in ipairs(positions) do
		local marker = Marker(data.x, data.y, data.z-1, "cylinder", 2, 0, 255, 0)
		marker.dimension = data.dim
		marker.interior = data.int
		if (name == "fight") then
			marker:setColor(255, 0, 0, 255)
		end
		if (not markers[name]) then
			markers[name] = {}
		end
		table.insert(markers[name], marker)
	end
end

addEvent("buyStyle", true)
addEventHandler("buyStyle", resourceRoot,
	function (style, name, price, id)
		if (style == "walk") then
			name = name.. "walking style"
		elseif (style == "fight") then
			name = name.." fighting style"
		end
		if (client.money >= price) then
			client.money = client.money - price
			if (style == "walk") then
				client.walkingStyle = id
				exports.UCDaccounts:SAD(client, "walkstyle", id)
			elseif (style == "fight") then
				client.fightingStyle = id
				--exports.UCDaccounts:SAD(client, "fightstyle", id)
			end
			exports.UCDdx:new(client, "You successfully bought "..name, 0, 255, 0)
		else
			exports.UCDdx:new(client, "You don't have enough money to buy "..name, 255, 0, 0)
		end
	end
)