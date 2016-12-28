function isPositionInZone(x, y, z, zoneID)
	local position = Vector3(_zoneData[zoneID].x, _zoneData[zoneID].y, _zoneData[zoneID].z)
	local dimensions = Vector3(_zoneData[zoneID].l, _zoneData[zoneID].w, _zoneData[zoneID].h)
	
	if (x < position.x or x > position.x + dimensions.x) then
		return false, "x"
	end
	if (y < position.y or y > position.y + dimensions.y) then
		return false, "y"
	end
	if (z < position.z or z > position.z + dimensions.z) then
		return false, "z"
	end
	return true
end
