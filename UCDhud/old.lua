local sX, sY = guiGetScreenSize()
local nX, nY = 1366, 768
local disabledHUD = {"ammo", "health", "armour", "breath", "clock", "money", "weapon"}

--[[
24 = 100:
	dxDrawRectangle(1498, 185, 323, 18, tocolor(0, 0, 0, 255), false)
	dxDrawRectangle(1501, 188, 317, 12, tocolor(255, 255, 255, 255), false)
else:
	dxDrawRectangle(1639, 161, 181, 18, tocolor(0, 0, 0, 255), false)
	dxDrawRectangle(1642, 164, 175, 12, tocolor(255, 255, 255, 255), false)
--]]

function renderHealthBar()
	if (not isPlayerHudComponentVisible("radar") or isPlayerMapVisible()) then return end	
	health = getElementHealth(localPlayer)
	
	if (getPedStat(localPlayer, 24) == 1000) then
		--dxDrawRectangle((1066 / nX) * sX, (132 / nY) * sY, (229 / nX) * sX, (12 / nY) * sY, tocolor(0, 0, 0, 100), false)
		--dxDrawRectangle((1068 / nX) * sX, (134 / nY) * sY, health * ((1.125 / nX) * sX), (8 / nY) * sY, tocolor(255, 0, 0, 100), false)
	else
		--dxDrawRectangle((1166 / nX) * sX, (115 / nY) * sY, (129 / nX) * sX, (12 / nY) * sY, tocolor(0, 0, 0, 100), false)
		--dxDrawRectangle((1168 / nX) * sX, (117 / nY) * sY, health * ((1.25 / nX) * sX), (8 / nY) * sY, tocolor(255, 0, 0, 100), false)
	end
end
addEventHandler("onClientRender", root, renderHealthBar)



-- Export functions to make life easier
function getDisabledHUD()
	return disabledHUD
end

function isLocalPlayerCustomHUDEnabled()
	if (isPlayerMapVisible() or (not isPlayerHudComponentVisible("radar"))) then
		return false
	end
	return true
end


-- Actual HUD

-- Disabled the in-built HUD on resource start
for _, v in pairs(disabledHUD) do
	showPlayerHudComponent(v, false)
end

addEventHandler("onClientResourceStop", resourceRoot,
	function ()
		for _, v in pairs(disabledHUD) do
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
	
	dxDrawText(h..":"..m, (1169 / nX) * sX, (26 / nY) * sY, (1299 / nX) * sX, (83 / nY) * sY, tocolor(0, 0, 0, 255), 3.5, "default", "center", "top", false, false, false, true, false)
	dxDrawText(h..":"..m, (1169 / nX) * sX, (24 / nY) * sY, (1299 / nX) * sX, (81 / nY) * sY, tocolor(0, 0, 0, 255), 3.5, "default", "center", "top", false, false, false, true, false)
	dxDrawText(h..":"..m, (1167 / nX) * sX, (26 / nY) * sY, (1297 / nX) * sX, (83 / nY) * sY, tocolor(0, 0, 0, 255), 3.5, "default", "center", "top", false, false, false, true, false)
	dxDrawText(h..":"..m, (1167 / nX) * sX, (24 / nY) * sY, (1297 / nX) * sX, (81 / nY) * sY, tocolor(0, 0, 0, 255), 3.5, "default", "center", "top", false, false, false, true, false)
	dxDrawText(h..":"..m, (1168 / nX) * sX, (25 / nY) * sY, (1298 / nX) * sX, (82 / nY) * sY, tocolor(255, 255, 255, 255), 3.5, "default", "center", "top", false, false, false, true, false)
end
addEventHandler("onClientRender", root, renderClock)



function renderMoney()
	if (not isPlayerHudComponentVisible("radar") or isPlayerMapVisible()) then return end
	local fpMoney = getPlayerMoney(localPlayer)
	if fpMoney >= 0 then
		if (fpMoney <= 9) then
			finalOutputM = "$0000000"..math.abs(fpMoney)
		elseif fpMoney <= 99 then
			finalOutputM = "$000000"..math.abs(fpMoney)
		elseif fpMoney <= 999 then
			finalOutputM = "$00000"..math.abs(fpMoney)
		elseif fpMoney <= 9999 then
			finalOutputM = "$0000"..math.abs(fpMoney)
		elseif fpMoney <= 99999 then
			finalOutputM = "$000"..math.abs(fpMoney)
		elseif fpMoney <= 999999 then
			finalOutputM = "$00"..math.abs(fpMoney)
		elseif fpMoney <= 9999999 then
			finalOutputM = "$0"..math.abs(fpMoney)
		elseif fpMoney <= 99999999 then
			finalOutputM = "$"..math.abs(fpMoney)
		end
	else
		if fpMoney > (-9) then
			finalOutputM = "-$0000000"..math.abs(fpMoney)
		elseif fpMoney > (-99) then
			finalOutputM = "-$000000"..math.abs(fpMoney)
		elseif fpMoney > (-999) then
			finalOutputM = "-$00000"..math.abs(fpMoney)
		elseif fpMoney > (-9999) then
			finalOutputM = "-$0000"..math.abs(fpMoney)
		elseif fpMoney > (-99999) then
			finalOutputM = "-$000"..math.abs(fpMoney)
		elseif fpMoney > (-999999) then
			finalOutputM = "-$00"..math.abs(fpMoney)
		elseif fpMoney > (-9999999) then
			finalOutputM = "-$0"..math.abs(fpMoney)
		else
			finalOutputM = "-$"..math.abs(fpMoney)
		end
	end
	
	if (getPedStat(localPlayer, 24) == 1000) then
		aY = 140
		bY = 138
		cY = 139
		dY = 195
		eY = 193
		fY = 194
	else
		aY = 135
		bY = 133
		cY = 134
		dY = 180
		eY = 178
		fY = 179
	end
	
	--dxDrawRectangle((1083 / nX) * sX, (158 / nY) * sY, (211 / nX) * sX, (21 / nY) * sY, tocolor(0, 0, 0, 255), false) -- A little bit in the back to stop the sky from seeping through the letters
	
	dxDrawText(finalOutputM, (1062 / nX) * sX, (aY / nY) * sY, (1309 / nX) * sX, (dY / nY) * sY, tocolor(0, 0, 0, 255), 1.90, "pricedown", "center", "center", false, true, false, false, false)
	dxDrawText(finalOutputM, (1062 / nX) * sX, (bY / nY) * sY, (1309 / nX) * sX, (eY / nY) * sY, tocolor(0, 0, 0, 255), 1.90, "pricedown", "center", "center", false, true, false, false, false)
	dxDrawText(finalOutputM, (1058 / nX) * sX, (aY / nY) * sY, (1305 / nX) * sX, (dY / nY) * sY, tocolor(0, 0, 0, 255), 1.90, "pricedown", "center", "center", false, true, false, false, false)
	dxDrawText(finalOutputM, (1058 / nX) * sX, (bY / nY) * sY, (1305 / nX) * sX, (eY / nY) * sY, tocolor(0, 0, 0, 255), 1.90, "pricedown", "center", "center", false, true, false, false, false)
	dxDrawText(finalOutputM, (1059 / nX) * sX, (cY / nY) * sY, (1306 / nX) * sX, (fY / nY) * sY, tocolor(1, 71, 3, 255), 1.90, "pricedown", "center", "center", false, true, false, false, false)	
end
--addEventHandler("onClientRender", root, renderMoney)

function renderArmour()
	if (not isPlayerHudComponentVisible("radar") or isPlayerMapVisible()) then return end	
	local armourLevel = getPedArmor(localPlayer)
	if armourLevel == 0 then return end
	
	dxDrawRectangle((1166 / nX) * sX, (84 / nY) * sY, (129 / nX) * sX, (12 / nY) * sY, tocolor(0, 0, 0, 255), false)
	dxDrawRectangle((1168 / nX) * sX, (86 / nY) * sY, armourLevel * ((1.25 / nX) * sX), (8 / nY) * sY, tocolor(255, 255, 255, 255), false)
end
addEventHandler("onClientRender", root, renderArmour)

function renderOxygen()
	if (not isPlayerHudComponentVisible("radar") or isPlayerMapVisible()) then return end	
	if not isElementInWater(localPlayer) then return end
	local oxygenLevel = getPedOxygenLevel(localPlayer) / 10
	
	if (getPedStat(localPlayer, 24) == 1000) then
		gY = 109
		hY = 111
	else
		gY = 99
		hY = 101
	end
	
	dxDrawRectangle((1166 / nX) * sX, (gY / nY) * sY, (129 / nX) * sX, (12 / nY) * sY, tocolor(0, 0, 0, 255), false)
	dxDrawRectangle((1168 / nX) * sX, (hY / nY) * sY, oxygenLevel * ((1.25 / nX) * sX), (8 / nY) * sY, tocolor(25, 208, 215, 255), false)
end
addEventHandler("onClientRender", root, renderOxygen)

function renderWeapons2()
	if (not isPlayerHudComponentVisible("radar") or isPlayerMapVisible()) then return end
	
	local wepID = getPedWeapon(localPlayer)
	imagePath = ":UCDhud/icons/"..getWeaponNameFromID(wepID)..".png"
	dxDrawImage((1064 / nX) * sX, (39 / nY) * sY, (92 / nX) * sX, (90 / nY) * sY, imagePath, 0, 0, 0, tocolor(255, 255, 255, 255), false)
end
addEventHandler("onClientRender", root, renderWeapons2)

function renderWeapons()
	if (not isPlayerHudComponentVisible("radar") or isPlayerMapVisible()) then return end
	
	local wepSlot = getPedWeaponSlot(localPlayer)
	local clipAmmo = getPedAmmoInClip(localPlayer)
	local totalAmmo = getPedTotalAmmo(localPlayer)
	local wepID = getPedWeapon(localPlayer)
	local ammoIndicatorText = clipAmmo.."/"..totalAmmo - clipAmmo
	
	if (wepSlot == 6) or (wepSlot == 8) or (wepID == 25) or (wepID == 35) or (wepID == 36) then
		ammoIndicatorText = tostring(totalAmmo)
	end

	if (wepSlot == 0) or (wepSlot == 1) or (wepSlot == 10) or (wepSlot == 12) or (wepID == 44) or (wepID == 45) or (wepID == 46) then
		return
	end
	
	dxDrawText(ammoIndicatorText, ((1078 - 1) / nX) * sX, ((110 - 1) / nY) * sY, ((1140 - 1) / nX) * sX, ((134 - 1) / nY) * sY, tocolor(0, 0, 0, 255), 1.50, "default-bold", "center", "top", false, false, false, false, false)
	dxDrawText(ammoIndicatorText, ((1078 + 1) / nX) * sX, ((110 - 1) / nY) * sY, ((1140 + 1) / nX) * sX, ((134 - 1) / nY) * sY, tocolor(0, 0, 0, 255), 1.50, "default-bold", "center", "top", false, false, false, false, false)
	dxDrawText(ammoIndicatorText, ((1078 - 1) / nX) * sX, ((110 + 1) / nY) * sY, ((1140 - 1) / nX) * sX, ((134 + 1) / nY) * sY, tocolor(0, 0, 0, 255), 1.50, "default-bold", "center", "top", false, false, false, false, false)
	dxDrawText(ammoIndicatorText, ((1078 + 1) / nX) * sX, ((110 + 1) / nY) * sY, ((1140 + 1) / nX) * sX, ((134 + 1) / nY) * sY, tocolor(0, 0, 0, 255), 1.50, "default-bold", "center", "top", false, false, false, false, false)
	dxDrawText(ammoIndicatorText, (1078 / nX) * sX, (110 / nY) * sY, (1140 / nX) * sX, (134 / nY) * sY, tocolor(255, 255, 255, 255), 1.50, "default-bold", "center", "top", false, false, false, false, false)	
end
addEventHandler("onClientRender", root, renderWeapons)
