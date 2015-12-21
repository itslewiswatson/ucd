local wires_and_cables = {
	--9569, 9568, 9567, 9558, 9532, 8981, 8969, 8608, 8607, 8596, 8595, 8594, 8593
	-- Objects that we replace
	1316, 1317, -- hoop and cylinder marker types
	
	17455, 1307,
	
	-- Objects to completely remove
	1290, 1283, 1294, 1297, 1226, 3516, 1350, 1231, 3460, 3463, 643, 642, 1315,
	
	-- Annoying wires and alpha objects
	--9557, 8487, 8324, 7926, 7708, 6972, 6964, 5844,
	9569, 9568, 9567, 9558, 9352, 8981, 8969, 8608, 8607, 8596, 8595, 8594, 8593, 8087,
	8086, 8085, 8084, 8083, 8082, 8081, 7862, 7649, 7648, 7647, 7646, 7645, 7644, 7643,
	7642, 7641, 7640, 7639, 7638, 7637, 7609, 7608, 7607, 7598, 7578, 7577, 7576, 7575,
	7574, 7573, 7572, 7571, 7570, 7569, 7568, 7567, 7566, 7565, 7564, 7563, 7562, 7543,
	7542, 7541, 7087, 7086, 7085, 7084, 7083, 7082, 7081, 7080, 7079, 7079, 7077, 7076,
	7075, 5783, 5764, 5681, 5337, 5326, 5323, 5295, 5294, 5293, 5292, 18472, 18471, 18470,
	18448, 18215, 18214, 18213, 18212, 18211, 18210, 18209, 18208, 18207, 18206, 18205, 18204,
	17530, 17527, 17518, 17504, 17434, 17433, 17432, 17431, 17430, 17429, 17428, 17427, 17426,
	17048, 17047, 17046, 16622, 16374, 16373, 16372, 16371, 16307, 16306, 16292, 16291, 16290,
	16289, 16288, 16286, 16284, 16283, 16282, 16270, 16269, 16268, 16099, 16050, 16049, 16048,
	16047, 16046, 16045, 16044, 16043, 16042, 16041, 16040, 16039, 16038, 16015, 16014, 16013,
	13864, 13863, 13862, 13861, 13806, 13743, 13731, 13712, 13452, 13451, 13449, 13448, 13447,
	13444, 13443, 13442, 13441, 13440, 13439, 13437, 13436, 13375, 13374, 13205, 13143, 13137,
	11627, 11626, 11625, 11610, 11609, 11608, 11565, 11564, 11563, 11562, 11561, 11478, 11477, 
	11476, 11460, 10743, 10742, 10741, 10740, 10739, 10738, 10737, 10736, 10735, 10734, 10712,
	10711, 10710, 10709, 10708, 10707, 10706, 10705, 10704, 10703, 10702, 10701, 10700, 10699,
	10698, 10697, 10696, 10695, 10267, 10040, 10012,
	
	4983, 5031, 5231, 5232, 5233, 5312, 5464,
	
	-- more wires
	16747, 16746, 16745, 16744, 16743, 16742, 16741, 16740, 16739, 16738, 16737, 16736, 16735, 
	
	9154, 5150, 5290, 13018, 17936, 
	-- Objects we can do either with
	4574, -- The annoying bit of that building in LS that planes crash into
}

for _, i in pairs(wires_and_cables) do
	local a = removeWorldModel(i, 10000, 0, 0, 0)
	if not a then outputDebugString("Could not remove "..i) end
end

function applyMods()
	engineReplaceCOL(engineLoadCOL("island.col"), 1316 )
	engineImportTXD(engineLoadTXD("island.txd", true), 1316 )
	engineReplaceModel(engineLoadDFF("island.dff", 1316 ), 1316 )
	engineSetModelLODDistance(1316, 180)
	
	engineReplaceCOL(engineLoadCOL("vehpad.col"), 17455)
	engineReplaceModel(engineLoadDFF("vehpad.dff"), 17455)
	engineImportTXD(engineLoadTXD("spawnpads.txd", true), 17455)
	
		-- island
	local island = createObject(1316, -3341.5, 2086, 1.2)
	local island_lod = createObject(1316, -3341.5, 2086, 1.2, 0, 0, 0, true)
	setElementDoubleSided(island, true)
	island:setLowLOD(island_lod)
	
	
end
addEventHandler( "onClientResourceStart", resourceRoot, applyMods )


function create()

	
end
addEventHandler( "onClientResourceStart", resourceRoot, create )
	
	