local skins = {1, 2, 7, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 32, 33, 34, 35, 36, 37, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 57, 58, 59, 60, 61, 62, 66, 67, 68, 70, 71, 72, 73, 78, 79, 80, 81, 82, 83, 84, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 120, 121, 122, 123, 124, 125, 126, 127, 128, 132, 133, 134, 135, 136, 137, 142, 143, 144, 146, 147, 153, 154, 155, 156, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 170, 171, 173, 174, 175, 176, 177, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 200, 202, 203, 204, 206, 209, 210, 212, 213, 217, 220, 221, 222, 223, 227, 228, 229, 230, 234, 235, 236, 239, 240, 241, 242, 247, 248, 249, 250, 252, 253, 254, 255, 258, 259, 260, 261, 262, 264, 265, 266, 267, 268, 269, 270, 271, 272, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 290, 291, 292, 293, 294, 295, 296, 297, 299, 300, 301, 302, 303, 305, 306, 307, 308, 309, 310, 311, 312, 9, 10, 11, 12, 13, 31, 38, 39, 40, 41, 53, 54, 55, 56, 63, 64, 69, 75, 76, 77, 85, 87, 88, 89, 90, 91, 92, 93, 129, 130, 131, 138, 139, 140, 141, 145, 148, 150, 151, 152, 157, 169, 172, 178, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 201, 205, 207, 211, 214, 215, 216, 218, 219, 224, 225, 226, 231, 232, 233, 237, 238, 243, 244, 245, 246, 251, 256, 257, 263, 298, 304}
local objects = {1210, 367}
local destinations = {
	{x = 1968.6837, y = -1482.7329, z = 10.8281, rot = 90, objs = {{1996.3604, -1478.6409, 11.644}, {1955.5939, -1474.5669, 13.5469}, {1972.6407, -1473.288, 13.5564}, {1960.7535, -1494.8043, 3.3559}}},
}
local curr
local prev
local ped
local blip
local col2id = {}
local id2obj = {}
local hitCount = 0
local objCount

addEventHandler("onClientResourceStart", resourceRoot,
	function ()
		if (localPlayer:getData("jobName") == "Detective") then
			newMission()
		end
	end
)

addEvent("onClientPlayerGetJob", true)
addEventHandler("onClientPlayerGetJob", root,
	function (jobName)
		if (jobName == "Detective") then
			newMission()
		end
	end
)

function newMission()
	if (curr) then
		prev = curr
	end
	
	repeat curr = math.random(1, #destinations)
	until curr ~= prev
	
	local dest = destinations[curr]
	
	ped = Ped(math.random(1, #skins), dest.x, dest.y, dest.z)
	blip = Blip.createAttachedTo(ped, 23)
	ped.rotation = Vector3(0, 0, dest.rot)
	ped.health = 0
	ped.frozen = true
	
	objCount = #dest.objs
	hitCount = 0
	exports.UCDdx:add("detective", "Clues: "..tostring(hitCount).."/"..tostring(objCount), 30, 144, 255)
	
	for k, v in ipairs(dest.objs) do
		local sphere = ColShape.Sphere(v[1], v[2], v[3], 1)
		addEventHandler("onClientColShapeHit", sphere, onEvidenceHit)
		local obj = Object(objects[math.random(1, #objects)], v[1], v[2], v[3] - 0.8, 90, 90, 0)
		obj:setCollisionsEnabled(false)
		col2id[sphere] = k
		id2obj[k] = obj
	end
end

function onEvidenceHit(plr, matchingDimension)
	if (plr and plr.type == "player" and plr == localPlayer and matchingDimension) then
		
		id2obj[col2id[source]]:destroy()
		id2obj[col2id[source]] = nil
		source:destroy()
		col2id[source] = nil
		hitCount = hitCount + 1
		exports.UCDdx:add("detective", "Clues: "..tostring(hitCount).."/"..tostring(objCount), 30, 144, 255)

		
		if (#id2obj == 0) then
			ped:destroy()
			blip:destroy()
			exports.UCDdx:del("detective")
			-- trigger server event for payment
			-- do shit in a callback from the server
		end
	end
end
