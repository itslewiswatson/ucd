function onPlayerDamage(attacker, _, _, loss)
	if (not wasEventCancelled()) then
		outputDebugString("Go forth")
		if (attacker == localPlayer) then
			if (source.health - loss <= 0) then
				outputDebugString("This would kill the player... Returning to avoid issues")
				return
			end
			cancelEvent()
			triggerServerEvent("UCDdamage.onPlayerDamage", resourceRoot, source, loss)
		end
	else
		outputDebugString("fuck me dead")
	end
end
addEventHandler("onClientPlayerDamage", root, onPlayerDamage, true, "low")
