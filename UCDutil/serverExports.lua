function getCityZoneFromXYZ(x, y, z)
	local theZone = getZoneName(x, y, z, true)
	if (theZone) then
		if (theZone == "Las Venturas") then
			return "LV"
		elseif (theZone == "Los Santos") then
			return "LS"
		elseif (theZone == "San Fierro") then
			return "SF"
		elseif (theZone == "Red County") then
			return "RC"
		elseif (theZone == "Flint County") then
			return "FC"
		elseif (theZone == "Whetstone") then
			return "WS"
		elseif (theZone == "Bone County") then
			return "BC"
		elseif (theZone == "Tierra Robada") then
			return "TR"
		else
			return "SA"
		end
	end
	return false
end

function getElementCityZone(ele)
	if (not ele) then return nil end
	local pX, pY, pZ = getElementPosition(ele)
	return getCityZoneFromXYZ(pX, pY, pZ)
end

function getPlayerCityZone(ele)
	if (not ele) then return nil end
	return getElementCityZone(ele)
end

function tocomma(number)
	while true do  
		number, k = string.gsub(number, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k == 0) then
			break
		end
	end
	return number
end

function mathround(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

function getPlayerFromPartialName(name)
    local name = name and name:gsub("#%x%x%x%x%x%x", ""):lower() or nil
    if name then
        for _, player in pairs(Element.getAllByType("player")) do
            local name_ = player.name:gsub("#%x%x%x%x%x%x", ""):lower()
            if name_:find(name, 1, true) then
                return player
            end
        end
    end
end

function isPlayerInRangeOfPoint(player, x, y, z, range)
	local pX, pY, pZ = getElementPosition(player)
	return ((x - pX) ^ 2 + (y - pY) ^ 2 + (z - pZ) ^ 2) ^ 0.5 <= range
end

function getTimeStamp()
	local time = getRealTime()
	local year, month, day, hours, mins, secs = time.year + 1900, time.month + 1, time.monthday, time.hour, time.minute, time.second
	
	if (month < 10) then
		month = "0"..month
	end
	
	if (day < 10) then
		day = "0"..day
	end
	
	if (hours < 10) then
		hours = "0" .. hours
	end
	
	if (mins < 10) then
		mins = "0" .. mins
	end
	
	if (secs < 10) then
		secs = "0" .. secs
	end
	
	aTime = day .. "/" .. month .. "/" .. year
	aDate = hours .. ":" .. mins .. ":" .. secs
	return aTime, aDate--, time.timestamp
end

function secondsToHoursMinutes(seconds)
	local hours   = math.floor (seconds / (60 * 60))
	local minutes = math.floor ((seconds / 60) % 60)
	local hours         = (hours < 10 and 0 .. hours) or hours
	local minutes       = (minutes < 10 and 0 .. minutes) or minutes
	return hours..":"..minutes
end

function getElementSpeed(element, unit)
	if (unit == nil) then unit = 0 end
	if (isElement(element)) then
		local x,y,z = getElementVelocity(element)
		if (unit == "mph" or unit == 1 or unit == '1') then
			return (x^2 + y^2 + z^2) ^ 0.5 * 100
		else
			return (x^2 + y^2 + z^2) ^ 0.5 * 1.8 * 100
		end
	else
		outputDebugString("Not an element. Can't get speed")
		return false
	end
end

function randomstring(len)
	local allowed = {{48, 57}, {65, 90}, {97, 122}} -- numbers/lowercase chars/uppercase chars
    if tonumber(len) then
        math.randomseed(getTickCount())
        local str = ""
        for i = 1, len do
            local charlist = allowed[math.random(1, 3)]
            str = str..string.char(math.random(charlist[1], charlist[2]))
        end
        return str
    end
    return false
end
