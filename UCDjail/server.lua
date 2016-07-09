local col = exports.UCDsafeZones:getJail()
local jails = {} -- jails[string accName] = {[1] = int duration, [2] = int isAdminJail, [3] = int timeLeft, [4] = string loc}
local jailSpawn = {x = 3806.1226, y = -1141.0939, z = 6.5394, r = 180}
local releaseLocations = {
	["LS"] = {x = 1422.4785, y = -1177.4348, z = 25.9922, r = 0},
	["SF"] = {x = -1501.6691, y = 920.1942, z = 7.1875, r = 90},
}
local db = exports.UCDsql:getConnection()
local TL = {}

addEventHandler("onResourceStart", resourceRoot,
	function ()
		db:query(cacheJails, {}, "SELECT * FROM `jails`")
	end
)

function cacheJails(qh)
	local result = qh:poll(-1)
	for i, data in ipairs(result) do
		jails[data.account] = {data.duration, tonumber(data.isAdminJail), data.timeLeft, data.loc}
		if (Account(data.account) and Account(data.account).player and jails[data.account]) then
			local plr = Account(data.account).player
			triggerEvent("onPlayerJailed", plr)
		end
	end
end

addEventHandler("onPlayerLogin", root,
	function ()
		if (jails[source.account.name]) then
			triggerEvent("onPlayerJailed", source)
		end
	end
)

function saveTime(plr)
	if (jails[plr.account.name]) then
		local elapsed = TL[plr.account.name]
		if (not elapsed) then
			return
		end
		if ((jails[plr.account.name][3] - (getRealTime().timestamp - elapsed)) <= 0) then
			triggerEvent("UCDjail.releasePlayer", plr)
			return
		end
		jails[plr.account.name][3] = jails[plr.account.name][3] - (getRealTime().timestamp - elapsed)
		db:exec("UPDATE `jails` SET `timeLeft` = ? WHERE `account` = ?", jails[plr.account.name][3], plr.account.name)
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
			if (exports.UCDaccounts:isPlayerLoggedIn(plr) and isPlayerJailed(plr)) then
				saveTime(plr)
			end
		end
	end
)

function isPlayerJailed(plr)
	if (jails[plr.account.name]) then
		return true
	end
	return false
end

function calculateReleasePoint(plr)
	local d, l = {}, {}
	for spot, ent in pairs(releaseLocations) do
		local dist = getDistanceBetweenPoints3D(ent.x, ent.y, ent.z, plr.position)
		table.insert(d, dist)
		l[dist] = spot
	end
	table.sort(d)
	return l[d[1]] or "LS"
end

function jailPlayer(plr, duration, isAdminJail)
	if (not plr or not isElement(plr) or plr.type ~= "player" or plr.account.guest or not duration or not tonumber(duration)) then
		return false
	end
	local loc, timeLeft
	
	if (isAdminJail) then
		isAdminJail = 1
		loc = "LS"
	else
		isAdminJail = 0
		loc = calculateReleasePoint(plr)
	end
	
	if (isPlayerJailed(plr)) then
		timeLeft = duration + jails[plr.account.name][3]
		duration = duration + jails[plr.account.name][1]
		jails[plr.account.name] = {duration, isAdminJail, timeLeft, loc}
		db:exec("UPDATE `jails` SET `duration` = ?, `timeLeft` = ?, `isAdminJail` = ? WHERE `account` = ?", duration, timeLeft, tostring(isAdminJail), plr.account.name)
	else
		timeLeft = duration
		jails[plr.account.name] = {duration, isAdminJail, timeLeft, loc}
		db:exec("INSERT INTO `jails` (`account`, `duration`, `isAdminJail`, `timeLeft`, `loc`) VALUES (?, ?, ?, ?, ?)", plr.account.name, duration, tostring(isAdminJail), timeLeft, loc)
	end
	triggerEvent("onPlayerJailed", plr)
end

function onPlayerJailed()
	local x, y, z = math.random(jailSpawn.x - 4, jailSpawn.x + 4), math.random(jailSpawn.y - 4, jailSpawn.y + 4), jailSpawn.z + 1
	if (source.vehicle) then
		source:removeFromVehicle(source.vehicle)
	end
	exports.UCDwanted:setWantedPoints(source, 0)
	exports.UCDhousing:stopRobbing(source)
	source.interior = 0
	source.dimension = 0
	source.position = Vector3(x, y, z)
	source.rotation = Vector3(0, 0, jailSpawn.r)
	source.health = 200
	TL[source.account.name] = getRealTime().timestamp
	source:setData("jailed", true)
	triggerClientEvent(source, "onClientPlayerJailed", source, jails[source.account.name][3])
end
addEvent("onPlayerJailed")
addEventHandler("onPlayerJailed", root, onPlayerJailed)

function releasePlayer()
	if (client) then source = client end
	if (source) then
		if (jails[source.account.name]) then
			local loc = jails[source.account.name][4] or "LS"
			local x, y, z, r = releaseLocations[loc].x, releaseLocations[loc].y, releaseLocations[loc].z, releaseLocations[loc].r
			jails[source.account.name] = nil
			TL[source.account.name] = nil
			source.position = Vector3(x, y, z)
			source.rotation = Vector3(0, 0, r)
			source.dimension = 0
			source.interior = 0
			source:removeData("jailed")
			db:exec("DELETE FROM `jails` WHERE `account` = ?", source.account.name)
			triggerLatentClientEvent(source, "onClientPlayerReleased", source)
			exports.UCDdx:new(source, "You have been released from jail", 0, 255, 0)
		end
	end
end
addEvent("UCDjail.releasePlayer", true)
addEventHandler("UCDjail.releasePlayer", root, releasePlayer)

addEventHandler("onColShapeLeave", col, 
	function (ele, matchingDimension)
		if (ele and ele.type == "player" and matchingDimension) then
			if (isPlayerJailed(ele)) then
				local x, y, z = math.random(jailSpawn.x - 4, jailSpawn.x + 4), math.random(jailSpawn.y - 4, jailSpawn.y + 4), jailSpawn.z + 1
				ele.interior = 0
				ele.dimension = 0
				ele.position = Vector3(x, y, z)
				ele.rotation = Vector3(0, 0, jailSpawn.r)	
			end
		end
	end
)
