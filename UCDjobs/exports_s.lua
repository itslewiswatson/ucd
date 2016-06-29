jobs = exports.UCDjobsTable:getJobTable()

function onPlayerGetJob(jobName)
	
end
addEvent("onPlayerGetJob", true)
addEventHandler("onPlayerGetJob", root, onPlayerGetJob)

function getPlayerJobData(plr, jobName)
	if (not plr or not isElement(plr) or plr.type ~= "player" or not exports.UCDaccounts:isPlayerLoggedIn(plr) or not jobName or not jobs[jobName]) then
		return false
	end
	return exports.UCDaccounts:GAD(plr, jobName:lower())
end

function getPlayerJobRank(plr, jobName)
	local stat = getPlayerJobData(plr, jobName)
	if (not stat) then
		return false
	end
	local ranks = exports.UCDjobsTable:getJobRanks(jobName)
	for i = 0, #ranks do
		if (ranks[i + 1]) then
			if (ranks[i].req <= stat and ranks[i + 1].req > stat) then
				return i
			end
		else
			return 10
		end
	end
end
