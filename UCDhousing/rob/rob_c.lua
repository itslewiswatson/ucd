-------------------------------------------------------------------
--// PROJECT: Union of Clarity and Diversity
--// RESOURCE: UCDhousing
--// DEVELOPER(S): Lewis Watson (Noki)
--// DATE: 07/03/2016
--// PURPOSE: Client-side house robbing.
--// FILE: \rob\rob_c.lua [client]
-------------------------------------------------------------------

local disabledControls = {"walk", "sprint", "jump", "aim_weapon", "next_weapon", "previous_weapon", "fire"}
local destinations = {
	-- need to do sf and some country side
	{1431.697, 2620.3625, 11.3926}, -- LV TT turf
	{2580.7158, 2077.2678, 10.813}, -- North LV ammu
	{2193.2915, 2734.7463, 10.8203}, -- North LV burger shot
	{2609.6699, 1433.4579, 10.8203}, -- East LV
	{2160.2356, 727.831, 10.8203}, -- South LV
	
	{2309.3264, -12.2267, 32.5313}, -- Palomino
	{1286.736, 384.5921, 19.5547}, -- Montgomery
	{158.0782, -22.119, 1.5781}, -- Blueberry
	{790.1355, -609.1966, 16.3359}, -- Dillimore
	
	{856.1099, -1646.4517, 13.5588}, -- LS Verona beach
	{1769.2211, -2048.4094, 13.5593}, -- Ghetto near train station
	{2495.9412, -1754.7944, 13.4684}, -- Grove
	{2459.179, -1318.4813, 24}, -- Fav house robbing spot
	{2010.808, -1029.4069, 24.7701}, -- Las Collinas
}
local mab = {}
local houseMarkers = {
	--[[
	[interiorID] = 
	{
		{{x, y, z}, {x, y, z}},
		{{x, y, z}, {x, y, z}},
	}
	--]]
	[1] = 
	{
		{{244.1054, 1187.8848, 1080.2645}, {233.6735, 1208.7473, 1080.2578}},
		{{225.2519, 1188.5431, 1080.2578}, {220.125, 1194.0642, 1080.2578}},
		{{224.2136, 1196.4874, 1084.4141}, {237.5436, 1207.4929, 1084.3693}},
	},
	[2] =
	{
		{{219.2521, 1238.8999, 1082.1481}, {233.0799, 1248.1656, 1082.1406}},
		{{231.6389, 1244.4644, 1082.1406}, {222.9504, 1253.2241, 1082.1406}},
		{{224.1686, 1241.172, 1082.1406}, {217.1861, 1251.1779, 1082.1481}},
	},
	[3] = 
	{
		{{217.9442, 1288.2179, 1082.1406}, {225.795, 1293.0828, 1082.1406}},
		{{218.4608, 1292.7729, 1082.1406}, {225.2276, 1287.541, 1082.1328}},
		{{232.3228, 1290.046, 1082.1406}, {229.2341, 1287.1615, 1082.1406}},
	},
	[4] = 
	{
		{{320.828, 1478.9242, 1084.4404}, {325.3394, 1488.9866, 1084.4446}},
		{{328.8333, 1490.2247, 1084.4375}, {332.6343, 1484.4196, 1084.4387}},
		{{335.8072, 1480.0912, 1084.4364}, {323.9041, 1478.6791, 1084.4452}},
	},
	[5] = 
	{
		{{2462.4949, -1697.7559, 1013.5078}, {2455.583, -1703.5757, 1013.5078}},
		{{2452.0742, -1705.9607, 1013.5078}, {2449.4609, -1685.9984, 1013.5078}},
		{{2456.5054, -1695.4949, 1013.5078}, {2451.7886, -1691.8053, 1013.5078}},
	},
	[6] = 
	{
		{{234.5659, 1119.7927, 1080.9922}, {243.5902, 1106.6982, 1080.9922}},
		{{246.1019, 1112.1351, 1085.0139}, {241.4137, 1116.8788, 1084.9922}},
		{{243.2645, 1111.6643, 1085.0391}, {233.2438, 1109.9762, 1080.9922}},
	},
	[7] = 
	{
		{{384.2462, 1468.9017, 1080.187}, {375.5055, 1463.0876, 1080.1875}},
		{{384.2104, 1466.2495, 1080.1875}, {378.426, 1458.2986, 1080.1875}},
		{{372.2294, 1464.9943, 1080.1875}, {378.4206, 1455.9886, 1080.1875}},
	},
	[8] = 
	{
		{{}, {}},
		{{}, {}},
		{{}, {}},
	},
	[9] = 
	{
		{{}, {}},
		{{}, {}},
		{{}, {}},
	},
	[10] = 
	{
		{{}, {}},
		{{}, {}},
		{{}, {}},
	},
	[11] = 
	{
		{{}, {}},
		{{}, {}},
		{{}, {}},
	},
	[12] = 
	{
		{{}, {}},
		{{}, {}},
		{{}, {}},
	},
	[13] = 
	{
		{{}, {}},
		{{}, {}},
		{{}, {}},
	},
	[14] = 
	{
		{{}, {}},
		{{}, {}},
		{{}, {}},
	},
	[15] = 
	{
		{{}, {}},
		{{}, {}},
		{{}, {}},
	},
	[16] = 
	{
		{{}, {}},
		{{}, {}},
		{{}, {}},
	},
	[17] = 
	{
		{{}, {}},
		{{}, {}},
		{{}, {}},
	},
	[18] = 
	{
		{{}, {}},
		{{}, {}},
		{{}, {}},
	},
	[20] = 
	{
		{{}, {}},
		{{}, {}},
		{{}, {}},
	},
	[21] = 
	{
		{{}, {}},
		{{}, {}},
		{{}, {}},
	},
	[22] = 
	{
		{{}, {}},
		{{}, {}},
		{{}, {}},
	},
	[23] = 
	{
		{{}, {}},
		{{}, {}},
		{{}, {}},
	},
	[24] = 
	{
		{{}, {}},
		{{}, {}},
		{{}, {}},
	},
	[25] =
	{
		{{2336.4004, -1143.1626, 1050.7031}, {2332.3762, -1135.3767, 1050.7031}},
		{{2318.9158, -1137.0846, 1050.7031}, {2313.0276, -1143.8291, 1050.7031}},
		{{2311.0552, -1135.979, 1054.3047}, {2320.3696, -1134.9302, 1052.5}},
		{{2336.5164, -1135.9199, 1054.304}, {2337.9553, -1141.6927, 1054.3047}},
		{{2324.4324, -1140.7075, 1050.499}, {2310.9287, -1141.8047, 1054.3047}},
	},
	[26] = 
	{
		{{}, {}},
		{{}, {}},
		{{}, {}},
	},
	[27] = 
	{
		{{}, {}},
		{{}, {}},
		{{}, {}},
	},
	[28] = 
	{
		{{}, {}},
		{{}, {}},
		{{}, {}},
	},
	[29] = 
	{
		{{}, {}},
		{{}, {}},
		{{}, {}},
	},
	[30] = 
	{
		{{}, {}},
		{{}, {}},
		{{}, {}},
	},
	[31] = 
	{
		{{}, {}},
		{{}, {}},
		{{}, {}},
	},
	[32] = 
	{
		{{}, {}},
		{{}, {}},
		{{}, {}},
	},
}
local robMarkers = {}
local hitCount = 0
local markerCount = 0
local sprintDisabler

function manageRendering()
	exports.UCDdx:add("houserob_items", "Items: "..tostring(hitCount).."/"..tostring(markerCount), 255, 0, 0)
end

function fuark()
	toggleControl("enter_exit", false)
	addEventHandler("onClientVehicleStartEnter", root, cancelVehicleEntry)
end
function cancelVehicleEntry(ele)
	if (ele == localPlayer) then
		exports.UCDdx:new("You are currently robbing a house", 255, 0, 0)
		cancelEvent()
	end
end

function onClientRobMarkerHit(plr, matchingDimension)
	if (plr == localPlayer and matchingDimension) then
		hitCount = hitCount + 1
		removeEventHandler("onClientMarkerHit", source, onClientRobMarkerHit)
		for i = 1, #robMarkers do
			if (robMarkers[i] == source) then
				source:destroy()
				robMarkers[i] = nil
				break
			end
		end
	end
end

function onEnterHouse(houseID, interiorID, rob)
	if (houseID and interiorID and rob) then
		for _, v in ipairs(disabledControls) do
			toggleControl(v, false)
		end
		setControlState("walk", true)
		local i = math.random(1, #houseMarkers[interiorID])
		for k = 1, #houseMarkers[interiorID][i] do
			robMarkers[k] = Marker(houseMarkers[interiorID][i][k][1], houseMarkers[interiorID][i][k][2], houseMarkers[interiorID][i][k][3] - 1, "cylinder", 1, 32, 208, 11, 150)
			robMarkers[k].dimension = localPlayer.dimension
			robMarkers[k].interior = localPlayer.interior
			markerCount = markerCount + 1
			addEventHandler("onClientMarkerHit", robMarkers[k], onClientRobMarkerHit)
		end
		addEventHandler("onClientRender", root, manageRendering)
		exports.UCDdx:add("houserob_info", "Search the house for valuables", 255, 0, 0)
	end
end
addEvent("onClientEnterHouse", true)
addEventHandler("onClientEnterHouse", root, onEnterHouse)

function onLeaveHouse(houseID)
	if (robMarkers and #robMarkers >= 1) then
		for i = 1, #robMarkers do
			if (isElement(robMarkers[i])) then
				robMarkers[i]:destroy()
			end
		end
	end
	for _, v in ipairs(disabledControls) do
		toggleControl(v, true)
	end
	setControlState("walk", false)
	
	robMarkers = {}
	removeEventHandler("onClientRender", root, manageRendering)
	exports.UCDdx:del("houserob_items")
	exports.UCDdx:del("houserob_info")
	
	if (hitCount >= 1 and markerCount >= 1) then
		triggerServerEvent("UCDhousing.randomObject", resourceRoot)
		-- Create markers and blip for the rob stuff
		for i = 1, #destinations do
			local m = Marker(destinations[i][1], destinations[i][2], destinations[i][3] - 1, "cylinder", 2.5, 255, 0, 0, 150)
			local b = Blip.createAttachedTo(m, 51, nil, nil, nil, nil, nil, 0, 850)
			mab[i] = {m, b}
			addEventHandler("onClientMarkerHit", m, onHitRewardMarker)
		end
		MC = markerCount
		HC = hitCount
		exports.UCDdx:add("houserob_info", "/giveup if you want to give up", 255, 0, 0)
		exports.UCDdx:add("houserob_post", "Go to a truck blip to finish the robbery", 255, 0, 0)
		sprintDisabler = Timer(disableSprint, 1000, 1)
		toggleControl("sprint", false)
	else
		exports.UCDactions:clearAction()
	end	
	
	markerCount = 0
	hitCount = 0
end
addEvent("onClientLeaveHouse", true)
addEventHandler("onClientLeaveHouse", root, onLeaveHouse)

function restore()
	if (sprintDisabler and isTimer(sprintDisabler)) then
		sprintDisabler:destroy()
		sprintDisabler = nil
	end
	toggleControl("sprint", true)
	HC = nil
	MC = nil
	exports.UCDdx:del("houserob_post")
	exports.UCDdx:del("houserob_info")
	for _, v in ipairs(mab) do
		removeEventHandler("onClientMarkerHit", v[1], onHitRewardMarker)
		v[1]:destroy()
		v[2]:destroy()
	end
	mab = {}
end
addEvent("UCDhousing.rob.restore", true)
addEventHandler("UCDhousing.rob.restore", root, restore)

function onHitRewardMarker(plr, matchingDimension)
	if (plr == localPlayer and not plr.vehicle and matchingDimension) then
		Camera.fade(false, 1, 0, 0, 0)
		toggleAllControls(false, true, false)
		Timer(function () Camera.fade(true) toggleAllControls(true) end, 1000, 1)
		triggerServerEvent("UCDhousing.completeHouseRob", resourceRoot, {HC, MC})
		restore()
	end
end

function disableSprint()
	toggleControl("sprint", false)
end

function isPlayerRobbing()
	if (MC or HC or markerCount > 0 or hitCount > 0) then
		return true
	end
	return false
end

function nToRob(_, _, plr, thePickup)
	if (not UCDhousing) then
		removeHouseNotification()
		local houseID = thePickup:getData("houseID")
		outputDebugString("Robbing houseID = "..tostring(houseID))
		-- triggerServerEvent("UCDhousing.enterHouse", localPlayer, houseID, true) -- true on the end because we are robbing it
		triggerServerEvent("UCDhousing.robHouse", localPlayer, houseID)
	else
		exports.UCDdx:new("You need to close the house panel to rob this house", 255, 0, 0)
	end
end

