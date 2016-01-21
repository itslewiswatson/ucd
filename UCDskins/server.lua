function takeSkin(skinID)
	if (client and skinID) then
		local currSkinID = exports.UCDaccounts:GAD(client, "model")
		if (currSkinID == skinID) then
			exports.UCDdx:new(client, "You already have this skin", 255, 0, 0)
			return
		end
		local OD = exports.UCDjobs:isPlayerOnDuty(client)
		exports.UCDaccounts:SAD(client, "model", skinID)
		if (OD) then
			exports.UCDdx:new(client, "Quit your job or go off-duty to change your skin", 255, 0, 0)
			return
		end
		exports.UCDdx:new(client, "You have changed your skin to skin ID "..skinID, 0, 255, 0)
		client.model = skinID
	end
end
addEvent("UCDskins.takeSkin", true)
addEventHandler("UCDskins.takeSkin", root, takeSkin)