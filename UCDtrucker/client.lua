local trucks = {[515] = true, [403] = true}
local curr
local prev
local m, b
local c = exports.UCDjobsTable:getJobTable()["Trucker"].colour


function startHaul(v, seat)
	if (seat == 0 and localPlayer.team.name == "Citizens" and localPlayer.dimension == 0 and localPlayer.interior == 0 and trucks[v.model] and localPlayer:getData("Occupation") == "Trucker") then
		calculateHaul()
	end
end
addEventHandler("onClientPlayerVehicleEnter", root, startHaul)
addEvent("UCDtrucker.startHaul", true)
addEventHandler("UCDtrucker.startHaul", root, startHaul)

function isHaul()
	if (curr) then
		return true
	end
	return false
end

function calculateHaul()
	if (not localPlayer.vehicle) then
		return
	end
	if (curr) then
		prev = curr
	end
	local text
	
	if (prev) then
		m:destroy()
		b:destroy()
		text = "Take this load to "
		repeat
			curr = math.random(1, #destinations)
		until curr ~= prev
	else
		curr = math.random(1, #destinations)
		text = "Pick the load up at "
	end
	
	local pos = Vector3(destinations[curr][1], destinations[curr][2], destinations[curr][3] - 1)
	m = Marker(pos, "cylinder", 5, c.r, c.g, c.b, 170)
	b = Blip.createAttachedTo(m, 51)
	exports.UCDdx:new("Trucker: "..text..getZoneName(pos)..", "..getZoneName(pos, true), 255, 215, 0)
	
	addEventHandler("onClientMarkerHit", m, onClientMarkerHit)
end

function cancelHaul()
	if (m and isElement(m) and b and isElement(b) and isHaul()) then
		removeEventHandler("onClientMarkerHit", m, onClientMarkerHit)
		--prev = curr
		m:destroy()
		b:destroy()
		m = nil
		b = nil
		curr = nil
		prev = nil
		hasHit = nil
	end
end
addEventHandler("onClientPlayerVehicleExit", localPlayer, cancelHaul)
addEventHandler("onClientPlayerWasted", localPlayer, cancelHaul)
addEventHandler("onClientElementDestroy", root, function () if (localPlayer.vehicle and source == localPlayer.vehicle) then cancelHaul() end end)
addEvent("onClientPlayerGetJob", true)
addEventHandler("onClientPlayerGetJob", localPlayer, cancelHaul)

function onClientMarkerHit(plr, matchingDimension)
	if (source ~= m) then return end
	if (plr == localPlayer and matchingDimension and plr.vehicle and trucks[plr.vehicle.model]) then
		if (hasHit) then
			return
		end
		if (not plr.vehicle.onGround and (plr.vehicle.position.z - 2) > source.position.z) then
			exports.UCDdx:new("Trucker: You must be on the ground to unload", 255, 215, 0)
			return
		end
		stopVehicle(true)
		hasHit = true
		Timer(onCompleteUnload, 3000, 1)
		if (prev) then
			exports.UCDdx:new("Trucker: Unloading your truck. Please wait...", 255, 215, 0)
		else
			exports.UCDdx:new("Trucker: Loading your truck. Please wait...", 255, 215, 0)
		end
	end
end

function onCompleteUnload()
	hasHit = nil
	stopVehicle()
	
	if (prev) then
		triggerServerEvent("UCDtrucker.processHaul", localPlayer, prev, curr)
		cancelHaul()
	else
		calculateHaul()
	end
end
