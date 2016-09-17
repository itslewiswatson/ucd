addEventHandler("onClientPlayerDamage", root,
	function (attacker, weapon, _, loss)
		--if (source.name == "[UCD]Risk|AFK") then cancelEvent() end
		if (attacker and isElement(attacker) and attacker.type == "player") then
			if (attacker.team.name == "Law" and (source.team.name == "Criminals" or source.team.name == "Gangsters")) then
				if (weapon == 23 and getElementData(source, "w") > 0) then
					cancelEvent()
					if (getDistanceBetweenPoints3D(source.position, attacker.position) <= 15) then
						triggerEvent("onClientPlayerTased", source, attacker)
						triggerServerEvent("onPlayerTased", source, attacker)
					end
				end
			elseif (source:getData("tased") == "full") then
				cancelEvent()
			end
		end
	end
)

addEventHandler("onClientKey", root,
	function ()
		if (localPlayer:getData("tased") == "full") then
			toggleAllControls(false, false)
		else
			toggleAllControls(true, true)
		end
	end
)