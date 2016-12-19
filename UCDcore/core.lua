-------------------------------------------------------------------
--// PROJECT: Union of Clarity and Diversity
--// RESOURCE: UCDcore
--// DEVELOPER(S): Lewis Watson (Noki)
--// DATE: 17.05.2014
--// PURPOSE: A core resource. 
--// FILE: \UCDcore\core.lua [server]
-------------------------------------------------------------------

db = exports.UCDsql:getConnection()

-- This is so we don't get weird symbols in the db
-- This snippet doesn't like to work in UCDsql for some reason.
local charset = db:exec("SET NAMES `utf8mb4`")
if (not charset) then
	outputDebugString("["..getThisResource():getName().."] Failed to encode database with utf8m4")
else
	outputDebugString("["..getThisResource():getName().."] Successfully encoded database with utf8m4")
end


function getGameVersion()
	local qh = db:query("SELECT `version` FROM `core`")
	local ver = qh:poll(-1)
	return tostring(ver[1].version)
end

setGameType("Vanos "..getGameVersion())
setMinuteDuration(6000)
setFPSLimit(60)
setServerPassword("onelove")
setWeather(10)
setTime(0, 0)
for i = 0, 49 do setGarageOpen(i, true) end

-- Weapons vals
-- Minigun
setWeaponProperty("minigun", "pro", "damage", 5)
setWeaponProperty("minigun", "std", "damage", 5)
setWeaponProperty("minigun", "poor", "damage", 5)
setWeaponProperty("minigun", "pro", "flag_move_and_shoot", false)
setWeaponProperty("minigun", "std", "flag_move_and_shoot", false)
setWeaponProperty("minigun", "poor", "flag_move_and_shoot", false)
-- MP5
setWeaponProperty("mp5", "pro", "accuracy", 1.9)
setWeaponProperty("mp5", "std", "accuracy", 1.9)
setWeaponProperty("mp5", "poor", "accuracy", 1.9)
-- Tec-9
setWeaponProperty("tec-9", "pro", "flag_type_dual", true)
setWeaponProperty("tec-9", "std", "flag_type_dual", true)
setWeaponProperty("tec-9", "poor", "flag_type_dual", true)
setWeaponProperty("tec-9", "pro", "damage", 15)
setWeaponProperty("tec-9", "std", "damage", 15)
setWeaponProperty("tec-9", "poor", "damage", 15)
-- Uzi
setWeaponProperty("uzi", "pro", "flag_type_dual", true)
setWeaponProperty("uzi", "std", "flag_type_dual", true)
setWeaponProperty("uzi", "poor", "flag_type_dual", true)
setWeaponProperty("uzi", "pro", "damage", 15)
setWeaponProperty("uzi", "std", "damage", 15)
setWeaponProperty("uzi", "poor", "damage", 15)

-----------------------------------------------------
-- Kill command
-----------------------------------------------------

addCommandHandler( "kill",
	function (plr)
		if (not exports.UCDaccounts:isPlayerLoggedIn(plr)) then return end
		if (plr.vehicle) then exports.UCDdx:new(plr, "You cannot kill yourself while in a vehicle", 255, 0, 0) return end
		if (not plr.onGround) then exports.UCDdx:new(plr, "You must be on the ground in order to kill yourself", 255, 0, 0) return end
		if (plr.wantedLevel > 0) then exports.UCDdx:new(plr, "You cannot kill yourself while wanted", 255, 0, 0) return end
		
		if (plr.team.name == "Admins") then
			plr:kill()
			return
		end
		
		exports.UCDdx:new(plr, "You will be killed in 10 seconds", 255, 0, 0)
		toggleAllControls(plr, false, true, false)
		plr.frozen = true
		setTimer(
			function ()
				plr:kill()
				toggleAllControls(plr, true)
			end, 10000, 1
		)
		
	end
)
