spawnerData = {} -- Table of spawner data
PJV = {} -- Table of player spawned vehicles

-- Handled client-side for now (because binds are easier)
--[[
-- Create markers
function init()
	for _, info in ipairs(jobVehicles) do
		local mkr = Marker(info.x, info.y, info.z - 1, "cylinder", 2, info.colour.r, info.colour.g, info.colour.b, 200)
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
--]]

function getPlayerJobVehicle(plr)
	if (not plr) then return end
	if (not isElement(plr) or plr.type ~= "player") then return false end
	if (PJV[plr] and isElement(PJV[plr])) then
		return PJV[plr]
	end
	return false
end

function destroyPlayerJobVehicle(plr, force)
	if (not plr) then return end
	if (not isElement(plr) or plr.type ~= "player") then return false end
	local vehicle = PJV[plr]
	if (vehicle and isElement(vehicle)) then
		if (vehicle:getOccupant(0) == plr and exports.UCDutil:getElementSpeed(vehicle) > 30 and not force) then
			return "too fast"
		end
		vehicle:destroy()
		PJV[plr] = nil
		return true
	end
	return false
end
addEvent("onPlayerGetJob")
addEventHandler("onPlayerGetJob", root,
	function (jobName, oldJob)
		if ((jobName == "Criminal" and oldJob == "Gangster") or (jobName == "Gangster" and oldJob == "Criminal")) then
			return
		end
		destroyPlayerJobVehicle(source, true)
	end
)

function djv(plr)
	local q = destroyPlayerJobVehicle(plr)
	if (q == "too fast") then
		exports.UCDdx:new(plr, "Your vehicle cannot be destroyed as it is going too fast", 255, 255, 0)
	elseif (q == true) then
		exports.UCDdx:new(plr, "Thank you for destroying your vehicle", 0, 255, 0)
	--elseif (q == false or q == nil) then
	--	exports.UCDdx:new(plr, "No vehicle to destroy", 255, 0, 0)
	end
end
addCommandHandler("djv", djv)
addCommandHandler("dveh", djv)

function createJobVehicle(plr, model, rot, pos, index)
	if (not plr or not model or not rot or not pos) then return end
	if (not isElement(plr) or plr.type ~= "player") then return false end
	if (not exports.UCDchecking:canPlayerDoAction(plr, "JobVehicle")) then return false end
	
	local jobName = plr:getData("Occupation")
	local playerRank = exports.UCDjobs:getPlayerJobRank(plr, jobName) or 0
	local r, g, b
	if (not jobName) then
		return
	end
	
	local r1, g1, b1, r2, g2, b2
	local ranks = exports.UCDjobsTable:getJobRanks(jobName)
	local restricted = exports.UCDjobsTable:getRestricedVehicles(jobName)
	local custColours = exports.UCDjobsTable:getVehicleColours(jobName)
	
	if (restricted) then
		local vehicleRestricted = restricted[model]
		if (vehicleRestricted and playerRank < vehicleRestricted) then
			local reqRank
			for i in ipairs(ranks) do
				if (i == vehicleRestricted) then
					reqRank = i
					break
				end
			end
			exports.UCDdx:new(plr, "This vehicle requires you be L"..tostring(reqRank).." ("..tostring(ranks[vehicleRestricted].name)..") or above", 255, 0, 0)
			return
		end
	end
	
	if (not custColours) then
		if (ranks and ranks[playerRank] and #jobVehicles[index].vt ~= 0) then
			r1, g1, b1, r2, g2, b2 = ranks[playerRank].colour.r1, ranks[playerRank].colour.g1, ranks[playerRank].colour.b1, ranks[playerRank].colour.r2, ranks[playerRank].colour.g2, ranks[playerRank].colour.b2
		end
	else
		if (custColours[model]) then
			r1, g1, b1, r2, g2, b2 = custColours[model].r1, custColours[model].g1, custColours[model].b1, custColours[model].r2, custColours[model].g2, custColours[model].b2
		end
	end
	
	plr.position = Vector3(pos.x, pos.y, pos.z + 2)
	plr.rotation = Vector3(0, 0, rot)
	
	if (getPlayerJobVehicle(plr)) then
		destroyPlayerJobVehicle(plr)
	end
	
	PJV[plr] = Vehicle(model, pos.x, pos.y, pos.z + 2.5, 0, 0, rot)
	plr:warpIntoVehicle(PJV[plr])
	
	-- If it's not a tug or a baggage
	--if (model ~= 583 and model ~= 485) then
	if (r1 and g1) then
		PJV[plr]:setColor(r1, g1, b1, r2, g2, b2)
	end
	
	PJV[plr]:setData("owner", plr.name)
end

function createFromMarker(model, rot, coords, index)
	createJobVehicle(client, model, rot, coords, index)
end
addEvent("UCDjobVehicles.createFromMarker", true)
addEventHandler("UCDjobVehicles.createFromMarker", root, createFromMarker)

addEventHandler("onPlayerQuit", root,
	function ()
		if (getPlayerJobVehicle(source)) then
			destroyPlayerJobVehicle(source, true)
		end
	end
)
