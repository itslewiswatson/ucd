local evidencePiecePrice = 500

function onEvidenceCollected()
	if (client) then
		local paycheck = math.random(2000, 3000)
		client.money = client.money + paycheck
		exports.UCDdx:new(client, "You have gathered enough evidence to solve the case and determine the killer. You have been paid $"..tostring(exports.UCDutil:tocomma(paycheck))..".", 30, 144, 255)
		Timer(function (client) triggerClientEvent(client, "UCDdetective.newCase", client) end, 5000, 1, client)
	end
end
addEvent("UCDdetective.onEvidenceCollected", true)
addEventHandler("UCDdetective.onEvidenceCollected", root, onEvidenceCollected)

function onEvidenceHit()
	if (client) then
		client.money = client.money + evidencePiecePrice
		exports.UCDdx:new(client, "You have gathered a piece of evidence and earned $"..tostring(evidencePiecePrice)..".", 30, 144, 255)
	end
end
addEvent("UCDdetective.onEvidenceHit", true)
addEventHandler("UCDdetective.onEvidenceHit", root, onEvidenceHit)
