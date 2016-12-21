local markerData = {}
local viewDistance = 75 -- Possibly create a setting for this

function isMarkerCached(m)
	for i, data in ipairs(markerData) do
		if (data[2] == m) then
			return i
		end
	end
	return false
end

function cacheMarkers()
	-- There were roughly 350 markers client-side when I checked (21/12/2016). I don't think it's a good idea to continually cache all 350 so frequently.
	-- This new way of doing it takes ~17.5 seconds if we have 350 markers ((50 * n) / 1000, where n is the number of markers)
	-- Checking if the marker is already cached allows them to stay there and not disappear
	-- If only MTA allowed us to use timer intervals < 50ms...
	
	local _markers = Element.getAllByType("marker") -- Lua passes by value for tables and not reference, so new markers created within the 17.5 second range will have no effect
	
	-- Remove markers that don't exist anymore
	for i, data in ipairs(markerData) do
		local m = data[2]
		if (not m or not isElement(m)) then
			--outputDebugString("Removing "..i.." from markerData ("..tostring(not m).." "..tostring(not isElement(m))..")")
			table.remove(markerData, i)
		end
	end
	
	local i = 1
	function _cacheMarker()
		local m = _markers[i]
		
		if (m:getData("displayText")) then
			if (isMarkerCached(m)) then
				-- We can safely do this, I think
				markerData[isMarkerCached(m)] = {m:getData("displayText"), m}
			else
				table.insert(markerData, {m:getData("displayText"), m})
			end
		end
		
		if (not _markers[i + 1]) then
			return
		end
		
		i = i + 1
		Timer(_cacheMarker, 50, 1)
	end
	_cacheMarker() -- Good old recursion
end
Timer(cacheMarkers, 5 * 60000, 0) -- Cache them every 5 minutes, just in case
addEventHandler("onClientResourceStart", root, cacheMarkers) -- Every time a resource starts, recache them (just in case marker data has been changed)
addCommandHandler("cachemarkers", cacheMarkers, false, false)

function renderMarkerText()
	for ind, dat in ipairs(markerData) do
		local x, y, z = dat[2].position.x, dat[2].position.y, dat[2].position.z
		local distance = getDistanceBetweenPoints3D(x, y, z, localPlayer.position)
		local cX, cY, cZ = getCameraMatrix()
		if (distance <= viewDistance) then
			if (not Camera.target or (Camera.target.type ~= "vehicle" and Camera.target.type ~= "player")) then
				return
			end
			if (isLineOfSightClear(cX, cY, cZ, x, y, z + 1, _, _, _, _, _, _, _, localPlayer)) then
				local sX, sY = getScreenFromWorldPosition(x, y, z + 1, 0.06)
				if (sX and sY) then
					local msg = dat[1]
					local scale = 1 / ((1 / 3) * (distance / viewDistance))
					dxDrawText(tostring(msg), sX + 1, sY - 30 + 1, sX + 1, sY - 30 + 1, tocolor(0, 0, 0, 255), math.min (0.4 * (viewDistance / distance) * 1.4, 4), "default-bold", "center", "bottom", false, false, false)
					dxDrawText(tostring(msg), sX + 1, sY - 30 + 1, sX - 1, sY - 30 + 1, tocolor(0, 0, 0, 255), math.min (0.4 * (viewDistance / distance) * 1.4, 4), "default-bold", "center", "bottom", false, false, false)
					dxDrawText(tostring(msg), sX - 1, sY - 30 - 1, sX + 1, sY - 30 - 1, tocolor(0, 0, 0, 255), math.min (0.4 * (viewDistance / distance) * 1.4, 4), "default-bold", "center", "bottom", false, false, false)
					dxDrawText(tostring(msg), sX - 1, sY - 30 - 1, sX - 1, sY - 30 - 1, tocolor(0, 0, 0, 255), math.min (0.4 * (viewDistance / distance) * 1.4, 4), "default-bold", "center", "bottom", false, false, false)
					dxDrawText(tostring(msg), sX, sY - 30, sX, sY - 30, tocolor(255, 255, 255, 255), math.min (0.4 * (viewDistance / distance) * 1.4, 4), "default-bold", "center", "bottom", false, false, false)
				end
			end
		end
	end
end

function enable(new)
	removeEventHandler("onClientRender", root, renderMarkerText)
	if (new == "Yes") then
		addEventHandler("onClientRender", root, renderMarkerText)
	end
end
enable(exports.UCDsettings:getSetting("indicatetexts"))
