local LS = createColTube(1181, -1324, 10, 30, 10) -- All Saints Hospital
local LS2 = createColRectangle(1980, -1454, 125, 80) -- Jefferson Hospital
local SF = createColRectangle(-2745, 576, 135, 100) -- SF Hospital
local LV = createColPolygon(1559, 1801, 1559, 1801, 1558, 1910, 1674, 1910, 1681, 1806) -- LV Hospital

local sZone = {LS, JF, SF1, LV}

function isElementWithinSafeZone(element)
	if not isElement(element) then return false end
	if (getElementDimension(element) ~= 0) or (getElementInterior(element) ~= 0) then return false end
	for i, sZone in pairs(sZone) do
		if (isElementWithinColShape(element, sZone)) then return true end
	end
	return false
end

function zoneEntry(element, matchingDimension)
	if (element ~= localPlayer or not matchingDimension) then return end
	if (getElementDimension(element) ~= 0) then return end
	if (getTeamName(getPlayerTeam(localPlayer)) == "Admins") then exports.UCDdx:new("You have entered a safe zone", 50, 200, 70) return end
	setPedWeaponSlot(localPlayer, 0)
	exports.UCDdx:new("You have entered a safe zone", 50, 200, 70)
end

function zoneExit()
	exports.UCDdx:new("You have left a safe zone", 50, 200, 70)
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


function cancelWepSwitch(_, currentWeaponSlot)
	if (not isElementWithinSafeZone(localPlayer)) then return end
	if (getElementDimension(localPlayer) ~= 0) then return end
	if (getTeamName(getPlayerTeam(localPlayer)) == "Admins") then return end
	if (currentWeaponSlot ~= 0) then
		setPedWeaponSlot(localPlayer, 0)
	end
end
addEventHandler("onClientPlayerWeaponSwitch", root, cancelWepSwitch)
