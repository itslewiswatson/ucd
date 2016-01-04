local jobs

addEventHandler("onResourceStart", resourceRoot,
	function ()
		jobs = exports.UCDjobsTable:getJobTable()
	end
)

function takeJob(jobName, skinID)
	if (source and jobName and skinID) then
		local job = setPlayerJob(source, jobName, skinID)
		if (job) then
			exports.UCDdx:new(source, "You have been employed as a "..jobName, 0, 255, 0)
		else
			exports.UCDdx:new(source, "Error! Could not employ you as a "..jobName, 0, 255, 0)
		end
	end
end
addEvent("UCDjobs.takeJob", true)
addEventHandler("UCDjobs.takeJob", root, takeJob)

function setPlayerJob(plr, jobName, skinID)
	if (not plr or not jobName or not skinID) then return end
	if (not isElement(plr) or plr.type ~= "player" or type(jobName) ~= "string" or tonumber(skinID) == nil or not jobs[jobName]) then return false end
	
	-- Model
	plr:setModel(skinID)
	exports.UCDaccounts:SAD(plr, "jobModel", skinID)
	
	-- Team
	local team = jobs[jobName].team
	exports.UCDteams:setPlayerTeam(plr, team)
	
	-- Element data
	plr:setData("Occupation", jobName)
	
	return true
end
