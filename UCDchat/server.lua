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
			local sourceCity = exports.UCDutil:getPlayerCityZone(source)
			
			outputChatBox("("..sourceCity..") "..source.name.."#FFFFFF "..message, root, nR, nG, nB, true)
			antiSpam[player] = true
			setTimer(clearAntiSpam, antiSpamTime, 1, player)
			
			exports.UCDlogging:new(source, "Main", message, sourceCity)
		
		-- if team chat
		elseif (messageType == 2) then
			
			if (message:sub(1, 1) == "/") then
				executeCommandHandler(message:sub(2, #message), source)
				return
			end
			
			for _, v in pairs(source.team:getPlayers()) do
				outputChatBox("("..source.team.name..") "..source.name.."#FFFFFF "..message, v, nR, nG, nB, true)
			end
			
			antiSpam[player] = true
			setTimer(clearAntiSpam, antiSpamTime, 1, player)
			exports.UCDlogging:new(source, "Teamchat", message, source.team.name)
		
		-- if /me chat
		elseif (messageType == 1) then
			
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
