local jobs
local vowels = {["a"] = true, ["e"] = true, ["i"] = true, ["o"] = true, ["u"] = true}

addEventHandler("onResourceStart", resourceRoot,
	function ()
		jobs = exports.UCDjobsTable:getJobTable()
	end
)

function takeJob(jobName, skinID)
	if (source and jobName and skinID) then
		local job = setPlayerJob(source, jobName, skinID)
		local aan
		if (vowels[jobName:sub(1, 1):lower()]) then
			aan = "an"
		else
			aan = "a"
		end
		if (job) then
			exports.UCDdx:new(source, "You have been employed as "..aan.." "..jobName, 0, 255, 0)
		else
			exports.UCDdx:new(source, "Error! Could not employ you as "..aan.." "..jobName, 0, 255, 0)
		end
	end
end
addEvent("UCDjobs.takeJob", true)
addEventHandler("UCDjobs.takeJob", root, takeJob)

function setPlayerJob(plr, jobName, skinID)
	if (not plr or not jobName or not skinID) then return end
	if (not isElement(plr) or plr.type ~= "player" or type(jobName) ~= "string" or tonumber(skinID) == nil or (not jobs[jobName] and jobName ~= "Admin")) then return false end
		
	if (jobName == "Admin") then
		exports.UCDteams:setPlayerTeam(plr, "Admins")
		plr:setModel(skinID)
		exports.UCDaccounts:SAD(plr, "jobModel", skinID)
		triggerEvent("onPlayerGetJob", plr, jobName)
		triggerClientEvent(plr, "onClientPlayerGetJob", plr, jobName)
	else
		-- Model
		plr:setModel(skinID)
		exports.UCDaccounts:SAD(plr, "jobModel", skinID)
		
		-- Team
		local team = jobs[jobName].team
		exports.UCDteams:setPlayerTeam(plr, team)
		
		-- Element data
		plr:setData("Occupation", jobName)
		
		-- Server event
		triggerEvent("onPlayerGetJob", plr, jobName)
		-- Client event
		triggerClientEvent(plr, "onClientPlayerGetJob", plr, jobName)
	end
	
	return true
end
