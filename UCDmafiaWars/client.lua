local ghosts = {}

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

addEvent("ghost", true)
addEventHandler("ghost", resourceRoot,
	function ()
		ghosts[localPlayer] = true
		Timer(
			function (localPlayer)
				ghosts[localPlayer] = nil
			end, 10000, 1, localPlayer
		)
	end
)

addEventHandler("onClientKey", root,
	function (k, s)
		if (not ghosts[localPlayer]) then return end
		local fires = getBoundKeys("fire")
		local aimes = getBoundKeys("aim_weapon")
		if (fires) then
			for k2, s2 in pairs(fires) do
				if (k == k2) then
					cancelEvent()
				end
			end
		end
		if (aimes) then
			for k2, s2 in pairs(aimes) do
				if (k == k2) then
					cancelEvent()
				end
			end
		end
	end
)

addEventHandler("onClientPlayerDamage", root,
	function ()
		if (ghosts[source]) then
			cancelEvent()
		end
	end
)