-- This table should act as a master table containing vehicle elements and their current fuel
-- vehicleFuel[vehicleEle] = amount

vehicleFuel = {}

function onVehicleEnter(plr)
	if (source and plr) then
		if (not vehicleFuel[source]) then
			vehicleFuel[source] = {}
			if (source:getData("vehicleID")) then
				-- We're dealing with a player vehicle
				vehicleFuel[source] = getVehicleData(source:getData("vehicleID"), "fuel")
			else
				vehicleFuel[source] = 99
			end
		end
	end
end

-- If the server is up for a long time and lots of elements are created and destroyed, element id recycling can occur when old ids are used
-- Always remove from the table
function removeFromTable()
	if (source and vehicleFuel[source]) then
		vehicleFuel[source] = nil
	end
end
addEventHandler("onElementDestroy", root, removeFromTable)
addEventHandler("onVehicleExplode", root, removeFromTable)
addEventHandler("onVehicleHidden", root, removeFromTable)

-- Make a custom event when a vehicle is created

