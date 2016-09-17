local cruise = false
local timer = false
local speed = 0

function togCruise()
	if (cruise) then
		local veh = getPedOccupiedVehicle(localPlayer)
		if (not veh or not isElement(veh)) then return false end
		local v1,v2,v3 = getElementVelocity(veh)
		local currspeed = (v1^2 + v2^2 + v3^2)^(0.5)
		if (currspeed < speed) then
			setControlState("accelerate", true)
		else
			setControlState("accelerate", false)
		end
	end
end

function cruiseNow()
	local veh = getPedOccupiedVehicle(localPlayer)
	if (not veh or not isElement(veh)) then return false end
	if (getVehicleOccupant(veh, 0) ~= localPlayer or not getVehicleOccupant(veh, 0)) then
		return false
	end
	if (not cruise) then
		cruise = true
		local speedx,speedy,speedz = getElementVelocity(veh)
		speed = (speedx^2 + speedy^2 + speedz^2)^(0.5)
		timer = setTimer(togCruise, 50, 0)
		exports.UCDdx:add("cruise", "Cruising", 255, 255, 255)
	else
		cruise = false
		killTimer(timer)
		speed = 0
		setControlState("accelerate", false)
		exports.UCDdx:del("cruise")
	end
end
bindKey("c", "up", cruiseNow) 

function exitVeh(player)
	if (cruise and player == localPlayer) then
		cruise = false
		killTimer(timer)
		speed = 0
		setControlState("accelerate", false)
		exports.UCDdx:del("cruise")
	end
end
addEventHandler("onClientVehicleExit", root, exitVeh)

function diedVeh()
	if (cruise) then
		cruise = false
		killTimer(timer)
		speed = 0
		setControlState("accelerate", false)
		exports.UCDdx:del("cruise")
	end
end
addEventHandler("onClientPlayerWasted", localPlayer, diedVeh)
