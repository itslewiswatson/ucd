local LS = createColTube(1181, -1324, 10, 30, 10) -- All Saints Hospital
local LS2 = createColRectangle(1996.9545, -1451.0143, 106, 80) -- Jefferson Hospital
local SF = createColRectangle(-2745, 576, 135, 100) -- SF Hospital
local LV = createColPolygon(1559, 1801, 1559, 1801, 1558, 1910, 1674, 1910, 1681, 1806) -- LV Hospital
local jail = createColRectangle(3587, -1215, 260, 150)
local LVMech = createColRectangle(1937.5712, 2140.3237, 45, 40)
local LVRecovery = createColRectangle(1718.4382, 1993.0917, 38, 50)

local sZone = {LS, JF, SF1, LV, LS2, jail, LVMech, LVRecovery}

function isElementWithinSafeZone(element)
	if (not isElement(element)) then return false end
	if (getElementDimension(element) ~= 0 ) or ( getElementInterior( element ) ~= 0) then return false end
	for i, sZone in pairs(sZone) do
		if (isElementWithinColShape(element, sZone)) then return true end
	end
	return false
end

function getJail()
	return jail
end
