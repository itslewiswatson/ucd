-- Vehicles prices to sell to bank
-- Divide the number by 10, then divide the vehicle price by the result
-- Rate: 920 (92%)
-- Fluctuation: 50 (5%)

Vehicles = {
	rate = 920,	fluc = 50,	default = {rate = 920},	old = {},
}

function getVehicleRate()
	return Vehicles.rate, Vehicles.fluc
end

function setVehicleRate()
	local default_rate = Vehicles.default.rate
	
	if Vehicles.rate ~= nil and Vehicles.rate ~= false then
		Vehicles.old.rate = Vehicles.rate
	end
	
	local rate = math.random(default_rate - Vehicles.fluc, default_rate + Vehicles.fluc)
	
	-- Set it in the table
	Vehicles.rate = rate
	
	-- Tell every player it has been set
	triggerEvent("UCDmarket.onVehiclePriceChange", resourceRoot)
end

function onVehiclePriceChange()
	outputDebugString("UCDmarket[vehicles] - New: r="..Vehicles.rate.." Old: r="..Vehicles.old.rate.." [static fluc="..Vehicles.fluc.."]")
	exports.UCDdx:new(root, "Vehicle market: The new vehicle selling percentage is "..tostring(Vehicles.rate / 10).."%", 255, 255, 255)
	
	-- This is synced client-side, so we don't need to worry about a client file or manual syncing
	-- Removed this as it is unneeded
	root:setData("vehicles.rate", Vehicles.rate)
	root:setData("vehicles.fluc", Vehicles.fluc)
end
addEvent("UCDmarket.onVehiclePriceChange", true)
addEventHandler("UCDmarket.onVehiclePriceChange", root, onVehiclePriceChange)

-- We call this first up
setVehicleRate()
setTimer(setVehicleRate, 5000000, 0) -- Need to find a proper timer for this
addCommandHandler("veh", function (plr) if exports.UCDadmin:isPlayerOwner(plr) then setVehicleRate() end end)
