addEvent("UCDvehicleShops.purchase", true)
addEventHandler("UCDvehicleShops.purchase", root,
	function (model, colour, mID)
		local pos = markers[mID].p
		local rot = markers[mID].r
		local vehicle = exports.UCDvehicles:purchase(client, model, pos, rot, colour, prices[Vehicle.getNameFromModel(model)])
		if (vehicle) then
			client:warpIntoVehicle(vehicle)
		else
			outputDebugString("Error")
		end
	end
)

