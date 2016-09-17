local missions = {} -- Paramedic player to vehicle
local timers = {}   -- This one to cancel the mission
local timers2 = {}  -- This one to keep the DX message up to date (1st timer-render)

-- Handle giving spraycan
function onPlayerGetJob(jobName)
	if (source.team.name == "Citizens") then
		if (jobName == "Paramedic") then
			if (source:getWeapon(9) ~= 41) then
				source:giveWeapon(41, 9000)
			end
		else
			source:takeWeapon(41)
		end
	else
		source:takeWeapon(41)
	end
end
addEvent("onPlayerGetJob")
addEventHandler("onPlayerGetJob", root, onPlayerGetJob)

function isPlayerParamedic(plr)
	if (isElement(plr) and plr.type == "player" and isElement(plr.team) and plr.team.name == "Citizens" and plr:getData("Occupation") == "Paramedic") then
		return true
	end
	return false
end

addEvent("givePlayerMoney", true)
addEventHandler("givePlayerMoney", resourceRoot,
	function (paramedic, healed)
		paramedic.money = paramedic.money + 5
		healed.money = healed.money - 10
	end
)

function isPlayerDoingMission(plr)
	return isElement(missions[plr]) and true or false
end

function startPlayerMission(plr)
	unbindKey(plr, "k", "down", startPlayerMission)
	if (not isPlayerDoingMission(plr)) then -- If the player started it for the first ime
		missions[plr] = plr.vehicle
		exports.UCDdx:add(plr, "paramedic_mission_info", "Go to the injured citizen", 255, 255, 0)
		triggerClientEvent(plr, "startParamedicMission", resourceRoot)
		return
	end
	-- Player is resuming
	if (isTimer(timers[plr])) then
		timers[plr]:destroy()
	end
	if (isTimer(timers2[plr])) then
		timers2[plr]:destroy()
	end
	triggerClientEvent(plr, "resumeParamedicMission", resourceRoot)
end

function cancelPlayerMission(plr)
	if (isPlayerDoingMission(plr)) then
		missions[plr] = nil
		timers[plr] = nil
		timers2[plr] = nil
		exports.UCDdx:del(plr, "paramedic_mission_info")
		exports.UCDdx:new(plr, "Paramedic job cancelled", 255, 0, 0)
		triggerClientEvent(plr, "cancelParamedicMission", resourceRoot)
	end
end

function onVehicleDelete()
	if (math.floor(source.health / 10) <= 25) then -- If vehicle is destroyed(25% hp) then cancel the mission
		for plr, missionVehicle in pairs(missions) do
			if (source == missionVehicle) then
				cancelPlayerMission(plr)
			end
		end
	end
end
addEventHandler("onVehicleDamage", root, onVehicleDelete)

function onVehicleEnterExit(plr, seat)
	if (isPlayerParamedic(plr) and source:getModel() == 416 and source:getHealth() > 250 and seat == 0) then
		if (eventName == "onVehicleEnter") then
			if (isPlayerDoingMission(plr)) then -- If the player is on mission, resume. Look startPlayerMission up
				if (source == missions[plr]) then
					startPlayerMission(plr)
				end
				return
			end
			-- Entered for first time, new mission. Look startPlayerMission up
			Timer(
				function(source, plr)
					if (Player(source:getData("owner")) ~= plr) then
						exports.UCDdx:new(plr, "Spawn your own ambulance to have access to paramedic mission", 255, 255, 0)
						return
					end
					bindKey(plr, "k", "down", startPlayerMission)
					exports.UCDdx:add(plr, "paramedic_mission_info", "Press K: Start Paramedic Mission", 255, 255, 0)
					return
				end, 500, 1, source, plr
			)
		end
		unbindKey(plr, "k", "down", startPlayerMission) -- Player wasn't in mission, remove the dx message and the bind
		if (isPlayerDoingMission(plr)) then -- Left while in mission, give 30 seconds to cancel it
			exports.UCDdx:add(plr, "paramedic_mission_info", "Enter the ambulance again within 30 seconds or the mission will be cancelled!", 255, 255, 0)
			if (isTimer(timers2[plr])) then -- Destroy old new timers
				timers2[plr]:destroy()
			end
			if (isTimer(timers[plr])) then
				timers[plr]:destroy()
			end
			timers[plr] = Timer(cancelPlayerMission, 30000, 1, plr) -- Set new timers
			timers2[plr] = Timer(
				function(plr)
					if (isTimer(timers[plr])) then
						local secondsLeft = math.floor(timers[plr]:getDetails() / 1000)
						exports.UCDdx:add(plr, "paramedic_mission_info", "Enter the ambulance again within "..secondsLeft.." seconds or the mission will be cancelled!", 255, 255, 0)
					end
				end, 1000, 29, plr
			)
			triggerClientEvent(plr, "pauseParamedicMission", resourceRoot)
			return
		end
		exports.UCDdx:del(plr, "paramedic_mission_info")
	end
end
addEventHandler("onVehicleEnter", root, onVehicleEnterExit)
addEventHandler("onVehicleExit", root, onVehicleEnterExit)

addEvent("setParamedicMissionInfo", true)
addEventHandler("setParamedicMissionInfo", resourceRoot,
	function(info)
		exports.UCDdx:add(client, "paramedic_mission_info", info, 255, 255, 0)
	end
)

addEventHandler("onPlayerTeamChange", root,
	function(oldTeam, newTeam)
		if (not oldTeam or not newTeam and oldTeam.name ~= "Citizens" and newTeam.name == "Citizens") then
			return
		end
		if (isPlayerDoingMission(source)) then
			cancelPlayerMission(source)
		end
	end
)