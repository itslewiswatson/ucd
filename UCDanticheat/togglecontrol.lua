addCommandHandler("tog",
	function ()
		outputDebugString(tostring(not isControlEnabled("fire")))
		toggleControl("fire", not isControlEnabled("fire")) 
	end
)

local fireKeys = getBoundKeys("fire")
local exceptedWeapons = {[41] = true}
local exceptedSlots = {[0] = true, [1] = true, [8] = true, [10] = true, [11] = true, [12] = true}

function aimCheck(button, state)
	if (localPlayer.vehicle) then return end
	if (fireKeys[button] and state == true) then
		if (exceptedSlots[localPlayer.weaponSlot] or exceptedWeapons[localPlayer:getWeapon()]) then
			return
		end
		--outputDebugString("fire")
		if (getControlState("aim_weapon")) then
			--outputDebugString("is aiming")
		else
			toggleControl("fire", false)
			--outputDebugString("not aiming")
		end
	end
	if (fireKeys[button] and state == false) then
		if (exports.UCDsafeZones:isElementWithinSafeZone(localPlayer) or localPlayer.frozen) then return end
		toggleControl("fire", true)
	end
end
addEventHandler("onClientKey", root, aimCheck)