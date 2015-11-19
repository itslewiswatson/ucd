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
addEvent("UCDvehicleSystem.syncVehicleTable", true)
addEventHandler("UCDvehicleSystem.syncVehicleTable", root, syncVehicleTable)

function requestVehicleTableSync()
	-- This should allow the sync to properly go through if the resource is restarted
	if (exports.UCDaccounts:isPlayerLoggedIn(localPlayer)) then
		-- The timer is for the local server
		setTimer(
			function (localPlayer)
				triggerServerEvent("UCDvehicleSystem.requestVehicleTableSync", localPlayer)
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
addEvent("UCDvehicleSystem.syncVehicleTable", true)
addEventHandler("UCDvehicleSystem.syncVehicleTable", root, syncVehicleTable)

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
addEvent("UCDvehicleSystem.syncVehicleTable", true)
addEventHandler("UCDvehicleSystem.syncVehicleTable", root, syncVehicleTable)
--]]