local antiSpam = {}
local range = 100

function doChat(plr, _, ...)
	if (not exports.UCDaccounts:isPlayerLoggedIn(plr)) then return end
	if (not exports.UCDchecking:canPlayerDoAction(plr, "Chat")) then return end
	if (antiSpam[plr]) then 
		exports.UCDdx:new(plr, "Your last sent message was less than one second ago!", 255, 0, 0)
		return
	end
	local msg = table.concat({...}, " ")
	if (msg == "" or msg == " " or msg:gsub(" ", "") == "") then return end
	if (msg:find("ucd")) then msg = msg:gsub("ucd", "UCD") end
	local p = plr.position
	
	for _, v in pairs(Element.getAllByType("player")) do
		if (exports.UCDutil:isPlayerInRangeOfPoint(v, p.x, p.y, p.z, range)) then
			if (plr.dimension == v.dimension and plr.interior == v.interior) then
				outputChatBox("* "..msg.." ("..plr.name..")", v, 200, 50, 150)
			end
		end
	end
end
addCommandHandler("do", doChat)

-- /me is handled in server.lua