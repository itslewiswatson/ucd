-------------------------------------------------------------------
--// PROJECT: Union of Clarity and Diversity
--// RESOURCE: UCDvehicleSystem
--// DEVELOPER(S): Lewis Watson (Noki)
--// DATE: 04/01/2016
--// PURPOSE: DirectX related vehicle functions.
--// FILE: \vehicleDirectX.lua [client]
-------------------------------------------------------------------

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

function lolrender()
	if localPlayer.vehicle ~= false then
		if alpha ~= 0 then
			local vehicle = localPlayer.vehicle
			render(vehicle)
		end
	else
		removeEventHandler("onClientRender", root, lolrender)
		if isTimer(t) then
			killTimer(t)
		end
	end
end

function renderVehicleName(vehicle)
	alpha = 0
	lol("+")
	setTimer(lol, 3500, 1, "-")
	addEventHandler("onClientRender", root, lolrender)
	t = setTimer(function () removeEventHandler("onClientRender", root, lolrender) end, 4600, 1)
end
addEventHandler("onClientPlayerVehicleEnter", root, renderVehicleName)

-- If you get in an out of your vehicles too fast it causes issues
