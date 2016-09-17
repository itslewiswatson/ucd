-------------------------------------------------------------------
--// PROJECT: Project Downtown
--// RESOURCE: respawn
--// DEVELOPER(S): Lewis Watson (Noki)
--// DATE: 14.12.2014
--// PURPOSE: To handle client side re-spawning of players.
--// FILE: \respawn\client.lua [client]
-------------------------------------------------------------------

local hospitalTable = {
	{ "All Saints Public Hospital", 1179.1, -1324.4, 14.15, 270.12222290039, 0, 70 },
	{ "Jefferson County Hospital", 2030.31, -1406.77, 17.2, 178.76403808594, 0, 70 },
	{ "Crippen Memorial Hospital", 1245.22, 334.22, 19.55, 335.55230712891, 0, 7 },
	{ "Fort Carson Medical Village", -319.24, 1057.76, 19.74, 343.53948974609, 0, 70 },
	{ "LVA Medical Centre", 1607.87, 1823, 10.82, 1.5188903808594, 0, 70 },
	{ "El Quebrados Health Precinct", -1514.85, 2528.23, 55.72, 358.66787719727, 0, 70 },
	{ "San Fierro General", -2647.62, 631.2, 14.45, 176.91278076172, 0, 70 },
	{ "Angel Pine Health Centre", -2199.24, -2310.78, 30.62, 319.53399658203, 0, 70 }
}

weaponTable = {}

function getWeapons()
	for i=1,12 do
		local weapon = getPedWeapon(localPlayer, i)
		if weapon then
			local ammo = getPedTotalAmmo(localPlayer, i)
			weaponTable[i] = {weapon, ammo}
		end
	end
	return weaponTable
end

-- Event triggerd when the player dies
addEventHandler("onClientPlayerWasted", localPlayer, 
	function ()
		if (source ~= localPlayer) then
			return false
		end
		
		if not (getElementHealth(localPlayer) > 0) then
			local hospitalDist = false
			local nearestHospital = false
			
			if (exports.UCDbankrob:getBank() and exports.UCDbankrob:getBank().type == "colshape" and localPlayer:isWithinColShape(exports.UCDbankrob:getBank())) then
				nearestHospital = 1
			elseif (exports.UCDmafiaWars and exports.UCDmafiaWars:isElementInLV(localPlayer)) then
				nearestHospital = 5
			else
				for i=1, #hospitalTable do
					local pX, pY, pZ = getElementPosition(localPlayer)
					local hX, hY, hZ = hospitalTable[i][2], hospitalTable[i][3], hospitalTable[i][4]
					local distance = getDistanceBetweenPoints3D(pX, pY, pZ, hX, hY, hZ)
					if not (hospitalDist) or (distance < hospitalDist) then
						hospitalDist = distance
						nearestHospital = i
					end
				end
			end
			
			if (nearestHospital) then
				local ID = nearestHospital
				local hX, hY, hZ, rotation, hospitalName = hospitalTable[ID][2], hospitalTable[ID][3], hospitalTable[ID][4], hospitalTable[ID][5], hospitalTable[ID][1]
				local mX, mY, mZ, lX, lY, lZ = hospitalTable[ID][6], hospitalTable[ID][7], hospitalTable[ID][8], hospitalTable[ID][9], hospitalTable[ID][10], hospitalTable[ID][11]
				--setTimer(function () triggerServerEvent("respawnDeadPlayer", localPlayer, hX, hY, hZ, rotation, hospitalName, slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7, slot8, slot9, slot10, slot11, slot12, ammo2, ammo3, ammo4, ammo5, ammo6, ammo7, ammo8, ammo9) end, 4000, 1)
				setTimer(
					function ()
						local weaponTable = getWeapons()
						triggerServerEvent("respawnDeadPlayer", localPlayer, hX, hY, hZ, rotation, hospitalName, weaponTable) 
					end, 4000, 1
				)
			end
		end
	end
)
