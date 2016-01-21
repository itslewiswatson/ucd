local jobs
local entryMarkers = {}
local exitMarkers = {}
local toMarker = {["entry"] = {}, ["exit"] = {}}
local hasHit

addEventHandler("onClientResourceStart", resourceRoot,
	function ()
		jobs = exports.UCDjobsTable:getJobTable()
	end
)

function createMarkers()
	for type_, data in pairs(interiors) do
		entryMarkers[type_] = {}
		exitMarkers[type_] = {}
		for i, info in ipairs(data) do
			local r, g, b			
			if (jobs[type_]) then
				r, g, b = jobs[type_].colour.r, jobs[type_].colour.g, jobs[type_].colour.b
			elseif (info.colour) then
				r, g, b = info.colour[1], info.colour[2], info.colour[3]
			else
				r, g, b = 255, 255, 255
			end
			
			-- Entry markers
			entryMarkers[type_][i] = Marker(info.entryX, info.entryY, info.entryZ + 0.5, "arrow", 1, r, g, b)
			if (jobs[type_] and jobs[type_].blipID) then
				Blip.createAttachedTo(entryMarkers[type_][i], jobs[type_].blipID, nil, nil, nil, nil, nil, 5, 255)
			elseif (info.blipID) then
				Blip.createAttachedTo(entryMarkers[type_][i], info.blipID, nil, nil, nil, nil, nil, 5, 255)
			end
			
			-- Exit markers
			exitMarkers[type_][i] = Marker(info.exitX, info.exitY, info.exitZ + 0.5, "arrow", 1, r, g, b)
			exitMarkers[type_][i].dimension = info.dimension
			exitMarkers[type_][i].interior = info.interior
			
			-- Event handlers for entry and exit
			addEventHandler("onClientMarkerHit", entryMarkers[type_][i], onClientMarkerHit)
			addEventHandler("onClientMarkerHit", exitMarkers[type_][i], onClientMarkerHit)
		end
	end
end
addEventHandler("onClientResourceStart", resourceRoot, createMarkers)

function onClientMarkerHit(plr, matchingDimension)
	if (plr == localPlayer and not plr.vehicle and matchingDimension) then
		if (plr.position.z - 1.5 < source.position.z and plr.position.z + 1.5 > source.position.z and not hasHit) then
			local markerNumber, type_, entryOrExit
			
			for x, y in pairs({entryMarkers, exitMarkers}) do
				for k, v in pairs(y) do
					for index in ipairs(v) do
						if (v[index] == source) then
							markerNumber = index
							type_ = k
							break
						end
					end
				end
			end
			
			if (exitMarkers[type_][markerNumber] == source) then
				entryOrExit = "exit"
			elseif (entryMarkers[type_][markerNumber] == source) then
				entryOrExit = "entry"
			else
				return
			end
			
			triggerServerEvent("UCDinteriors.warp", localPlayer, markerNumber, type_, entryOrExit)
			
			hasHit = true
			Timer(function () hasHit = nil end, 1000, 1)
		end
	end
end
