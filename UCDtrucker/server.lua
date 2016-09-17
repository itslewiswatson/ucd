addEventHandler("onResourceStart", resourceRoot,
	function ()
		ranks = exports.UCDjobsTable:getJobRanks("Trucker")
	end
)

function processHaul(prev, dest)
	local pos = Vector3(destinations[prev][1], destinations[prev][2], destinations[prev][3]) 
	local pos_ = Vector3(destinations[dest][1], destinations[dest][2], destinations[dest][3]) 
	local distance = getDistanceBetweenPoints3D(pos, pos_)	
	local base = math.random((distance * 1.6) - 240, (distance * 1.7) + 240)
	local playerRank = exports.UCDjobs:getPlayerJobRank(client, "Trucker") or 0
	local bonus = ranks[playerRank].bonus
	local newAmount = math.floor((base * (bonus / 100)) + base)
	local formattedAmount = exports.UCDutil:tocomma(newAmount)
	local sZ, eZ = getZoneName(pos), getZoneName(pos_)
	
	outputDebugString("Base = "..base)
	outputDebugString("Bonus = "..bonus.."%")
	outputDebugString("New amount = "..newAmount)
		
	local dist2 = exports.UCDutil:mathround(distance / 1000, 2)
	exports.UCDaccounts:SAD(client.account.name, "trucker", exports.UCDaccounts:GAD(client.account.name, "trucker") + dist2)
	
	exports.UCDdx:new(client, "Trucker: Load from "..sZ.." to "..eZ.." complete ("..tostring(dist2).." km). You have been paid $"..tostring(formattedAmount), 255, 215, 0)
	
	if (client.vehicle) then
		local health = math.floor(client.vehicle.health / 10)
		if (health >= 95) then
			exports.UCDdx:new(client, "Trucker: 5% bonus for minimal damage to the truck and its cargo", 255, 215, 0)
			newAmount = newAmount + (newAmount * 0.5)
		elseif (health <= 60) then
			exports.UCDdx:new(client, "Trucker: Your truck suffered considerable damage and 10% of your earnings were taxed for repairs", 255, 215, 0)
			newAmount = newAmount - (newAmount * 0.1)
		end
		Timer(
			function (plr)
				triggerClientEvent(plr, "UCDtrucker.startHaul", plr, plr.vehicle, plr.vehicleSeat)
			end, 2000, 1, client
		)
	end
	
	client.money = client.money + newAmount
end
addEvent("UCDtrucker.processHaul", true)
addEventHandler("UCDtrucker.processHaul", root, processHaul)
