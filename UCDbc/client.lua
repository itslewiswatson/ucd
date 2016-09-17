local endPoses = {
	{x = 1477.3679, y = 1174.1127, z = 10.8203, rot = 0},
	{x = 1457.6606, y = 2025.8295, z = 10.8203, rot = 180},
	{x = 1583.4188, y = 2296.4595, z = 14.8222, rot = 270},
	{x = 1874.9923, y = 2339.6074, z = 16.0224, rot = 270},
	{x = 1676.6254, y = 1449.4098, z = 10.7839, rot = 270},
	{x = 1910.9481, y = 1342.8011, z = 24.7188, rot = 270},
	{x = 2204.1094, y = 1285.5223, z = 23.7011, rot = 270},
	{x = 2272.9263, y = 1395.5236, z = 42.8203, rot = 270},
	{x = 2483.4512, y = 1527.7893, z = 11.1359, rot = 316.2683},
	{x = 2483.4512, y = 1527.7893, z = 11.1359, rot = 316.2683},
	{x = 2039.3998, y = 1907.5741, z = 25.0625, rot = 270},
	{x = 2456.8867, y = 1884.6825, z = 21.6909, rot = 270},
}

local blip, marker, ped, bcTaker, colshape, endPos = nil

function bcEnd(plr, matchingDimension)
	if (plr and isElement(plr) and plr.type == "player" and matchingDimension) then
		if (bcTaker ~= plr) then return end
		triggerServerEvent("bcEnd", resourceRoot, endPos.x, endPos.y, endPos.z)
		marker:destroy()
		blip:destroy()
		ped:destroy()
		colshape:destroy()
		endPos = nil
	end
end

addEvent("bcDoBlip", true)
addEventHandler("bcDoBlip", resourceRoot,
	function (_do)
		if (_do) then
			if (not endPos) then
				endPos = endPoses[math.random(#endPoses)]
			end
			bcTaker = localPlayer
			blip = Blip(endPos.x, endPos.y, endPos.z, 46)
			marker = Marker(endPos.x, endPos.y, endPos.z, "checkpoint", 4, 0, 255, 0)
			ped = Ped(294, endPos.x, endPos.y, endPos.z, endPos.rot)
			colshape = ColShape.Sphere(endPos.x, endPos.y, endPos.z, 5)
			ped.collisions = false
			addEventHandler("onClientColShapeHit", colshape, bcEnd)
		else
			removeEventHandler("onClientColShapeHit", colshape, bcEnd)
			blip:destroy()
			marker:destroy()
			ped:destroy()
			colshape:destroy()
		end
	end
)

addEventHandler("onClientRender", root,
	function ()
		if (localPlayer == bcTaker) then
			if (localPlayer.inWater) then
				triggerServerEvent("bcDrop", resourceRoot)
			end
		end
	end
)