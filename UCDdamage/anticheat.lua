-- Disable stealth kill
addEventHandler( "onClientPlayerStealthKill", localPlayer,
	function ()
		cancelEvent()
	end
)

addEventHandler("onClientPlayerDamage", localPlayer,
	function (attacker, weapon, bodypart, loss)
		if (attacker and isElement(attacker) and attacker:getType() == "player") then
			
			-- Disable nightstick damage [This is still needed for a law system]
			--[[
			if (weapon == 3) then
				cancelEvent()
			end
			--]]
			
			-- Disable katana 1 hit kill
			if (weapon == 8 and loss > 50) then
				cancelEvent()
			end
		end
	end
)

addEventHandler("onClientPlayerHeliKilled", localPlayer,
	function ()
		cancelEvent()
	end
)
