-------------------------------------------------------------------
--// PROJECT: Union of Clarity and Diversity
--// RESOURCE: UCDvehicles
--// DEVELOPER(S): Lewis Watson (Noki)
--// DATE: 04/01/2016
--// PURPOSE: DirectX related vehicle functions.
--// FILE: \vehicleDirectX.lua [client]
-------------------------------------------------------------------

setPlayerHudComponentVisible("vehicle_name", false)

local sX, sY = guiGetScreenSize()
local nX, nY = 1920, 1080

function lol(pm)
	if pm == "+" then
		setTimer(
			function ()
				alpha = alpha + 12.75
			end, 50, 20
		)		
	elseif pm == "-" then
		setTimer(
			function ()
				alpha = alpha - 12.75
				--if alpha == 0 then render = nil end
			end, 50, 20
		)
	end
end

function render(vehicle)
	if (not isPlayerMapVisible()) then
		dxDrawText(tostring(vehicle.name), 0, sY - (sY / 4), sX, sY, tocolor(255, 255, 255, alpha), 3.00, "default", "center", "center", false, false, false, false, false)
	end
end

function lolrender()
	if localPlayer.vehicle ~= false then
		if alpha ~= 0 then
			local vehicle = localPlayer.vehicle
			render(vehicle)
		end
	else
		removeEventHandler("onClientRender", root, lolrender)
		if isTimer(t) then
			killTimer(t)
		end
	end
end

function renderVehicleName(vehicle)
	--if (vehicle ~= localPlayer.vehicle) then return end
	alpha = 0
	lol("+")
	setTimer(lol, 3500, 1, "-")
	addEventHandler("onClientRender", root, lolrender)
	t = setTimer(function () removeEventHandler("onClientRender", root, lolrender) end, 4600, 1)
end
addEventHandler("onClientPlayerVehicleEnter", localPlayer, renderVehicleName)

-- If you get in an out of your vehicles too fast it causes issues

Timer(
	function ()
		if (localPlayer.vehicle) then
			local veh = localPlayer.vehicle
			vehSpeedKMH = math.floor(exports.UCDutil:getElementSpeed(veh, unit))
		end
	end, 100, 0
)

function dxDrawCircle( x, y, width, height, color, angleStart, angleSweep, borderWidth )
	exports.shader_circle:dxDrawCircle( x, y, width, height, color, angleStart, angleSweep, borderWidth )
end

--[[
def rgb(minimum, maximum, value):
    minimum, maximum = float(minimum), float(maximum)
    ratio = 2 * (value-minimum) / (maximum - minimum)
    b = int(max(0, 255*(1 - ratio)))
    r = int(max(0, 255*(ratio - 1)))
    g = 255 - b - r
    return r, g, b
--]]
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
	local secretKMH = math.floor(exports.UCDutil:getElementSpeed(veh))
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
	--[[
	if (vehSpeedKMH >= 200) then
		sR, sG, sB = 160, 25, 25
	elseif (vehSpeedKMH < 200 and vehSpeedKMH >= 160) then
		sR, sG, sB = 255, 135, 25
	elseif (vehSpeedKMH < 160 and vehSpeedKMH >= 120) then
		sR, sG, sB = 255, 200, 55
	elseif (vehSpeedKMH < 120 and vehSpeedKMH >= 90) then
		sR, sG, sB = 150, 200, 55
	elseif (vehSpeedKMH < 90 and vehSpeedKMH >= 50) then
		sR, sG, sB = 65, 200, 150
	else
		sR, sG, sB = 65, 200, 220
	end
	--]]
	--[[
	if (vehSpeedKMH <= 255) then
		sR = vehSpeedKMH
	else
		sR = 255
	end
	if (255 - vehSpeedKMH >= 0) then
		sB = 255 - vehSpeedKMH
	else
		sB = 0
	end
	if (vehSpeedKMH > 0) then
		sG = getEasingValue(vehSpeedKMH / 360, "SineCurve") * 150 --math.asin(math.log(vehSpeedKMH) / 10) * 20
	else
		sG = 0
	end
	--]]
	
	--[[
	dxDrawRectangle(1701, 998, 209, 15, tocolor(0, 0, 0, 100), false)
	dxDrawRectangle(1701, 1038, 209, 15, tocolor(0, 0, 0, 100), false)
	dxDrawText("GPS: "..tostring(zone), 1701, 1038, 1910, 1053, tocolor(255, 255, 255, 255), 1.00, "default", "center", "center", false, false, false, false, false)
	dxDrawRectangle(1701, 1018, 102, 15, tocolor(0, 0, 0, 100), false)
	dxDrawRectangle(1808, 1018, 102, 15, tocolor(0, 0, 0, 100), false)
	
	--dxDrawRectangle(1703, 1020, 98, 11, tocolor(18, 90, 14, 255), false)
	dxDrawRectangle(1703, 1020, vehHealth * 0.98, 11, tocolor(r, g, b, 255), false)
	dxDrawText(tostring(vehHealth).."%", 1701, 1018, 1808, 1033, tocolor(255, 255, 255, 255), 1.00, "default", "center", "center", false, false, false, false, false)
	
	dxDrawRectangle(1810, 1020, 98, 11, tocolor(255, 255, 255, 25), false)
	dxDrawText("Fuel: 100", 1808, 1018, 1910, 1033, tocolor(100, 100, 150, 255), 1.00, "default", "center", "center", false, false, false, false, false)
	dxDrawText(tostring(vehSpeedKMH).." KPH | "..tostring(vehSpeedMPH).." MPH | "..tostring(nitro).." NOS", 1711, 998, 1910, 1013, tocolor(255, 255, 255, 255), 1.00, "default", "left", "center", false, false, false, false, false)
	--]]
	--[[
	dxDrawRectangle(1701, 1005, 209, 15, tocolor(0, 0, 0, 100), false)
	dxDrawRectangle(1701, 1045, 209, 15, tocolor(0, 0, 0, 100), false)
	dxDrawText("GPS: "..tostring(zone), 1701, 1052, 1910, 1053, tocolor(255, 255, 255, 255), 1.00, "default", "center", "center", false, false, false, false, false)
	dxDrawRectangle(1701, 1025, 102, 15, tocolor(0, 0, 0, 100), false)
	dxDrawRectangle(1808, 1025, 102, 15, tocolor(0, 0, 0, 100), false)
	
	--dxDrawRectangle(1703, 1020, 98, 11, tocolor(18, 90, 14, 255), false)
	dxDrawRectangle(1703, 1027, vehHealth * 0.98, 11, tocolor(r, g, b, 255), false)
	dxDrawText(tostring(vehHealth).."%", 1701, 1032, 1808, 1033, tocolor(255, 255, 255, 255), 1.00, "default", "center", "center", false, false, false, false, false)
	
	dxDrawRectangle(1810, 1027, 98, 11, tocolor(255, 255, 255, 25), false)
	dxDrawText("Fuel: 100", 1808, 1032, 1910, 1033, tocolor(100, 100, 150, 255), 1.00, "default", "center", "center", false, false, false, false, false)
	dxDrawText(tostring(vehSpeedKMH).." KPH | "..tostring(vehSpeedMPH).." MPH | "..tostring(nitro).." NOS", 1711, 1012, 1910, 1013, tocolor(255, 255, 255, 255), 1.00, "default", "left", "center", false, false, false, false, false)
	
	
	dxDrawRectangle(dial, 1003, 3, 17, tocolor(255, 255, 255, 255), false) -- Speed thing
	--]]
	-- 1038 --> 1045 (7)
	
	-- Speed
	--dxDrawCircle(sX - 65, sY - 75, 110, 110, tocolor(0, 0, 0, 100), 0, 360, 17.5)
	
	dxDrawCircle(sX - 65, sY - 75, 105, 105, tocolor(sR, sG, sB, 255), 0, secretKMH * diff, 3)
	
	local text = tostring(vehSpeedKMH).." "..tostring(unit):upper().."\n"..tostring(vehHealth).."%"
	
	dxDrawText(text, sX - 117.5 - 1, sY - 77.5 - 1, sX - 12.5 - 1, sY - 63.5 - 1, tocolor(0, 0, 0, 255), 1, "default", "center", "center", false, false, false, false, false)
	dxDrawText(text, sX - 117.5 - 1, sY - 77.5 + 1, sX - 12.5 - 1, sY - 63.5 + 1, tocolor(0, 0, 0, 255), 1, "default", "center", "center", false, false, false, false, false)
	dxDrawText(text, sX - 117.5 + 1, sY - 77.5 - 1, sX - 12.5 + 1, sY - 63.5 - 1, tocolor(0, 0, 0, 255), 1, "default", "center", "center", false, false, false, false, false)
	dxDrawText(text, sX - 117.5 + 1, sY - 77.5 + 1, sX - 12.5 + 1, sY - 63.5 + 1, tocolor(0, 0, 0, 255), 1, "default", "center", "center", false, false, false, false, false)
	
	dxDrawText(text, sX - 117.5, sY - 77.5, sX - 12.5, sY - 63.5, tocolor(255, 255, 255, 255), 1, "default", "center", "center", false, false, false, false, false)

	dxDrawCircle(sX - 65, sY - 75, 90, 90, tocolor(hR, hG, hB, 255), 0, vehHealth * 3.6, 3)
	
	-- Health
	--dxDrawCircle(sX - 65, sY - 75, 90, 90, tocolor(0, 0, 0, 100), 0, 360, 10)

	--dxDrawRectangle(sX - 219, sY - 75, 209, 15, tocolor(0, 0, 0, 100), false)
	--dxDrawRectangle(sX - 219, sY - 35, 209, 15, tocolor(0, 0, 0, 100), false)
	--dxDrawText("GPS: "..tostring(zone), sX - 219, sY - 28, sX - 10, sY - 27, tocolor(255, 255, 255, 255), 1, "default", "center", "center", false, false, false, false, false)
	
	--dxDrawRectangle(sX - 112, sY - 55, 102, 15, tocolor(0, 0, 0, 100), false)
	
	--dxDrawRectangle(sX - 219, sY - 77.5, 102, 15, tocolor(0, 0, 0, 100), false)
	--dxDrawRectangle(1703, 1020, 98, 11, tocolor(18, 90, 14, 255), false)
	--dxDrawRectangle(sX - 217, sY - 75.5, vehHealth * 0.98, 11, tocolor(r, g, b, 255), false)
	--dxDrawText(tostring(vehHealth).."%", sX - 219, sY - 75.5, sX - 112, sY - 63.5, tocolor(255, 255, 255, 255), 1, "default", "center", "center", false, false, false, false, false)
	
	--dxDrawRectangle(sX - 110, sY - 53, 98, 11, tocolor(255, 255, 255, 25), false)
	--dxDrawText("Fuel: 100", sX - 112, sY - 48, sX - 10, sY - 47, tocolor(100, 100, 150, 255), 1.00, "default", "center", "center", false, false, false, false, false)
	
	--dxDrawRectangle(sX - 217, sY - 73, 205, 11, tocolor(0, 255, 0, 100), false)
	--dxDrawRectangle(sX - 217, sY - 73, dial2, 11, tocolor(0, 255, 0, 100), false)
	--dxDrawText(tostring(vehSpeedKMH).." KPH | "..tostring(vehSpeedMPH).." MPH | "..tostring(nitro).." NOS", sX - 219, sY - 68, sX - 10, sY - 67, tocolor(255, 255, 255, 255), 1, "default", "center", "center", false, false, false, false, false)
	--outputDebugString(dial)
	--dxDrawRectangle(dial, sY - 77, 3, 17, tocolor(255, 255, 255, 255), false) -- Speed thing
end
addEventHandler("onClientHUDRender", root, renderVehicleHUD)

function addVehicleHelperText()
	local vehicle = localPlayer.vehicle
	if (not vehicle) then return end

	local owner = vehicle:getData("owner")
	if (owner) then
		local ownerText
		if (owner:lower():sub(owner:len()) == "s") then
			ownerText = owner.."' "..vehicle.name
		else 
			ownerText = owner.."'s "..vehicle.name
		end

		exports.UCDdx:add("vehicleInfo", ownerText, 255, 255, 255)
	end
end
addEventHandler("onClientVehicleEnter", root, addVehicleHelperText)
local dxHelperTimer = Timer(addVehicleHelperText, 5000, 0)

function removeVehicleHelperText()
	exports.UCDdx:del("vehicleInfo")
end
addEventHandler("onClientPlayerVehicleExit", root, removeVehicleHelperText)
addEventHandler("onClientPlayerWasted", root, removeVehicleHelperText)
addEventHandler("onClientElementDestroy", root,
	function ()
		if (localPlayer.vehicle and source == localPlayer.vehicle) then
			removeVehicleHelperText()
		end
	end
)

function toggleVehicleOwnerDX(new)
	removeEventHandler("onClientVehicleEnter", root, addVehicleHelperText)
	if (dxHelperTimer and isTimer(dxHelperTimer)) then
		dxHelperTimer:destroy()
	end
	removeVehicleHelperText()
	if (new == "Yes") then
		addVehicleHelperText()
		addEventHandler("onClientVehicleEnter", root, addVehicleHelperText)
		dxHelperTimer = Timer(addVehicleHelperText, 5000, 0)
	end
end
toggleVehicleOwnerDX(exports.UCDsettings:getSetting("vehicleownerdx"))
