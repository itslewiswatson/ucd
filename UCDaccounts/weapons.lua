--------------------------------------------------------------------
--// PROJECT: Union of Clarity and Diversity
--// RESOURCE: UCDaccounts
--// DEVELOPER(S): Lewis Watson (Noki)
--// DATE: 25.10.2015
--// PURPOSE: Save and manage player weapons.
--// FILE: \UCDaccounts\weapons.lua [server]
--------------------------------------------------------------------

db = exports.UCDsql:getConnection()

function getPlayerWeaponTable(plr)
	local t = {}
	for i=1, 12 do
		if plr:getTotalAmmo(i) ~= 0 then
			t[i] = {plr:getWeapon(i), plr:getTotalAmmo(i)}
		end
	end
	return t
end

addEventHandler("onPlayerLogin", root,
	function ()
		db:query(loadPlayerWeaponString, {source}, "SELECT `weaponString` FROM `playerWeapons` WHERE `account`=? LIMIT 1", source.account.name)
	end
)

-- Some code while we're always restarting the resource 
-- We might keep it, even thought it is inefficient as fuck
addEventHandler("onResourceStart", resourceRoot,
	function ()
		for _, plr in pairs(Element.getAllByType("player")) do
			if isPlayerLoggedIn(plr) then
				db:query(loadPlayerWeaponString, {plr, false}, "SELECT `weaponString` FROM `playerWeapons` WHERE `account`=? LIMIT 1", plr.account.name)
			end
		end
	end
)

function loadPlayerWeaponString(qh, plr, togive)
	local result = qh:poll(-1)
	
	if (result and #result ~= 0) then
		if (togive ~= false) then
			for i, v in pairs(fromJSON(result[1].weaponString)) do
				giveWeapon(plr, v[1], v[2])
			end
		end
	end
end

function savePlayerWeaponString(plr)
	db:exec("UPDATE `playerWeapons` SET `weaponString`=? WHERE `account`=?", toJSON(getPlayerWeaponTable(plr)), plr.account.name)
end
addEventHandler("onPlayerQuit", root, function () savePlayerWeaponString(source) end)
addEventHandler("onPlayerWasted", root, function () savePlayerWeaponString(source)  end)
addEventHandler("onResourceStop", resourceRoot, function () for _, plr in pairs(Element.getAllByType("player")) do savePlayerWeaponString(plr) end end)

function getPlayerWeaponString(plr)
	if (not plr) then return end
	if (not isElement(plr) or plr.type ~= "player" or not isPlayerLoggedIn(plr)) then return false end
	return toJSON(getPlayerWeaponTable(plr))
end

-- 
function getOwnedWeapons(plr)
	if (not plr) then return end
	if (not isElement(plr) or plr.type ~= "player" or not isPlayerLoggedIn(plr)) then return false end
	return fromJSON(GAD(plr, "ownedWeapons")) or {}
end

function setOwnedWeapon(plr, weaponID)
	if (not plr) then return end
	if (not isElement(plr) or plr.type ~= "player" or not isPlayerLoggedIn(plr)) then return false end
	local t = fromJSON(GAD(plr, "ownedWeapons")) or {}
	for _, v in ipairs(t or {}) do
		if (v == weaponID) then
			return
		end
	end
	table.insert(t, weaponID)
	SAD(plr, "ownedWeapons", toJSON(t))
	return true
end
