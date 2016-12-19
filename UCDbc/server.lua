local startPoses = {
	{x = 1084.5038, y = 1069.6995, z = 10.8359},
	{x = 2248.2061, y = 965.667, z = 10.8203},
	{x = 2851.0708, y = 1290.7704, z = 11.3906},
	{x = 2785.1489, y = 2208.7131, z = 13.7722},
	{x = 2523.6846, y = 2816.4714, z = 10.8203},
	{x = 2156.9614, y = 2833.438, z = 10.8203},
	{x = 1782.8796, y = 2757.615, z = 11.3438},
	{x = 1487.1903, y = 2773.6333, z = 10.8203},
	{x = 1433.1881, y = 2621.0181, z = 11.3926},
	{x = 1152.1843, y = 2083.5986, z = 16.0938},
	{x = 1098.2401, y = 1404.9833, z = 6.6328},
	{x = 1106.9404, y = 1283.0291, z = 10.8203},
}

local bc, blip, bcTaker, startTimer, stopTimer, startPos = nil
local antiSpam = {}

function bcSetStartTimer(plr, cmd, mins)
	if (plr.account.name == "risk" or plr.account.name == "Noki") then
		if (isTimer(startTimer)) then
			startTimer:destroy()
			startTimer = Timer(bcStart, tonumber(mins) * 60 * 1000, 1)
		end
	end
end
addCommandHandler("timebc", bcSetStartTimer)

function bcTake(plr)
	if (exports.UCDchecking:canPlayerDoAction(plr, "BC") and plr.team.name == "Gangsters") then
		bcTaker = plr
		exports.UCDactions:setAction(plr, "BC")
		removeEventHandler("onPickupHit", bc, bcTake)
		bc:destroy()
		bc = Object(1210, plr.position)
		blip:attach(bc)
		exports.bone_attach:attachElementToBone(bc, plr, 11, 0, 0.06, 0.3, 0, 180, 0)
		triggerClientEvent(plr, "bcDoBlip", resourceRoot, true)
		exports.UCDdx:new(plr, "Deliver the briefcase to Woozie within 10 minutes", 0, 255, 0)
		for _, plr2 in ipairs(Element.getAllByType("player")) do
			if (plr2 ~= plr) then
				exports.UCDdx:new(plr2, plr.name.." has picked up the briefcase", 0, 255, 0)
			end
		end
		if (isTimer(stopTimer)) then
			stopTimer:destroy()
		end
		stopTimer = Timer(bcDestroy, 10 * 60 * 1000, 1)
	end
end

function bcStart()
	startPos = startPoses[math.random(#startPoses)]
	bc = Pickup(startPos.x, startPos.y, startPos.z, 3, 1210, 0)
	startPos = bc:getPosition()
	blip = Blip.createAttachedTo(bc, 17, nil, nil, nil, nil, nil, 0, 650)
	for _, plr in ipairs(Element.getAllByType("player")) do
		exports.UCDdx:new(plr, "A briefcase needs to be delivered, look for diner blip on the map", 0, 255, 0)
	end
	addEventHandler("onPickupHit", bc, bcTake)
end
startTimer = Timer(bcStart, 30 * 60 * 1000, 1)

function bcDestroy()
	bc:destroy()
	blip:destroy()
	exports.UCDactions:clearAction(bcTaker)
	if (isTimer(stopTimer)) then
		stopTimer:destroy()
	end
	bcTaker = nil
	stopTimer = nil
	startTimer = Timer(bcStart, 30 * 60 * 1000, 1)
end

function bcDrop()
	if (not bcTaker) then return end
	exports.UCDdx:new(bcTaker, "Your current position blocks you from holding the briefcase!", 255, 0, 0)
	bc:destroy()
	triggerClientEvent(bcTaker, "bcDoBlip", resourceRoot, false)
	bc = Pickup(startPos.x, startPos.y, startPos.z, 3, 1210, 0)
	addEventHandler("onPickupHit", bc, bcTake)
	blip:attach(bc)
	exports.UCDactions:clearAction(bcTaker)
	bcTaker = nil
end
addEvent("bcDrop", true)
addEventHandler("bcDrop", resourceRoot, bcDrop)

addEventHandler("onVehicleStartEnter", root,
	function (plr)
		if (plr == bcTaker) then
			cancelEvent()
		end
	end
)

addEventHandler("onPlayerArrested", root,
	function (plr)
		if (plr == bcTaker) then
			bcDrop()
		end
	end
)

addEventHandler("onPlayerTased", root,
	function (cop)
		if (source == bcTaker) then
			bcDrop()
		end
	end
)

addEventHandler("onPlayerWasted", root,
	function ()
		if (source == bcTaker) then
			bc:destroy()
			bc = Pickup(source.position, 3, 1210, 0)
			blip:attach(bc)
			addEventHandler("onPickupHit", bc, bcTake)
			triggerClientEvent(source, "bcDoBlip", resourceRoot, false)
			exports.UCDactions:clearAction(source)
			bcTaker = nil
		end
	end
)

addEvent("bcEnd", true)
addEventHandler("bcEnd", resourceRoot,
	function(x, y, z)
		for _, plr in ipairs(Element.getAllByType("player")) do
			if (plr ~= client) then
				exports.UCDdx:new(plr, client.name.." has delivered the briefcase", 0, 255, 0)
			end
		end
		local reward = math.floor(getDistanceBetweenPoints3D(x, y, z, startPos) * 50)
		if (reward > 30000) then reward = 30000 end
		client.money = client.money + reward
		exports.UCDdx:new(client, "You have been rewarded $"..exports.UCDutil:tocomma(reward).." and 15 criminal XP!", 0, 255, 0)
		exports.UCDwanted:addWantedPoints(bcTaker, 30)
		bcDestroy()
	end
)

addEventHandler("onPlayerLeaveLV", root,
	function()
		if (source == bcTaker) then
			bcDrop()
		end
	end
)

addEventHandler("onPlayerGetJob", root,
	function ()
		if (source == bcTaker) then
			exports.UCDdx:new(source, "Your current job blocks you from holding the briefcase", 255, 0, 0)
			bc:destroy()
			bc = Pickup(source.position, 3, 1210, 0)
			blip:attach(bc)
			addEventHandler("onPickupHit", bc, bcTake)
			triggerClientEvent(source, "bcDoBlip", resourceRoot, false)
			exports.UCDactions:clearAction(source)
			bcTaker = nil
		end
	end
)

function formatMil(mil)
	if not mil then mil = 0 end
	local secs = math.floor(mil / 1000 % 60)
	local mins = math.floor(mil / 1000 / 60 % 60)
	return string.format("%02d:%02d", mins, secs)
end

function bcGetTime()
	local msg
	if (isTimer(startTimer)) then
		msg = tostring(formatMil(startTimer:getDetails())).." left for Woozie to arrive in LV"
	elseif (isTimer(stopTimer)) then	
		msg = tostring(formatMil(stopTimer:getDetails())).." left for Woozie to leave for SF"
	else
		msg = "Waiting for Woozie's savior"
	end
	return msg
end

function bcGetTimeRaw()
	if (isTimer(startTimer)) then
		return startTimer:getDetails()
	elseif (isTimer(stopTimer)) then
		return stopTimer:getDetails()
	end
	return false
end

function bcGetTimeMsg()
	local msg
	if (isTimer(startTimer)) then
		msg = "left for Woozie to arrive in LV"
	elseif (isTimer(stopTimer)) then	
		msg = "left for Woozie to leave for SF"
	else
		msg = "Waiting for Woozie's savior"
	end
	return msg
end

addCommandHandler("bctime",
	function (plr)
		if (antiSpam[plr]) then return end
		local r, g, b
		if (isTimer(stopTimer)) then
			r, g, b = 255, 0, 0
		elseif (isTimer(startTimer)) then
			r, g, b = 0, 255, 0
		else
			r, g, b = 255, 255, 0
		end
		if (not r or not g or not b) then
			r, g, b = 255, 255, 255
		end
		exports.UCDdx:new(plr, tostring(bcGetTime()), r, g, b)
		antiSpam[plr] = true
		Timer(function (plr) if (isElement(plr)) then antiSpam[plr] = nil end end, 5000, 1, plr)
	end
)
