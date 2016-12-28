function destroyObject(obj)
	for k, v in ipairs(obj:getAttachedElements()) do
		v:destroy()
	end
	obj:destroy()
	outputDebugString("Destroyed obj")
end
addEvent("UCDbuilder.destroy", true)
addEventHandler("UCDbuilder.destroy", root, destroyObject)

function getCloserPoint(num, point1, point2)
	if (math.abs(num - point1) > math.abs(num - point2)) then
		return point2
	end
	return point1
end

function sync(obj, pos)
	if (client) then
		local isZone, zoneID = isPlayerInZone(client, "*")
		if (not zoneID) then
			outputDebugString("client not in a zone")
			return
		end
		local isWithinZone, offendingAxis = isPositionInZone(pos[1], pos[2], pos[3], zoneID)
		if (not isWithinZone) then
			-- Set it to the max of the offending axis
			if (offendingAxis == "x") then		
				local newX = getCloserPoint(pos[1], zones[zoneID].position.x, zones[zoneID].position.x + zones[zoneID].dimensions.x)
				obj.position = Vector3(newX, pos[2], pos[3])
			elseif (offendingAxis == "y") then
				local newY = getCloserPoint(pos[2], zones[zoneID].position.y, zones[zoneID].position.y + zones[zoneID].dimensions.y)
				obj.position = Vector3(pos[1], newY, pos[3])
			elseif (offendingAxis == "z") then
				local newZ = getCloserPoint(pos[3], zones[zoneID].position.z, zones[zoneID].position.z + zones[zoneID].dimensions.z)
				obj.position = Vector3(pos[1], pos[2], newZ)
			end
			
			--outputDebugString("not within bounds of zoneID ("..tostring(offendingAxis)..")")
			return
		end
	end
	
	obj.position = Vector3(pos[1], pos[2], pos[3])
	obj.rotation = Vector3(pos[4], pos[5], pos[6])
end
addEvent("UCDbuilder.sync", true)
addEventHandler("UCDbuilder.sync", root, sync)

function testObject(plr)
	local isZone, zoneID = isPlayerInZone(plr, "*")
	if (isZone) then
		if (idToZone[zoneID]) then
			
			local pos = plr.matrix.position + plr.matrix.forward * 6
			pos = pos + plr.matrix.up
			
			local o = Object(1684, pos)
			o:setParent(idToZone[zoneID])
			
		else
			outputDebugString("wtf")
		end
	end
end
addCommandHandler("testobj", testObject)

function toggleBuild(plr)
	--[[
	if (not exports.UCDchecking:canPlayerDoAction(plr, "Builder")) then return false end
	
	-- Set the player's action
	if (exports.UCDactions:getAction(plr) == "Builder") then
		exports.UCDactions:clearAction(plr)
	else
		exports.UCDactions:setAction(plr, "Builder")
	end
	
	if (plr or exports.UCDadmin:getPlayerAdminRank(plr) >= 4) then
		
		local zoneID
		for i, z in ipairs(idToZone) do
			if (plr:isWithinColShape(z)) then
				if (zones[i].account == plr.account.name or (plr:isWithinColShape(idToZone[i]) and exports.UCDadmin:getPlayerAdminRank(plr))) then
					zoneID = i
					break
				end
			end
		end
		
		if (zoneID) then
			if (getZoneOwner(zoneID) == plr.account.name or authorizedToBuild[zoneID][plr.account.name] or exports.UCDadmin:getPlayerAdminRank(plr)) then
				triggerClientEvent(plr, "UCDbuilder.toggleBuild", plr)				
			else
				exports.UCDdx:new(plr, "You are not authorized to use Builder here", 255, 255, 255)
			end
		else
			exports.UCDdx:new(plr, "You must be in a zone to use Builder", 255, 255, 255)
		end
	end
	--]]
	
	local _, zoneID = isPlayerInZone(plr, "*")
	if (zoneID) then
	
		local t = 
		{
			x = zones[zoneID].position.x,
			y = zones[zoneID].position.y,
			z = zones[zoneID].position.z,
			
			l = zones[zoneID].dimensions.x,
			w = zones[zoneID].dimensions.y,
			h = zones[zoneID].dimensions.z,
		}
		
		triggerClientEvent(plr, "UCDbuilder.toggleBuild", resourceRoot, zoneID, t)
	end
	
	--triggerClientEvent(plr, "UCDbuilder.toggleBuild", plr)
end
addCommandHandler("builder", toggleBuild, false, false)

-- Ugly bind stuff

for _, plr in ipairs(Element.getAllByType("player")) do
	bindKey(plr, "n", "down", "builder")
end

addEventHandler("onPlayerJoin", root, 
	function ()
		bindKey(source, "n", "down", "builder")
	end
)