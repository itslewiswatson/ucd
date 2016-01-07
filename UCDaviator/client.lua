local cargoPlanes = {[592] = true, [511] = true, [593] = true, [513] = true}
local passgenerPlanes = {[577] = true, [553] = true, [519] = true}
local airports = {[1] = "Los Santos", [2] = "San Fierro", [3] = "Las Venturas", [4] = "Verdant Meadows"}
local destinations = 
{
	["Plane"] = 
	{
		["Los Santos"] = 
		{
			{0, 0, 0},
			{0, 0, 0},
		},
		["San Fierro"] = 
		{
			{-1289.8391, -1.7542, 14.1484},
		},
		["Las Venturas"] = 
		{
			{1335.9799, 1588.3812, 10.8203},
			{0, 0, 0},
		},
		["Verdant Meadows"] = 
		{
			{358.5139, 2538.1794, 16.6982},
			{0, 0, 0},
		},
	},
	["Helicopter"] = 
	{
		{1544.1847, -1353.4109, 329.4742},
		{1451.7689, -1066.7189, 213.3828},
		{1765.832, -2286.3018, 26.796},
		{2761.9385, -1454.833, 66.8605},
	},
}
local curr = {} -- Contains the current flight itinerary
local prev = {} -- Contains the previous flight itinerary
local markings = {}
local pending

addEventHandler("onClientPlayerVehicleEnter", root,
	function (vehicle, seat)
		if (source == localPlayer and seat == 0 and (vehicle.vehicleType == "Plane" or vehicle.vehicleType == "Helicopter")) then
			pending = Timer(calculateItinerary, 750, 1, vehicle.vehicleType)
		end
	end
)

function cancelItinerary()
	if (isItinerary()) then
		outputDebugString("cancelling")
		if (pending and isTimer(pending)) then
			killTimer(pending)
			pending = nil
		end
		curr.airport = nil
		curr.dest = nil
		prev.airport = nil
		prev.dest = nil
		markings.marker:destroy()
		markings.blip:destroy()
		markings.marker = nil
		markings.blip = nil
	end
end
addEventHandler("onClientPlayerWasted", localPlayer, cancelItinerary)
addEventHandler("onClientElementDestroy", root, function () if (localPlayer.vehicle and source == localPlayer.vehicle) then cancelItinerary() end end)
addEventHandler("onClientPlayerVehicleExit", localPlayer, cancelItinerary)
addEvent("onClientPlayerGetJob")
addEventHandler("onClientPlayerGetJob", localPlayer, cancelItinerary)

function isItinerary()
	if (curr.airport or curr.dest) then
		return true
	end
	return false
end

function calculateItinerary(vehType)
	if (vehType == "Plane") then
		
		if (curr.airport) then
			prev.airport = curr.airport
		end
		
		repeat 
			curr.airport = math.random(1, #airports)
			curr.dest = math.random(1, #destinations["Plane"][airports[curr.airport]])
		until curr.airport ~= prev.airport
		
		if (prev.airport) then
			markings.marker:destroy()
			markings.blip:destroy()
			markings.marker = nil
			markings.blip = nil
			
			local dest = destinations["Plane"][airports[curr.airport]][curr.dest]
			markings.marker = Marker(dest[1], dest[2], dest[3], "cylinder", 3, 255, 255, 0, 120)
			markings.blip = Blip.createAttachedTo(markings.marker, 41, nil, nil, nil, nil, nil, 0, 65535)
			
			if (cargoPlanes[localPlayer.vehicle.model]) then
				exports.UCDdx:new("ATC: Take this cargo to "..airports[curr.airport], 255, 255, 0)
			elseif (passgenerPlanes[localPlayer.vehicle.model]) then
				exports.UCDdx:new("ATC: Take these passgeners to "..airports[curr.airport], 255, 255, 0)
			end
		else
			local dest = destinations["Plane"][airports[curr.airport]][curr.dest]
			markings.marker = Marker(dest[1], dest[2], dest[3], "cylinder", 3, 255, 255, 0, 120)
			markings.blip = Blip.createAttachedTo(markings.marker, 41, nil, nil, nil, nil, nil, 0, 65535)
			
			if (cargoPlanes[localPlayer.vehicle.model]) then
				exports.UCDdx:new("ATC: There has been a request for cargo pickup at "..airports[curr.airport], 255, 255, 0)
			elseif (passgenerPlanes[localPlayer.vehicle.model]) then
				exports.UCDdx:new("ATC: There has been a request for passgener pickup at "..airports[curr.airport], 255, 255, 0)
			end
		end
		
	elseif (vehType == "Helicopter") then
		
		if (curr.dest) then
			prev.dest = curr.dest
		end
		
		repeat
			curr.dest = math.random(1, #destinations["Helicopter"])
		until curr.dest ~= prev.dest
		
		
		if (prev.dest) then
			markings.marker:destroy()
			markings.blip:destroy()
			markings.marker = nil
			markings.blip = nil

			local dest = destinations["Helicopter"][curr.dest]
			markings.marker = Marker(dest[1], dest[2], dest[3], "cylinder", 3, 255, 255, 0, 120)
			markings.blip = Blip.createAttachedTo(markings.marker, 41, nil, nil, nil, nil, nil, 0, 65535)
			
			exports.UCDdx:new("PASSENGER: Take me to "..getZoneName(dest[1], dest[2], dest[3]).." in "..getZoneName(dest[1], dest[2], dest[3], true)..", please!", 255, 255, 0)
		else
			local dest = destinations["Helicopter"][curr.dest]
			markings.marker = Marker(dest[1], dest[2], dest[3], "cylinder", 3, 255, 255, 0, 120)
			markings.blip = Blip.createAttachedTo(markings.marker, 41, nil, nil, nil, nil, nil, 0, 65535)
			
			exports.UCDdx:new("ATC: A private passgener is requesting pickup. Make your way to "..getZoneName(dest[1], dest[2], dest[3])..", "..getZoneName(dest[1], dest[2], dest[3], true)..".", 255, 255, 0)
		end
	end
	
	addEventHandler("onClientMarkerHit", markings.marker, onClientMarkerHit)
end

function onClientMarkerHit(plr, matchingDimension)
	if (plr == localPlayer and matchingDimension) then
		if (localPlayer.vehicle.vehicleType == "Helicopter") then
			if (prev.dest) then
				exports.UCDdx:new("You completed this flight", 255, 255, 0)
				cancelItinerary()
			else
				calculateItinerary("Helicopter")
			end
		elseif (localPlayer.vehicle.vehicleType == "Plane") then
			if (prev.airport) then
				exports.UCDdx:new("You completed this flight", 255, 255, 0)
				cancelItinerary()
			else
				calculateItinerary("Plane")
			end
		end
	end
end	
