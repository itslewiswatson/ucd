local a2h = {[20] = 5, [50] = 10, [100] = 20}

addEvent("UCDfood.purchaseMeal", true)
addEventHandler("UCDfood.purchaseMeal", root,
	function (amount)
		if (client and amount) then
			if (client.money < amount) then
				exports.UCDdx:new(client, "You cannot afford this", 255, 0, 0)
				return
			end
			if (client.health == 200) then
				exports.UCDdx:new(client, "You are already at full health", 255, 0, 0)
				return
			end
			local h = a2h[amount]
			client.health = client.health + h
			client:takeMoney(amount)
		end
	end	
)
