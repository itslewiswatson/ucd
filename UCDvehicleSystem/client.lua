local blip = {}
playerVehicles = {}

function syncIdToVehicle(tbl)
	idToVehicle = tbl
end
addEvent("UCDvehicleSystem.syncIdToVehicle", true)
addEventHandler("UCDvehicleSystem.syncIdToVehicle", root, syncIdToVehicle)

triggerServerEvent("UCDvehicleSystem.getIdToVehicleTable", localPlayer) -- Sync the idToVehicle table when the resource starts
triggerServerEvent("UCDvehicleSystem.loadPlayerVehicles", localPlayer) -- Sync the playerVehicles table when the resource starts

function onClientVehicleEnter(theVehicle, seat)
	if (source ~= localPlayer) then return end
	local owner = theVehicle:getData("owner")
	if (not owner or seat ~= 0 or localPlayer:getName() == owner) then return end
	
	exports.UCDdx:new("This vehicle is owned by "..owner, 0, 255, 0)
end
addEventHandler("onClientPlayerVehicleEnter", localPlayer, onClientVehicleEnter)

GUIEditor = {gridlist = {}, window = {}, button = {}, label = {}}

function updateVehicleGrid(vehicleID)
	if (not vehicleID) then return end
	outputDebugString("Updating grid for vehicleID = "..vehicleID)
	if (not vehicles[vehicleID].row) then
		vehicles[vehicleID].row = guiGridListAddRow(GUIEditor.gridlist[1]) -- make oop
	end
	local row = vehicles[vehicleID].row
	
	if (idToVehicle[vehicleID]) then
		local vehicleEle = idToVehicle[vehicleID]
		model = getVehicleNameFromModel(vehicleEle:getModel())
		health = exports.UCDutil:mathround(vehicleEle:getHealth() / 10)
		fuel = 100
	else
		model = getVehicleNameFromModel(getVehicleData(vehicleID, "model")) -- Wait until this is oop
		health = exports.UCDutil:mathround(getVehicleData(vehicleID, "health") / 10)
		fuel = 100 --idToVehicle[vehicleID] -- Get the fuel later
	end
	
	if (health <= 40) then
		hR, hG, hB = 255, 50, 50
	elseif (health > 40) and (health <= 65) then
		hR, hG, hB = 255, 150, 0
	elseif (health > 65) and (health <= 85) then
		hR, hG, hB = 255, 255, 0
	else
		hR, hG, hB = 0, 255, 0
	end
	if (fuel <= 40) then
		fR, fG, fB = 255, 50, 50
	elseif (fuel > 40) and (fuel <= 65) then
		hR, hG, hB = 255, 150, 0
	elseif (fuel > 65) and (fuel <= 85) then
		hR, hG, hB = 255, 255, 0
	else
		fR, fG, fB = 0, 255, 0
	end
	
	guiGridListSetItemText(GUIEditor.gridlist[1], row, 1, tostring(model), false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], row, 2, tostring(health).."%", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], row, 3, tostring(fuel), false, false)
		
	guiGridListSetItemColor(GUIEditor.gridlist[1], row, 2, hR, hG, hB, 255)
	guiGridListSetItemColor(GUIEditor.gridlist[1], row, 3, fR, fG, fB, 255)
	
	guiGridListSetItemData(GUIEditor.gridlist[1], row, 1, vehicleID) -- Vehicle ID
end

function populateGridList()
	--guiGridListClear(GUIEditor.gridlist[1])
	for i, v in pairs(vehicles) do
		if v.ownerID == localPlayer:getData("accountID") then
			updateVehicleGrid(i)
		end
	end
end

function createGUI()
	GUIEditor.window[1] = guiCreateWindow(586, 330, 326, 333, "UCD | Vehicles", false)
	guiWindowSetSizable(GUIEditor.window[1], false)
	guiSetVisible(GUIEditor.window[1], false)
	GUIEditor.gridlist[1] = guiCreateGridList(11, 31, 305, 186, false, GUIEditor.window[1])
	guiGridListAddColumn(GUIEditor.gridlist[1], "Vehicle", 0.5)
	guiGridListAddColumn(GUIEditor.gridlist[1], "HP", 0.2)
	guiGridListAddColumn(GUIEditor.gridlist[1], "Fuel", 0.2)
	guiSetProperty(GUIEditor.gridlist[1], "SortSettingEnabled", "False")
	
	GUIEditor.button[1] = guiCreateButton(11, 247, 66, 32, "Recover", false, GUIEditor.window[1])
	GUIEditor.button[2] = guiCreateButton(91, 247, 66, 32, "Toggle blip", false, GUIEditor.window[1])
	GUIEditor.button[3] = guiCreateButton(171, 247, 66, 32, "Toggle lock", false, GUIEditor.window[1])
	GUIEditor.button[4] = guiCreateButton(251, 247, 66, 32, "Sell", false, GUIEditor.window[1])
	
	GUIEditor.button[5] = guiCreateButton(11, 289, 66, 32, "Spawn", false, GUIEditor.window[1])
	GUIEditor.button[6] = guiCreateButton(91, 289, 66, 32, "Hide", false, GUIEditor.window[1])
	GUIEditor.button[7] = guiCreateButton(171, 289, 66, 32, "Spectate", false, GUIEditor.window[1])
	GUIEditor.button[8] = guiCreateButton(251, 290, 66, 32, "Close", false, GUIEditor.window[1])
	
	--GUIEditor.label[1] = guiCreateLabel(11, 223, 303, 18, "Selected: NRG-500 - LV, Julius Thruway South", false, GUIEditor.window[1])  
	GUIEditor.label[1] = guiCreateLabel(12, 222, 303, 18, "Selected: N/A", false, GUIEditor.window[1])  

	populateGridList()
end
addEventHandler("onClientResourceStart", resourceRoot, createGUI)

function toggleGUI()
	if (not isElement(GUIEditor.window[1])) then
		createGUI()
		--triggerServerEvent("UCDvehicleSystem.getPlayerVehicleTable", localPlayer)
	end
	if (not guiGetVisible(GUIEditor.window[1])) then
		guiSetVisible(GUIEditor.window[1], true)
		
		for i, v in pairs(playerVehicles[localPlayer]) do
			-- Should we update them regardless of whether they are spawned in or not?
			if (idToVehicle[v]) then
				updateVehicleGrid(v)
			end
		end
		
		local row = guiGridListGetSelectedItem(GUIEditor.gridlist[1])
		if (row ~= -1 and row and row ~= nil) then
			local vehicleID = guiGridListGetItemData(GUIEditor.gridlist[1], row, 1)
			if (vehicleID and idToVehicle[vehicleID]) then
				local x, y, z = getElementPosition(idToVehicle[vehicleID])
				GUIEditor.label[1]:setText("Selected: "..getVehicleNameFromModel(getVehicleData(vehicleID, "model")).." - "..exports.UCDutil:getCityZoneFromXYZ(x, y, z)..", "..getZoneName(x, y, z))
			end
		end
		
	else
		guiSetVisible(GUIEditor.window[1], false)
	end
	showCursor(not isCursorShowing())
end
addCommandHandler("vehicles", toggleGUI, false, false)
bindKey("F3", "down", "vehicles")

function lolrender()
	local vehicleVector = vehicle:getPosition()
	vehicleVector.z = vehicleVector.z + 10
	local vehicleVector2 = vehicle:getPosition()
	Camera.setMatrix(vehicleVector, vehicleVector2)
end

function handleInput(button, state)
	if (source:getParent() == GUIEditor.gridlist[1] or source:getParent() == GUIEditor.window[1]) then
		local row = guiGridListGetSelectedItem(GUIEditor.gridlist[1])
		-- Instead of nesting this in every elseif
		if (row == -1 or not row or row == nil) then
			GUIEditor.label[1]:setText("Selected: N/A") -- If there is no row we don't display the data
			if (source:getParent() == GUIEditor.window[1] and (source ~= GUIEditor.gridlist[1] and source ~= GUIEditor.button[8])) then
				exports.UCDdx:new("You did not select a vehicle from the list", 255, 0, 0)
				return
			end
			return
		end

		-- We use this throughout the rest of the function
		local vehicleID = guiGridListGetItemData(GUIEditor.gridlist[1], row, 1)
		
		-- The label
		if (idToVehicle[vehicleID]) then
			local x, y, z = getElementPosition(idToVehicle[vehicleID])
			GUIEditor.label[1]:setText("Selected: "..getVehicleNameFromModel(getVehicleData(vehicleID, "model")).." - "..exports.UCDutil:getCityZoneFromXYZ(x, y, z)..", "..getZoneName(x, y, z))
		else
			local x, y, z = unpack(fromJSON(getVehicleData(vehicleID, "xyz")))
			GUIEditor.label[1]:setText("Selected: "..getVehicleNameFromModel(getVehicleData(vehicleID, "model")).." - "..exports.UCDutil:getCityZoneFromXYZ(x, y, z)..", "..getZoneName(x, y, z))
		end
		
		-- No action can be taken on vehicles that aren't spawned in [EXCEPTION: SELLING THE VEHICLE]
		if (source == GUIEditor.button[1]) then
			if (button == "left" and state == "up") then
				triggerServerEvent("UCDvehicleSystem.recoverVehicle", localPlayer, vehicleID)
			end
		elseif (source == GUIEditor.button[2]) then
			if (button == "left" and state == "up") then
				if (idToVehicle == nil or idToVehicle[vehicleID] == nil or not idToVehicle or not idToVehicle[vehicleID]) then
					exports.UCDdx:new("The selected vehicle is not spawned", 255, 0, 0)
					return
				end
				if (blip[vehicleID]) then
					blip[vehicleID]:destroy()
					blip[vehicleID] = nil
				else
					-- Create blip for vehicle
					local vehicle = idToVehicle[vehicleID]
					blip[vehicleID] = createBlipAttachedTo(vehicle, 55)
				end
			end
		elseif (source == GUIEditor.button[3]) then
			if (button == "left" and state == "up") then
				if (idToVehicle == nil or idToVehicle[vehicleID] == nil or not idToVehicle or not idToVehicle[vehicleID]) then
					exports.UCDdx:new("The selected vehicle is not spawned", 255, 0, 0)
					return
				end
				triggerServerEvent("UCDvehicleSystem.toggleLock", localPlayer, vehicleID)
				outputDebugString("Triggered server UCDvehicleSystem.toggleLock")
			end
		elseif (source == GUIEditor.button[4]) then
			if (button == "left" and state == "up") then
				-- trigger a server event and make sure to despawn the vehicle and delete from database
				local price = getVehicleData(vehicleID, "price")
				local rate = root:getData("vehicles.rate") --exports.UCDmarket:getVehicleRate()
				exports.UCDutil:createConfirmationWindow("Are you sure you want to sell this vehicle\n for "..tostring(rate / 10).."% of what it's worth [$"..exports.UCDutil:tocomma(tostring(exports.UCDutil:mathround(price * (rate / 1000), 2))).."]?", "exports.UCDvehicleSystem:callback_sellVehicle("..vehicleID..")")
				
			end
		elseif (source == GUIEditor.button[5]) then
			if (button == "left" and state == "up") then
				triggerServerEvent("UCDvehicleSystem.spawnVehicle", localPlayer, vehicleID)
				outputDebugString("triggered UCDvehicleSystem.spawnVehicle with vehicleID = "..vehicleID)
			end
		elseif (source == GUIEditor.button[6]) then
			if (button == "left" and state == "up") then
				if (idToVehicle == nil or idToVehicle[vehicleID] == nil or not idToVehicle or not idToVehicle[vehicleID]) then
					exports.UCDdx:new("The selected vehicle is not spawned", 255, 0, 0)
					return
				end
				if (isSpectating) then
					setCameraTarget(localPlayer)
					isSpectating = false
					removeEventHandler("onClientRender", root, lolrender)
					exports.UCDdx:new("You are no longer spectating your "..idToVehicle[vehicleID].name, 0, 255, 0)
				end
				if (blip[vehicleID]) then
					blip[vehicleID]:destroy()
					blip[vehicleID] = nil
				end
				triggerServerEvent("UCDvehicleSystem.hideVehicle", localPlayer, vehicleID)
			end
		elseif (source == GUIEditor.button[7]) then
			if (button == "left" and state == "up") then
				if (idToVehicle == nil or idToVehicle[vehicleID] == nil or not idToVehicle or not idToVehicle[vehicleID]) then
					exports.UCDdx:new("The selected vehicle is not spawned", 255, 0, 0)
					return
				end
				-- add checks to see if a player was hurt in the last X seconds, add checks to see if a player is in dim and int 0 etc
				vehicle = idToVehicle[vehicleID]
				if (localPlayer:isInVehicle(vehicle)) then
					if (localPlayer:getOccupiedVehicle() == vehicle) then
						exports.UCDdx:new("You can't spectate a vehicle you are currently in", 255, 0, 0)
						return
					end
					exports.UCDdx:new("You must be on foot to spectate a vehicle", 255, 0, 0)
					return
				end
				if (localPlayer.dimension ~= 0 or localPlayer.interior ~= 0) then
					exports.UCDdx:new("You cannot spectate a vehicle while not in the main world", 255, 0, 0)
					return
				end
				if (isSpectating == true) then
					setCameraTarget(localPlayer)
					isSpectating = false
					exports.UCDdx:new("You are no longer spectating your "..vehicle.name, 0, 255, 0)
					removeEventHandler("onClientRender", root, lolrender)
					return
				end
				
				local vehVec = vehicle:getPosition()
				--local vehVec2 = vehicle:getPosition()
				vehVec.z = vehVec.z + 20
				
				Camera.setMatrix(vehVec, vehicle:getPosition())
				--cp1, cp2, cp3, la1, la2, la3 = getCameraMatrix()
				--exports.UCDutil:smoothMoveCamera(cp1, cp2, cp3, la1, la2, la3, vehVec.x, vehVec.y, vehVec.z + 10, vehVec.x, vehVec.y, vehVec.z, 3000)
				--setTimer(function () addEventHandler("onClientRender", root, lolrender) end, 3000, 1) -- This allows us to smooth towards the vehicle and keep on its position afterwards
				addEventHandler("onClientRender", root, lolrender)
				
				isSpectating = true
				exports.UCDdx:new("You are now spectating your "..vehicle.name..". Press the spectate button again to cancel.", 0, 255, 0)
			end
		elseif (source == GUIEditor.button[8]) then
			if (button == "left" and state == "up") then
				toggleGUI()
			end
		end
	end
end
addEventHandler("onClientGUIClick", guiRoot, handleInput)

addEvent("UCDvehicleSystem.playerVehiclesTable", true)
addEventHandler("UCDvehicleSystem.playerVehiclesTable", root,
	function (tbl)
		if (type(tbl) ~= "table") then outputDebugString("playerVehicles did not pass table - ["..tostring(tbl).."]") return end
		if (not playerVehicles[source]) then
			playerVehicles[source] = {}
		end
		playerVehicles[source] = tbl
	end
)

function callback_sellVehicle(arg)
	outputDebugString("Successfully called callback_sellVehicle")
	outputDebugString("Argument passed = "..tostring(arg))
end

--[[
function populateGridList(vehicleTable)
	if (not vehicleTable) then return end
	if (not isElement(GUIEditor.window[1])) then return end
	if (source ~= localPlayer) then return end
	guiGridListClear(GUIEditor.gridlist[1])

	for i, v in pairs(vehicleTable) do
		if (v.ownerID == localPlayer:getData("accountID")) then
			local row = guiGridListAddRow(GUIEditor.gridlist[1])
			local modelID, health, fuel = getVehicleNameFromModel(v.model), v.health, v.fuel
			local health = health / 10
			
			if (health <= 35) then
				hR, hG, hB = 255, 0, 0
			elseif (health > 35) and (health <= 65) then
				hR, hG, hB = 255, 150, 0
			elseif (health > 65) and (health <= 90) then
				hR, hG, hB = 150, 150, 0
			else
				hR, hG, hB = 0, 255, 0
			end
			
			if (fuel <= 35) then
				fR, fG, fB = 255, 0, 0
			elseif (fuel > 35) and (fuel <= 65) then
				fR, fG, fB = 255, 0
			elseif (fuel > 65) and (fuel <= 90) then
				fR, fG, fB = 150, 150, 0
			else
				fR, fG, fB = 0, 255, 0
			end
			
			guiGridListSetItemText(GUIEditor.gridlist[1], row, 1, tostring(modelID), false, false)
			guiGridListSetItemText(GUIEditor.gridlist[1], row, 2, tostring(health).."%", false, false)
			guiGridListSetItemText(GUIEditor.gridlist[1], row, 3, tostring(fuel), false, false)
			
			guiGridListSetItemColor(GUIEditor.gridlist[1], row, 2, hR, hG, hB, 255)
			guiGridListSetItemColor(GUIEditor.gridlist[1], row, 3, fR, fG, fB, 255)
			
			guiGridListSetItemData(GUIEditor.gridlist[1], row, 1, i) -- Vehicle ID
		end
	end
end
addEvent("UCDvehicleSystem.populateGridList", true)
addEventHandler("UCDvehicleSystem.populateGridList", root, populateGridList)


function toggleGUI()
	if (not isElement(GUIEditor.window[1])) then
		createGUI()
		--triggerServerEvent("UCDvehicleSystem.getPlayerVehicleTable", localPlayer)
	end
	if (not guiGetVisible(GUIEditor.window[1])) then
		guiSetVisible(GUIEditor.window[1], true)
		
		-- Sync the vehicle data
		local vehicleTable = {}
		for i, v in pairs(vehicles) do -- vehicles is defined in vehicleData.lua
			if v.ownerID == localPlayer:getData("accountID") then
				if (idToVehicle[i]) then
					vehicleTable[i] = {ownerID = v.ownerID, model = idToVehicle[i]:getModel(), health = idToVehicle[i]:getHealth(), fuel = 100} -- change the 100 to be a way to get fuel
				else
					vehicleTable[i] = v
				end				
			end
		end
		--outputDebugString("gui open")
		if (vehicleTable and #vehicleTable >= 1) then
			triggerEvent("UCDvehicleSystem.populateGridList", localPlayer, vehicleTable)
		end
	else
		guiSetVisible(GUIEditor.window[1], false)
	end
	showCursor(not isCursorShowing())
end
addCommandHandler("vehicles", toggleGUI, false, false)
bindKey("F3", "down", "vehicles")

function createGUI()
	GUIEditor.window[1] = guiCreateWindow(586, 330, 349, 333, "UCD | Vehicles", false)
	guiWindowSetSizable(GUIEditor.window[1], false)
	guiSetVisible(GUIEditor.window[1], false)
	GUIEditor.gridlist[1] = guiCreateGridList(11, 31, 225, 206, false, GUIEditor.window[1])
	guiGridListAddColumn(GUIEditor.gridlist[1], "Name:", 0.5)
	guiGridListAddColumn(GUIEditor.gridlist[1], "Health", 0.2)
	guiGridListAddColumn(GUIEditor.gridlist[1], "Fuel", 0.2)
	guiSetProperty(GUIEditor.gridlist[1], "SortSettingEnabled", "False")
	GUIEditor.button[1] = guiCreateButton(11, 247, 70, 32, "Recover", false, GUIEditor.window[1])
	GUIEditor.button[2] = guiCreateButton(91, 247, 70, 32, "Toggle blip", false, GUIEditor.window[1])
	GUIEditor.button[3] = guiCreateButton(11, 289, 70, 32, "Pick", false, GUIEditor.window[1])
	GUIEditor.button[4] = guiCreateButton(171, 248, 66, 31, "(un)lock", false, GUIEditor.window[1])
	GUIEditor.button[5] = guiCreateButton(91, 289, 67, 32, "Hide", false, GUIEditor.window[1])
	GUIEditor.button[6] = guiCreateButton(171, 290, 66, 31, "Close", false, GUIEditor.window[1])
	populateGridList()
end
addEventHandler("onClientResourceStart", resourceRoot, createGUI)

	GUIEditor.button[1] = guiCreateButton(11, 247, 66, 32, "Recover", false, GUIEditor.window[1])
	GUIEditor.button[2] = guiCreateButton(91, 247, 66, 32, "Toggle blip", false, GUIEditor.window[1])
	GUIEditor.button[4] = guiCreateButton(171, 247, 66, 32, "(un)lock", false, GUIEditor.window[1])
	GUIEditor.button[7] = guiCreateButton(251, 247, 66, 32, "Close", false, GUIEditor.window[1])
	
	GUIEditor.button[3] = guiCreateButton(11, 289, 66, 32, "Pick", false, GUIEditor.window[1])
	GUIEditor.button[5] = guiCreateButton(91, 289, 66, 32, "Hide", false, GUIEditor.window[1])
	GUIEditor.button[6] = guiCreateButton(171, 289, 66, 32, "Close", false, GUIEditor.window[1])
	GUIEditor.button[8] = guiCreateButton(251, 290, 66, 32, "Close", false, GUIEditor.window[1])
--]]
