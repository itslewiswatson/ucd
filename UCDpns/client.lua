local MAX_SPEED = 75
local locs = 
{
	{2290.5786, -1676.5746, 14.3835}, -- Grove Street
	{1854.7446, -2409.2378, 13.5547}, -- LS Airport
	{721.8774, -1634.1714, -0.05}, -- Near canal boat shop, LS
	{720.0313, -457.2752, 16.3359}, -- Dillimore
	{2409.7002, 91.0102, 26.4733}, -- Palomino Creek
	{1025.2513, -1023.9696, 32.1016}, -- LS Mech
	{1974.2849, 2162.6072, 11.0703}, -- LV Mech
	{345.5509, 2543.4856, 16.7615}, -- Verdant Meadows
	{1569.4238, 1447.0719, 10.8184}, -- LV airport
	{2386.5808, 1051.7126, 10.8203}, -- South LV transfender
	{2323.8877, 531.7814, -0.55}, -- South LV boat shop
	{487.4951, -1741.9119, 11.135}, -- Santa Maria Beach 
	{211.2498, 24.8661, 2.5781}, -- blueberry acres
	{-1420.6552, 2584.2786, 55.8433}, -- El Quebrados
	{-2425.8401, 1020.8616, 50.3906}, -- SF central
	{-1786.6021, 1216.3926, 25.125}, -- SF central
	{-1904.1547, 286.1548, 41.0469}, -- Wangs Car shop SF
}
local objs = 
{
	-- Palomino Creek
	{m = 12978, x = 2411.7, y = 91.1, z = 25.5, r = 270},
	{m = 13027, x = 2411.7, y = 91.1, z = 28.6, r = 90},
}

addEventHandler("onClientResourceStart", resourceRoot,
	function ()
		for k, v in ipairs(objs) do
			local o = Object(v.m, v.x, v.y, v.z)
			o.rotation = Vector3(0, 0, v.r)
		end
		for k, v in ipairs(locs) do
			local m = Marker(v[1], v[2], v[3] - 1, "cylinder", 4, 255, 100, 100, 255)
			Blip.createAttachedTo(m, 63, nil, nil, nil, nil, nil, 0, 350)
			addEventHandler("onClientMarkerHit", m, onMarkerHit)
			addEventHandler("onClientMarkerLeave", m, onMarkerLeave)
		end
	end
)

function onMarkerHit(plr, matchingDimension)
	if (plr == localPlayer and plr.vehicle and matchingDimension and plr.position.z < source.position.z + 1.5 and plr.position.z > source.position.z - 1.5 and plr.vehicle.controller == plr) then
		exports.UCDdx:add("pns", "Press Z: Repair Vehicle", 255, 0, 0)
		bindKey("z", "down", onTryRepair)
	end
end

function onMarkerLeave(plr, matchingDimension)
	if (plr == localPlayer and matchingDimension) then
		exports.UCDdx:del("pns")
		unbindKey("z", "down", onTryRepair)
	end
end

function onTryRepair()
	local vehicle = localPlayer.vehicle
	if (vehicle) then
		onMarkerLeave(localPlayer, true)
		if (math.floor(vehicle.health) == 1000) then
			exports.UCDdx:new("Your "..tostring(vehicle.name).." does not require a repair", 255, 0, 0)
			return
		end
		if (exports.UCDutil:getElementSpeed(vehicle) > 0) then
			exports.UCDdx:new("Please bring the vehicle to a complete stop to repair it", 255, 0, 0)
			return
		end
		triggerServerEvent("UCDpns.process", localPlayer)
	end
end
