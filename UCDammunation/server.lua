function onMarkerHit(ele, matchingDimension)
	if (ele and isElement(ele) and ele.type == "player" and matchingDimension) then
		triggerClientEvent(ele, "UCDammunation.open", ele, exports.UCDaccounts:getOwnedWeapons(ele) or {})
	end
end

local markers = 
{
	-- Ammunation 1
	{x = 294.9519, y = -37.7483, z = 1001.5156, dimRange = {13000, 13001}, interior = 1},
	-- Ammunation 2
	{x = 291.8691, y = -80.9219, z = 1001.5156, dimRange = {13000, 13002}, interior = 4},
	-- Ammunation 3
	{x = 290.0173, y = -109.2233, z = 1001.5156, dimRange = {13000, 13004}, interior = 6},
}
for _, info in ipairs(markers) do
	for i = info.dimRange[1], info.dimRange[2] do
		local m = Marker(info.x, info.y, info.z - 1, "cylinder", 2, 160, 160, 160, 170)
		m.interior = info.interior
		m.dimension = i
		m:setData("displayText", "Ammunation")
		addEventHandler("onMarkerHit", m, onMarkerHit)
	end
end

-- 
function buyWeapon(weaponID)
	if (client and weaponID) then
		if (client.money < prices[weaponID][1]) then
			exports.UCDdx:new(client, "You cannot afford to purchase this weapon", 255, 0, 0)
			return
		end
		local o = exports.UCDaccounts:setOwnedWeapon(client, weaponID)
		if (not o) then
			exports.UCDdx:new(client, "You were unable to make this purchase", 255, 0, 0)
			return
		end
		client:takeMoney(prices[weaponID][1])
		giveWeapon(client, weaponID, 0)
		triggerClientEvent(client, "UCDammunation.update", client, exports.UCDaccounts:getOwnedWeapons(client) or {})
		exports.UCDstats:setPlayerAccountStat(client, "totalguns", exports.UCDstats:getPlayerAccountStat(client, "totalguns") + prices[weaponID][1])
	end
end
addEvent("UCDammunation.buyWeapon", true)
addEventHandler("UCDammunation.buyWeapon", root, buyWeapon)

function buyAmmo(weaponID, amount)
	if (client and weaponID and amount) then
		if (client.money < (amount * prices[weaponID][2])) then
			exports.UCDdx:new(client, "You cannot afford to purchase this much ammo", 255, 0, 0)
			return
		end
		if (tonumber(amount) <= 0) then
			exports.UCDdx:new(client, "You cannot purchase negative ammo amount", 255, 0, 0)
			return
		end
		client:takeMoney(amount * prices[weaponID][2])
		giveWeapon(client, weaponID, amount)
		setPedWeaponSlot(client, getSlotFromWeapon(weaponID))
		triggerClientEvent(client, "UCDammunation.update", client, exports.UCDaccounts:getOwnedWeapons(client) or {})
		exports.UCDstats:setPlayerAccountStat(client, "totalguns", exports.UCDstats:getPlayerAccountStat(client, "totalguns") + (amount * prices[weaponID][2]))
	end
end
addEvent("UCDammunation.buyAmmo", true)
addEventHandler("UCDammunation.buyAmmo", root, buyAmmo)