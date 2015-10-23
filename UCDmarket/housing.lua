-- Housing prices to sell to bank
-- Divide the number by 10, then divide the house price by the result
-- Rate: 888 (88.8%)
-- Fluctuation: 100 (10%)

Housing = {
	rate = 888,	fluc = 100,	default = {rate = 888, fluc = 100},	old = {},
}

function getHouseRate()
	return Housing.rate, Housing.fluc
end

function setHouseRate()
	local default_rate = Housing.default.rate
	local default_fluc = Housing.default.fluc
	
	if Housing.rate ~= nil and Housing.fluc ~= nil and Housing.rate ~= false and Housing.fluc ~= false then
		Housing.old.rate = Housing.rate
		Housing.old.fluc = Housing.fluc
	end
	
	local fluc = math.random(default_fluc - 40, default_fluc)
	local rate = math.random(default_rate - fluc, default_rate + fluc)
	
	-- Set it in the table
	Housing.rate = rate
	Housing.fluc = fluc
	
	-- Tell every player it has been set
	triggerEvent("UCDmarket.onHousePriceChange", resourceRoot)
end

function onHousePriceChange()
	outputDebugString("UCDmarket[housing] - New: r="..Housing.rate.." f="..Housing.fluc.."; Old: r="..Housing.old.rate.." f="..Housing.old.fluc)
	exports.UCDdx:new(root, "Housing market: The new housing percentage is "..tostring(Housing.rate / 10).."%", 255, 255, 255)
	
	-- This is synced client-side, so we don't need to worry about a client file or manual syncing
	-- Removed this as it is unneeded
	root:setData("rate", Housing.rate)
	root:setData("fluc", Housing.fluc)
end
addEvent("UCDmarket.onHousePriceChange", true)
addEventHandler("UCDmarket.onHousePriceChange", root, onHousePriceChange)

-- We call this first up
setHouseRate()
setTimer(setHouseRate, 5000000, 0) -- Need to find a proper timer for this
addCommandHandler("hous", function (plr) if exports.UCDadmin:isPlayerOwner(plr) then setHouseRate() end end)