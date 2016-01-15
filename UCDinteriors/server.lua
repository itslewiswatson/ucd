function foo(markerNumber, type_, entryOrExit)
	if (client and markerNumber and type_) then
		local goto = interiors[type_][markerNumber]
		if (entryOrExit == "exit") then
			client.dimension = 0
			client.interior = 0
			client.position = Vector3(goto.entryX, goto.entryY, goto.entryZ)
		elseif (entryOrExit == "entry") then
			client.position = Vector3(goto.exitX, goto.exitY, goto.exitZ)
			client.dimension = goto.dimension
			client.interior = goto.interior
		end
	end
end
addEvent("UCDinteriors.warp", true)
addEventHandler("UCDinteriors.warp", root, foo)
