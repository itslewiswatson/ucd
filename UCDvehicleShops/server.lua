addEvent("UCDvehicleShops.purchase", true)
addEventHandler("UCDvehicleShops.purchase", root,
	function (model, colour, mID)
		local pos = markers[mID].p
		local rot = markers[mID].r
		local price = prices[Vehicle.getNameFromModel(model)] or 0
		if (client.money < price) then
			exports.UCDdx:new(client, "You don't have enough money to purchase this vehicle", 255, 0, 0)
			return
		end
		
		local vehicle = exports.UCDvehicles:purchase(client, model, pos, rot, colour, price)
		if (vehicle) then
			client:warpIntoVehicle(vehicle)
		else
			outputDebugString("Error")
		end
	end
)

