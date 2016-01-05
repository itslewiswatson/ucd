local jobs = exports.UCDjobsTable:getJobTable()
local entryMarkers = {}
local exitMarkers = {}

function createMarkers()
	for jobName, data in pairs(interiors) do
		entryMarkers[jobName] = {}
		exitMarkers[jobName] = {}
		for i, info in ipairs(data) do
			-- Entry markers
			entryMarkers[jobName][i] = Marker(info.entryX, info.entryY, info.entryZ + 0.5, "arrow", 1, jobs[jobName].colour.r, jobs[jobName].colour.g, jobs[jobName].colour.b)
			Blip.createAttachedTo(entryMarkers[jobName][i], jobs[jobName].blipID, nil, nil, nil, nil, nil, 5, 225)
			entryMarkers[jobName][i]:setData("job", jobName)
			
			addEventHandler("onClientMarkerHit", entryMarkers[jobName][i], onClientMarkerHit)
			
			-- Exit markers
			exitMarkers[jobName][i] = Marker(info.exitX, info.exitY, info.exitZ + 0.5, "arrow", 1, jobs[jobName].colour.r, jobs[jobName].colour.g, jobs[jobName].colour.b)
			exitMarkers[jobName][i].dimension = info.dimension
			exitMarkers[jobName][i].interior = info.interior
			exitMarkers[jobName][i]:setData("job", jobName)
			
			addEventHandler("onClientMarkerHit", exitMarkers[jobName][i], onClientMarkerHit)			
		end
	end
end
addEventHandler("onClientResourceStart", resourceRoot, createMarkers)

function onClientMarkerHit(plr, matchingDimension)
	if (plr == localPlayer and not plr.vehicle and matchingDimension) then
		if (plr.position.z - 1.5 < source.position.z and plr.position.z + 1.5 > source.position.z) then
			local jobName = source:getData("job")
			if (jobName) then
				local markerNumber
				if (plr.dimension ~= 0 or plr.interior ~= 0) then
					for i, marker in ipairs(exitMarkers[jobName]) do
						if (marker == source) then
							markerNumber = i
							markerType = "exit"
							break
						end
					end
				else
					for i, marker in ipairs(entryMarkers[jobName]) do
						if (marker == source) then
							markerNumber = i
							markerType = "entry"
							break
						end
					end
				end
				
				triggerServerEvent("UCDinteriors.warp", localPlayer, markerNumber, jobName)
			end
		end
	end
end
