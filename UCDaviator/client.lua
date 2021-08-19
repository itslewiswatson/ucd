
-- Settings
local MARKER_SIZE = 10 -- Size of the markers
local HELI_MARKER_DIST = 12 -- Max Z distance of a marker hit registering for a helicopter
local WAIT_TIME = 2000

-- Utility tables
local cargoPlanes = {[592] = true, [511] = true, [593] = true, [513] = true}
local passgenerPlanes = {[577] = true, [553] = true, [519] = true}
local sml = {[511] = true, [593] = true, [513] = true} -- Beagle, Dodo, Stuntplane
local lrg = {[592] = true, [577] = true, [553] = true} -- Nevada, AT-400, Andromada
local mid = {[519] = true} -- Shamal

-- Other tables and settings used throughout that relate to the flight(s)
local curr = {} -- Contains the current flight itinerary
local prev = {} -- Contains the previous flight itinerary
local markings = {}
local pending
local hasHit
local dest

function startItinerary(vehicle, seat)
	if (source == localPlayer and localPlayer.team.name == "Citizens" and localPlayer:getData("Occupation") == "Aviator" and seat == 0 and (vehicle.vehicleType == "Plane" or vehicle.vehicleType == "Helicopter")) then
		if ((not cargoPlanes[localPlayer.vehicle.model] and not passgenerPlanes[localPlayer.vehicle.model]) and localPlayer.vehicle.vehicleType ~= "Helicopter") then
			outputDebugString("Not right type of vehicle")
			return
		end
		pending = Timer(calculateItinerary, 750, 1)
	end
end
addEventHandler("onClientPlayerVehicleEnter", root, startItinerary)
addEvent("UCDaviator.startItinerary", true)
addEventHandler("UCDaviator.startItinerary", root, startItinerary)

function cancelItinerary()
	if (isItinerary()) then
		removeEventHandler("onClientRender", root, displayDistance)
		exports.UCDdx:del("aviatordist")
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
		hasHit = nil
	end
end
addEventHandler("onClientPlayerWasted", localPlayer, cancelItinerary)
addEventHandler("onClientElementDestroy", root, function () if (localPlayer.vehicle and source == localPlayer.vehicle) then cancelItinerary() end end)
addEventHandler("onClientPlayerVehicleExit", localPlayer, cancelItinerary)
addEvent("onClientPlayerGetJob", true)
addEventHandler("onClientPlayerGetJob", localPlayer, cancelItinerary)

function isItinerary()
	if (curr.airport or curr.dest) then
		return true
	end
	return false
end

function calculateItinerary()
	if (not localPlayer.vehicle) then
		return
	end
	if (localPlayer.vehicle.vehicleType == "Plane") then
		
		if (curr.airport) then
			prev.airport = curr.airport
			prev.dest = curr.dest
		end
		
		-- We don't want the big planes in VM
		if (not lrg[localPlayer.vehicle.model]) then
			repeat 
				curr.airport = math.random(1, #airports)
				curr.dest = math.random(1, #destinations["Plane"][airports[curr.airport]])
			until curr.airport ~= prev.airport
		else
			repeat 
				curr.airport = math.random(1, #airports)
				curr.dest = math.random(1, #destinations["Plane"][airports[curr.airport]])
			until curr.airport ~= prev.airport and curr.airport ~= 4
		end
		
		if (prev.airport) then
			markings.marker:destroy()
			markings.blip:destroy()
			markings.marker = nil
			markings.blip = nil
			
			dest = destinations["Plane"][airports[curr.airport]][curr.dest]
			markings.marker = Marker(dest[1], dest[2], dest[3] - 1, "cylinder", MARKER_SIZE, 255, 215, 0, 120)
			markings.blip = Blip.createAttachedTo(markings.marker, 41, nil, nil, nil, nil, nil, 0, 65535)
			
			if (cargoPlanes[localPlayer.vehicle.model]) then
				exports.UCDdx:new("ATC: Take this cargo to "..airports[curr.airport], 255, 215, 0)
			elseif (passgenerPlanes[localPlayer.vehicle.model]) then
				exports.UCDdx:new("ATC: Take these passengers to "..airports[curr.airport], 255, 215, 0)
			end
		else
			dest = destinations["Plane"][airports[curr.airport]][curr.dest]
			markings.marker = Marker(dest[1], dest[2], dest[3] - 1, "cylinder", MARKER_SIZE, 255, 215, 0, 120)
			markings.blip = Blip.createAttachedTo(markings.marker, 41, nil, nil, nil, nil, nil, 0, 65535)
			
			if (cargoPlanes[localPlayer.vehicle.model]) then
				exports.UCDdx:new("ATC: There has been a request for cargo pickup at "..airports[curr.airport], 255, 215, 0)
			elseif (passgenerPlanes[localPlayer.vehicle.model]) then
				exports.UCDdx:new("ATC: There has been a request for passgener pickup at "..airports[curr.airport], 255, 215, 0)
			end
		end
		
	elseif (localPlayer.vehicle.vehicleType == "Helicopter") then
		
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

			dest = destinations["Helicopter"][curr.dest]
			markings.marker = Marker(dest[1], dest[2], dest[3] - 1, "cylinder", MARKER_SIZE, 255, 215, 0, 120)
			markings.blip = Blip.createAttachedTo(markings.marker, 41, nil, nil, nil, nil, nil, 0, 65535)
			
			suburb, city = getZoneName(dest[1], dest[2], 0), getZoneName(dest[1], dest[2], 0, true)
			if (suburb ~= city) then
				exports.UCDdx:new("PASSENGER: Take me to "..suburb.." in "..city..", please!", 255, 215, 0)
			else
				exports.UCDdx:new("PASSENGER: Take me to "..suburb..", please!", 255, 215, 0)
			end
		else
			dest = destinations["Helicopter"][curr.dest]
			markings.marker = Marker(dest[1], dest[2], dest[3] - 1, "cylinder", MARKER_SIZE, 255, 215, 0, 120)
			markings.blip = Blip.createAttachedTo(markings.marker, 41, nil, nil, nil, nil, nil, 0, 65535)
			
			local suburb, city = getZoneName(dest[1], dest[2], 0), getZoneName(dest[1], dest[2], 0, true)
			if (suburb ~= city) then
				exports.UCDdx:new("ATC: A private passgener is requesting pickup. Make your way to "..suburb..", "..city..".", 255, 215, 0)
			else
				exports.UCDdx:new("ATC: A private passgener is requesting pickup. Make your way to "..suburb..".", 255, 215, 0)
			end
		end
	end
	
	if (#getEventHandlers("onClientRender", root, displayDistance) == 0) then
		addEventHandler("onClientRender", root, displayDistance)
	end
	addEventHandler("onClientMarkerHit", markings.marker, onClientMarkerHit)
end

function onClientMarkerHit(plr, matchingDimension)
	if (source ~= markings.marker) then return end
	if (plr == localPlayer and matchingDimension) then
		
		if (hasHit) then
			return
		end
		
		--outputDebugString("H: "..localPlayer.vehicle.position.z)
		--outputDebugString("M: "..source.position.z)
		if (localPlayer.vehicle.vehicleType == "Helicopter" and (localPlayer.vehicle.position.z - HELI_MARKER_DIST) > source.position.z) then
			return
		end
		
		--stopVehicle(true)
		
		if (localPlayer.vehicle.vehicleType == "Plane") then
			if (not localPlayer.vehicle.onGround or (localPlayer.vehicle.position.z - HELI_MARKER_DIST) > source.position.z) then
				exports.UCDdx:new("ATC: You must be on the ground in order to process the flight!", 255, 215, 0)
				return
			end
		end
		
		if (prev.airport or prev.dest) then
			if (localPlayer.vehicle.vehicleType == "Plane") then
				if (cargoPlanes[localPlayer.vehicle.model]) then
					exports.UCDdx:new("ATC: Please wait while your aircraft is unloaded", 255, 215, 0)
				else
					exports.UCDdx:new("ATC: Please wait while your passengers disembark the aircraft", 255, 215, 0)
				end
			else
				exports.UCDdx:new("ATC: Please wait while the private passgener disembarks", 255, 215, 0)
			end
		else
			if (localPlayer.vehicle.vehicleType == "Plane") then
				if (cargoPlanes[localPlayer.vehicle.model]) then
					exports.UCDdx:new("ATC: Please wait while your aircraft is loaded", 255, 215, 0)
				else
					exports.UCDdx:new("ATC: Please wait while your passengers embark the aircraft", 255, 215, 0)
				end
			else
				exports.UCDdx:new("ATC: Please wait while the private passgener embarks", 255, 215, 0)
			end
		end
		
		
		--localPlayer.vehicle.rotation = Vector3(0, 0, localPlayer.vehicle.rotation.z)
		--localPlayer.vehicle.velocity = Vector3(0, 0, -0.1)
		--localPlayer.vehicle.position = Vector3(localPlayer.vehicle.position.x, localPlayer.vehicle.position.y, source.position.z + 1)
		--localPlayer.vehicle.frozen = true
		
		stopVehicle(true)
		
		hasHit = true
		
		Timer(onCompleteWaitForPassengers, WAIT_TIME, 1)
	end
end

function onCompleteWaitForPassengers()
	if (localPlayer.vehicle) then
	
		stopVehicle()
		hasHit = nil
		
		if (localPlayer.vehicle.vehicleType == "Plane") then
			if (prev.airport) then
				triggerServerEvent("UCDaviator.processFlight", localPlayer, {curr.airport, curr.dest, prev.airport, prev.dest}, localPlayer.vehicle)
				cancelItinerary()
			else
				calculateItinerary()
			end
		elseif (localPlayer.vehicle.vehicleType == "Helicopter") then
			if (prev.dest) then
				triggerServerEvent("UCDaviator.processFlight", localPlayer, {curr.dest, prev.dest}, localPlayer.vehicle)
				cancelItinerary()
			else
				calculateItinerary()
			end
		end
	end
end

function displayDistance()
	if (isItinerary() and dest) then
		local meas = "m"
		local p = localPlayer.position
		local x, y, z = dest[1], dest[2], dest[3]
		local dist = math.floor(getDistanceBetweenPoints3D(p.x, p.y, p.z, x, y, z))
		if (dist >= 1000) then
			dist = exports.UCDutil:mathround(dist / 1000, 2)
			meas = "km"
		end
		
		exports.UCDdx:add("aviatordist", "Distance: "..tostring(exports.UCDutil:tocomma(dist))..tostring(meas), 255, 215, 0)
	end
end
