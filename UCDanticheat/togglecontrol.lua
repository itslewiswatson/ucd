local aimKeys = getBoundKeys("aim_weapon")
local fireKeys = getBoundKeys("fire")
local exceptedWeapons = {[0] = true, [3] = true, [41] = true}
local exceptedSlots = {[0] = true, [1] = true, [8] = true, [10] = true, [11] = true, [12] = true}
local disallowedTeams = {["Citizens"] = true, ["Not logged in"] = true}

-- and (localPlayer.team.name ~= "Law" and localPlayer:getWeapon() ~= 3)

-- Firing checks (also disables firing without aiming)
function fireCheck(button, state)
	if (localPlayer.vehicle) then return end
	if (fireKeys[button] and state == true and not isCursorShowing()) then
		-- If they are in a safezone, disable firing regardless of everything else (except for cops with baton)
		if (exports.UCDsafeZones:isElementWithinSafeZone(localPlayer)) then
			if (localPlayer.team.name == "Law" and localPlayer:getWeapon() == 3) then
				toggleControl("fire", true)
				return
			end
			toggleControl("fire", false)
			return
		end
		-- Disallow fists in LV
		if (exports.UCDmafiaWars:isElementInLV(localPlayer) and localPlayer:getWeapon() == 0) then
			toggleControl("fire", false)
			return
		end
		-- If they are in not in LV, are a civilian and are not currently using their fists then
		if (not exports.UCDmafiaWars:isElementInLV(localPlayer) and disallowedTeams[localPlayer.team.name] and localPlayer:getWeapon() ~= 0) then
			if (localPlayer:getData("Occupation") == "Paramedic" and localPlayer:getWeapon() == 41) then
				toggleControl("fire", true)
				return
			end
			toggleControl("fire", false)
			return
		end
		if (exceptedSlots[localPlayer.weaponSlot] or exceptedWeapons[localPlayer:getWeapon()]) then
			return
		end
		--outputDebugString("fire")
		if (not getControlState("aim_weapon")) then
			toggleControl("fire", false)
			--outputDebugString("not aiming")
		end
	end
	if (fireKeys[button] and state == false) then
		if (not exports.UCDsafeZones:isElementWithinSafeZone(localPlayer) and not localPlayer.frozen) then
			toggleControl("fire", true)
		end
	end
end
addEventHandler("onClientKey", root, fireCheck)

function aimCheck(button, state)
	if (localPlayer.vehicle) then return end
	if (aimKeys[button] and state == true and not isCursorShowing()) then
		--if ((disallowedTeams[localPlayer.team.name] and not exports.UCDmafiaWars:isElementInLV(localPlayer)) and localPlayer.weaponSlot ~= 11 and not exceptedWeapons[localPlayer:getWeapon()] and not exports.UCDsafeZones:isElementWithinSafeZone(localPlayer)) then
		if ((disallowedTeams[localPlayer.team.name] and not exports.UCDmafiaWars:isElementInLV(localPlayer)) or exports.UCDsafeZones:isElementWithinSafeZone(localPlayer)) then
			--outputDebugString("true")
			if (localPlayer:getData("Occupation") == "Paramedic" and localPlayer:getWeapon() == 41) then
				toggleControl("aim_weapon", true)
				toggleControl("fire", true)
				return
			end
			toggleControl("aim_weapon", false)
			toggleControl("fire", false)
		else
			--outputDebugString("false")
			toggleControl("aim_weapon", true)
			toggleControl("fire", true)
		end
	end
end
addEventHandler("onClientKey", root, aimCheck)

--addEventHandler("onClientRender", root,
Timer(
	function ()
		if (getControlState("fire") and not getControlState("aim_weapon") and (not exceptedSlots[localPlayer.weaponSlot] and not exceptedWeapons[localPlayer:getWeapon()])) then
			toggleControl("fire", false)
		end
	end, 100, 0
)
