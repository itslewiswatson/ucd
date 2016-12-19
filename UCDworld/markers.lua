function goThroughMarkers()
	for i, m in ipairs(Element.getAllByType("marker")) do
		if (m:getData("displayText")) then
			local x, y, z = m.position.x, m.position.y, m.position.z
			local offset = 75
			local distance = getDistanceBetweenPoints3D(x, y, z, localPlayer.position)
			local cx, cy, cz = getCameraMatrix()
			if (distance <= offset) then
				if (isLineOfSightClear(cx, cy, cz, x, y, z + 1, _, _, _, _, _, _, _, localPlayer)) then
					local sX, sY = getScreenFromWorldPosition(x, y, z + 1, 0.06)
					if (sX and sY) then
						local scale = 1 / ((1 / 3) * (distance / offset))

						dxDrawText(tostring(m:getData("displayText")), sX + 1, sY - 30 + 1, sX + 1, sY - 30 + 1, tocolor(0, 0, 0, 255), math.min (0.4 * (offset/distance) * 1.4, 4), "default-bold", "center", "bottom", false, false, false)
						dxDrawText(tostring(m:getData("displayText")), sX + 1, sY - 30 + 1, sX - 1, sY - 30 + 1, tocolor(0, 0, 0, 255), math.min (0.4 * (offset/distance) * 1.4, 4), "default-bold", "center", "bottom", false, false, false)
						dxDrawText(tostring(m:getData("displayText")), sX - 1, sY - 30 - 1, sX + 1, sY - 30 - 1, tocolor(0, 0, 0, 255), math.min (0.4 * (offset/distance) * 1.4, 4), "default-bold", "center", "bottom", false, false, false)
						dxDrawText(tostring(m:getData("displayText")), sX - 1, sY - 30 - 1, sX - 1, sY - 30 - 1, tocolor(0, 0, 0, 255), math.min (0.4 * (offset/distance) * 1.4, 4), "default-bold", "center", "bottom", false, false, false)

						dxDrawText(tostring(m:getData("displayText")), sX, sY - 30, sX, sY - 30, tocolor(255, 255, 255, 255), math.min (0.4 * (offset/distance) * 1.4, 4), "default-bold", "center", "bottom", false, false, false)
					end
				end
			end
		end
	end
end

function enable(new)
	removeEventHandler("onClientRender", root, goThroughMarkers)
	if (new == "Yes") then
		addEventHandler("onClientRender", root, goThroughMarkers)
	end
end
enable(exports.UCDsettings:getSetting("indicatetexts"))