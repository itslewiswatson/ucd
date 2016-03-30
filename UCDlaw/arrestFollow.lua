function followArrestor(plr, cop)
	if (not isElement(plr) or not isElement(cop)) then return end
	if (plr.vehicle or not isPlayerArrested(plr)) then return end
	
	local cX, cY = getElementPosition(cop)
	local pX, pY = getElementPosition(plr)
	local copangle = (360 - math.deg(math.atan2((cX - pX), (cY - pY)))) % 360
	setPedRotation(plr, copangle)
	setCameraTarget(plr, plr)
	
	plr.interior = cop.interior
	plr.dimension = cop.dimension
	
	local dist = getDistanceBetweenPoints2D(cX, cY, pX, pY)
	if (dist > 16) then
			-- Warp
		local x, y, z = getElementPosition(cop)
		setElementPosition(plr, x, y, z)
		setTimer(followArrestor, 500, 1, plr, cop)
	elseif (dist > 12) then
			-- Sprint
		setControlState(plr, "sprint", true)
		setControlState(plr, "walk", false)
		setControlState(plr, "forwards", true)
		setTimer(followArrestor, 500, 1, plr, cop)
	elseif (dist > 6) then
			-- Jog
		setControlState(plr, "sprint", false)
		setControlState(plr, "walk", false)
		setControlState(plr, "forwards", true)
		setTimer(followArrestor, 500, 1, plr, cop)
	elseif (dist > 1.5) then
			-- Walk
		setControlState(plr, "sprint", false)
		setControlState(plr, "walk", true)
		setControlState(plr, "forwards", true)
		setTimer(followArrestor, 500, 1, plr, cop)
	elseif (dist <= 1.5) then
			-- Stop
		setControlState(plr, "sprint", false)
		setControlState(plr, "walk", false)
		setControlState(plr, "forwards", false)
		setTimer(followArrestor, 500, 1, plr, cop)
	end
end

addEventHandler("onVehicleStartEnter", root, 
	function (plr)
		if (not getPlayerArrests(plr) or #getPlayerArrests(plr) == 0) then return end
		local max_pass = getVehicleMaxPassengers(source)
		for _, v in ipairs(getPlayerArrests(plr)) do
			for i = 1, max_pass do
				if (not getVehicleOccupant(source, i)) then
					v:warpIntoVehicle(source, i)
				end
			end
		end
	end
)

addEventHandler("onPlayerVehicleExit", root,
	function (vehicle)
		if (not getPlayerArrests(source) or #getPlayerArrests(source) == 0) then return end
		for _, v in ipairs(getPlayerArrests(source)) do
			if (v.vehicle == vehicle) then
				v:removeFromVehicle(vehicle)
				v.position = source.position
				followArrestor(v, source)
			end
		end
	end
)
