db = exports.UCDsql:getConnection()

zones = {}
idToZone = {}
authorizedToBuild = {}

addEventHandler("onResourceStart", resourceRoot,
	function ()
		db:query(cacheZones, {}, "SELECT * FROM `zones__`")
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
		zones[data.zoneID] = {owner = data.owner, name = data.name, position = xyz, dimensions = lwh}
		
		authorizedToBuild[i] = fromJSON(data.authorized)
	end
	outputDebugString("["..tostring(getThisResource().name).."] Zones successfully cached!")
end

function onEnterZone(ele, matchingDim)
	if (ele and ele.type == "player" and matchingDim) then
		local zoneID = source:getData("zoneID")
		local zoneName = zones[zoneID].name
		local zoneOwner = getZoneOwner(zoneID, true)
		
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
	for zoneID in ipairs(zones) do
		local owner = getZoneOwner(zoneID)
		local ownerType = getZoneOwnerType(zoneID)
		if (owner == plr.account.name and ownerType == "account") then
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
	local position = zones[zoneID].position
	local dimensions = zones[zoneID].dimensions
	
	if (x < position.x or x > position.x + dimensions.x) then
		return false, "x"
	end
	if (y < position.y or y > position.y + dimensions.y) then
		return false, "y"
	end
	if (z < position.z or z > position.z + dimensions.z) then
		return false, "z"
	end
	return true
end


function getZoneOwner(zoneID, formatted)
	local owner = zones[zoneID].owner
	if (not formatted) then
		return owner
	end
	-- More to be added
	if (owner:sub(1, 4) == "acc:" or owner:sub(1, 4) == "grp:") then
		return owner:sub(5)
	end
end

function getZoneOwnerType(zoneID)
	local owner = zones[zoneID].owner
	if (owner:sub(1, 3) == "acc") then
		return "account"
	elseif (owner:sub(1, 3) == "grp") then
		return "group"
	end
end
