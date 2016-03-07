function process()
	if (client) then
		local vehicle = client.vehicle
		if (not vehicle or math.floor(vehicle.health) == 1000) then
			return
		end
		
		local sPrice, ePrice
		if (vehicle.health >= 800) then
			sPrice, ePrice = 200, 300
		elseif (vehicle.health < 800 and vehicle.health >= 500) then
			sPrice, ePrice = 300, 400
		elseif (vehicle.health < 500 and vehicle.health >= 300) then
			sPrice, ePrice = 400, 500
		elseif (vehicle.health < 300) then
			sPrice, ePrice = 500, 600
		end
		local price = math.random(sPrice, ePrice)
		if (client.money < price) then
			exports.UCDdx:new(client, "You don't have enough money to repair this vehicle", 255, 0, 0)
			return
		end
		client.money = client.money - price
		vehicle.velocity = Vector3(0, 0, 0)
		vehicle.frozen = true
		exports.UCDvehicles:fix(vehicle)
		vehicle.frozen = false
		exports.UCDdx:new(client, "Vehicle repaired! You have been charged $"..price, 0, 255, 0)
	end
end
addEvent("UCDpns.process", true)
addEventHandler("UCDpns.process", root, process)
