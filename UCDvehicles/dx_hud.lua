function lol(pm)
	if pm == "+" then
		setTimer(
			function ()
				alpha = alpha + 12.75
			end, 50, 20
		)		
	elseif pm == "-" then
		setTimer(
			function ()
				alpha = alpha - 12.75
				--if alpha == 0 then render = nil end
			end, 50, 20
		)
	end
end

function render(vehicle)
	dxDrawText(tostring(vehicle.name), 0, 840, 1920, 887, tocolor(255, 255, 255, alpha), 3.00, "default", "center", "center", false, false, false, false, false)
end

function renderVehicleName(vehicle)
	alpha = 0
	lol("+")
	setTimer(lol, 3500, 1, "-")
	addEventHandler("onClientRender", root, function () if alpha ~= 0 then render(vehicle) end end)
end
addEventHandler("onClientPlayerVehicleEnter", root, renderVehicleName)
