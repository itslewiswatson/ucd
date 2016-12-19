local zones = {
	{createColRectangle, 3587, -1215, 260, 150}, -- #1 is always jail
	
	{createColRectangle, 1155.9263, -1353.4421, 60, 60},
	{createColRectangle, 1996.9545, -1451.0143, 106, 80},
	{createColRectangle, -2745, 576, 135, 100},
	{createColRectangle, 1559, 1801, 115, 109},
	{createColRectangle, 1937.5712, 2140.3237, 45, 40},
	{createColRectangle, 1718.4382, 1993.0917, 38, 50},
}

local sZone = {}
local jail

for _, data in ipairs(zones) do
	local col = data[1](data[2], data[3], data[4], data[5])
	table.insert(sZone, col)
	
	if (i == 1) then
		jail = col
	end
end

--local sZone = {LS, JF, SF1, LV, LS2, jail, LVMech, LVRecovery}

function isElementWithinSafeZone(element)
	if not isElement(element) then return false end
	if (element.dimension ~= 0 or element.interior ~= 0) then return false end
	for i, sZone in pairs(sZone) do
		if (isElementWithinColShape(element, sZone)) then return true end
	end
	return false
end

function getJail()
	return jail
end
