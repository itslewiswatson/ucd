-------------------------------------------------------------------
--// PROJECT: Union of Clarity and Diversity
--// RESOURCE: UCDvehicles
--// DEVELOPER(S): Lewis Watson (Noki)
--// DATE: 09/12/2015
--// PURPOSE: Storing data tables on the client-side for access.
--// FILE: \vehicleData.lua [client]
-------------------------------------------------------------------

vehicles = {}

function syncVehicleTable(id, sync)
	if (not sync) then outputDebugString("Table not sent.") return end
	
	vehicles[id] = sync
	
	if (not vehicles[id]) then
		outputDebugString("Table is empty.")
	else
		outputDebugString("Successfully synced vehicle data for vehicleID = "..id)
	end
	
	updateVehicleGrid(id)
end
addEvent("UCDvehicles.syncVehicleTable", true)
addEventHandler("UCDvehicles.syncVehicleTable", root, syncVehicleTable)

function forceSync(sync)
	if (not sync) then outputDebugString("Table not sent.") return end
	local temp = {}
	--GUIEditor.gridlist[1]:clear()
	for k,v in pairs(sync) do
		vehicles[k] = v
		temp[k] = true
		if (not vehicles[k]) then
			outputDebugString("Table is empty.")
		end
		
		updateVehicleGrid(k)
	end
	for i = 0, guiGridListGetRowCount(GUIEditor.gridlist[1]) - 1 do
		if (not temp[guiGridListGetItemData(GUIEditor.gridlist[1], i, 1)]) then
			guiGridListRemoveRow(GUIEditor.gridlist[1], i)
		end
	end
end
addEvent("UCDvehicles.forceSync", true)
addEventHandler("UCDvehicles.forceSync", root, forceSync)

function requestVehicleTableSync()
	-- This should allow the sync to properly go through if the resource is restarted
	if (exports.UCDaccounts:isPlayerLoggedIn(localPlayer)) then
		-- The timer is for the local server
		setTimer(
			function (localPlayer)
				triggerServerEvent("UCDvehicles.requestVehicleTableSync", localPlayer)
			end, 500, 1, localPlayer
		)
	end
	outputDebugString("Sent request for vehicle data.")
end
addEventHandler("onClientResourceStart", resourceRoot, requestVehicleTableSync)

function getVehicleData(vehicleID, column)
	if (not vehicleID) or (not column) then return nil end
	if (tonumber(vehicleID) == nil or type(column) ~= "string") then return false end
	
	if (column == "*") then
		return vehicles[vehicleID]
	else
		if (vehicles[vehicleID] == nil) or (vehicles[vehicleID][column] == nil) then
			return nil
		end
	end
	
	return vehicles[vehicleID][column]
end

--[[
function syncVehicleTable(sync)
	if (not sync) then outputDebugString("Table not sent.") return end
	vehicles = sync
	if (#vehicles == 0) then
		outputDebugString("Table is empty.")
	else
		outputDebugString("Successfully synced vehicle data table.")
	end
	for i, _ in pairs(sync) do
		updateVehicleGrid(i)
	end
end
addEvent("UCDvehicles.syncVehicleTable", true)
addEventHandler("UCDvehicles.syncVehicleTable", root, syncVehicleTable)

function syncVehicleTable(sync)
	if (not sync) then outputDebugString("Table not sent.") return end
	vehicles = sync
	if (#vehicles == 0) then
		outputDebugString("Vehicles not loaded successfully.")
	else
		outputDebugString("Successfully synced vehicles table.")
	end
	for i, _ in pairs(vehicles) do
		updateVehicleGrid(i)
	end
end
addEvent("UCDvehicles.syncVehicleTable", true)
addEventHandler("UCDvehicles.syncVehicleTable", root, syncVehicleTable)
--]]