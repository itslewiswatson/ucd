function displayData()
	if (not exports.UCDaccounts:isPlayerLoggedIn(localPlayer)) then return end
	localPlayer:setData("dxscoreboard_money", exports.UCDutil:tocomma(getPlayerMoney(localPlayer)), true)
	localPlayer:setData("dxscoreboard_city", exports.UCDutil:getPlayerCityZone(localPlayer), true)
	--localPlayer:setData("dxscoreboard_playtime", localPlayer:getData("playtime"), true) -- Set in UCDplaytime
end
--addEventHandler("onClientPreRender", root, displayData)
Timer(displayData, 1000, 0)