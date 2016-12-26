mutes = {} -- mutes[string accName] = {[1] = int duration, [3] = int timeLeft}
local db = exports.UCDsql:getConnection()
TL = {}

addEventHandler("onResourceStart", resourceRoot,
	function ()
		db:query(cacheMutes, {}, "SELECT * FROM `mutes`")
	end
)

function cacheMutes(qh)
	local result = qh:poll(-1)
	for i, data in ipairs(result) do
		mutes[data.account] = {data.duration, data.timeLeft}
		if (Account(data.account) and Account(data.account).player and mutes[data.account]) then
			local plr = Account(data.account).player
			triggerEvent("UCDadmin.onPlayerMute", plr)
		end
	end
	print("Mutes successfully cached!")
end

addEventHandler("onPlayerLogin", root,
	function ()
		if (mutes[source.account.name]) then
			triggerEvent("UCDadmin.onPlayerMute", source)
		end
	end
)

function saveTime(plr)
	if (mutes[plr.account.name] and plr.muted) then
		local elapsed = TL[plr.account.name]
		if (not elapsed) then
			return
		end
		if ((mutes[plr.account.name][2] - (getRealTime().timestamp - elapsed)) <= 0) then
			triggerEvent("UCDadmin.onPlayerUnmuted", plr)
			return
		end
		mutes[plr.account.name][2] = mutes[plr.account.name][2] - (getRealTime().timestamp - elapsed)
		db:exec("UPDATE `mutes` SET `timeLeft` = ? WHERE `account` = ?", mutes[plr.account.name][2], plr.account.name)
	end
end
addEventHandler("onPlayerQuit", root,
	function ()
		saveTime(source)
	end
)
addEventHandler("onResourceStop", resourceRoot,
	function ()
		for _, plr in ipairs(Element.getAllByType("player")) do
			if (exports.UCDaccounts:isPlayerLoggedIn(plr) and plr.muted) then
				saveTime(plr)
			end
		end
	end
)

function mutePlayer(plr, duration)
	if (not plr or not isElement(plr) or plr.type ~= "player" or plr.account.guest or not duration or not tonumber(duration)) then
		return false
	end
	local timeLeft
	if (plr.muted or mutes[plr.account.name]) then
		timeLeft = duration + mutes[plr.account.name][2]
		duration = duration + mutes[plr.account.name][1]
		mutes[plr.account.name] = {duration, timeLeft}
		db:exec("UPDATE `mutes` SET `duration` = ?, `timeLeft` = ? WHERE `account` = ?", duration, timeLeft, plr.account.name)
	else
		timeLeft = duration
		mutes[plr.account.name] = {duration, timeLeft}
		db:exec("INSERT INTO `mutes` (`account`, `duration`, `timeLeft`) VALUES (?, ?, ?)", plr.account.name, duration, timeLeft)
	end
	triggerEvent("UCDadmin.onPlayerMute", plr)
end

function onPlayerUnmuted()
	if (client) then source = client end
	if (source) then
		if (mutes[source.account.name]) then
			mutes[source.account.name] = nil
			db:exec("DELETE FROM `mutes` WHERE `account` = ?", source.account.name)
			source.muted = false
			TL[source.account.name] = nil
			triggerLatentClientEvent(source, "onClientPlayerUnmuted", source)
		end
	end
end
addEvent("UCDadmin.onPlayerUnmuted", true)
addEventHandler("UCDadmin.onPlayerUnmuted", root, onPlayerUnmuted)

function onPlayerMute()
	source.muted = true
	TL[source.account.name] = getRealTime().timestamp
	triggerClientEvent(source, "onClientPlayerMuted", source, mutes[source.account.name][2])
end
addEvent("UCDadmin.onPlayerMute")
addEventHandler("UCDadmin.onPlayerMute", root, onPlayerMute)
