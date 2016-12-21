local types = {["mute"] = "muted", ["admin jail"] = "jailed"}
local infr = 300 -- Infraction base number, no of infractions * base = time (0 = base)
punishments = {}

addEventHandler("onResourceStart", resourceRoot,
	function ()
		db:query(cachePunishments, {}, "SELECT * FROM `punishments`")
	end
)

function cachePunishments(qh)
	local result = qh:poll(-1)
	for _, data in ipairs(result) do
		table.insert(punishments, {data.val, data.datum, data.duration, data.serial, data.who, data.reason, data.log, tonumber(data.active)})
	end
end

addEventHandler("onPlayerLogin", root,
	function ()
		for _, p in ipairs(punishments) do
			if (p[1] == source.account.name and p[6] == 1) then
				if (p[5]:find("has%soffline%smuted") or p[5]:find("has%smuted")) then
					-- Mute them
				elseif (p[5]:find("has%soffline%sjailed") or p[5]:find("has%sjailed")) then
					-- Jail them
				end
			end
		end
	end
)

function getTimeString(seconds)
	local timeString, minutes, hours
	if (seconds) then
		minutes = math.floor(seconds / 60)
		if (minutes > 60) then
			hours = math.floor(seconds / 3600)
			minutes = math.floor((seconds - (hours * 3600)) / 60)
			if (minutes ~= 0) then
				timeString = hours.." hours, "..minutes.." minutes"
			else
				timeString = hours.." hours"
			end
		else
			timeString = minutes.." minutes"
		end
	end
	return timeString
end

function punish(val, duration, type1, who, reason)
	-- type1: punishment type {admin jail, kick, reconnect, mute, ban}	
	if (who.type == "player" or who.type == "resource") then
		who = who.name
	elseif (not who) then
		who = "Console"
	end
	
	if (type1 == "unjail" or type1 == "unmute") then
		if (val and val.type == "player") then
			if (type1 == "unjail") then
				if (not exports.UCDjail:isPlayerJailed(val)) then
					exports.UCDdx:new(client, "This player is not jailed", 255, 0, 0)
					return
				end
				triggerEvent("UCDjail.releasePlayer", val)
				exports.UCDlogging:adminLog(client.account.name, tostring(client.name).." has unjailed "..tostring(val.name))
			else
				if (not val.muted) then
					exports.UCDdx:new(client, "This player is not muted", 255, 0, 0)
					return
				end
				triggerEvent("UCDadmin.onPlayerUnmuted", val)
				exports.UCDlogging:adminLog(client.account.name, tostring(client.name).." has unmuted "..tostring(val.name))
			end
		else
			if (val:sub(1, 4) ~= "acc:") then
				exports.UCDdx:new(client, "Invalid syntax", 255, 0, 0)
				return
			end
			if (type1 == "unjail") then
				-- There really isn't a way around this
				db:exec("DELETE FROM `jails` WHERE `account` = ?", val:sub(5))
				db:query(exports.UCDjail:cacheJails(), {}, "SELECT * FROM `jails`")
				exports.UCDlogging:adminLog(client.account.name, tostring(client.name).." has unjailed "..tostring(val))
			else
				-- Unmute offline
				db:exec("DELETE FROM `mutes` WHERE `account` = ?", val:sub(5))
				mutes[val:sub(5)] = nil
				TL[val:sub(5)] = nil
				exports.UCDlogging:adminLog(client.account.name, tostring(client.name).." has unmuted "..tostring(val))
			end
		end
		return
	end
	
	-- Redirect bans elsewhere
	if (type1 == "ban") then
		if (not canAdminDoAction(client, "ban")) then
			exports.UCDdx:new(client, "Only L3+ admins may issue bans", 255, 0, 0)
			return
		end
		
		if (val.type == "player") then
			local n = val.name
			local dur
			if (duration == -1) then
				dur = "permanently"
			else
				dur = duration
			end
			if (exports.UCDaccounts:isPlayerLoggedIn(val)) then
				local msg = 
				addBan("acc:"..val.account.name, who, reason[1], duration)
				local msg = tostring(client.name).." has banned "..tostring(n).." for "..tostring(getTimeString(duration)).." ("..tostring(reason[1])..")"
				if (type(dur) == "string") then
					msg = tostring(client.name).." has permanently banned "..tostring(n).." ("..tostring(reason[1])..")"
				end
				exports.UCDlogging:adminLog(who, msg)
			end
			local b = addBan(val.serial, who, reason[1], duration)
			local msg = tostring(client.name).." has banned "..tostring(val.name).." for "..tostring(getTimeString(duration)).." ("..tostring(reason[1])..")"
			if (type(dur) == "string") then
				msg = tostring(client.name).." has permanently banned "..tostring(val.name).." ("..tostring(reason[1])..")"
			end
			if (b) then
				outputChatBox(msg, root, 255, 140, 0)
				exports.UCDlogging:adminLog(who, msg)
			end
			return
		end
		
		if (val:len() ~= 32 and val:sub(1, 4) ~= "acc:") then
			exports.UCDdx:new(client, "Invalid syntax", 255, 0, 0)
			return
		end
		
		addBan(val, who, reason[1], duration)
		local msg = tostring(client.name).." has banned "..tostring(val).." for "..tostring(getTimeString(duration)).." ("..tostring(reason[1])..")"
		if (type(dur) == "string") then
			msg = tostring(client.name).." has permanently banned "..tostring(val).." ("..tostring(reason[1])..")"
		end
		outputChatBox(msg, root, 255, 140, 0)
		exports.UCDlogging:adminLog(who, msg)
		return
	end
	
	if (type(val) == "string") then
		if (val:len() == 32) then
			exports.UCDdx:new(client, "You cannot punish serials", 255, 0, 0)
			return
		end
		if (val:sub(1, 4) == "acc:") then
			val = val:sub(5)
		end
	end
	
	--local plr
	if (isElement(val) and val.type == "player") then
		-- Players who aren't logged in etc
		if (not exports.UCDaccounts:isPlayerLoggedIn(val)) then
			if (type1 == "admin jail" or type1 == "mute") then
				return false
			end
		end
		local _, x, p1 = punish2(val.account.name, duration, type1, who, reason)
		--if (p1) then
			outputChatBox(tostring(x), root, 255, 140, 0)
		--end
		return
	end
	
	local _, m, p = punish2(val, duration, type1, who, reason)
	--if (p) then
		outputChatBox(tostring(m), root, 255, 140, 0)
	--end
end
addEvent("UCDadmin.punish", true)
addEventHandler("UCDadmin.punish", root, punish)

function punish2(val, duration, type1, who, reason)
	local infractions
	--if (reason:sub(1, 1) == "#" and reason:sub(3, 4) == ": ") then
	
	if (not reason[2]) then -- Not a custom reason
		if (not duration) then
			infractions = 1
			for i = 1, #punishments do
			--[[
				if (punishments[i][1]:sub(5) == val:sub(5) or punishments[i][1]:len() == 32 and punishments[i][5] == reason and punishments[i][7] == 1) then
					if (punishments[i][1]:len() == 32 and val:sub(1, 4) == "acc:") then
						if (punishments[i][1] == val:sub(5)) then
							infractions = infractions + 1
						end
						if (punishments[i - 1]) then
							if (punishments[i - 1][2] == punishments[i][2]) then
								infractions = infractions + 1
							end
						end
					end
				end
			--]]
				if (punishments[i][1] == val and punishments[i][6] == reason[1] and punishments[i][8] == 1) then
					infractions = infractions + 1
				end
			end
			duration = infractions * 300
		end
	end
	
	local timeString = getTimeString(duration)
	local log_, pureLog
	local d, t = exports.UCDutil:getTimeStamp()
	local datetime = "["..d.."] ["..t.."] "
	local timestamp = getRealTime().timestamp
	local serial, plr
	
	if (Account(val) and Account(val).player) then
		plr = Account(val).player
		serial = plr.serial
	end
	
	-- Fuck this
	local output, offline
	if (plr) then
		output = plr.name
		if (type1 == "admin jail") then
			exports.UCDjail:jailPlayer(plr, duration, true)
		elseif (type1 == "mute") then
			mutePlayer(plr, duration)
		end
	else
		output = val
		offline = true
	end
	
	if (infractions ~= nil) then
		log_ = tostring(who).." has "..tostring((offline and "offline ") or "")..tostring(types[type1]).." "..tostring(output).." for "..tostring(infractions).." infraction"..tostring((infractions == 1 and "") or "s").." of "..tostring(reason[1])
	else
		log_ = tostring(who).." has "..tostring((offline and "offline ") or "")..tostring(types[type1]).." "..tostring(output).." ("..tostring(reason[1])..")"
	end
	
	if (plr) then
		if (infractions ~= nil) then
			exports.UCDlogging:adminLog(who, tostring(who).." has "..tostring((offline and "offline ") or "")..tostring(types[type1]).." "..tostring(plr.name).." for "..tostring(infractions).." infraction"..tostring((infractions == 1 and "") or "s").." of "..tostring(reason[1]))
		else
			exports.UCDlogging:adminLog(who, tostring(who).." has "..tostring((offline and "offline ") or "")..tostring(types[type1]).." "..tostring(plr.name).." ("..tostring(reason[1])..")")
		end
	else
		exports.UCDlogging:adminLog(who, log_)
	end
	
	if (timeString) then
		log_ = tostring(log_).." ("..tostring(timeString)..")"
	end
	
	pureLog = log_
	
	table.insert(punishments, {val, timestamp, duration, serial, who, reason[1], tostring(datetime..log_), 1})
	db:exec("INSERT INTO `punishments` (`val`, `datum`, `duration`, `who`, `reason`, `log`, `serial`) VALUES (?, ?, ?, ?, ?, ?, ?)", val, timestamp, duration, who, reason[1], tostring(datetime..log_), serial)
	return true, pureLog, plr
end

function getPunishmentLog(val, serial)
	if (val or serial) then
		local punishlog = {}
		for i, v in ipairs(punishments) do
			if (val and v[1] == val) then
				if (not punishlog.acc) then punishlog.acc = {} end
				table.insert(punishlog.acc, v)
			end
			if (serial and v[4] == serial) then
				if (not punishlog.serial) then punishlog.serial = {} end
				table.insert(punishlog.serial, v)
			end
		end
		if (not punishlog.acc and not punishlog.serial) then return end -- for empty punishlogs
		return punishlog
	end
	return punishments
end
