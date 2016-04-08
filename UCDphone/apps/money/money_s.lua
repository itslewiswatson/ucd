Money = {}

function Money.sendMoney(plr, amount)
	if (client and plr and isElement(plr) and plr.type == "player" and amount and tonumber(amount)) then
		if (not exports.UCDaccounts:isPlayerLoggedIn(plr)) then
			exports.UCDdx:new(client, "This player is not logged in", 255, 0, 0)
			return 
		end
		if (amount > client.money) then
			exports.UCDdx:new(client, "You don't have this much money on you", 255, 0, 0)
			return
		end
		plr.money = plr.money + amount
		client.money = client.money - amount
		exports.UCDdx:new(plr, client.name.." has sent you $"..exports.UCDutil:tocomma(amount), 0, 255, 0)
		exports.UCDdx:new(client, "You have sent "..plr.name.." $"..exports.UCDutil:tocomma(amount), 0, 255, 0)
	end
end
addEvent("UCDphone.sendMoney", true)
addEventHandler("UCDphone.sendMoney", root, Money.sendMoney)