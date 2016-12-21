local markerData = {}
local offset = 75

function cacheMarkers()
	markerData = {}
	for i, m in ipairs(Element.getAllByType("marker")) do
		if (m:getData("displayText")) then
			table.insert(markerData, {m:getData("displayText"), m.position})
		end
	end
end
Timer(cacheMarkers, 5 * 60000, 0) -- Cache them every 5 minutes, just in case
addEventHandler("onClientResourceStart", root, cacheMarkers) -- Every time a resource starts, recache them (just in case marker data has been changed)

function renderMarkerText()
	for ind, dat in ipairs(markerData) do
		local x, y, z = dat[2].x, dat[2].y, dat[2].z
		local distance = getDistanceBetweenPoints3D(x, y, z, localPlayer.position)
		local cX, cY, cZ = getCameraMatrix()
		if (distance <= offset) then
			if (isLineOfSightClear(cX, cY, cZ, x, y, z + 1, _, _, _, _, _, _, _, localPlayer)) then
				local sX, sY = getScreenFromWorldPosition(x, y, z + 1, 0.06)
				if (sX and sY) then
					local scale = 1 / ((1 / 3) * (distance / offset))
					dxDrawText(tostring(dat[1]), sX + 1, sY - 30 + 1, sX + 1, sY - 30 + 1, tocolor(0, 0, 0, 255), math.min (0.4 * (offset / distance) * 1.4, 4), "default-bold", "center", "bottom", false, false, false)
					dxDrawText(tostring(dat[1]), sX + 1, sY - 30 + 1, sX - 1, sY - 30 + 1, tocolor(0, 0, 0, 255), math.min (0.4 * (offset / distance) * 1.4, 4), "default-bold", "center", "bottom", false, false, false)
					dxDrawText(tostring(dat[1]), sX - 1, sY - 30 - 1, sX + 1, sY - 30 - 1, tocolor(0, 0, 0, 255), math.min (0.4 * (offset / distance) * 1.4, 4), "default-bold", "center", "bottom", false, false, false)
					dxDrawText(tostring(dat[1]), sX - 1, sY - 30 - 1, sX - 1, sY - 30 - 1, tocolor(0, 0, 0, 255), math.min (0.4 * (offset / distance) * 1.4, 4), "default-bold", "center", "bottom", false, false, false)
					dxDrawText(tostring(dat[1]), sX, sY - 30, sX, sY - 30, tocolor(255, 255, 255, 255), math.min (0.4 * (offset / distance) * 1.4, 4), "default-bold", "center", "bottom", false, false, false)
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