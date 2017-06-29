function isVehicleAccelerating(vehicle)
	local vel = vehicle.velocity
	local rot = vehicle.rotation
	if (rot.z >= 0 and rot.z < 90) then
		if (vel.x < 0 and vel.y >= 0) then
			return true
		end
	elseif (rot.z >= 90 and rot.z < 180) then
		if (vel.x < 0 and vel.y < 0) then
			return true
		end
	elseif (rot.z >= 180 and rot.z < 270) then
		if (vel.x >= 0 and vel.y < 0) then
			return true
		end
	elseif (rot.z >= 270 and rot.z < 360) then
		if (vel.x >= 0 and vel.y >= 0) then
			return true
		end
	end
	return false
end

--[[
function stopVehicle(freeze)
	if (not localPlayer.vehicle) then return end
	for _, ctrl in ipairs({"accelerate", "brake_reverse"}) do
		toggleControl(ctrl, false)
		setControlState(ctrl, false)
	end
	
	local vehicle = getPedOccupiedVehicle(localPlayer)
	local x,y,z = getElementVelocity(vehicle)
	local speed = math.sqrt(x^2 + y^2 + z^2)*100
	if (speed >= 15) then
		local div = math.sqrt(x^2 + y^2 + z^2)*100/15
		setElementVelocity(vehicle, x/div, y/div, z/div)
	end
		
	addEventHandler("onClientRender", root, vehicleBrake)
	if (isVehicleAccelerating(vehicle)) then
		setControlState("brake_reverse", true)
	else
		setControlState("accelerate", true)
	end
	freezeOnStop = freeze
end
--]]

function stopVehicle(freeze)
	if (not isPedInVehicle(localPlayer)) then return end
	for i,ctrl in ipairs({"accelerate", "brake_reverse"}) do
		toggleControl(ctrl, false)
		setControlState(ctrl, false)
	end
	
	local vehicle = getPedOccupiedVehicle(localPlayer)
	local x,y,z = getElementVelocity(vehicle)
	local speed = math.sqrt(x^2 + y^2 + z^2)*100
	if (speed >= 15) then
		local div = math.sqrt(x^2 + y^2 + z^2)*100/15
		setElementVelocity(vehicle, x/div, y/div, z/div)
	end
		
	addEventHandler("onClientRender", root, vehicleBrake)
	if (isVehicleAccelerating(vehicle)) then
		setControlState("brake_reverse", true)
	else
		setControlState("accelerate", true)
	end
	freezeOnStop = freeze
end

function vehicleBrake()
	if (localPlayer:getData("Occupation") ~= "Aviator" or not isPedInVehicle(localPlayer)) then 
		removeEventHandler("onClientRender", root, vehicleBrake)
		for i,ctrl in ipairs({"accelerate", "brake_reverse"}) do
			toggleControl(ctrl, true)
			setControlState(ctrl, false)
		end
	return end
	
	local vehicle = getPedOccupiedVehicle(localPlayer)
	local x,y,z = getElementVelocity(vehicle)
	local speed = math.sqrt(x^2 + y^2 + z^2)*100
	if (speed <= 2) then
		for i,ctrl in ipairs({"accelerate", "brake_reverse"}) do
			if (not freezeOnStop) then
				toggleControl(ctrl, true)
			end
			setControlState(ctrl, false)
		end
		setElementVelocity(vehicle, 0, 0, 0)
		removeEventHandler("onClientRender", root, vehicleBrake)
		freezeOnStop = nil
	end
end
