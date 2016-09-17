local injured_citizens =
{
	{x = 1646.5645, y = -1342.9098, z = 16.9576, rot = 181.5492},
	{x = 841.5184, y = -1483.2914, z = 13.1157, rot = 87.6082},
	{x = 377.9776, y = -1856.9041, z = 7.3543, rot = 178.5596},
	{x = 2524.3611, y = -1054.4268, z = 69.0887, rot = 270.239},
	{x = 2359.6008, y = -1368.7007, z = 23.5403, rot = 178.6282},
	{x = 2476.5574, y = -1548.0465, z = 23.5249, rot = 269.3983},
	{x = 2506.7754, y = -1672.0249, z = 12.892, rot = 349.5156},
	{x = 2440.7817, y = -2108.4856, z = 13.0668, rot = 179.4855},
	{x = 2768.5603, y = -2447.4915, z = 13.1615, rot = 359.9478},
	{x = 1948.3262, y = -2114.4548, z = 13.0632, rot = 91.2662},
	{x = 1840.1942, y = -1865.4153, z = 12.9054, rot = 269.2592},
	{x = 2041.3912, y = -1649.8143, z = 13.0652, rot = 0.0166},
	{x = 2124.7251, y = -1294.2175, z = 23.5002, rot = 90.3202},
	{x = 1281.3657, y = -1648.5583, z = 13.0652, rot = 91.3512},
	{x = 911.9732, y = -1229.5687, z = 16.4949, rot = 90.8881},
	{x = 960.9066, y = -936.301, z = 40.9711, rot = 0.9721},
	{x = 405.9735, y = -1320.5337, z = 14.3993, rot = 23.7934},
	{x = 285.9122, y = -1588.2141, z = 32.3233, rot = 77.8498},
	{x = 166.3, y = -1775.2813, z = 3.7338, rot = 271.6941},
	{x = 695.8552, y = -1802.827, z = 11.9852, rot = 75.8881},
	{x = 1082.0039, y = -1703.9376, z = 13.0652, rot = 270.2952},
	{x = 1097.5891, y = -1082.9624, z = 26.1201, rot = 270.1609},
	{x = 1319.4429, y = -875.106, z = 39.0965, rot = 92.9828},
	{x = 1434.9229, y = -1169.4307, z = 23.3428, rot = 91.3414},
	{x = 1248.1333, y = -2043.6702, z = 59.2826, rot = 89.7809},
	{x = 726.0222, y = -1435.6145, z = 13.0566, rot = 267.5191},
	{x = 483.7343, y = -1499.2687, z = 19.8214, rot = 176.9751},
	{x = 1270.8628, y = -1338.5194, z = 13.3394, rot = 90},
	{x = 2392.571, y = -1309.2666, z = 25.4865, rot = 89.007},
    {x = 2412.4155, y = -1480.1326, z = 23.8281, rot = 270.1305},
    {x = 2462.8489, y = -1550.9515, z = 24.0012, rot = 92.3414},
    {x = 2377.8025, y = -1891.3549, z = 13.3828, rot = 263.6164},
    {x = 2182.0562, y = -1990.246, z = 13.5469, rot = 299.0729},
    {x = 2320.8157, y = -2078.4968, z = 13.5469, rot = 18.5039},
    {x = 2198.1992, y = -2509.4023, z = 13.5469, rot = 359.5046},
    {x = 2014.9517, y = -1239.5404, z = 22.6388, rot = 199.7199},
    {x = 1883.8489, y = -1404.5814, z = 13.5703, rot = 43.0895},
}
local citizen = nil    		-- Injured citizen
local blip = nil   			-- Attached blip (+)
local marker = nil 			-- Attached marker
local go_back_marker = nil  -- Go back marker
local id = nil     			-- Current id from injured_citizens
local model = nil  			-- Current citizen model(used to resume missions)
local vehicle = nil         -- onClientMarkerHit
local spam = {}    			-- Heal anti spam
local abusers = {}          -- Healing abuse
local timers = {}           -- Remove abusers timer

function removeAntiAbuse(plr)
	if (isTimer(timers[plr])) then
		timers[plr]:destroy()
	end
	timers[plr] = Timer(function(plr) abusers[plr] = nil end, 5000, 1, plr)
end

function isPlayerParamedic(plr)
	if (isElement(plr) and plr.type == "player" and isElement(plr.team) and plr.team.name == "Citizens" and plr:getData("Occupation") == "Paramedic") then
		return true
	end
	return false
end

addEventHandler("onClientPlayerDamage", root,
	function(attacker, weapon, _, loss)
		if (isElement(attacker) and attacker.type == "player") then
			if (isPlayerParamedic(attacker) and weapon == 41) then
				cancelEvent() -- Cancel damage given
				if (spam[source] and getTickCount() - spam[source] <= 1000 or source.health >= 199) then -- To avoid spam money/hp
					return
				end								-- To avoid spam money/hp
				if (source.health >= 197) then
					return
				end
				spam[source] = getTickCount()	
				source.health = source.health + loss + 4						-- Give him the loss and more 4 points as a heal
				if (abusers[source] ~= attacker) then
					triggerServerEvent("givePlayerMoney", resourceRoot, attacker, source)	-- Give paramedic money
				end
			elseif (isPlayerParamedic(attacker)) then
				abusers[source] = attacker
				removeAntiAbuse(source)
			end
		end
	end
)

addEventHandler("onClientPedDamage", root,
	function()
		if (source == citizen) then
			cancelEvent()
		end
	end
)

addEventHandler("onClientMarkerHit", root,
	function(hitElement, matchingDimension)
		if (hitElement.type ~= "player" or not matchingDimension) then 
			return
		end
		if (hitElement.vehicle ~= vehicle) then
			return
		end
		if (source == marker or source == go_back_marker) then
			Camera.fade(false)
			toggleAllControls(false)
			vehicle:setFrozen(true)
			Timer(Camera.fade, 2500, 1, true)
			Timer(toggleAllControls, 2500, 1, true)
			Timer(vehicle.setFrozen, 2500, 1, vehicle, false)
		else
			return
		end
		if (source == marker) then -- Arrived at the injured citizen
			citizen:destroy()
			blip:destroy()
			marker:destroy()
			Timer(
				function()
					local chance = math.random(1, 2) -- Start new mission instantly or go back hospital?
					local info
					if (chance == 1) then            -- Start new mission instantly, they were injured badly
						id = math.random(#injured_citizens)
						local data = injured_citizens[id]
						model = getValidPedModels()[math.random(#getValidPedModels())] -- To avoid citizen being nil(not valid citizen model)
						citizen = Ped(model, data.x, data.y, data.z, data.rot)
						citizen:setFrozen(true)
						blip = Blip.createAttachedTo(citizen, 22)
						marker = Marker(data.x, data.y, data.z - 1, "cylinder", 5, 255, 255, 0)
						marker:attach(citizen, 0, 5, -1) -- Attach it in front of him
						info = "Go to the injured citizen"
						local money = math.random(2000, 3500)
						Player.giveMoney(money)
						exports.UCDdx:new("You have been rewarded $"..exports.UCDutil:tocomma(money).." for healing the injured citizen", 0, 255, 0)
					elseif (chance == 2) then        -- Go back hospital
						go_back_marker = Marker(1188.588, -1325.6146, 13.5673-1,  "cylinder", 5, 255, 255, 0)
						blip = Blip.createAttachedTo(go_back_marker, 22)
						info = "Take the injured citizen to the hospital"
					end
					triggerServerEvent("setParamedicMissionInfo", resourceRoot, info)
				end, 2500, 1
			)
		elseif (source == go_back_marker) then -- Arrived at the hospital with the injured citizen, new mission
			source:destroy()
			blip:destroy()
			id = math.random(#injured_citizens)
			local data = injured_citizens[id]
			model = getValidPedModels()[math.random(#getValidPedModels())] -- To avoid citizen being nil(not valid citizen model)
			citizen = Ped(model, data.x, data.y, data.z, data.rot)
			citizen:setFrozen(true)
			blip = Blip.createAttachedTo(citizen, 22)
			marker = Marker(data.x, data.y, data.z - 1, "cylinder", 5, 255, 255, 0)
			marker:attach(citizen, 0, 5, -1) -- Attach it in front of him
			local money = math.random(3500, 5000)
			Player.giveMoney(money)
			exports.UCDdx:new("You have been rewarded $"..exports.UCDutil:tocomma(money).." for taking the injured citizen to the hospital", 0, 255, 0)
			triggerServerEvent("setParamedicMissionInfo", resourceRoot, "Go to the injured citizen")
		end
	end
)

addEvent("startParamedicMission", true)
addEventHandler("startParamedicMission", resourceRoot,
	function()
		id = math.random(#injured_citizens)
		local data = injured_citizens[id]
		model = getValidPedModels()[math.random(#getValidPedModels())] -- To avoid citizen being nil(not valid citizen model)
		citizen = Ped(model, data.x, data.y, data.z, data.rot)
		citizen:setFrozen(true)
		blip = Blip.createAttachedTo(citizen, 22)
		marker = Marker(data.x, data.y, data.z - 1, "cylinder", 5, 255, 255, 0)
		marker:attach(citizen, 0, 5, -1) -- Attach it in front of him
		vehicle = localPlayer.vehicle
	end
)

addEvent("cancelParamedicMission", true)
addEventHandler("cancelParamedicMission", resourceRoot,
	function() -- Destroy everything, remove variables
		if (isElement(citizen)) then
			citizen:destroy()
		end
		if (isElement(blip)) then
			blip:destroy()
		end
		if (isElement(marker)) then
			marker:destroy()
		end
		destroyGoBackMarkers()
		id, model = nil
	end
)

addEvent("pauseParamedicMission", true)
addEventHandler("pauseParamedicMission", resourceRoot,
	function() -- Destroy everything, keep variables(model, id)
		if (isElement(citizen)) then
			citizen:destroy()
			blip:destroy()
			marker:destroy()
		else
			id, model = nil
		end
	end
)

addEvent("resumeParamedicMission", true)
addEventHandler("resumeParamedicMission", resourceRoot,
	function(new) -- Resume mission, they entered the ambulance again(using model + id) If no id/model stop.
		if (not id or not model) then return end
		local data = injured_citizens[id]
		citizen = Ped(model, data.x, data.y, data.z, data.rot)
		citizen:setFrozen(true)
		blip = Blip.createAttachedTo(citizen, 22)
		marker = Marker(data.x, data.y, data.z - 1, "cylinder", 5, 255, 255, 0)
		marker:attach(citizen, 0, 5, -1) -- Attach it in front of him
		triggerServerEvent("setParamedicMissionInfo", resourceRoot, "Go to the injured ped")
	end
)