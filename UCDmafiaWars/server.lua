local turfCoordinates = {
    [1] = {x = 1377.5, y = 903, z = 9, w = 120, l = 220, h = 20, spawn = {1435, 974, 10.8, 0}},
    [2] = {x = 1577.7, y = 883, z = 9, w = 180, l = 240, h = 20, spawn = {1632, 972, 10.8, 270}},
    [3] = {x = 1873, y = 939, z = 9, w = 160, l = 149, h = 10, spawn = {2022, 1008, 10.8, 270}},
    [4] = {x = 1837, y = 1103, z = 9, w = 195, l = 160, h = 10, spawn = {2012, 1167, 10.8, 270}},
    [5] = {x = 2077, y = 982, z = 9, w = 260, l = 205, h = 50, spawn = {2183, 1115, 12.6, 60}},
    [6] = {x = 2082, y = 1203, z = 6, w = 335, l = 160, h = 100, spawn = {2233, 1285, 10.8, 90}},
    [7] = {x = 1014, y = 985, z = 5, w = 154.4, l = 180, h = 20, spawn = {1044, 1013, 11, 320}},
    [8] = {x = 1017, y = 1202, z = 5, w = 160.3, l = 161.1, h = 20, spawn = {1061, 1259, 10.8, 270}}, -- Add CIT style staircase
    [9] = {x = 1017, y = 1383, z = 0, w = 160, l = 321, h = 17, spawn = {1098, 1604, 12.5, 0}},
    [10] = {x = 918, y = 1623, z = 5, w = 79.5, l = 220.3, h = 12, spawn = {941, 1733, 10.8, 270}},
    [11] = {x = 917, y = 1963.3, z = 5, w = 81, l = 221.3, h = 20, spawn = {971, 2133, 10.8, 270}},
    [12] = {x = 1017.7, y = 1837, z = 5, w = 160, l = 207, h = 20, spawn = {1072, 1915, 10.8, 0}},
    [13] = {x = 1018, y = 2063.5, z = 5, w = 160, l = 218, h = 20, spawn = {1050, 2122, 10.8, 90}},
	[14] = {x = 1398, y = 2323, z = 9, w = 161, l = 61, h = 17, spawn = {1500, 2366, 10.8, 0}},
	[15] = {x = 1577, y = 2282.5, z = 9, w = 180, l = 130, h = 18, spawn = {1680, 2321, 10.8, 270}},
    [16] = {x = 1250, y = 2516, z = 9, w = 350, l = 113, h = 20, spawn = {1385, 2523, 10.6, 0}},
    [17] = {x = 1698, y = 2720, z = 9, w = 215, l = 165, h = 16, spawn = {1765, 2860, 10.8, 180}},
    [18] = {x = 1778, y = 2564, z = 9, w = 200, l = 120, h = 15, spawn = {1850, 2583, 10.8, 0}},
    [19] = {x = 1833, y = 2282, z = 9, w = 95, l = 190, h = 16, spawn = {1882, 2339, 11, 270}},
    [20] = {x = 1717, y = 2063, z = 2, w = 200, l = 100, h = 23, spawn = {1764, 2078, 10.8, 180}},
    [21] = {x = 2036, y = 2348, z = 9, w = 180, l = 102, h = 70, spawn = {2127, 2375, 10.8, 180}},
    [22] = {x = 2232.5, y = 2419, z = -10, w = 125, l = 88, h = 36, spawn = {2341, 2455, 15, 180}},
    [23] = {x = 2296, y = 2240, z = 9, w = 125, l = 165, h = 15, spawn = {2379, 2310, 8.1, 0}},
    [24] = {x = 2558.8, y = 2239, z = 6, w = 125, l = 215, h = 15, spawn = {2631, 2346, 10.7, 210}},
    [25] = {x = 2354, y = 903, z = 9, w = 185, l = 168, h = 20, spawn = {2475, 1022, 10.8, 180}},
    [26] = {x = 2436, y = 1080, z = 9, w = 165, l = 285, h = 20, spawn = {2534, 1125, 10.8, 90}},
    [27] = {x = 1837, y = 1284, z = 8, w = 195, l = 163, h = 20, spawn = {1933, 1342, 10, 270}},
    [28] = {x = 1840, y = 1464, z = 6, w = 195, l = 240, h = 22,spawn = {1969, 1623, 13, 270}},
    [29] = {x = 1852, y = 1722, z = 6, w = 222, l = 304.5, h = 25, spawn = {1903, 1809, 12.8, 0}},
    [30] = {x = 2086, y = 1383, z = 9, w = 152, l = 140, h = 10, spawn = {2148, 1485, 10.8, 90}},
    [31] = {x = 2255, y = 1383, z = 9, w = 105, l = 140, h = 50, spawn = {2301, 1455, 10.8, 270}},
    [32] = {x = 2088, y = 1543, z = 9, w = 229, l = 220, h = 10, spawn = {2194, 1677, 12.4, 90}},
    [33] = {x = 2438, y = 1483, z = 9, w = 159, l = 120, h = 25, spawn = {2556, 1562, 10.8, 90}},
    [34] = {x = 2337.2, y = 1624, z = 9, w = 199, l = 79.5, h = 20, spawn = {2435, 1673, 10.8, 0}},
    [35] = {x = 2558, y = 1624, z = 9, w = 119.5, l = 319, h = 9, spawn = {2597, 1895, 11, 180}},
    [36] = {x = 2533, y = 2119, z = 0, w = 160, l = 109, h = 21, spawn = {2613, 2169, 10.8, 0}},
    [37] = {x = 2135, y = 1784, z = 9, w = 270, l = 99, h = 6, spawn = {2220, 1838, 10.8, 90}},
    [38] = {x = 2160, y = 1904, z = 9, w = 170, l = 110, h = 30, spawn = {2323, 1991, 5.35, 180}},
    [39] = {x = 2160, y = 2033, z = 9, w = 170, l = 170, h = 21, spawn = {2275, 2039, 10.8, 270}},
    [40] = {x = 2097.5, y = 903.5, z = 5, w = 130, l = 65, h = 20, spawn = {2239, 963, 10.8, 10}},
    [41] = {x = 2777, y = 833, z = 10, w = 118, l = 190.5, h = 20, spawn = {2845, 983, 10.8, 94}},
    [42] = {x = 2517, y = 703, z = 5, w = 160.5, l = 60, h = 20, spawn = {2597, 758, 11.2, 359}},
    [43] = {x = 2157.5, y = 643, z = 5, w = 260, l = 120, h = 15, spawn = {2255, 728, 11.2, 265}},
    [44] = {x = 2001.1, y = 633.3, z = 5, w = 135.4, l = 160, h = 15, spawn = {2086, 688, 11.2, 179}},
    [45] = {x = 1877.6, y = 644, z = 9, w = 99.9, l = 119, h = 15, spawn = {1913, 703, 11.3, 357}},
    [46] = {x = 1577, y = 663, z = 5, w = 180.5, l = 120, h = 20, spawn = {1664, 709, 10.8, 1}},
    [47] = {x = 2237, y = 2723, z = 9, w = 210, l = 100, h = 15, spawn = {2367, 2757, 10.4, 177}},
    [48] = {x = 2498.6782, y = 2645, z = 9, w = 251, l = 212.2, h = 32, spawn = {2589, 2790, 10.5, 92}},
    [49] = {x = 2756, y = 2312, z = 9, w = 140, l = 290, h = 8, spawn = {2846, 2375, 11.3, 94}},
    [50] = {x = 2365, y = 2061, z = 9, w = 152, l = 165, h = 10, spawn = {2441, 2160, 10.3, 177}},
}
local idToCol = {}
local colToArea = {}
local allowedToTurf = {--[[["Law"] = true,]] ["Criminals"] = true, ["Gangsters"] = true}
local provoking = {}
local level = {}

addEventHandler("onResourceStart", resourceRoot,
	function ()
		for turfID, v in ipairs(turfCoordinates) do
			local col = createColCuboid(v.x, v.y, v.z, v.w, v.l, v.h)
			provoking[col] = {}
			level[col] = {}
			
			level[col]["fuark"] = 100
			col:setData("turfOwner", "fuark")
			
			idToCol[turfID] = col
			colToArea[col] = createRadarArea(v.x, v.y, v.w, v.l, 255, 255, 255, 175)
			col:setData("id", turfID)
			addEventHandler("onColShapeHit", col, onEnterTurf)
			addEventHandler("onColShapeLeave", col, onExitTurf)
		end
		Timer(corrections, 1000, 0)
	end
)

function corrections()
	for i = 1, #idToCol do
		if (idToCol[i]:getData("turfOwner")) then
			local gR, gG, gB = exports.UCDgroups:getGroupColour(idToCol[i]:getData("turfOwner"))-- or 255, 255, 255
			local rR, rG, rB = colToArea[idToCol[i]]:getColor()
			if (gR ~= rR or gG ~= rG or gB ~= rB) then
				colToArea[idToCol[i]]:setColor(gR, gG, gB, 175)
				outputDebugString("Setting colour")
			end
		end
	end
end

function turfPayout()
	for _, plr in ipairs(Element.getAllByType("player")) do
		local group = exports.UCDgroups:getPlayerGroup(plr)
		if (group and isElementInLV(plr) and exports.UCDaccounts:isPlayedLoggedIn(plr)) then
			local members = exports.UCDgroups:getGroupOnlineMembers(group)
			local turfs = 0
			for _, col in ipairs(idToCol) do
				if (col:getData("turfOwner") == group) then
					turfs = turfs + 1
				end
			end
			if (turfs >= 1 and #members >= 1) then
				local payout = math.floor((5000 * turfs) / #members)
				exports.UCDdx:new(plr, "You have earned "..exports.UCDutil:tocomma(payout).." from your turfs in the past 5 minutes", 0, 255, 0)
			end
		end
	end
end
Timer(turfPayout, 5 * 60000, 0)

function getTurfGroupMembers(col, group)
	local groupMembers = {}
	for i, v in ipairs(col:getElementsWithin("player")) do
	--for i, v in ipairs(getElementsWithinColShape(col, "player")) do
		if (not v.dead and allowedToTurf[v.team.name] and exports.UCDgroups:getPlayerGroup(v) == group) then
			table.insert(groupMembers, v)
		end
	end
	return groupMembers or {}
end

function getAllTurfers(col)
	local all = {}
	for i, v in ipairs(col:getElementsWithin("player")) do
		if (not v.dead and allowedToTurf[v.team.name] and exports.UCDgroups:getPlayerGroup(v)) then
			table.insert(all, v)
		end
	end
	return all
end

function provokeTurf(col, group)
	if (col and isElement(col) and group) then
		local groupMembers = getTurfGroupMembers(col, group)
		-- Cancel provocation if there are no members of the provoking group in the turf
		if (#groupMembers == 0) then
			provoking[col][group]:destroy()
			provoking[col][group] = nil
			return
		end
		if (not level[col][group]) then
			level[col][group] = 0
		end
		local ownerLevel = 100
		local groupsInTurf = 0
		for i in pairs(level[col]) do
			groupsInTurf = groupsInTurf + 1
		end
		outputDebugString(groupsInTurf.." groups in the turf")
		for group_, l in pairs(level[col]) do
			if (#groupMembers > #getTurfGroupMembers(col, group_) and group ~= group_) then
				if (level[col][group_] >= 5) then
				
					--if (groupsInTurf ~= 2) then
					--	return
					--end
					
					level[col][group] = level[col][group] + 5
					level[col][group_] = level[col][group_] - 5
					outputDebugString(group.." +5 provoke ("..level[col][group]..")")
					
					if (level[col][group] > level[col][group_] and col:getData("turfOwner") ~= group) then
						outputDebugString(group.." have taken a turf")
						col:setData("turfOwner", group)
						
						triggerEvent("onGroupTakeTurf", resourceRoot, group, col)
						
						for k, v in ipairs(getAllTurfers(col)) do
							exports.UCDdx:new(v, "This turf is now controlled by "..group, 0, 255, 0)
						end
					end
					
					triggerLatentClientEvent(getAllTurfers(col), "onClientTurf", resourceRoot, getTurfData(col))
				end
			end
			if (group_ ~= col:getData("turfOwner")) then
				ownerLevel = ownerLevel - l
			end
			--[[
			if (level[col][group_] > 50 and group_ ~= col:getData("turfOwner")) then
				outputDebugString(group_.." have taken a turf")
				col:setData("turfOwner", group_)
				for k, v in ipairs(getAllTurfers(col)) do
					exports.UCDdx:new(v, "This turf is now controlled by "..group_, 0, 255, 0)
				end
			end
			--]]
		end
		local radarArea = colToArea[col]
		if (ownerLevel <= 85) then
			if (radarArea.flashing) then
				--outputDebugString(tostring(col:getData("turfOwner")).." need to defend a turf")
				return
			else
				local id
				for k, v in ipairs(idToCol) do
					if (v == col) then
						id = k
						break
					end
				end
				local zone = getZoneName(turfCoordinates[id].spawn[1], turfCoordinates[id].spawn[2], turfCoordinates[id].spawn[3])
				exports.UCDgroups:messageGroup(col:getData("turfOwner"), "Your group's turf in "..tostring(zone).." needs defending", "info")
			end
			radarArea:setFlashing(true)
		else
			radarArea:setFlashing(false)
		end
	end
end

function onGroupTakeTurf(group, col)
	local members = exports.UCDgroups:getGroupOnlineMembers(group)
	for _, plr in ipairs(members) do
		if (plr:isWithinColShape(col) and allowedToTurf[plr.team.name] and not plr.inWater and isElementInLV(plr)) then
			-- Give money
			plr.money = plr.money + 300 -- Go through money resource
		end
	end
end
addEvent("onGroupTakeTurf")
addEventHandler("onGroupTakeTurf", root, onGroupTakeTurf)

function getTurfData(col)
	local temp = {}
	temp[1] = {col:getData("turfOwner"), level[col][col:getData("turfOwner")], {exports.UCDgroups:getGroupColour(col:getData("turfOwner"))}}-- or 255, 255, 255}}
	for g, l in pairs(level[col]) do
		if (g ~= col:getData("turfOwner") and l > 0) then
			table.insert(temp, {g, l, {exports.UCDgroups:getGroupColour(g)}})
		end
	end
	return temp
end

function onEnterTurf(plr, matchingDimension)
	if (plr and plr.type == "player" and plr.dimension == 0 and plr.interior == 0 and matchingDimension) then
		local group = exports.UCDgroups:getPlayerGroup(plr)
		if (not group or not allowedToTurf[plr.team.name]) then
			return false
		end
		exports.UCDdx:new(plr, "You have entered a turf controlled by "..source:getData("turfOwner"), 0, 255, 0)
		triggerLatentClientEvent(plr, "onClientTurf", plr, getTurfData(source))
		
		local groupMembers = getTurfGroupMembers(source, group)
		
		if (#groupMembers >= 1) then
			-- If they also aren't the current turf owners or not at 100
			if (source:getData("turfOwner") ~= group or level[source][group] ~= 100) then
				-- If they are already provoking, return
				if (provoking[source][group] and isTimer(provoking[source][group])) then
					outputDebugString(group.." is already provoking")
					return
				end
				provoking[source][group] = Timer(provokeTurf, 2000, 0, source, group) -- Set the timer which acts to provoke
				if (provoking[source][group]) then
					outputDebugString(group.." is beginning provocation")
				else
					outputDebugString(group.." is not beginning provocation")
				end
			else -- If they are the owners (defend the turf if it needs to be - create the timer anyway)
				
			end
		end
	end
end

function onExitTurf(plr, matchingDimension)
	if (plr and plr.type == "player" and plr.dimension == 0 and plr.interior == 0 and matchingDimension) then
		triggerLatentClientEvent(plr, "onClientExitTurf", plr) -- Need this to trigger regardless of groups
		
		local group = exports.UCDgroups:getPlayerGroup(plr)
		if (group) then
			local groupMembers = getTurfGroupMembers(source, group)
			
			-- If there is no one in the turf anymore, cancel provocation
			if (#groupMembers == 0) then
				if (provoking[source][group] and isTimer(provoking[source][group])) then
					provoking[source][group]:destroy()
					provoking[source][group] = nil
				end
			end
		end
	end
end

-- If a player from a group died in their own turf, and they killed themselves or someone else did, subtract some points
--[[
function onPlayerDead(_, killer)
	for _, col in ipairs(idToCol) do
		if (source:isWithinColShape(col)) then
			if (killer.type == "player") then
				
			elseif (not killer) then
				-- They killed themselves?
				-- todo
			end
			break
		end
	end
end
addEventHandler("onPlayerWasted", root, onPlayerDead)
--]]
