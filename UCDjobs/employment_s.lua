local vowels = {a = true, e = true, i = true, o = true, u = true}
local disallowedOffShift = {["Criminal"] = true, ["Gangster"] = true, ["Unoccupied"] = true} -- Add more at will
local offShift = {}

function onPlayerToggleShift()
	if (source and source.type == "player" and exports.UCDaccounts:isPlayerLoggedIn(source)) then
		if (not exports.UCDchecking:canPlayerDoAction(source, "EndShift")) then
			return false
		end
		
		local account = source.account.name
		if (offShift[account]) then
			-- They are off shift already
			local data = offShift[account]
			setPlayerJob(source, data, exports.UCDaccounts:GAD(account, "jobModel"))
			data = nil
			offShift[account] = nil
		else
			-- Need to check if they're allowed to go off-shift
			local jobCurr = getPlayerJob(source)
			if (disallowedOffShift[jobCurr]) then
				exports.UCDdx:new(source, "You are not allowed to end your shift in this job/occupation", 255, 0, 0)
				return false
			end
			offShift[account] = jobCurr
			local k = setPlayerJob(source, "Unoccupied")
		end
	end
end
addEvent("UCDjobs.onPlayerToggleShift", true)
addEventHandler("UCDjobs.onPlayerToggleShift", root, onPlayerToggleShift)

function onAttemptQuitJob()
	if (source and source.type == "player" and exports.UCDaccounts:isPlayerLoggedIn(source)) then
		if (not exports.UCDchecking:canPlayerDoAction(source, "QuitJob")) then
			return false
		end
		local jobCurr = getPlayerJob(source)
		if (not jobCurr or jobCurr == "") then
			jobCurr = "Unemployed"
		end
		
		local article = "a"
		if (vowels[jobCurr:lower():sub(1, 1)]) then
			article = "an"
		end
		
		local jobSet = setPlayerJob(source, "") -- Set them to no job
		if (not jobSet) then
			exports.UCDdx:new(source, "Could not quit job", 255, 0, 0)
			return false
		end
		exports.UCDdx:new(source, "You have quit your job as "..tostring(article).." "..tostring(jobCurr), 255, 0, 0)
	end
	triggerLatentClientEvent(source, "UCDjobs.forceClose", source)
end
addEvent("UCDjobs.onAttemptQuitJob", true)
addEventHandler("UCDjobs.onAttemptQuitJob", root, onAttemptQuitJob)