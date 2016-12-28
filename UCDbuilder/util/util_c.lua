function getCoordsWithBoundingBox(origX, origY, origZ)
	local newX, newY, newZ = origX, origY, origZ
	local _, _, minZ = getElementBoundingBox(obj)
	local surfaceFound, surfaceX, surfaceY, surfaceZ, element = processLineOfSight(origX, origY, origZ + 0.5, origX, origY, origZ + minZ, true, true, true, true, true, true, false, true, obj)
	
	if (surfaceFound) then
		newZ = surfaceZ + baseOffset
	end
	return newX, newY, newZ
end
