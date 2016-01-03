-------------------------------------------------------------------
--// PROJECT: Union of Clarity and Diversity
--// RESOURCE: UCDvehicleSystem
--// DEVELOPER(S): Lewis Watson (Noki)
--// DATE: 09/12/2015
--// PURPOSE: Managing miscellanous client functions.
--// FILE: \client2.lua [client]
-------------------------------------------------------------------

local resX, resY = guiGetScreenSize()

function draw()
	local target = localPlayer:getTarget()
	if (target and target.type == "vehicle" and localPlayer:getControlState("aim_weapon")) then
		if (not target:getData("owner")) then return end
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


addEventHandler("onClientVehicleDamage", root,
	function (_, _, loss)
		if (isElement(source) and source.type == "vehicle") then
			if (source.health < 250 or (source.health - loss) < 250) then
				if (source.damageProof == false or source.engineState == true) then
					triggerServerEvent("dmgproof", source)
					source:setDamageProof(true)
					source:setEngineState(false)
				end
				--exports.UCDdx:new("This vehicle is critically damaged. It must be repaired!", 255, 0, 0)
				source.health = 250
				outputDebugString("hh")
				cancelEvent()
			end
		end
	end
)

addEventHandler("onClientVehicleEnter", root,
	function (plr)
		if (plr ~= localPlayer) then return end
		if (isElement(source) and source.type == "vehicle") then
			if (source.health <= 250) then
				source:setEngineState(false)
				source:setDamageProof(true)
				triggerServerEvent("dmgproof", source)
				source.health = 250
				exports.UCDdx:new("This vehicle is critically damaged. It must be repaired!", 255, 0, 0)
			end
		end
	end
)
