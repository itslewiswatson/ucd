function onClientEnterTurf(turfID)	
	-- exports.UCDdx:add("turf_indicator")
end
addEvent("onClientEnterTurf", true)
addEventHandler("onClientEnterTurf", root, onClientEnterTurf)

function onClientTurf(infoTable)
	if (_infoTable) then
		for k, v in ipairs(_infoTable) do
			exports.UCDdx:del("turf_indicator_"..tostring(v[1]))
		end
	end
	for k, v in ipairs(infoTable) do
		exports.UCDdx:add("turf_indicator_"..tostring(v[1]), tostring(v[1])..": "..tostring(v[2]).."%", v[3][1], v[3][2], v[3][3])
	end
	_infoTable = infoTable
end
addEvent("onClientTurf", true)
addEventHandler("onClientTurf", root, onClientTurf)

function onClientExitTurf()
	if (_infoTable) then
		for k, v in ipairs(_infoTable) do
			exports.UCDdx:del("turf_indicator_"..tostring(v[1]))
		end
	end
end
addEvent("onClientExitTurf", true)
addEventHandler("onClientExitTurf", root, onClientExitTurf)