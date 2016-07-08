local jobs = exports.UCDjobsTable:getJobTable()

function requestData()
	if (client) then
		local jobName = client:getData("Occupation")
		if (not jobName) then return end
		if (not jobs[jobName].f5) then return end
		
		local ranks = exports.UCDjobsTable:getJobRanks(jobName)
		local playerRank = exports.UCDjobs:getPlayerJobRank(client, jobName) or 0
		local nextRank = playerRank + 1
		local jobData = exports.UCDjobs:getPlayerJobData(client, jobName) or 0
		if (nextRank and nextRank > 10) then nextRank = 10 end
		
		local data = {jobName = jobName, currRank = playerRank, nextRank = nextRank, progress = jobData, desc = jobs[jobName].desc}
		triggerClientEvent(client, "UCDjobs.F5.togglePanel", client, data)
	end
end
addEvent("UCDjobs.F5.requestData", true)
addEventHandler("UCDjobs.F5.requestData", root, requestData)