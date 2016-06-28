local badWeapons = {[0] = true, [1] = true, [41] = true, [42] = true, [10] = true, [11] = true, [12] = true, [14] = true, [15] = true, [44] = true, [45] = true, [46] = true, [40] = true, [43] = true}
local count = 0

function onClientPlayerWeaponFire(weapon)
	if (not badWeapons[weapon]) then
		count = count + 1
	end
end
addEventHandler("onClientPlayerWeaponFire", localPlayer, onClientPlayerWeaponFire)

function process()
	if (count and count ~= 0) then
		triggerServerEvent("UCDstats.addBulletCount", resourceRoot, count)
		count = 0
	end
end

addEventHandler("onClientPlayerLogin", localPlayer,
	function ()
		Timer(process, 15000, 0)
	end
)

addEventHandler("onClientResourceStart", resourceRoot,
	function ()
		if (exports.UCDaccounts:isPlayerLoggedIn(localPlayer)) then
			Timer(process, 15000, 0)
		end
	end
)