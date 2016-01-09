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
		local playerRank = 9 -- Change this in the future
		local base, bonus, distance
		local start, finish
		
		if (vehicle.vehicleType == "Plane") then
			start = destinations["Plane"][airports[flightData[3]]][flightData[4]]
			finish = destinations["Plane"][airports[flightData[1]]][flightData[2]]
			local x1, y1, z1 = start[1], start[2], start[3]
			local x2, y2, z2 = finish[1], finish[2], finish[3]
			distance = getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2)
			--outputDebugString("Distance: "..distance)
			
			if (sml[model]) then
				base = math.random((distance * 1.15) - 250, (distance * 1.15) + 250)
			elseif (lrg[model]) then
				base = math.random((distance * 2.5) - 250, (distance * 2.5) + 250)
			elseif (mid[model]) then
				base = math.random((distance * 1.6) - 250, (distance * 1.75) + 400)
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
			--outputDebugString("Distance: "..distance)
			
			-- You should earn slightly more with a helicopter
			base = math.random(distance * 1.5, (distance * 1.5) + 350)
		end
		
		bonus = ranks[playerRank].bonus
		
		local newAmount = math.floor((base * (bonus / 100)) + base)
		local formattedAmount = exports.UCDutil:tocomma(newAmount)
		
		outputDebugString("Base = "..base)
		outputDebugString("Bonus = "..bonus.."%")
		outputDebugString("New amount = "..newAmount)
		
		if (vehicle.vehicleType == "Plane") then
			local fA = airports[flightData[1]]
			local sA = airports[flightData[3]]
			exports.UCDdx:new(client, "ATC: Flight from "..sA.." to "..fA.." complete. You have been paid $"..formattedAmount..".", 255, 215, 0)
		else
			exports.UCDdx:new(client, "ATC: Flight complete. You have been paid $"..formattedAmount..".", 255, 215, 0)
		end
		
		if (client.vehicle) then
			--client.vehicle.frozen = false
			triggerClientEvent(client, "UCDaviator.startItinerary", client, client.vehicle, client.vehicleSeat)
		end
	end
end
addEvent("UCDaviator.processFlight", true)
addEventHandler("UCDaviator.processFlight", root, processFlight)
