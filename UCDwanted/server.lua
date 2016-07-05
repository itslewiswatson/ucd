local wantedPoints = {}

addEventHandler("onResourceStart", resourceRoot,
	function ()
		for _, plr in ipairs(Element.getAllByType("player")) do
			if (not plr.account.guest) then
				setWantedPoints(plr, exports.UCDaccounts:GAD(plr, "wp"))
			end
		end
	end
)

addEventHandler("onResourceStop", resourceRoot,
	function ()
		for _, plr in ipairs(Element.getAllByType("player")) do
			if (not plr.account.guest) then
				exports.UCDaccounts:GAD(plr, "wp", getWantedPoints(plr))
			end
		end
	end
)

function addWantedPoints(plr, wp)
	if (plr and wp and not plr.account.guest and tonumber(wp)) then
		wp = tonumber(wp)
		local a = plr.account.name
		if (not wantedPoints[a]) then
			wantedPoints[a] = 0
		end
		setWantedPoints(plr, wantedPoints[a] + wp)
		return true
	end
end

function getWantedPoints(plr)
	if (plr and not plr.account.guest) then
		local a = plr.account.name
		if (not wantedPoints[a]) then
			wantedPoints[a] = 0
		end
		return wantedPoints[a]
	end
end

function setWantedPoints(plr, wp)
	if (plr and wp and not plr.account.guest and tonumber(wp)) then
		wp = tonumber(wp)
		local a = plr.account.name
		if (not wantedPoints[a]) then
			wantedPoints[a] = wp
			return true
		end
		wantedPoints[a] = wp
		plr:setData("w", wantedPoints[a])
		triggerEvent("onPlayerWPChange", plr, wantedPoints[a])
		return true
	end
end

function onPlayerWPChange(wp)
	-- Stars
	if (wp > 0 and wp <= 10) then
		source.wantedLevel = 1
	elseif (wp > 10 and wp <= 20) then
		source.wantedLevel = 2
	elseif (wp > 20 and wp <= 30) then
		source.wantedLevel = 3
	elseif (wp > 30 and wp <= 40) then
		source.wantedLevel = 4
	elseif (wp > 40 and wp <= 50) then
		source.wantedLevel = 5
	elseif (wp > 50) then
		--if (source.wantedLevel ~= 60) then
			source.wantedLevel = 6
		--end
	else
		source.wantedLevel = 0
	end
	
	-- Nametag
	if (wp > 0) then
		source.nametagText = "["..tostring(source.wantedLevel).."] "..tostring(source.name)
	else
		source.nametagText = source.name
	end
	
	if (wp > 0) then
		if (source.team.name == "Law") then
			exports.UCDjobs:setPlayerJob(source, "Criminal")
		end
	end
end
addEvent("onPlayerWPChange")
addEventHandler("onPlayerWPChange", root, onPlayerWPChange)
