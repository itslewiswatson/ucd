local data = {}
local disappearTime = 10000

function foo()
	if (not exports.UCDaccounts or not exports.UCDaccounts:isPlayerLoggedIn(localPlayer)) then
		return false
	end
	
	playerMoney = getPlayerMoney(localPlayer)
	
	-- Only want one change at a time
	if (#data > 1) then	
		data = {}
	end
end
addEventHandler("onClientPreRender", root, foo)

function hasPlayerMoneyChanged()
	if (not exports.UCDaccounts or not exports.UCDaccounts:isPlayerLoggedIn(localPlayer)) then
		return false
	end
	
	-- Check if the money changed
	if (playerMoney ~= getPlayerMoney(localPlayer)) then	
		-- Since their money changed, we need to gather some info
		local newMoney = getPlayerMoney(localPlayer)
		
		-- Determine if the player lost, or gained money (little things like calculating the difference on the client save the server a lot of CPU)
		if (tonumber(newMoney) and tonumber(playerMoney))then
			if (newMoney > playerMoney) then
				local difference = playerMoney - newMoney
				table.insert(data, {newMoney, playerMoney, tick})
			else
				local difference = newMoney - playerMoney
				table.insert(data, {newMoney, playerMoney, tick})
			end
		else
			return
		end
		
		local sign, r, g, b
		if (newMoney > playerMoney) then
			sign = "+"
			r, g, b = 0, 200, 0
		else
			sign = "-"
			r, g, b = 200, 0, 0
		end
		exports.UCDdx:add("UCDmoneyChange", sign..tostring(exports.UCDutil:tocomma(math.abs(newMoney - playerMoney))), r, g, b)
		Timer(
			function () 
				exports.UCDdx:del("UCDmoneyChange") 
			end, disappearTime, 1
		)
	end
end
addEventHandler("onClientRender", root, hasPlayerMoneyChanged)
