-- LOTE filter
--[[
local chars = {
	-- Arabic alphabet
	"غ", "ظ", "ض", "ذ", "خ", "ث", "ت", "ش", "ر", "ق", "ص", "ف", "ع", "س", "ن", "م", "ل", "ك", "ي", "ط", "ح", "ز", "و", "ه", "د", "ج", "ب", "ا",
}

function getForeignLetters(str, customLength)
	local c = 0
	local charNum = {}
	local stringLength = customLength or #str
	for i = 1, #str do
		for ind, character in ipairs(chars) do
			if (ind >= 1 and ind <= 28 and not customLength) then
				if (#str > 1) then
					return getForeignLetters(str, #str / 2)
				end
				return
			end
			if (string.byte(str:sub(i, i)) == string.byte(character)) then
				--outputDebugString(character)
				c = c + 1
				table.insert(charNum, ind)
			end
		end
	end
	return c, charNum
end
--]]

local antiSpam = {}
local antiSpamTime = 1000 -- Time in ms that we don't allow a player to speak after have already spoken

function clearAntiSpam(player)
	if (antiSpam[player]) then
		antiSpam[player] = nil
	end
end

-- Main chat zones, team chat and /me

function onPlayerChat(message, messageType)
	cancelEvent()
	local player = source
	if (antiSpam[player]) then 
		exports.UCDdx:new(player, "Your last sent message was less than one second ago!", 255, 0, 0)
		return
	end
	if (exports.UCDaccounts:isPlayerLoggedIn(source)) then
		-- if main chat
		
		local nR, nG, nB = source:getNametagColor()
		local coord = source:getPosition()
		
		if (messageType == 0) then
			if (message:find("ucd")) then message = message:gsub("ucd", "UCD") end
			local sourceCity = exports.UCDutil:getPlayerCityZone(source)
			
			outputChatBox("("..sourceCity..") "..source.name.."#FFFFFF "..message, root, nR, nG, nB, true)
			antiSpam[player] = true
			setTimer(clearAntiSpam, antiSpamTime, 1, player)
			
			exports.UCDlogging:new(source, "Main", message, sourceCity)
		
		-- if team chat
		elseif (messageType == 2) then
			local t
			
			if (message:find("ucd")) then message = message:gsub("ucd", "UCD") end
			if (message:sub(1, 1) == "/") then
				executeCommandHandler(message:sub(2, #message), source)
				return
			end
				
			for _, v in pairs(source.team:getPlayers()) do
				outputChatBox("(TEAM) "..source.name.."#FFFFFF "..message, v, nR, nG, nB, true)
			end
			
			antiSpam[player] = true
			setTimer(clearAntiSpam, antiSpamTime, 1, player)
			exports.UCDlogging:new(source, "Teamchat", message, t)
		
		-- if /me chat
		elseif (messageType == 1) then
			if (message:find("ucd")) then message = message:gsub("ucd", "UCD") end
			for _, v in pairs(Element.getAllByType("player")) do
				if (v ~= source) then
					local vCoord = v:getPosition()
					if (exports.UCDutil:isPlayerInRangeOfPoint(source, vCoord.x, vCoord.y, vCoord.z, 100)) then
						if (source.dimension == v.dimension) and (source.interior == v.interior) then
							outputChatBox("* "..source.name.." "..message, v, 200, 50, 150)
							antiSpam[player] = true
							setTimer(clearAntiSpam, antiSpamTime, 1, player)
						end
					end
				end
			end
			outputChatBox("* "..source:getName().." "..message, v, 200, 50, 150)
			
			exports.UCDlogging:new(source, "/me", message)
		end
	else
		return false
	end
end
addEventHandler("onPlayerChat", root, onPlayerChat)
