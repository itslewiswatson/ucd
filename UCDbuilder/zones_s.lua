db = exports.UCDsql:getConnection()
zones = {}
idToZone = {}
authorizedToBuild = {}

zoneCoords = {
	[1] = {-3340.2417, 2054.9397, 0, 50, 30, 20}
}

addEventHandler("onResourceStart", resourceRoot,
	function ()
		db:query(cacheZones, {}, "SELECT * FROM zones")
	end
)

function cacheZones(qh)
	local result = qh:poll(-1)
	
	for i, coord in ipairs(zoneCoords) do
		local z = ColShape.Cuboid(coord[1], coord[2], coord[3], coord[4], coord[5], coord[6])
		local data = result[i]
		
		z:setData("zoneID", i)
		idToZone[i] = z
		addEventHandler("onColShapeHit", z, onEnterZone)
		addEventHandler("onColShapeLeave", z, onExitZone)
		zones[i] = {account = data.account, name = data.name}
		
		authorizedToBuild[i] = {}
		authorizedToBuild[i] = fromJSON(data.authorized)
	end
end

function onEnterZone(ele, matchingDim)
	if (ele and ele.type == "player" and matchingDim) then
		local zoneName = zones[source:getData("zoneID")].name
		local zoneOwner = exports.UCDaccounts:GAD(zones[source:getData("zoneID")].account, "lastUsedName")
		exports.UCDdx:add(ele, "builderzone", tostring(zoneName).." > "..tostring(zoneOwner), 255, 255, 255)
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
		if (data.account == plr.account.name) then
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
	return zones[zoneID].account
end
