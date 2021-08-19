--[[
-- Distances

LS --> LV = 4000
LS --> VM = 5000
LS --> SF = 3500
LV --> SF = 3300
LV --> VM = 1500
SF --> VM = 3000

--]]

local sml = {[511] = true, [593] = true, [513] = true} -- Beagle, Dodo, Stuntplane
local lrg = {[592] = true, [577] = true, [553] = true} -- Nevada, AT-400, Andromada
local mid = {[519] = true} -- Shamal

addEventHandler("onResourceStart", resourceRoot,
	function ()
		ranks = exports.UCDjobsTable:getJobRanks("Aviator")
	end
)

function processFlight(flightData, vehicle)
	if (client and flightData and vehicle) then
		
		local model = vehicle.model
		local playerRank = exports.UCDjobs:getPlayerJobRank(client, "Aviator") or 0
		local base, bonus, distance
		local start, finish
		
		if (vehicle.vehicleType == "Plane") then
			start = destinations["Plane"][airports[flightData[3]]][flightData[4]]
			finish = destinations["Plane"][airports[flightData[1]]][flightData[2]]
			local x1, y1, z1 = start[1], start[2], start[3]
			local x2, y2, z2 = finish[1], finish[2], finish[3]
			distance = getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2)
			
			if (sml[model]) then
				base = math.random((distance * 1.2) - 250, (distance * 1.2) + 250)
			elseif (lrg[model]) then
				base = math.random((distance * 2) - 250, (distance * 2) + 250)
			elseif (mid[model]) then
				base = math.random((distance * 1.6) - 250, (distance * 1.7) + 250)
			else
				outputDebugString("Unknown type given")
				return
			end
		else
			start = destinations["Helicopter"][flightData[1]]
			finish = destinations["Helicopter"][flightData[2]]
			local x1, y1, z1 = start[1], start[2], start[3]
			local x2, y2, z2 = finish[1], finish[2], finish[3]
			distance = getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2)
			
			-- You should earn slightly more with a helicopter
			base = math.random(distance * 1.5, (distance * 1.5) + 350)
		end
		
		bonus = ranks[playerRank].bonus
		
		local newAmount = math.floor((base * (bonus / 100)) + base)
		local formattedAmount = exports.UCDutil:tocomma(newAmount)
		local roundedDist = exports.UCDutil:mathround(distance / 1000, 2)
		
		if (vehicle.vehicleType == "Plane") then
			local fA = airports[flightData[1]]
			local sA = airports[flightData[3]]
			exports.UCDdx:new(client, "ATC: Flight from "..tostring(sA).." to "..tostring(fA).." complete ("..tostring(roundedDist).." km). You have been paid $"..tostring(formattedAmount)..".", 255, 215, 0)
		else
			exports.UCDdx:new(client, "ATC: Flight complete ("..tostring(roundedDist).."km). You have been paid $"..tostring(formattedAmount)..".", 255, 215, 0)
		end
		
		exports.UCDaccounts:SAD(client.account.name, "aviator", exports.UCDaccounts:GAD(client.account.name, "aviator") + roundedDist)
		
		if (client.vehicle) then
			local health = math.floor(client.vehicle.health / 10)
			if (health >= 95) then
				exports.UCDdx:new(client, "ATC: 5% bonus for minimal damage to the "..tostring(vehicle.vehicleType == "Plane" and "plane" or "helicopter").." and its cargo", 255, 215, 0)
				newAmount = newAmount + (newAmount * 0.5)
			elseif (health <= 60) then
				exports.UCDdx:new(client, "ATC: Your "..tostring(vehicle.vehicleType == "Plane" and "plane" or "helicopter").." suffered considerable damage and 10% of your earnings were taxed for repairs", 255, 215, 0)
				newAmount = newAmount - (newAmount * 0.1)
			end
			Timer(
				function (plr)
					triggerClientEvent(plr, "UCDaviator.startItinerary", plr, plr.vehicle, plr.vehicleSeat)
				end, 2000, 1, client
			)
		end
		client.money = client.money + newAmount
	end
end
addEvent("UCDaviator.processFlight", true)
addEventHandler("UCDaviator.processFlight", root, processFlight)
