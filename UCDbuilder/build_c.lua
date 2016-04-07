local sX, sY = guiGetScreenSize()
local cursor = 0
local editing = false
local maxMoveDistance = 50 --default
local MAX_DISTANCE = 50	--units
local MIN_DISTANCE = 2	--units
local prev = {}

function toggleBuild()
	if (cursor == 0) then
		showCursor(true)
		cursor = 1
		exports.UCDdx:add("builder", "Click on an object to edit", 255, 255, 255)
		toggleAllControls(false, true, false)
	else
		showCursor(false)
		cursor = 0
		exports.UCDdx:del("builder")
		exports.UCDdx:del("builderdebug")
		toggleAllControls(true)
	end
	obj = nil
	showGridlines()
end
addEvent("UCDbuilder.toggleBuild", true)
addEventHandler("UCDbuilder.toggleBuild", root, toggleBuild)

function syncObject(obj, p, r)
	if (obj and isElement(obj)) then
		if (prev[1] == p.x and prev[2] == p.y and prev[3] == p.z and prev[4] == r.x and prev[5] == r.y and prev[6] == r.z) then
			return
		end
		
		triggerServerEvent("UCDbuilder.sync", resourceRoot, obj, {p.x, p.y, p.z, r.x, r.y, r.z})
		
		prev[1] = p.x
		prev[2] = p.y
		prev[3] = p.z
		prev[4] = r.x
		prev[5] = r.y
		prev[6] = r.z
	end
end

function onBuild(button, state, _, _, wX, wY, wZ, clickEle)
	if (clickEle and isElement(clickEle) and clickEle.type == "object" and state == "down" and cursor == 1) then
		-- If an object is selected, deselect it
		if (obj and clickEle ~= obj and (not clickEle or clickEle)) then
			obj = nil
			showGridlines()
			return
		end
		-- Only allow editing of objects made by the UCDbuilder resource
		if (clickEle.parent.parent.parent.id ~= "UCDbuilder") then
			outputChatBox("You can only edit Builder objects")
			return
		end
		
		if (button == "middle") then
			if (obj) then
				triggerServerEvent("UCDbuilder.destroy", resourceRoot, obj)
			end
			return
		elseif (button == "right" and obj) then
			outputChatBox("Hold RMB and use the mousewheel to rotate")
			return
		end
		-- If the distance between the object and the player is larger than the max dist
		--if ((clickEle.position - Vector3(wX, wY, wZ)):getLength() > MAX_DISTANCE) then
		if ((clickEle.position - localPlayer.position):getLength() > MAX_DISTANCE) then
			outputChatBox("This object is too far away")
			return
		end
		
		if (not obj) then
			outputChatBox("This object can be edited. Click and drag to move")
		end
		
		obj = clickEle
		showGridlines(obj)
	end
end
addEventHandler("onClientClick", root, onBuild)

function onMoveCursor()
	if (obj and cursor == 1) then
		-- If they are holding the mouse wheel down
		if (getKeyState("mouse1")) then
			
			local cX, cY = getCursorPosition()
			local absoluteX, absoluteY = cX * sX, cY * sY
			local worldX, worldY, worldZ = getWorldFromScreenPosition(absoluteX, absoluteY, MAX_DISTANCE)
			local oX, oY, oZ = getCameraMatrix()

			local surfaceFound, surfaceX, surfaceY, surfaceZ, element = processLineOfSight(oX, oY, oZ, worldX, worldY, worldZ, true, true, true, true, true, true, false, true, obj)
			
			if (element == localPlayer) then
				return
			end
			
			local p = localPlayer.position
			local o = obj.position
			
			--local dist = math.sqrt((p.x - o.x)^2 + (p.y - o.y)^2 + (p.z - o.z)^2)
			--exports.UCDdx:add("builderdebug", dist, 255, 255, 255)
			
			if (surfaceFound) then
				surfaceDistance = math.sqrt((surfaceX - oX)^2 + (surfaceY - oY)^2 + (surfaceZ - oZ)^2)
				if (surfaceDistance > maxMoveDistance) then
					surfaceFound = false
				end
			end
			
			if (surfaceFound) then
				baseOffset = getElementDistanceFromCentreOfMassToBaseOfModel(obj)
				local final = Vector3(getCoordsWithBoundingBox(surfaceX, surfaceY, surfaceZ))
				--obj.position = final
				syncObject(obj, final, obj.rotation)
			else
				local tempDistance = math.sqrt((worldX - oX)^2 + (worldY - oY)^2 + (worldZ - oZ)^2)
				local distanceRatio = maxMoveDistance / tempDistance
				local x = oX + (worldX - oX) * distanceRatio
				local y = oY + (worldY - oY) * distanceRatio
				local z = oZ + (worldZ - oZ) * distanceRatio
				--obj.position = Vector3(x, y, z)
				syncObject(obj, Vector3(x, y, z), obj.rotation)
			end
		elseif (getKeyState("lctrl") or getKeyState("lshift")) then
			-- Z axis
			local diff
			if (getKeyState("lctrl") and not getKeyState("lshift")) then
				diff = -0.05
			elseif (not getKeyState("lctrl") and getKeyState("lshift")) then
				diff = 0.05
			end
			syncObject(obj, Vector3(obj.position.x, obj.position.y, obj.position.z + diff), obj.rotation)
		elseif (getKeyState("arrow_l") or getKeyState("arrow_r")) then
			-- X axis
			local diff
			if (getKeyState("arrow_l") and not getKeyState("arrow_r")) then
				diff = -0.05
			elseif (not getKeyState("arrow_l") and getKeyState("arrow_r")) then
				diff = 0.05
			end
			syncObject(obj, Vector3(obj.position.x + diff, obj.position.y, obj.position.z), obj.rotation)
		elseif (getKeyState("arrow_u") or getKeyState("arrow_d")) then
			-- Y axis
			local diff
			if (getKeyState("arrow_u") and not getKeyState("arrow_d")) then
				diff = 0.05
			elseif (not getKeyState("arrow_u") and getKeyState("arrow_d")) then
				diff = -0.05
			end
			syncObject(obj, Vector3(obj.position.x, obj.position.y + diff, obj.position.z), obj.rotation)
		end
	end
end
addEventHandler("onClientRender", root, onMoveCursor)

function rotateWithMouseWheel(key, state)
	if (obj and cursor == 1 and state == "down") then
		if (getKeyState("mouse1")) then
			return
		end
		if (getKeyState("mouse2")) then
			local rot = obj.rotation
			local diff
			if (key == "mouse_wheel_down") then
				diff = rot.z - 1
			elseif (key == "mouse_wheel_up") then
				diff = rot.z + 1
			else
				return
			end
			--obj.rotation = Vector3(rot.x, rot.y, diff)
			syncObject(obj, obj.position, Vector3(rot.x, rot.y, diff))
		end
	end
end
bindKey("mouse_wheel_up", "down", rotateWithMouseWheel)
bindKey("mouse_wheel_down", "down", rotateWithMouseWheel)

function mouseWheelObjectZoom(key, state)
	if (obj and cursor == 1 and state == "down") then
		if (getKeyState("mouse2")) then
			return
		end
		if (getKeyState("mouse1")) then
			local speed = 1
			if (key == "mouse_wheel_down") then
				maxMoveDistance = math.max(maxMoveDistance - speed, MIN_DISTANCE)
				onMoveCursor()
			else
				maxMoveDistance = math.min(maxMoveDistance + speed, MAX_DISTANCE)
				onMoveCursor()
			end
		end
	end
end
bindKey("mouse_wheel_up", "down", mouseWheelObjectZoom)
bindKey("mouse_wheel_down", "down", mouseWheelObjectZoom)
