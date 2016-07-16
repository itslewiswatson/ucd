function carChat(plr, _, ...)
	if (not exports.UCDchecking:canPlayerDoAction(plr, "Chat")) then
		return false
	end
	
	local vehicle
	local occupants = {}
	local msg = table.concat({...}, " ")
	if (msg == "" or msg == " " or msg:gsub(" ", "") == "") then return end
	if (msg:find("ucd")) then msg = msg:gsub("ucd", "UCD") end
	
	if (not plr.vehicle and plr:getAttachedTo()) then
		vehicle = plr:getAttachedTo()
		if (vehicle.type ~= "vehicle") then
			return
		end
	elseif (plr.vehicle) then
		vehicle = plr.vehicle
	else
		return
	end
	
	for _, ele in pairs(vehicle:getOccupants()) do
		if (ele and isElement(ele) and ele.type == "player") then
			table.insert(occupants, ele)
		end
	end
	for _, ele in pairs(vehicle:getAttachedElements()) do
		if (ele and isElement(ele) and ele.type == "player") then
			table.insert(occupants, ele)
		end
	end
	
	for _, player in ipairs(occupants) do
		outputChatBox("(CC) "..tostring(plr.name).." #FFFFFF"..tostring(msg), player, 0, 155, 0, true)
	end
	exports.UCDlogging:new(plr, "CC", "(CC) "..tostring(plr.name).." "..tostring(msg), #occupants)
end
addCommandHandler("carchat", carChat, false, false)
addCommandHandler("cc", carChat, false, false)
addCommandHandler("cchat", carChat, false, false)
