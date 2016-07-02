addEventHandler("onResourceStart", resourceRoot,
	function ()
		ranks = exports.UCDjobsTable:getJobRanks("Trucker")
	end
)

function processHaul(prev, dest)
	local pos = Vector3(destinations[prev][1], destinations[prev][2], destinations[prev][3]) 
	local pos_ = Vector3(destinations[dest][1], destinations[dest][2], destinations[dest][3]) 
	local distance = getDistanceBetweenPoints3D(pos, pos_)	
	local base = math.random((distance * 1.3) - 240, (distance * 1.3) - 240)
	local playerRank = exports.UCDjobs:getPlayerJobRank(client, "Trucker") or 0
	local bonus = ranks[playerRank].bonus
	local newAmount = math.floor((base * (bonus / 100)) + base)
	local formattedAmount = exports.UCDutil:tocomma(newAmount)
	local sZ, eZ = getZoneName(pos), getZoneName(pos_)
	
	outputDebugString("Base = "..base)
	outputDebugString("Bonus = "..bonus.."%")
	outputDebugString("New amount = "..newAmount)
	
	exports.UCDdx:new(client, "Trucker: Load from "..sZ.." to "..eZ.." complete. You have been paid $"..formattedAmount..".", 255, 215, 0)
	
	if (client.vehicle) then
		triggerClientEvent(client, "UCDtrucker.startHaul", client, client.vehicle, client.vehicleSeat)
	end
end
addEvent("UCDtrucker.processHaul", true)
addEventHandler("UCDtrucker.processHaul", root, processHaul)
