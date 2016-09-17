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
		{{233.3362, 1049.3322, 1084.0186}, {242.9789, 1018.1478, 1084.0145}},
		{{238.7755, 1029.7181, 1088.3099}, {236.7787, 1050.1949, 1084.0051}},
		{{235.4411, 1035.7085, 1088.3125}, {238.4865, 1033.0107, 1088.3125}},
	},
	[9] = 
	{
		{{2814.4932, -1166.7771, 1025.5778}, {2818.4856, -1173.1099, 1025.5703}},
		{{2818.5505, -1169.7209, 1029.1719}, {2818.9534, -1165.5623, 1029.1719}},
		{{2818.0806, -1165.752, 1025.5778}, {2809.28, -1171.1804, 1025.5703}},
	},
	[10] = 
	{
		{{2261.3438, -1206.9617, 1049.0308}, {2248.4177, -1211.9622, 1049.0234}},
		{{2253.3916, -1215.5105, 1049.0234}, {2253.3916, -1215.5105, 1049.0234}},
		{{2258.6096, -1220.262, 1049.0234}, {2255.9849, -1211.9327, 1049.0234}},
	},
	[11] = 
	{
		{{2496.7783, -1696.4917, 1014.7422}, {2500.0164, -1706.7634, 1014.7422}},
		{{2499.7703, -1710.4548, 1014.7422}, {2491.6563, -1701.1417, 1018.3438}},
		{{2493.9436, -1701.1321, 1018.3438}, {2495.3796, -1704.5273, 1018.3438}},
	},
	[12] = 
	{
		{{2260.7183, -1139.2073, 1050.6328}, {2264.0811, -1141.0079, 1050.6328}},
		{{2267.2151, -1134.4166, 1050.6328}, {2267.7676, -1141.2194, 1050.6328}},
		{{2260.9478, -1141.1854, 1050.6328}, {2263.0645, -1135.3182, 1050.6328}},
	},
	[13] = 
	{
		{{2368.321, -1134.4685, 1050.875}, {2367.5281, -1122.1541, 1050.875}},
		{{2370.3135, -1126.0063, 1050.875}, {2360.9368, -1130.8369, 1050.875}},
		{{2366.7637, -1120.2883, 1050.875}, {2373.5417, -1131.3523, 1050.875}},
	},
	[14] = 
	{
		{{2230.134, -1107.6173, 1050.8828}, {2230.3569, -1104.8698, 1050.8828}},
		{{2234.4006, -1106.4487, 1050.8828}, {2234.3123, -1104.9694, 1050.8828}},
		{{2234.2458, -1109.5114, 1050.8828}, {2231.9912, -1106.3807, 1050.8828}},
	},
	[15] = 
	{
		{{2285.2239, -1136.6199, 1050.8984}, {2277.5886, -1138.5231, 1050.8984}},
		{{2285.2219, -1133.9207, 1050.8984}, {2282.0417, -1135.8672, 1050.8984}},
		{{2280.3398, -1135.0557, 1050.8984}, {2277.5667, -1134.2345, 1050.8984}},
	},
	[16] = 
	{
		{{2184.0945, -1207.0739, 1049.0234}, {2187.9565, -1212.9009, 1049.0234}},
		{{2182.3965, -1202.49, 1049.0234}, {2182.3987, -1205.3772, 1049.0234}},
		{{2184.0994, -1201.6445, 1049.0308}, {2198.7854, -1219.1345, 1049.0234}},
	},
	[17] = 
	{
		{{2314.47, -1211.8534, 1049.0234}, {2319.9207, -1208.7886, 1049.0234}},
		{{2317.2979, -1211.8499, 1049.0234}, {2310.8386, -1207.6987, 1049.0234}},
		{{2320.1289, -1211.5837, 1049.0234}, {2308.1028, -1207.2772, 1049.0234}},
	},
	[18] = 
	{
		{{2211.3059, -1071.6768, 1050.4766}, {2208.5186, -1071.6139, 1050.4766}},
		{{2207.7871, -1071.8616, 1050.4766}, {2210.5344, -1077.3081, 1050.4844}},
		{{2205.0862, -1071.7561, 1050.4766}, {2208.2405, -1077.1154, 1050.4844}},
	},
	[19] = 
	{
		{{2240.9463, -1071.9719, 1049.0234}, {2242.7568, -1067.3594, 1049.0234}},
		{{2238.0015, -1064.8057, 1049.0234}, {2236.512, -1067.5122, 1049.0234}},
		{{2241.6326, -1078.5076, 1049.0234}, {2244.021, -1078.5757, 1049.0234}},
	},
	[20] = 
	{
		{{2313.1614, -1013.6863, 1050.2109}, {2314.2876, -1008.191, 1050.2109}},
		{{2316.7922, -1009.6821, 1050.2109}, {2327.0466, -1015.7479, 1050.2178}},
		{{2326.8479, -1015.2563, 1054.7111}, {2324.8784, -1008.1168, 1054.7188}},
	},
	[21] = 
	{
		{{2337.2788, -1062.577, 1049.031}, {2331.0361, -1068.3372, 1049.0234}},
		{{2343.5403, -1062.0211, 1049.0234}, {2335.1489, -1064.7814, 1049.0234}},
		{{2337.7573, -1067.2374, 1049.0234}, {2344.0256, -1068.3881, 1049.0234}},
	},
	[22] = 
	{
		{{1273.3846, -786.4949, 1089.9304}, {1292.1807, -791.9846, 1089.9375}},
		{{1273.6156, -800.3898, 1089.9309}, {1291.8937, -804.0322, 1089.9375}},
		{{1278.5883, -776.6212, 1090.7109}, {1283.3666, -837.3383, 1085.6328}},
	},
	[23] = 
	{
		{{248.2242, 301.8411, 999.1484}, {248.7324, 305.8331, 999.148}},
		{{248.8178, 304.0148, 999.1484}, {247.0331, 300.8354}},
		{{244.0446, 301.7513, 999.1484}, {248.7324, 305.8331, 999.148}},
	},
	[24] = 
	{
		{{268.3126, 307.4279, 999.1484}, {273.0536, 303.6228, 999.1558}},
		{{271.7234, 307.9991, 999.1484}, {267.1691, 303.6755, 999.1484}},
		{{273.0536, 303.6228, 999.1558}, {267.1691, 303.6755, 999.1484}},
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
		{{316.1421, 1117.1815, 1083.8828}, {325.7188, 1131.8018, 1083.8828}},
		{{305.8735, 1120.2188, 1083.8828}, {330.9896, 1128.6833, 1083.8828}},
		{{327.0077, 1118.4622, 1083.8828}, {330.8691, 1118.9468, 1083.8903}},
	},
	[27] = 
	{
		{{147.9287, 1373.5173, 1083.8594}, {153.6037, 1378.2905, 1083.8594}},
		{{140.1073, 1381.4323, 1083.8672}, {138.2874, 1383.8331, 1088.3672}},
		{{152.1862, 1368.3593, 1083.8594}, {138.2874, 1383.8331, 1088.3672}},
	},
	[28] = 
	{
		{{242.1097, 1071.6893, 1084.1875}, {241.8873, 1082.2631, 1084.1938}},
		{{224.9063, 1084.9069, 1084.2076}, {236.0179, 1082.2933, 1084.2344}},
		{{235.0375, 1079.6868, 1087.8126}, {237.0888, 1083.0186, 1087.8203}},
	},
	[29] = 
	{
		{{84.6014, 1331.8586, 1083.8594}, {78.4304, 1336.3024, 1083.8672}},
		{{79.5812, 1340.7487, 1083.8672}, {90.4503, 1333.689, 1088.3595}},
		{{77.7773, 1342.9181, 1088.3672}, {88.2648, 1340.5093, 1088.3672}},
	},
	[30] = 
	{
		{{21.4707, 1347.4819, 1084.375}, {19.117, 1349.6313, 1084.3812}},
		{{24.4248, 1350.7588, 1084.375}, {24.7727, 1347.4252, 1088.875}},
		{{28.9174, 1350.17, 1088.875}, {31.041, 1346.8457, 1084.375}},
	},
	[31] = 
	{
		{{370.9357, 1409.6907, 1081.3434}, {364.6916, 1429.4674, 1081.3359}},
		{{368.8625, 1431.5599, 1081.3434}, {362.271, 1417.1956, 1081.3281}},
		{{358.5354, 1414.0166, 1081.3356}, {371.224, 1412.6443, 1081.337}},
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

