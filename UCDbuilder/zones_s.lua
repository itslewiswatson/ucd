db = exports.UCDsql:getConnection()
zones = {}
idToZone = {}
authorizedToBuild = {}

addEventHandler("onResourceStart", resourceRoot,
	function ()
		db:query(cacheZones, {}, "SELECT * FROM zones")
	end
)

function cacheZones(qh)
	local result = qh:poll(0)
	
	for i, data in ipairs(result) do
		local xyz = Vector3(fromJSON(data.xyz))
		local lwh = Vector3(fromJSON(data.lwh))
		
		local z = ColShape.Cuboid(xyz, lwh)
		
		z:setData("zoneID", data.zoneID)
		idToZone[i] = z
		addEventHandler("onColShapeHit", z, onEnterZone)
		addEventHandler("onColShapeLeave", z, onExitZone)
		zones[data.zoneID] = {owner = data.owner, name = data.name}
		
		authorizedToBuild[i] = fromJSON(data.authorized)
	end
end

function onEnterZone(ele, matchingDim)
	if (ele and ele.type == "player" and matchingDim) then
		local zoneID = source:getData("zoneID")
		local zoneName = zones[zoneID].name
		local zoneOwner = zones[zoneID].owner
		
		exports.UCDdx:add(ele, "builderzone", tostring(zoneName).." | "..tostring(zoneOwner), 255, 255, 255)
	end
end

function onExitZone(ele, matchingDim)
	if (ele and ele.type == "player" and matchingDim) then
		exports.UCDdx:del(ele, "builderzone")
	end
end

function getPlayerZones(plr)
	if (not plr or not isElement(plr) or plr.type ~= "player" or plr.account.guest) then
		return false
	end
	local temp = {}
	for zoneID, data in ipairs(zones) do
		if (data.owner:sub(1, 4) == "acc:" and data.owner:sub(4) == plr.account.name) then
			table.insert(temp, zoneID)
		end
	end
	return temp
end

function isPlayerInZone(plr, zoneID)
	if (zoneID == "*") then
		for k, z in ipairs(idToZone) do
			if (plr and isElement(plr) and isElement(z) and plr:isWithinColShape(z)) then
				return true, k
			end
		end
	else
		local zone = idToZone[zoneID]
		if (plr and isElement(plr) and isElement(zone) and plr:isWithinColShape(zone)) then
			return true
		end
	end
	return false
end

function isPositionInZone(x, y, z, zoneID)
	local pos = zoneCoords[zoneID]
	if (x < pos[1] or x > pos[1] + pos[4]) then
		return false
	end
	if (y < pos[2] or y > pos[2] + pos[5]) then
		return false
	end
	if (z < pos[3] or z > pos[3] + pos[6]) then
		return false
	end
	return true
end

function getZoneOwner(zoneID)
	return zones[zoneID].owner
end
