-------------------------------------------------------------------
--// PROJECT: Project Downtown
--// RESOURCE: respawn
--// DEVELOPER(S): Lewis Watson (Noki)
--// DATE: 14.12.2014
--// PURPOSE: To handle server side respawning of players.
--// FILE: \respawn\server.lua [server]
-------------------------------------------------------------------

addEvent("respawnDeadPlayer", true)
addEventHandler("respawnDeadPlayer", root,
	function (hX, hY, hZ, rotation, hospitalName, weaponTable)
		fadeCamera(source, false, 1.0, 0, 0, 0)
		setTimer(fadeCamera, 2000, 1, source, true, 1.0, 0, 0, 0)
		setTimer(respawnPlayer, 2000, 1, source, hX, hY, hZ, rotation, weaponTable)
		--exports.UCDdx:new(source, "You respawned at "..hospitalName, 225, 225, 225)
	end
)

-- Function that respawns the player
function respawnPlayer(plr, hX, hY, hZ, rotation, weaponTable)
	if (isElement(plr)) then
		fadeCamera(plr, true)
		setCameraTarget(plr, plr)
		spawnPlayer(plr, hX + math.random(0.1, 2), hY + math.random(0.1, 2), hZ, rotation, plr.model, 0, 0)
		
		if (exports.UCDjail:isPlayerJailed(plr)) then
			triggerEvent("onPlayerJailed", plr)
		end
		
		for i=1,#weaponTable do
			local weapon = weaponTable[i][1]
			if weapon then
				local ammo = weaponTable[i][2]
				giveWeapon(plr, weapon, ammo)
			end
		end
	end
end

