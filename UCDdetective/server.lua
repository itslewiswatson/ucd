function onEvidenceCollected()
	if (client) then
		client.money = client.money + math.random(1200, 1700)
		Timer(function (client) triggerClientEvent(client, "UCDdetective.newCase", client) end, 5000, 1, client)
	end
end
addEvent("UCDdetective.onEvidenceCollected", true)
addEventHandler("UCDdetective.onEvidenceCollected", root, onEvidenceCollected)
