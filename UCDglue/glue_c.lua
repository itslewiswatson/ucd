function glue()
	if (not localPlayer.vehicle) then
		local vehicle = getPedContactElement(localPlayer)
		if (vehicle and vehicle.type == "vehicle") then
			
			local px, py, pz = getElementPosition(localPlayer)
			local vx, vy, vz = getElementPosition(vehicle)
			local sx = px - vx
			local sy = py - vy
			local sz = pz - vz
			
			local rotpX = 0
			local rotpY = 0
			local rotpZ = getPedRotation(localPlayer)
			
			local rotvX, rotvY, rotvZ = getElementRotation(vehicle)
			
			local t = math.rad(rotvX)
			local p = math.rad(rotvY)
			local f = math.rad(rotvZ)
			
			local ct = math.cos(t)
			local st = math.sin(t)
			local cp = math.cos(p)
			local sp = math.sin(p)
			local cf = math.cos(f)
			local sf = math.sin(f)
			
			local z = ct*cp*sz + (sf*st*cp + cf*sp)*sx + (-cf*st*cp + sf*sp)*sy
			local x = -ct*sp*sz + (-sf*st*sp + cf*cp)*sx + (cf*st*sp + sf*cp)*sy
			local y = st*sz - sf*ct*sx + cf*ct*sy
			
			local rotX = rotpX - rotvX
			local rotY = rotpY - rotvY
			local rotZ = rotpZ - rotvZ
			
			local slot = getPedWeaponSlot(localPlayer)
			
			triggerServerEvent("gluePlayer", resourceRoot, slot, vehicle, x, y, z, rotX, rotY, rotZ)
			
			bindKey("jump", "down", unglue)
		end
	end
end
addCommandHandler("glue", glue)
addEvent("UCDglue.glue", true)
addEventHandler("UCDglue.glue", root, glue)

function unglue()
	triggerServerEvent("ungluePlayer", localPlayer)
	unbindKey("jump", "down", unglue)
end
addCommandHandler("unglue", unglue)
