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
	dxDrawText(tostring(vehicle.name), 0, 840, 1920, 887, tocolor(255, 255, 255, alpha), 3.00, "default", "center", "center", false, false, false, false, false)
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
	alpha = 0
	lol("+")
	setTimer(lol, 3500, 1, "-")
	addEventHandler("onClientRender", root, lolrender)
	t = setTimer(function () removeEventHandler("onClientRender", root, lolrender) end, 4600, 1)
end
addEventHandler("onClientPlayerVehicleEnter", root, renderVehicleName)

-- If you get in an out of your vehicles too fast it causes issues


function renderVehicleHUD()
	if (not isPlayerHudComponentVisible("radar") or not localPlayer.vehicle or isPlayerMapVisible()) then return end
	
	local veh = localPlayer.vehicle
	local vehHealth = math.floor(veh.health / 10)
	local vehSpeedMPH = math.floor(exports.UCDutil:getElementSpeed(veh, "mph"))
	local vehSpeedKMH = math.floor(exports.UCDutil:getElementSpeed(veh))
	local nitro = getVehicleNitroCount(veh) or 0
	local zone = getZoneName(veh.position)
	local dial = 1701 * ((vehSpeedMPH / 1300) + 1)
	if (dial > ((1910 / nX) * sX)) then
		dial = (1910 / nX) * sX
	end
	local r, g, b
	if (vehHealth <= 80 and vehHealth > 60) then
		r, g, b = 79, 115, 32
	elseif (vehHealth <= 60 and vehHealth > 50) then
		r, g, b = 110, 105, 34
	elseif (vehHealth <= 50 and vehHealth > 40) then
		r, g, b = 108, 63, 33
	elseif (vehHealth <= 40 and vehHealth > 30) then
		r, g, b = 89, 54, 43
	elseif (vehHealth <= 30) then
		r, g, b = 150, 54, 43
	else
		r, g, b = 18, 90, 14
	end
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
	--]]
	-- 1038 --> 1045 (7)
	
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
end
addEventHandler("onClientRender", root, renderVehicleHUD)
