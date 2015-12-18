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
		db:query(loadPlayerWeaponString, {source}, "SELECT `weaponString` FROM `playerWeapons` WHERE `id`=? LIMIT 1", exports.UCDaccounts:getPlayerAccountID(source))
	end
)

-- Some code while we're always restarting the resource 
-- We might keep it, even thought it is inefficient as fuck
addEventHandler("onResourceStart", resourceRoot,
	function ()
		for _, plr in pairs(Element.getAllByType("player")) do
			if isPlayerLoggedIn(plr) then
				db:query(loadPlayerWeaponString, {plr, false}, "SELECT `weaponString` FROM `playerWeapons` WHERE `id`=? LIMIT 1", exports.UCDaccounts:getPlayerAccountID(plr))
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
	db:exec("UPDATE `playerWeapons` SET `weaponString`=? WHERE `id`=?", toJSON(getPlayerWeaponTable(plr)), getPlayerAccountID(plr))
end
addEventHandler("onPlayerQuit", root, function () savePlayerWeaponString(source) end)
addEventHandler("onPlayerWasted", root, function () savePlayerWeaponString(source)  end)
addEventHandler("onResourceStop", root, function () for _, plr in pairs(Element.getAllByType("player")) do savePlayerWeaponString(plr) end end)

function getPlayerWeaponString(plr)
	if (not plr) then return end
	if (not isElement(plr) or plr.type ~= "player" or not isPlayerLoggedIn(plr)) then return false end
	return toJSON(getPlayerWeaponTable(plr))
end
