local LS = createColTube(1181, -1324, 10, 30, 10) -- All Saints Hospital
local LS2 = createColRectangle(1980, -1454, 125, 80) -- Jefferson Hospital
local SF = createColRectangle(-2745, 576, 135, 100) -- SF Hospital
local LV = createColPolygon(1559, 1801, 1559, 1801, 1558, 1910, 1674, 1910, 1681, 1806) -- LV Hospital

local sZone = {LS, JF, SF1, LV}

function isElementWithinSafeZone(element)
	if not isElement(element) then return false end
	if (element.dimension ~= 0 or element.interior ~= 0) then return false end
	for i, sZone in pairs(sZone) do
		if (isElementWithinColShape(element, sZone)) then return true end
	end
	return false
end

function zoneEntry(element, matchingDimension)
	if (element ~= localPlayer or not matchingDimension) then return end
	if (isControlEnabled("aim_weapon") and localPlayer.team ~= "Admins") then
		toggleControl("aim_weapon", false)
		toggleControl("fire", false)
	end
	--exports.UCDdx:new("You have entered a safe zone", 50, 200, 70)
	exports.UCDdx:add("Safe Zone", 0, 255, 0)
end

function zoneExit(element, matchingDimension)
	if (element ~= localPlayer or not matchingDimension) then return end
	--exports.UCDdx:new("You have left a safe zone", 50, 200, 70)
	exports.UCDdx:del("Safe Zone")
end
	
for i, sZone in pairs(sZone) do
	addEventHandler("onClientColShapeHit", sZone, zoneEntry)
	addEventHandler("onClientColShapeLeave", sZone, zoneExit)
end

function cancelDmg()
	if (isElementWithinSafeZone(localPlayer)) then
		if (getPlayerWantedLevel(localPlayer) > 0) then return end
		cancelEvent()
	end
end
addEventHandler("onClientPlayerDamage", root, cancelDmg)
