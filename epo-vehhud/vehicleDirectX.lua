-------------------------------------------------------------------
--// PROJECT: Union of Clarity and Diversity
--// RESOURCE: UCDvehicles
--// DEVELOPER(S): Lewis Watson (Noki)
--// DATE: 04/01/2016
--// PURPOSE: DirectX related vehicle functions.
--// FILE: \vehicleDirectX.lua [client]
-------------------------------------------------------------------

local sX, sY = guiGetScreenSize()
local nX, nY = 1920, 1080

function getElementSpeed(element, unit)
	if (unit == nil) then unit = 0 end
	if (isElement(element)) then
		local x,y,z = getElementVelocity(element)
		if (unit == "mph" or unit == 1 or unit == '1') then
			return (x^2 + y^2 + z^2) ^ 0.5 * 100
		else
			return (x^2 + y^2 + z^2) ^ 0.5 * 1.8 * 100
		end
	else
		outputDebugString("Not an element. Can't get speed")
		return false
	end
end

-- If you get in an out of your vehicles too fast it causes issues
Timer(
	function ()
		if (localPlayer.vehicle) then
			local veh = localPlayer.vehicle
			vehSpeedKMH = math.floor(getElementSpeed(veh))
		end
	end, 100, 0
)

function dxDrawCircle( x, y, width, height, color, angleStart, angleSweep, borderWidth )
	exports.shader_circle:dxDrawCircle( x, y, width, height, color, angleStart, angleSweep, borderWidth )
end

function RGB(minimum, maximum, value)
	if (value > maximum) then
		value = maximum
	end
	ratio = 2 * (value - minimum) / (maximum - minimum)
	local b = math.max(0, 255 * (1 - ratio))
	local r = math.max(0, 255 * (ratio - 1))
    local g = 255 - b - r
	return r, g, b
end

local diff = (1 + (1 / 3))

function renderVehicleHUD()
	if (not isPlayerHudComponentVisible("radar") or not localPlayer.vehicle or isPlayerMapVisible()) then return end
	if (not vehSpeedKMH) then return end
	
	local veh = localPlayer.vehicle
	local vehHealth = math.floor(veh.health / 10)
	local secretKMH = math.floor(getElementSpeed(veh))
	local vehFuel = 100 -- REPLACE THIS
	
	local hR, hG, hB
	if (vehHealth <= 80 and vehHealth > 60) then
		hR, hG, hB = 79, 115, 32
	elseif (vehHealth <= 60 and vehHealth > 50) then
		hR, hG, hB = 110, 105, 34
	elseif (vehHealth <= 50 and vehHealth > 40) then
		hR, hG, hB = 108, 63, 33
	elseif (vehHealth <= 40 and vehHealth > 30) then
		hR, hG, hB = 89, 54, 43
	elseif (vehHealth <= 30) then
		hR, hG, hB = 150, 54, 43
	else
		hR, hG, hB = 18, 90, 14
	end
	
	local sR, sG, sB = RGB(0, 220, vehSpeedKMH)
	
	dxDrawCircle(sX - 65, sY - 75, 105, 105, tocolor(sR, sG, sB, 255), 0, secretKMH * diff, 5)
	
	dxDrawText(tostring(vehSpeedKMH).." KPH\n"..tostring(vehHealth).."%", sX - 117.5 - 1, sY - 77.5 - 1, sX - 12.5 - 1, sY - 63.5 - 1, tocolor(0, 0, 0, 255), 1, "default", "center", "center", false, false, false, false, false)
	dxDrawText(tostring(vehSpeedKMH).." KPH\n"..tostring(vehHealth).."%", sX - 117.5 - 1, sY - 77.5 + 1, sX - 12.5 - 1, sY - 63.5 + 1, tocolor(0, 0, 0, 255), 1, "default", "center", "center", false, false, false, false, false)
	dxDrawText(tostring(vehSpeedKMH).." KPH\n"..tostring(vehHealth).."%", sX - 117.5 + 1, sY - 77.5 - 1, sX - 12.5 + 1, sY - 63.5 - 1, tocolor(0, 0, 0, 255), 1, "default", "center", "center", false, false, false, false, false)
	dxDrawText(tostring(vehSpeedKMH).." KPH\n"..tostring(vehHealth).."%", sX - 117.5 + 1, sY - 77.5 + 1, sX - 12.5 + 1, sY - 63.5 + 1, tocolor(0, 0, 0, 255), 1, "default", "center", "center", false, false, false, false, false)
	
	dxDrawText(tostring(vehSpeedKMH).." KPH\n"..tostring(vehHealth).."%", sX - 117.5, sY - 77.5, sX - 12.5, sY - 63.5, tocolor(255, 255, 255, 255), 1, "default", "center", "center", false, false, false, false, false)

	dxDrawCircle(sX - 65, sY - 75, 90, 90, tocolor(hR, hG, hB, 255), 0, vehHealth * 3.6, 5)
	
	-- Fuel
	dxDrawCircle(sX - 150, sY - 75, 55, 55, tocolor(100, 100, 150, 255), 0, vehFuel * 3.6, 4)
	
	dxDrawText(tostring(vehFuel).."%", sX - 285 - 1, sY - 75 - 1, sX - 12.5 - 1, sY - 63.5 - 1 - 6, tocolor(0, 0, 0, 255), 1, "default", "center", "center", false, false, false, false, false)
	dxDrawText(tostring(vehFuel).."%", sX - 285 - 1, sY - 75 + 1, sX - 12.5 - 1, sY - 63.5 + 1 - 6, tocolor(0, 0, 0, 255), 1, "default", "center", "center", false, false, false, false, false)
	dxDrawText(tostring(vehFuel).."%", sX - 285 + 1, sY - 75 - 1, sX - 12.5 + 1, sY - 63.5 - 1 - 6, tocolor(0, 0, 0, 255), 1, "default", "center", "center", false, false, false, false, false)
	dxDrawText(tostring(vehFuel).."%", sX - 285 + 1, sY - 75 + 1, sX - 12.5 + 1, sY - 63.5 + 1 - 6, tocolor(0, 0, 0, 255), 1, "default", "center", "center", false, false, false, false, false)
	dxDrawText(tostring(vehFuel).."%", sX - 285 + 0, sY - 75 + 0, sX - 12.5 + 0, sY - 63.5 + 0 - 6, tocolor(255, 255, 255, 255), 1, "default", "center", "center", false, false, false, false, false)
end
addEventHandler("onClientHUDRender", root, renderVehicleHUD)

