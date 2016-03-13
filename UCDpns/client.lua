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
}

addEventHandler("onClientResourceStart", resourceRoot,
	function ()
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
		exports.UCDdx:add("Press Z: Repair Vehicle", 255, 0, 0)
		bindKey("z", "down", onTryRepair)
	end
end

function onMarkerLeave(plr, matchingDimension)
	if (plr == localPlayer and matchingDimension) then
		exports.UCDdx:del("Press Z: Repair Vehicle")
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
		if (exports.UCDutil:getElementSpeed(vehicle) > MAX_SPEED) then
			exports.UCDdx:new("You are travelling too fast for your vehicle to be repaired", 255, 0, 0)
			return
		end
		triggerServerEvent("UCDpns.process", localPlayer)
	end
end
