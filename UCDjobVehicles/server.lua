spawnerData = {} -- Table of spawner data
PJV = {} -- Table of player spawned vehicles

-- Create markers
function init()
	for _, info in ipairs(jobVehicles) do
		local mkr = Marker(info.x, info.y, info.z - 1, "cylinder", 2, info.colour.r, info.colour.g, info.colour.b, 175)
		spawnerData[mkr] = {info.vt, info.rot, info.vehs}
		addEventHandler("onMarkerHit", mkr, markerHit)
	end
end
addEventHandler("onResourceStart", resourceRoot, init)

function markerHit(ele, matchingDimension)
	if (ele and ele.type == "player" and not ele.vehicle and matchingDimension) then
		if (ele.position.z - 1.5 < source.position.z and ele.position.z + 1.5 > source.position.z) then
			if (spawnerData[source]) then
				local job = ele:getData("Occupation")
				local isAbleTo
				if (not job) then return end
				for i, v in ipairs(spawnerData[source][1]) do
					if (job == v) then
						isAbleTo = true
						break
					end
				end
				if (isAbleTo) then
					triggerClientEvent(ele, "UCDjobVehicles.toggleSpawner", ele, spawnerData[source], source)
				else
					exports.UCDdx:new(ele, "You are not allowed to use this spawner", 255, 255, 0)
				end
			end
		end
	end
end

function getPlayerJobVehicle(plr)
	if (not plr) then return end
	if (not isElement(plr) or plr.type ~= "player") then return false end
	if (PJV[plr] and isElement(PJV[plr])) then
		return PJV[plr]
	end
	return false
end

function destroyPlayerJobVehicle(plr)
	if (not plr) then return end
	if (not isElement(plr) or plr.type ~= "player") then return false end
	local vehicle = PJV[plr]
	if (vehicle and isElement(vehicle)) then
		if (vehicle:getOccupant(0) == plr and exports.UCDutil:getElementSpeed(vehicle) > 30) then
			return "too fast"
		end
		vehicle:destroy()
		PJV[plr] = nil
		return true
	end
	return false
end

function djv(plr)
	local q = destroyPlayerJobVehicle(plr)
	if (q == "too fast") then
		exports.UCDdx:new(plr, "Your job vehicle cannot be destroyed as it is going too fast", 255, 255, 0)
	elseif (q == true) then
		exports.UCDdx:new(plr, "Thank you for destroying your job vehicle", 0, 255, 0)
	--elseif (q == false or q == nil) then
	--	exports.UCDdx:new(plr, "No vehicle to destroy", 255, 0, 0)
	end
end
addCommandHandler("djv", djv)
addCommandHandler("dveh", djv)

function createJobVehicle(plr, model, rot, pos)
	if (not plr or not model or not rot or not pos) then return end
	if (not isElement(plr) or plr.type ~= "player") then return false end
	
	local jobName = plr:getData("Occupation")
	local playerRank = 9
	local r, g, b
	local ranks
	if (jobName ~= false and playerRank ~= false) then
		ranks = exports.UCDjobsTable:getJobRanks(jobName)
		r1, g1, b1, r2, g2, b2 = ranks[playerRank].colour.r1, ranks[playerRank].colour.g1, ranks[playerRank].colour.b1, ranks[playerRank].colour.r2, ranks[playerRank].colour.g2, ranks[playerRank].colour.b2
	end
	
	plr.position = Vector3(pos.x, pos.y, pos.z + 2)
	plr.rotation = Vector3(0, 0, rot)
	
	if (getPlayerJobVehicle(plr)) then
		destroyPlayerJobVehicle(plr)
	end
	
	PJV[plr] = Vehicle(model, pos.x, pos.y, pos.z + 2, 0, 0, rot)
	plr:warpIntoVehicle(PJV[plr])
	PJV[plr]:setColor(r1, g1, b1, r2, g2, b2)
end

function createFromMarker(model, rot, marker)
	createJobVehicle(client, model, rot, Vector3(marker.position.x, marker.position.y, marker.position.z))
end
addEvent("UCDjobVehicles.createFromMarker", true)
addEventHandler("UCDjobVehicles.createFromMarker", root, createFromMarker)