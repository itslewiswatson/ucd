local disabledVehicles = {}

function toggleVehicle(vehicle, resp)
	if (not vehicle or not isElement(vehicle) or vehicle.type ~= "vehicle"
		or not resp or not isElement(resp) or resp.type ~= "player") then
		return false
	end
	removeEventHandler("onVehicleStartEnter", vehicle, toggleEffects)
	removeEventHandler("onVehicleStartExit", vehicle, toggleEffects)
	removeEventHandler("onElementDestroy", vehicle, removeOnDestroy)
	if (disabledVehicles[vehicle]) then
		disabledVehicles[vehicle] = nil
		if (vehicle.controller) then
			triggerClientEvent(vehicle.controller, "onToggleVehicleControls", resourceRoot, false)
		end
	else
		disabledVehicles[vehicle] = true
		addEventHandler("onVehicleStartEnter", vehicle, toggleEffects, false)
		addEventHandler("onVehicleStartExit", vehicle, toggleEffects, false)
		addEventHandler("onElementDestroy", vehicle, removeOnDestroy, false)
		if (vehicle.controller) then -- Disable if in vehicle already
			triggerClientEvent(vehicle.controller, "onToggleVehicleControls", resourceRoot, true)
		end
	end
	return true
end

function isVehicleDisabled(vehicle)
	return disabledVehicles[vehicle] or false
end

function removeOnDestroy()
	disabledVehicles[source] = nil
end

function toggleEffects(plr, seat)
	if (not disabledVehicles[source] or seat ~= 0) then return end
	triggerClientEvent(plr, "onToggleVehicleControls", resourceRoot, eventName == "onVehicleStartEnter" and true or false)
end