function destroyObject(obj)
	for k, v in ipairs(obj:getAttachedElements()) do
		v:destroy()
	end
	obj:destroy()
	outputDebugString("Destroyed obj")
end
addEvent("UCDbuilder.destroy", true)
addEventHandler("UCDbuilder.destroy", root, destroyObject)

function sync(obj, pos)
	if (client) then
		local zones = getPlayerZones(client)
		if (zones) then
			if (not isPositionInZone(pos[1], pos[2], pos[3], zones[1])) then
				return
			end
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
			local o = Object(5464, plr.matrix.position + plr.matrix.forward * 3)
			o:setParent(idToZone[zoneID])
		else
			outputDebugString("wtf")
		end
	end
end
addCommandHandler("testobj", testObject)

function toggleBuild(plr)
	if (not exports.UCDchecking:canPlayerDoAction(plr, "Builder")) then return false end
	
	if (#getPlayerZones(plr) > 0 or exports.UCDadmin:getPlayerAdminRank(plr) >= 4) then
		
		local zoneID
		for i, z in ipairs(idToZone) do
			if (plr:isWithinColShape(z)) then
				if (zones[i].account == plr.account.name or (plr:isWithinColShape(idToZone[i]) and exports.UCDadmin:getPlayerAdminRank(plr) >= 4)) then
					zoneID = i
					break
				end
			end
		end
		
		if (zoneID) then
			if (getZoneOwner(zoneID) == plr.account.name or authorizedToBuild[zoneID][plr.account.name] or exports.UCDadmin:getPlayerAdminRank(plr) >= 4) then
				triggerClientEvent(plr, "UCDbuilder.toggleBuild", plr)
				
				--if (plr:getData("f") == true) then
				--	plr:setData("f", false)
				--else
				--	plr:setData("f", true)
				--end
				--plr.frozen = plr:getData("f")
				
			else
				exports.UCDdx:new(plr, "You are not authorized to use Builder here", 255, 255, 255)
			end
		else
			exports.UCDdx:new(plr, "You must be in a zone to use Builder", 255, 255, 255)
		end
	end
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