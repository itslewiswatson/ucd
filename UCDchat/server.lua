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
local antiSpamTime = 2000 -- Time in ms that we don't allow a player to speak after have already spoken

function clearAntiSpam(player)
	if (antiSpam[player]) then
		antiSpam[player] = nil
	end
end

-- Main chat zones, team chat and /me

function onPlayerChat(message, messageType)
	cancelEvent()
	if (message:gsub(" ", "") == "") then return end
	if (message:find("ucd")) then message = message:gsub("ucd", "UCD") end
	onPlayerChat2(source, message, messageType)
end
addEventHandler("onPlayerChat", root, onPlayerChat)

function onPlayerChat2(player, message, messageType)
	if (antiSpam[player]) then 
		exports.UCDdx:new(player, "Your last sent message was less than two seconds ago!", 255, 0, 0)
		return
	end
	if (message:find("%x%x%x%x%x%x")) then
		message = message:gsub("%x%x%x%x%x%x", "")
	end
	if (exports.UCDaccounts:isPlayerLoggedIn(player)) then
		-- if main chat
		
		local nR, nG, nB = player:getNametagColor()
		local coord = player:getPosition()
		
		if (messageType == 0) then
			
			local sourceCity = exports.UCDutil:getPlayerCityZone(player)
			
			outputChatBox(--[["("..sourceCity..") "..--]]player.name.."#FFFFFF "..message, root, nR, nG, nB, true)
			antiSpam[player] = true
			setTimer(clearAntiSpam, antiSpamTime, 1, player)
			
			exports.UCDlogging:new(player, "Main", message, sourceCity)
			
			--triggerClientEvent("listInsert", resourceRoot, "main", player, message)
			listInsert(root, "main", player, message)
		-- if team chat
		elseif (messageType == 2) then
			local t
			
			if (message:sub(1, 1) == "/") then
				executeCommandHandler(message:sub(2, #message), player)
				return
			end
				
			for _, v in pairs(player.team:getPlayers()) do
				outputChatBox("(TEAM) "..player.name.."#FFFFFF "..message, v, nR, nG, nB, true)
			end
			
			antiSpam[player] = true
			setTimer(clearAntiSpam, antiSpamTime, 1, player)
			exports.UCDlogging:new(player, "Teamchat", message, t)
			
			--triggerClientEvent(player.team:getPlayers(), "listInsert", resourceRoot, "team", player, message)
			listInsert(player.team:getPlayers(), "team", player, message)
		-- if /me chat
		elseif (messageType == 1) then
			for _, v in ipairs(Element.getAllByType("player")) do
				if (v ~= player) then
					local p = v.position
					if (exports.UCDutil:isPlayerInRangeOfPoint(player, p.x, p.y, p.z, 100)) then
						if (player.dimension == v.dimension) and (player.interior == v.interior) then
							outputChatBox("* "..player.name.." "..message, v, 200, 50, 150)
						end
					end
				end
			end
			outputChatBox("* "..player.name.." "..message, player, 200, 50, 150)
			antiSpam[player] = true
			setTimer(clearAntiSpam, antiSpamTime, 1, player)
			
			exports.UCDlogging:new(player, "/me", message)
		end
	else
		return false
	end
end

function supportChat(plr, _, ...)
	if (not exports.UCDchecking:canPlayerDoAction(plr, "Chat")) then
		return false
	end
	local msg = string.gsub(table.concat({...}, " "), "%x%x%x%x%x%x", "")
	if (not msg or string.gsub(msg, " ", "") == "") then
		exports.UCDdx:new(plr, "Enter a message!", 255, 0, 0)
		return
	end
	outputChatBox("(SUPPORT) "..plr.name.." #ffffff"..msg, root, 0, 155, 0, true)
	exports.irc:ircSay(exports.irc:ircGetChannelFromName("#ucd.echo"), "13(SUPPORT) "..plr.name.." "..msg)
	exports.UCDlogging:new(plr, "support", msg)
	--triggerClientEvent("listInsert", resourceRoot, "support", plr, msg)
	listInsert(root, "support", plr, msg)
end
addCommandHandler("support", supportChat)

local advertSpam = {}

addCommandHandler("advert",
	function (plr, _, ...)
		if (not exports.UCDchecking:canPlayerDoAction(plr, "Chat")) then
			return false
		end
		if (advertSpam[plr.account.name] and getTickCount() - advertSpam[plr.account.name] <= (30 * 60000)) then
			exports.UCDdx:new(plr, "You can advert once per 30 minutes", 255, 0, 0)
			return false
		end
		local msg = string.gsub(table.concat({...}, " "), "%x%x%x%x%x%x", "")
		if (not msg or string.gsub(msg, " ", "") == "") then
			exports.UCDdx:new(plr, "Enter a message!", 255, 0, 0)
			return false
		end
		outputChatBox("(ADVERT) "..plr.name.." #ffffff"..msg, root, 255, 255, 0, true)
		exports.irc:ircSay(exports.irc:ircGetChannelFromName("#ucd.echo"), "8(ADVERT) "..plr.name.." "..msg)
		exports.UCDlogging:new(plr, "advert", msg)
		advertSpam[plr.account.name] = getTickCount()
	end
)