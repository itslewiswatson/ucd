-------------------------------------------------------------------
--// PROJECT: Union of Clarity and Diversity
--// RESOURCE: UCDhousing
--// DEVELOPER(S): Lewis Watson (Noki)
--// DATE: 07/03/2016
--// PURPOSE: Server-side house robbing.
--// FILE: \rob\rob_s.lua [server]
-------------------------------------------------------------------

local robTimer = 20 -- Minute interval for robbing houses
local objects = {1208, 1518, 2103, 2648, 2595, 1786, 2229, 2230}
local robbed = {} -- A table containing all houses that have been robbed recently
local objj = {}

function robHouse(houseID)
	if (client) then
		if (not exports.UCDchecking:canPlayerDoAction(client, "RobHouse")) then
			return false
		end
		if (robbed[houseID] and not exports.UCDadmin:isPlayerOwner(client)) then
			exports.UCDdx:new(client, "This house has been robbed recently, come back later", 255, 0, 0)
			return
		end
		if (client:getData("Occupation") ~= "Criminal" and client:getData("Occupation") ~= "Gangster") then
			return
		end
		triggerEvent("UCDhousing.enterHouse", client, houseID, true)
		exports.UCDactions:setAction(client, "HouseRob")
		robbed[houseID] = true
		Timer(clearRobbed, robTimer * 60000, 1, houseID)
	else
		outputDebugString("FUARK")
	end
end
addEvent("UCDhousing.robHouse", true)
addEventHandler("UCDhousing.robHouse", root, robHouse)

function completeHouseRob(tbl)
	if (client) then
		local hitCount = tbl[1]
		local markerCount = tbl[2]
		
		local ic
		if (hitCount == 1) then
			ic = "item"
		else
			ic = "items"
		end
		local baseAmount = (hitCount * 1000) + 1000
		if ((hitCount / markerCount) < 1) then
			baseAmount = baseAmount - (500 * (markerCount - hitCount))
		end
		local amount = math.random(baseAmount, baseAmount + 500) + 1000
		
		exports.UCDdx:new(client, "You stole "..tostring(hitCount).." "..tostring(ic)..", with a total value of $"..tostring(exports.UCDutil:tocomma(amount)), 255, 0, 0)
		client.money = client.money + amount
		
		destroyRobObject(client)
		exports.UCDactions:clearAction(client)
		
		exports.UCDwanted:addWantedPoints(client, 5)
		exports.UCDaccounts:SAD(client, "crimXP", exports.UCDaccounts:GAD(client, "crimXP") + 2)
		exports.UCDstats:setPlayerAccountStat(client, "housesRobbed", exports.UCDstats:getPlayerAccountStat(client, "housesRobbed") + 1)
	end
end
addEvent("UCDhousing.completeHouseRob", true)
addEventHandler("UCDhousing.completeHouseRob", root, completeHouseRob)

function clearRobbed(houseID)
	robbed[houseID] = nil
end

function randomObject()
	if (client and client.dimension == 0 and client.interior == 0) then
		local objID = objects[math.random(1, #objects)]
		objj[client] = Object(objID, -5, -5, -5)
		objj[client].velocity = Vector3(0, 0, 0)
		objj[client]:setDoubleSided(true)
		outputDebugString("Attaching "..objID)
		exports.bone_attach:attachElementToBone(objj[client], client, 2, 0, 1, 0, 0, 0, 0)
	end
end
addEvent("UCDhousing.randomObject", true)
addEventHandler("UCDhousing.randomObject", root, randomObject)

function destroyRobObject2()
	destroyRobObject(source)
end
addEvent("onPlayerGetJob", true)
addEventHandler("onPlayerGetJob", root, destroyRobObject2)

function destroyRobObject(plr)
	if (objj[plr]) then
		exports.bone_attach:detachElementFromBone(objj[plr])
		objj[plr]:destroy()
		objj[plr] = nil
	end
end

function stopRobbing(plr)
	if (exports.UCDactions:getAction(plr) == "HouseRob" and objj[plr]) then
		destroyRobObject(plr)
		triggerClientEvent(plr, "UCDhousing.rob.restore", plr)
		exports.UCDactions:clearAction(plr)
		exports.UCDdx:new(plr, "You have given up and dropped the stolen items", 255, 0, 0)
	end
end
addCommandHandler("giveup", stopRobbing)

