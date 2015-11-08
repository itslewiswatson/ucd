--------------------------------------------------------------------
--// PROJECT: Union of Clarity and Diversity
--// RESOURCE: UCDaccounts
--// DEVELOPER(S): Lewis Watson (Noki)
--// DATE: 25.10.2015
--// PURPOSE: Save and manage player weapons.
--// FILE: \UCDaccounts\weapons.lua [server]
--------------------------------------------------------------------

db = exports.UCDsql:getConnection()
weaponString = {}

function getPlayerWeaponTable(plr)
	local t = {}
	for i=1, 12 do
		if plr:getTotalAmmo(i) ~= 0 then
			t[i] = {weapon = plr:getWeapon(i), ammo = plr:getTotalAmmo(i)}
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
				db:query(loadPlayerWeaponString, {plr}, "SELECT `weaponString` FROM `playerWeapons` WHERE `id`=? LIMIT 1", exports.UCDaccounts:getPlayerAccountID(plr))
			end
		end
	end
)

function loadPlayerWeaponString(qh, plr)
	local result = qh:poll(-1)
	
	if (result and #result ~= 0) then
		weaponString[plr] = result[1].weaponString
		--outputDebugString("result is actual")
		for i, v in pairs(fromJSON(weaponString[plr])) do
			giveWeapon(plr, v.weapon, v.ammo)
		end
	end
end

function savePlayerWeaponString(plr)
	if not weaponString[plr] then return nil end
	db:exec("UPDATE `playerWeapons` SET `weaponString`=? WHERE `id`=?", toJSON(getPlayerWeaponTable(plr)), getPlayerAccountID(plr))
	weaponString[plr] = toJSON(getPlayerWeaponTable(plr))
end
addEventHandler("onPlayerQuit", root, function () savePlayerWeaponString(source) weaponString[plr] = nil end)
addEventHandler("onPlayerWasted", root, function () savePlayerWeaponString(source)  end)
addEventHandler("onResourceStop", root, function () for _, plr in pairs(Element.getAllByType("player")) do savePlayerWeaponString(plr) weaponString[plr] = nil end end)

function getPlayerWeaponString(plr)
	if (not plr or weaponString[plr] == nil) then return "lol" end
	if (plr:getType() ~= "player") then return false end
	return weaponString[plr]
end
