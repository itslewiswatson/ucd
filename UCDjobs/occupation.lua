function drawOccupation()
	local r, g b = 255, 255, 255
	if (localPlayer.team) then
		r, g, b = localPlayer.team:getColor()
	end
	local occupation = tostring(localPlayer:getData("Occupation"))
	if (occupation == "") then
		exports.UCDdx:del("occupation")
		return
	end
	exports.UCDdx:add("occupation", tostring(localPlayer:getData("Occupation")), r, g, b)
end
addEvent("onClientPlayerGetJob", true)
addEventHandler("onClientPlayerGetJob", root, drawOccupation)
addEvent("onClientPlayerLogin", true)
addEventHandler("onClientPlayerLogin", root, drawOccupation)
addEventHandler("onClientResourceStart", resourceRoot,
	function ()
		if (exports.UCDaccounts:isPlayerLoggedIn(localPlayer)) then
			drawOccupation()
		end
	end
)

