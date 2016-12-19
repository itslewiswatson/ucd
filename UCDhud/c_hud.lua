local joinTick = getTickCount()
local ping = getPlayerPing(localPlayer)
local fps = localPlayer:getData("FPS") or 0
local uptime = 0
local sX, sY = guiGetScreenSize()

Timer(
	function ()
		ping = getPlayerPing(localPlayer)
		fps = localPlayer:getData("FPS") or 0
		uptime = getTickCount() - joinTick
	end, 1000, 0
)

addEventHandler("onClientRender", root,
	function ()
		if (Resource.getFromName("UCDaccounts") and Resource.getFromName("UCDaccounts").state == "running") then
			if (not isPlayerMapVisible() and exports.UCDaccounts:isPlayerLoggedIn(localPlayer)) then
				local timeString
				local uptime2 = math.floor(uptime) / 1000 -- Seconds
				if (uptime2) then
					local days, hours, minutes, seconds
					days = math.floor(uptime2 / 86400)
					hours = math.floor((uptime2 - (days * 86400)) / 3600)
					minutes = math.floor((uptime2 - ((days * 86400) + (hours * 3600))) / 60)
					seconds = math.floor(uptime2 - ((days * 86400) + (hours * 3600) + (minutes * 60)))
					if (days < 1) then
						if (hours < 1) then
							timeString = minutes.." minutes"
							if (minutes < 1) then
								timeString = seconds.." seconds"
							else
								timeString = minutes.." minutes"
							end
						else
							timeString = hours.." hours, "..minutes.." minutes"
						end
					else
						timeString = days.." days, "..hours.." hours, "..minutes.." minutes"
					end
				end

				dxDrawText("Uptime: "..timeString.." ─ FPS: "..fps.." ─ Ping: "..ping, 0 - 1, 0 - 1, (sX - 5) - 1, 16 - 1, tocolor(0, 0, 0, 255), 1, "default-bold", "right", "top", false, false, false, false, false)
				dxDrawText("Uptime: "..timeString.." ─ FPS: "..fps.." ─ Ping: "..ping, 0 + 1, 0 - 1, (sX - 5) + 1, 16 - 1, tocolor(0, 0, 0, 255), 1, "default-bold", "right", "top", false, false, false, false, false)
				dxDrawText("Uptime: "..timeString.." ─ FPS: "..fps.." ─ Ping: "..ping, 0 - 1, 0 + 1, (sX - 5) - 1, 16 + 1, tocolor(0, 0, 0, 255), 1, "default-bold", "right", "top", false, false, false, false, false)
				dxDrawText("Uptime: "..timeString.." ─ FPS: "..fps.." ─ Ping: "..ping, 0 + 1, 0 + 1, (sX - 5) + 1, 16 + 1, tocolor(0, 0, 0, 255), 1, "default-bold", "right", "top", false, false, false, false, false)
				dxDrawText("Uptime: "..timeString.." ─ FPS: "..fps.." ─ Ping: "..ping, 0, 0, (sX - 5), 16, tocolor(255, 255, 255, 255), 1, "default-bold", "right", "top", false, false, false, false, false)
			end
		end
	end
)

--[[
local sX, sY = 1366, 768
local sX, sY = guiGetScreenSize()
local nX, nY = 1366, 768
local iX, iY = 1920, 1080

function isLocalPlayerCustomHUDEnabled()
	if (isPlayerMapVisible() or (not isPlayerHudComponentVisible("radar"))) then
		return false
	end
	return true
end

local disabledHUD = {"ammo", "health", "armour", "breath", "clock", "money", "weapon", "wanted"}

function getDisabledHUD()
	return disabledHUD
end

-- Actual HUD

-- Disabled the in-built HUD on resource start
for _, v in pairs(getDisabledHUD()) do
	showPlayerHudComponent(v, false)
end

addEventHandler("onClientResourceStop", resourceRoot,
	function ()
		for _, v in pairs(getDisabledHUD()) do
			showPlayerHudComponent(v, true)
		end
	end
)

function renderClock()
	if (not isPlayerHudComponentVisible("radar") or isPlayerMapVisible()) then return end
	
	local h, m = getTime()
	if m < 10 then
		m = "0"..m
	end
	if h < 10 then
		h = "0"..h
	end
	
	local scaleX, scaleY
	scaleX = sX / iX
	scaleY = sY / iY
	
	dxDrawText(h..":"..m, ((1637 / iX) * sX) - 1, ((67 / iY) * sY) - 1, ((1822 / iX) * sX) - 1, ((109 / iY) * sY)- 1, tocolor(0, 0, 0, 255), (scaleX + scaleY) * 2, "default", "right", "bottom", false, false, false, false, false)
	dxDrawText(h..":"..m, ((1637 / iX) * sX) + 1, ((67 / iY) * sY) - 1, ((1822 / iX) * sX) + 1, ((109 / iY) * sY) - 1, tocolor(0, 0, 0, 255), (scaleX + scaleY) * 2, "default", "right", "bottom", false, false, false, false, false)
	dxDrawText(h..":"..m, ((1637 / iX) * sX) - 1, ((67 / iY) * sY) + 1, ((1822 / iX) * sX) - 1, ((109 / iY) * sY) + 1, tocolor(0, 0, 0, 255), (scaleX + scaleY) * 2, "default", "right", "bottom", false, false, false, false, false)
	dxDrawText(h..":"..m, ((1637 / iX) * sX) + 1, ((67 / iY) * sY) + 1, ((1822 / iX) * sX) + 1, ((109 / iY) * sY) + 1, tocolor(0, 0, 0, 255), (scaleX + scaleY) * 2, "default", "right", "bottom", false, false, false, false, false)
	dxDrawText(h..":"..m, ((1637 / iX) * sX), ((67 / iY) * sY), ((1822 / iX) * sX), ((109 / iY) * sY), tocolor(255, 255, 255, 255), (scaleX + scaleY) * 2, "default", "right", "bottom", false, false, false, false, false)
	
end
addEventHandler("onClientRender", root, renderClock)

-- This is still optimized for 1366x768
function renderWeapons2()
	if (not isPlayerHudComponentVisible("radar") or isPlayerMapVisible()) then return end
	
	local wepID = getPedWeapon(localPlayer)
	imagePath = ":UCDhud/icons/"..getWeaponNameFromID(wepID)..".png"
	dxDrawImage((1064 / nX) * sX, (39 / nY) * sY, (92 / nX) * sX, (90 / nY) * sY, imagePath, 0, 0, 0, tocolor(255, 255, 255, 255), false)
end
addEventHandler("onClientRender", root, renderWeapons2)

-- This is still optimized for 1366x768
function renderWeapons()
	if (not isPlayerHudComponentVisible("radar") or isPlayerMapVisible()) then return end
	
	local wepSlot = getPedWeaponSlot(localPlayer)
	local clipAmmo = getPedAmmoInClip(localPlayer)
	local totalAmmo = getPedTotalAmmo(localPlayer)
	local wepID = getPedWeapon(localPlayer)
	local ammoIndicatorText = clipAmmo.."/"..totalAmmo - clipAmmo
	
	if (wepSlot == 6 or wepSlot == 8 or wepID == 25 or wepID == 35 or wepID == 36) then
		ammoIndicatorText = tostring(totalAmmo)
	end

	if (wepSlot == 0 or wepSlot == 1 or wepSlot == 10 or wepSlot == 12 or wepID == 44 or wepID == 45 or wepID == 46) then
		return
	end
	
	local scaleX, scaleY
	scaleX = sX / nX
	scaleY = sY / nY
	
	dxDrawText(ammoIndicatorText, ((1078 / nX) * sX) - 1, ((110 / nY) * sY) - 1, ((1140 / nX) * sX) - 1, ((134 / nY) * sY) - 1, tocolor(0, 0, 0, 255), (scaleX + scaleY) / (1 + (1 / 3)), "default-bold", "center", "top", false, false, false, false, false)
	dxDrawText(ammoIndicatorText, ((1078 / nX) * sX) + 1, ((110 / nY) * sY) - 1, ((1140 / nX) * sX) + 1, ((134 / nY) * sY) - 1, tocolor(0, 0, 0, 255), (scaleX + scaleY) / (1 + (1 / 3)), "default-bold", "center", "top", false, false, false, false, false)
	dxDrawText(ammoIndicatorText, ((1078 / nX) * sX) - 1, ((110 / nY) * sY) + 1, ((1140 / nX) * sX) - 1, ((134 / nY) * sY) + 1, tocolor(0, 0, 0, 255), (scaleX + scaleY) / (1 + (1 / 3)), "default-bold", "center", "top", false, false, false, false, false)
	dxDrawText(ammoIndicatorText, ((1078 / nX) * sX) + 1, ((110 / nY) * sY) + 1, ((1140 / nX) * sX) + 1, ((134 / nY) * sY) + 1, tocolor(0, 0, 0, 255), (scaleX + scaleY) / (1 + (1 / 3)), "default-bold", "center", "top", false, false, false, false, false)
	dxDrawText(ammoIndicatorText, ((1078 / nX) * sX)	, ((110 / nY) * sY), 	 ((1140 / nX) * sX), 	 ((134 / nY) * sY), 	tocolor(255, 255, 255, 255), (scaleX + scaleY) / (1 + (1 / 3)), "default-bold", "center", "top", false, false, false, false, false)	
end
addEventHandler("onClientRender", root, renderWeapons)

-- All functions from here on in are optimized for 1920x1080 (the res they were made in)
function renderArmour()
	if (not isPlayerHudComponentVisible("radar") or isPlayerMapVisible()) then return end	
	local armourLevel = getPedArmor(localPlayer)
	if armourLevel == 0 then return end
	
	dxDrawRectangle((1639 / iX) * sX, (112 / iY) * sY, (181 / iX) * sX, (18 / iY) * sY, tocolor(0, 0, 0, 255), false)
	dxDrawRectangle((1641 / iX) * sX, (114 / iY) * sY, (175 / iX) * sX, (14 / iY) * sY, tocolor(255, 255, 255, 150), false)
	dxDrawRectangle((1641 / iX) * sX, (114 / iY) * sY, armourLevel * ((1.75 / iX) * sX), (14 / iY) * sY, tocolor(255, 255, 255, 255), false)
end
addEventHandler("onClientRender", root, renderArmour)

function renderHealthBar()
	if (not isPlayerHudComponentVisible("radar") or isPlayerMapVisible()) then return end
	
	if (getPedStat(localPlayer, 24) == 1000) then
		dxDrawRectangle((1498 / iX) * sX, (185 / iY) * sY, (323 / iX) * sX, (18 / iY) * sY, tocolor(0, 0, 0, 255), false)
		dxDrawRectangle((1500 / iX) * sX, (187 / iY) * sY, (320 / iX) * sX, (14 / iY) * sY, tocolor(255, 0, 0, 150), false)
		dxDrawRectangle((1500 / iX) * sX, (187 / iY) * sY, localPlayer.health * ((1.6 / iX) * sX), (14 / iY) * sY, tocolor(255, 0, 0, 255), false)
	else
		dxDrawRectangle((1639 / iX) * sX, (156 / iY) * sY, (181 / iX) * sX, (18 / iY) * sY, tocolor(0, 0, 0, 255), false)
		dxDrawRectangle((1641 / iX) * sX, (158 / iY) * sY, (175 / iX) * sX, (14 / iY) * sY, tocolor(255, 0, 0, 150), false)	
		dxDrawRectangle((1641 / iX) * sX, (158 / iY) * sY, localPlayer.health * ((1.76 / iX) * sX), (14 / iY) * sY, tocolor(255, 0, 0, 255), false)	
	end
end
addEventHandler("onClientRender", root, renderHealthBar)

function renderOxygen()
	if (not isPlayerHudComponentVisible("radar") or isPlayerMapVisible()) then return end	
	if not isElementInWater(localPlayer) then return end
	local oxygenLevel = getPedOxygenLevel(localPlayer) / 10
	
	if (getPedStat(localPlayer, 24) == 1000) then
		gY, hY = 147, 150
	else
		gY, hY = 134, 137
	end
	
	dxDrawRectangle((1639 / iX) * sX, (gY / iY) * sY, (181 / iX) * sX, (18 / iY) * sY, tocolor(0, 0, 0, 255), false)
	dxDrawRectangle((1641 / iX) * sX, (hY / iY) * sY, oxygenLevel * (1.75 / iX) * sX, (14 / iY) * sY, tocolor(25, 208, 215, 255), false)
end
addEventHandler("onClientRender", root, renderOxygen)

function renderMoney()
	if (not isPlayerHudComponentVisible("radar") or isPlayerMapVisible()) then return end
	local r, g, b
	local cY, fY
	local finalOutputM = exports.UCDutil:tocomma(localPlayer:getMoney())
	
	if (getPedStat(localPlayer, 24) == 1000) then
		cY = 209
		fY = 244
	else
		cY = 183	
		fY = 218
	end
	if (localPlayer:getMoney() < 0) then
		r, g, b = 178, 34, 34
	else
		r, g, b = 45, 180, 80
	end
	
	dxDrawText("$"..finalOutputM, ((1506 / iX) * sX) - 1, ((cY / iY) * sY) - 1, ((1822 / iX) * sX) - 1, ((244 / iY) * sY) - 1, tocolor(0, 0, 0, 255), 1.80, "pricedown", "right", "top", false, false, false, false, false)
	dxDrawText("$"..finalOutputM, ((1506 / iX) * sX) + 1, ((cY / iY) * sY) - 1, ((1822 / iX) * sX) + 1, ((244 / iY) * sY) - 1, tocolor(0, 0, 0, 255), 1.80, "pricedown", "right", "top", false, false, false, false, false)
	dxDrawText("$"..finalOutputM, ((1506 / iX) * sX) - 1, ((cY / iY) * sY) + 1, ((1822 / iX) * sX) - 1, ((244 / iY) * sY) + 1, tocolor(0, 0, 0, 255), 1.80, "pricedown", "right", "top", false, false, false, false, false)
	dxDrawText("$"..finalOutputM, ((1506 / iX) * sX) + 1, ((cY / iY) * sY) + 1, ((1822 / iX) * sX) + 1, ((244 / iY) * sY) + 1, tocolor(0, 0, 0, 255), 1.80, "pricedown", "right", "top", false, false, false, false, false)
	dxDrawText("$"..finalOutputM, ((1506 / iX) * sX)	, ((cY / iY) * sY)	  , ((1822 / iX) * sX)    , ((244 / iY) * sY), 	   tocolor(r, g, b, 255), 1.80, "pricedown", "right", "top", false, false, false, false, false)
end
addEventHandler("onClientRender", root, renderMoney)

function renderWanted()
	if (not isPlayerHudComponentVisible("radar") or isPlayerMapVisible() or localPlayer:getWantedLevel() == 0) then return end
	
	for i = 1, localPlayer:getWantedLevel() do
		local offset = 34 -- 1920 / 55 (55 being the old offset)
		-- The distance in between needs to be relative to the screen resolution
		-- This is level with the rest of the HUD at 1920x1080 and 1366x768
		dxDrawImage(((1780 / iX) * sX) - ((sX / offset) * (i - 1)), (280 / iY) * sY, (48 / iX) * sX, (48 / iY) * sY, "star.png")
	end
end
addEventHandler("onClientRender", root, renderWanted)
]]

--[[
24 = 100:
	dxDrawRectangle(1498, 185, 323, 18, tocolor(0, 0, 0, 255), false)
	dxDrawRectangle(1501, 188, 317, 12, tocolor(255, 255, 255, 255), false)
else:
	dxDrawRectangle(1639, 161, 181, 18, tocolor(0, 0, 0, 255), false)
	dxDrawRectangle(1642, 164, 175, 12, tocolor(255, 255, 255, 255), false)
	
$$$$$
	-- health 1000
        dxDrawText("$99,999,999", 1505, 208, 1821, 244 - 1, tocolor(0, 0, 0, 255), 1.80, "pricedown", "right", "top", false, false, false, false, false)
        dxDrawText("$99,999,999", 1507, 208, 1823, 244 - 1, tocolor(0, 0, 0, 255), 1.80, "pricedown", "right", "top", false, false, false, false, false)
        dxDrawText("$99,999,999", 1506, 210, 1821, 244 + 1, tocolor(0, 0, 0, 255), 1.80, "pricedown", "right", "top", false, false, false, false, false)
        dxDrawText("$99,999,999", 1507, 210, 1823, 244 + 1, tocolor(0, 0, 0, 255), 1.80, "pricedown", "right", "top", false, false, false, false, false)
        dxDrawText("$99,999,999", 1506, 209, 1822, 244, tocolor(255, 255, 255, 255), 1.80, "pricedown", "right", "top", false, false, false, false, false)
		
		dxDrawText("$99,999,999", 1505, 182, 1821, 217, tocolor(0, 0, 0, 255), 1.80, "pricedown", "right", "top", false, false, false, false, false)
        dxDrawText("$99,999,999", 1507, 182, 1823, 217, tocolor(0, 0, 0, 255), 1.80, "pricedown", "right", "top", false, false, false, false, false)
        dxDrawText("$99,999,999", 1506, 184, 1821, 219, tocolor(0, 0, 0, 255), 1.80, "pricedown", "right", "top", false, false, false, false, false)
        dxDrawText("$99,999,999", 1507, 184, 1823, 219, tocolor(0, 0, 0, 255), 1.80, "pricedown", "right", "top", false, false, false, false, false)
        dxDrawText("$99,999,999", 1506, 183, 1822, 218, tocolor(255, 255, 255, 255), 1.80, "pricedown", "right", "top", false, false, false, false, false)
		
		-- arm
        dxDrawRectangle(1639, 112, 181, 18, tocolor(0, 0, 0, 255), false)
        dxDrawRectangle(1642, 115, 175, 12, tocolor(255, 255, 255, 255), false)
		
		-- oxygenLevel
		dxDrawRectangle(1639, 134, 181, 18, tocolor(0, 0, 0, 255), false)
		dxDrawRectangle(1642, 137, 175, 12, tocolor(255, 255, 255, 255), false)
--]]
