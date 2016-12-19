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
				exports.UCDaccounts:SAD(plr, "wp", getWantedPoints(plr))
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
		exports.UCDstats:setPlayerAccountStat(plr, "lifetimeWanted", exports.UCDstats:getPlayerAccountStat(plr, "lifetimeWanted") + wp)
		if (math.floor(wp / 2) > 0) then
			exports.UCDaccounts:SAD(plr, "crimXP", exports.UCDaccounts:GAD(plr, "crimXP") + math.floor(wp / 2))
		end
		return true
	end
end

function getWantedPoints(plr)
	if (plr and not plr.account.guest) then
		local a = plr.account.name
		if (not wantedPoints[a]) then
			wantedPoints[a] = exports.UCDaccounts:GAD(plr, "wp") or 0
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
		-- For MDTs
		if (Team.getFromName("Law") and Team.getFromName("Law").players and #Team.getFromName("Law").players >= 1) then
			triggerClientEvent(Team.getFromName("Law").players or {}, "UCDmdt.onPlayerWPChange", plr)
		end
		return true
	end
end

function onPlayerWPChange(wp)
	-- Stars
	if (wp > 0 and wp <= 10) then
		source.wantedLevel = 1
	elseif (wp > 10 and wp < 20) then
		source.wantedLevel = 2
	elseif (wp >= 20 and wp < 30) then
		source.wantedLevel = 3
	elseif (wp >= 30 and wp < 40) then
		source.wantedLevel = 4
	elseif (wp >= 40 and wp < 50) then
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
	if (wp > 0) then
		exports.UCDdx:add(source, "wp", "Wanted Points: "..wp, 255, 0, 0)
	else
		exports.UCDdx:del(source, "wp")
	end
	triggerClientEvent("UCDmdt.onPlayerWPChange", resourceRoot)
end
addEvent("onPlayerWPChange")
addEventHandler("onPlayerWPChange", root, onPlayerWPChange)

addEventHandler("onPlayerChangeNick", root,
	function ()
		if (getWantedPoints(source) and getWantedPoints(source) > 0) then
			source.nametagText = "["..tostring(source.wantedLevel).."] "..tostring(source.name)
		end
	end
)

Timer(
	function ()
		for _, plr in ipairs(Element.getAllByType("player")) do
			if (getWantedPoints(plr) and not exports.UCDlaw:isPlayerArrested(plr)) then
				if (getWantedPoints(plr) > 0) then
					setWantedPoints(plr, getWantedPoints(plr) - 1)
				end
			end
		end
	end, 60 * 1000, 0
)
