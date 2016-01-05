--local jobs = exports.UCDjobsTable:getJobTable()

function foo(markerNumber, jobName)
	if (client and markerNumber and jobName) then
		local goto = interiors[jobName][markerNumber]
		if (client.dimension ~= 0 or client.interior ~= 0) then
			client.position = Vector3(goto.entryX, goto.entryY, goto.entryZ)
			client.dimension = 0
			client.interior = 0
		else
			client.position = Vector3(goto.exitX, goto.exitY, goto.exitZ)
			client.dimension = goto.dimension
			client.interior = goto.interior
		end
	end
end
addEvent("UCDinteriors.warp", true)
addEventHandler("UCDinteriors.warp", root, foo)
