function listInsert(receiver, type, sender, msg)
	triggerClientEvent(receiver, "listInsert", resourceRoot, type, sender, msg)
end

addEvent("doChat", true)
addEventHandler("doChat", resourceRoot,
	function (type, msg)
		if (not exports.UCDchecking:canPlayerDoAction(client, "Chat")) then return end
		if (type == "main" or type == "team") then
			triggerEvent("onPlayerChat", client, msg, type == "main" and 0 or 2)
		elseif (type == "local") then
			localChat(client, _, msg)
		elseif (type == "support") then
			supportChat(client, _, msg)
		elseif (type == "group" and exports.UCDgroups:getPlayerGroup(client)) then
			exports.UCDgroups:groupChat(client, _, msg)
		elseif (type == "alliance") then
			exports.UCDgroups:allianceChat(client, _, msg)
		end
	end
)