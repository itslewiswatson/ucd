local pdMarkers = {
	{1534.5527, -1670.0854, 13.3828, "LSPD"}, --LSPD
	{ 638.0579, -571.6723, 16.1875, "RCPD"}, -- RCPD
	{-221.3963, 994.7599, 19.5981, "BCPD"}, --BCPD
	{2292.0781, 2416.1091, 10.7613, "LVPD"}, --LVPD
	{-1608.3231, 725.833, 12.32, "SFPD"}, -- SFPD
	{-2166.5378, -2391.573, 30.4688, "WSPD"}, --WSPD
	{-1412.5796, 2640.4912, 55.6875, "EQPD"}, -- EQPD
}
local pdMarkers2, prox, dist, b = {}, {}, {}, nil

function createPDMarkers()
	pdMarkers2 = {}
	for ind, ent in ipairs(pdMarkers) do
		local p = localPlayer.position
		local dist2 = getDistanceBetweenPoints3D(p.x, p.y, p.z, ent[1], ent[2], ent[3])
		table.insert(prox, dist2)
		dist[dist2] = ind
	end
	table.sort(prox)
	local t = dist[prox[1]]
	
	for ind, ent in ipairs(pdMarkers) do
		local m = Marker(ent[1], ent[2], ent[3] - 1, "cylinder", 4, 0, 30, 144, 255)
		table.insert(pdMarkers2, m)
		if (ind == t) then
			b = Blip.createAttachedTo(m, 30)
		end
		addEventHandler("onClientMarkerHit", m, onFinishEscorting)
	end
	
	exports.UCDdx:new("The nearest PD has been marked ("..tostring(pdMarkers[t][4])..")", 30, 144, 255)
end
addEvent("UCDlaw.createPDMarkers", true)
addEventHandler("UCDlaw.createPDMarkers", root, createPDMarkers)

function onFinishEscorting(cop, matchingDimension)
	if (cop and cop.team.name == "Law" and cop == localPlayer and matchingDimension) then
		triggerServerEvent("UCDlaw.onFinishEscorting", resourceRoot)
	end
end

function destroyPDMarkers()
	for x, y in ipairs(pdMarkers2) do
		y:destroy()
	end
	b:destroy()
end
addEvent("UCDlaw.destroyPDMarkers", true)
addEventHandler("UCDlaw.destroyPDMarkers", root, destroyPDMarkers)

function displayHits(plr, hits, total)
	if (plr == "remove" or hits == "remove" or total == "remove") then
		exports.UCDdx:del("nightstick_hits")
		return
	end
	if (hits == 0) then
		exports.UCDdx:del("nightstick_hits")
		return
	end
	exports.UCDdx:add("nightstick_hits", tostring(hits).."/"..tostring(total).." hits - "..tostring(plr.name), 30, 144, 255)
end
addEvent("UCDlaw.displayHits", true)
addEventHandler("UCDlaw.displayHits", root, displayHits)

function displayArrested(cop)
	if (cop == "remove") then
		exports.UCDdx:del("arrestedby")
		return
	end
	exports.UCDdx:add("arrestedby", "Arrested by "..tostring(cop.name), 30, 144, 255)
	exports.UCDdx:del("nightstick_hits")
	addEventHandler("onClientPlayerQuit", cop,
		function ()
			exports.UCDdx:del("arrestedby")
		end
	)
end
addEvent("UCDlaw.displayArrested", true)
addEventHandler("UCDlaw.displayArrested", root, displayArrested)

addEventHandler("onClientResourceStop", resourceRoot,
	function ()
		exports.UCDdx:del("arrestedby")
		exports.UCDdx:del("nightstick_hits")
	end
)

addEventHandler("onClientPlayerDamage", root, 
	function ()
		if (source:getData("arrested") == true) then
			cancelEvent()
		end
	end
)

