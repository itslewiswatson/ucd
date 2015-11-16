local resX, resY = guiGetScreenSize()

function draw()
	local target = localPlayer:getTarget()
	if (target and target:getType() == "vehicle" and localPlayer:getControlState("aim_weapon")) then
		if (not ((localPlayer:getWeaponSlot() ~= 0 and localPlayer:getWeaponSlot() ~= 1) and
		(localPlayer:getWeaponSlot() ~= 7) and (localPlayer:getWeaponSlot() ~= 8) and
		(localPlayer:getWeaponSlot() ~= 9) and (localPlayer:getWeaponSlot() ~= 11) and
		(localPlayer:getWeaponSlot() ~= 12))) then return end
		--local vX, vY, vZ = getElementPosition(target)
		local v = target:getPosition()
		--local pX, pY, pZ = getElementPosition(localPlayer)
		local p = localPlayer:getPosition()
		
		if isElementOnScreen(target) then
			--local dist = getDistanceBetweenPoints3D(vX, vY, vZ, pX, pX, pX)
			local dist = getDistanceBetweenPoints3D(v.x, v.y, v.z, p.x, p.y, p.z)
			--local tX, tY = getScreenFromWorldPosition(vX, vY, vZ + 1, 0, false)
			local tX, tY = getScreenFromWorldPosition(v.x, v.y, v.z + 1, 0, false)
			if tX and tY and isLineOfSightClear(p.x, p.y, p.z, v.x, v.y, v.z, true, false, false, true, true, false, false, target) and dist < 30 then
				local theText = target:getData("owner")
				local width = dxGetTextWidth(tostring(theText), 0.6, "bankgothic")
				dxDrawText(tostring(theText).."'s "..target.name.." ["..tostring(exports.UCDutil:mathround(target.health / 10)).."%]", tX - width / 2, tY, resX, resY, tocolor(255, 0, 0), 1)
			end
		end
	end
end
addEventHandler("onClientRender", root, draw)

function onResourceStop()
	if (isSpectating) then
		setCameraTarget(localPlayer)
		isSpectating = false
	end
end
addEventHandler("onClientResourceStop", resourceRoot, onResourceStop)
