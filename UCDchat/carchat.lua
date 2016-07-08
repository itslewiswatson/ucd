function carChat(plr, _, ...)
	if (not plr.vehicle or not exports.UCDchecking:canPlayerDoAction(plr, "Chat")) then
		return false
	end
	local msg = table.concat({...}, " ")
	if (msg == "" or msg == " " or msg:gsub(" ", "") == "") then return end
	if (msg:find("ucd")) then msg = msg:gsub("ucd", "UCD") end
	
	local occupants = {}
	for _, ele in pairs(plr.vehicle:getOccupants()) do
		if (ele and isElement(ele) and ele.type == "player") then
			table.insert(occupants, ele)
		end
	end
	for _, ele in pairs(plr.vehicle:getAttachedElements()) do
		if (ele and isElement(ele) and ele.type == "player") then
			table.insert(occupants, ele)
		end
	end
	
	for _, player in ipairs(occupants) do
		outputChatBox("(CC) "..tostring(plr.name).." "..tostring(msg), player, 200, 0, 0)
	end
	exports.UCDlogging:new(plr, "CC", "(CC) "..tostring(plr.name).." "..tostring(msg), #occupants)
end
addCommandHandler("carchat", carChat, false, false)
addCommandHandler("cc", carChat, false, false)
addCommandHandler("cchat", carChat, false, false)
